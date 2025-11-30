#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <sstream>
#include <iomanip>
#include <cstdint>

using namespace std;

// --- Constants ---
uint8_t INITIAL_A = 0x01;
uint8_t INITIAL_B = 0x89;
uint8_t INITIAL_C = 0xFE;
uint8_t INITIAL_D = 0x76;

class HashSimulator {
private:
    vector<uint8_t> constants;

public:
    HashSimulator(const string& constant_file_path) {
        load_constants(constant_file_path);
    }

    void load_constants(const string& path) {
        ifstream file(path);
        if (!file.is_open()) {
            cerr << "Error: Could not open " << path << endl;
            exit(1);
        }
        string line;
        while (getline(file, line)) {
            if (line.empty()) continue;
            if (line.back() == '\r') line.pop_back();
            try {
                constants.push_back((uint8_t)strtol(line.c_str(), nullptr, 16));
            } catch (...) { continue; }
        }
    }

    // Helper to print hex
    string hex8(uint8_t v) {
        stringstream ss;
        ss << hex << setw(2) << setfill('0') << (int)v;
        return ss.str();
    }

    string calculate_digest(const string& message_hex, bool verbose) {
        uint8_t A = INITIAL_A;
        uint8_t B = INITIAL_B;
        uint8_t C = INITIAL_C;
        uint8_t D = INITIAL_D;

        vector<uint8_t> M;
        // Parse input hex
        for (size_t i = 0; i < message_hex.length(); i += 2) {
            string byteString = message_hex.substr(i, 2);
            try {
                M.push_back((uint8_t)strtol(byteString.c_str(), nullptr, 16));
            } catch (...) { M.push_back(0); }
        }
        while (M.size() < 4) M.push_back(0);

        if (verbose) {
            cout << "\n--- TRACE START for Input: " << message_hex << " ---" << endl;
            cout << "Initial State: A=" << hex8(A) << " B=" << hex8(B) << " C=" << hex8(C) << " D=" << hex8(D) << endl;
            cout << "----------------------------------------------------------------------------------------" << endl;
            cout << " i | rnd | M[rnd] | K[i] |   F_calc  |   New A  |   New B  |   New C  |   New D  " << endl;
            cout << "---|-----|--------|------|-----------|----------|----------|----------|----------" << endl;
        }

        for (int i = 0; i < 64; ++i) {
            uint8_t F = 0;
            // F logic
            if (i <= 15)      F = (B & C) | ((~B) & D);
            else if (i <= 31) F = (D & B) | ((~D) & C);
            else if (i <= 47) F = B ^ C ^ D;
            else              F = C ^ (B | (~D));

            // Rnd generation
            uint8_t x = (uint8_t)i;
            for (int k = 0; k < 6; ++k) {
                uint8_t fb = ((x >> 5) & 1) ^ ((x >> 3) & 1) ^ ((x >> 1) & 1);
                x = ((x << 1) | fb) & 0xFF;
            }
            uint8_t rnd = (((x >> 5) & 1) << 1) | ((x >> 4) & 1);
            
            uint8_t msg_byte = M[rnd % 4];
            uint8_t k_byte = (i < constants.size()) ? constants[i] : 0;

            // F update
            F = F + A + k_byte + msg_byte;

            // Shift variables
            // Store old values before overwriting
            uint8_t prev_B = B;

            A = D;
            D = C;
            C = B;

            // Multiplier logic (replacing rotate)
            // B := B + (F_high * F_low)
            uint8_t f_upper = (F >> 4) & 0x0F;
            uint8_t f_lower = F & 0x0F;
            uint8_t product = f_upper * f_lower;
            
            // Note: In the PDF logic, B is updated using its OLD value?
            // "B := B + ..." usually implies the value of B at start of iteration.
            // But usually in these hashing steps, 'C' gets 'B', and 'B' gets calculated result.
            // Let's look at standard structure provided in PDF lines 32-35:
            // A:=D, D:=C, C:=B, B:=B + ... 
            // If executed sequentially in C++, C becomes B, then D becomes C (new B)... wait.
            // The Pseudocode in PDF page 3 is:
            // 32: A := D
            // 33: D := C
            // 34: C := B
            // 35: B := B + ...
            // In hardware/rtl these happen simultaneously. In C++ sequential:
            // If we do A=D; D=C; C=B; B=B+... 
            // The 'B' in line 35 is the OLD B because we haven't written to B yet, 
            // BUT 'C' just got overwritten by B. 
            // We must use temporary variables to simulate simultaneous update.

            B = prev_B + product; // Use prev_B to be safe, though C++ hasn't overwritten B yet here.

            if (verbose) {
                cout << setw(2) << i << " |  " 
                     << (int)rnd << "  |   " 
                     << hex8(msg_byte) << "   |  " 
                     << hex8(k_byte) << "  |    " 
                     << hex8(F) << "     |    " 
                     << hex8(A) << "    |    " 
                     << hex8(B) << "    |    " 
                     << hex8(C) << "    |    " 
                     << hex8(D) << endl;
            }
        }
        
        string result = hex8(A) + hex8(B) + hex8(C) + hex8(D);
        if (verbose) {
            cout << "----------------------------------------------------------------------------------------" << endl;
            cout << "FINAL DIGEST: " << result << endl << endl;
        }
        return result;
    }
};

int main(int argc, char* argv[]) {
    string constants_file = "constant.mem";
    HashSimulator sim(constants_file);

    string user_input;
    cout << "Enter input hex (e.g. 3761eded) to trace, or type 'FILE' to run testcase.txt: ";
    cin >> user_input;

    if (user_input == "FILE" || user_input == "file") {
        // Batch Mode
        ifstream inputs("testcase.txt");
        ifstream outputs("out_hw.txt");
        string input_line, expected_line;
        int pass = 0, total = 0;
        
        cout << "\nRunning Batch Mode..." << endl;
        while(getline(inputs, input_line)) {
            if(input_line.empty() || input_line.back() == '\r') if(!input_line.empty()) input_line.pop_back();
            if(input_line.empty()) continue;
            
            string digest = sim.calculate_digest(input_line, false);
            getline(outputs, expected_line);
            if(!expected_line.empty() && expected_line.back() == '\r') expected_line.pop_back();

            cout << "In: " << input_line << " -> Out: " << digest;
            if(digest == expected_line) { cout << " [OK]" << endl; pass++; }
            else { cout << " [FAIL] Exp: " << expected_line << endl; }
            total++;
        }
        cout << "Passed: " << pass << "/" << total << endl;
    } else {
        // Trace Mode
        sim.calculate_digest(user_input, true);
    }

    return 0;
}