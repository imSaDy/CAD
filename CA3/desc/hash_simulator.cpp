#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <sstream>
#include <iomanip>
#include <cstdint>

using namespace std;

// --- Configuration ---
// Set to true to see detailed state at every iteration (tracking values)
const bool VERBOSE = false; 

// --- Constants (From PDF Page 2) ---
uint8_t INITIAL_A = 0x01;
uint8_t INITIAL_B = 0x89;
uint8_t INITIAL_C = 0xFE;
uint8_t INITIAL_D = 0x76;

// --- Helper Functions ---

// Convert a hex string to a vector of bytes (Big Endian logic: first 2 chars = first byte)
vector<uint8_t> hex_string_to_bytes(const string& hex) {
    vector<uint8_t> bytes;
    for (size_t i = 0; i < hex.length(); i += 2) {
        string byteString = hex.substr(i, 2);
        try {
            uint8_t byte = (uint8_t)strtol(byteString.c_str(), nullptr, 16);
            bytes.push_back(byte);
        } catch (...) {
            bytes.push_back(0);
        }
    }
    return bytes;
}

// Convert a byte to a 2-digit hex string
string byte_to_hex(uint8_t byte) {
    stringstream ss;
    ss << hex << setw(2) << setfill('0') << (int)byte;
    return ss.str();
}

// --- Core Logic ---

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
            // Clean line (remove \r if present)
            if (line.back() == '\r') line.pop_back();
            
            try {
                // Parse hex constant
                constants.push_back((uint8_t)strtol(line.c_str(), nullptr, 16));
            } catch (...) {
                continue;
            }
        }
        if (constants.size() < 64) {
            cerr << "Warning: Loaded " << constants.size() << " constants. Expected 64." << endl;
        }
    }

    string calculate_digest(const string& message_hex) {
        // 1. Initialize Variables
        uint8_t A = INITIAL_A;
        uint8_t B = INITIAL_B;
        uint8_t C = INITIAL_C;
        uint8_t D = INITIAL_D;

        // 2. Break message into four 8-bit words M[0..3]
        vector<uint8_t> M = hex_string_to_bytes(message_hex);
        if (M.size() != 4) {
            // Handle incorrect length gracefully or pad if necessary
            // For this assignment, inputs seem strictly 32-bit (8 hex chars)
            while (M.size() < 4) M.push_back(0); 
        }

        if (VERBOSE) {
            cout << "\nProcessing: " << message_hex << endl;
            cout << "Init: A=" << byte_to_hex(A) << " B=" << byte_to_hex(B) 
                 << " C=" << byte_to_hex(C) << " D=" << byte_to_hex(D) << endl;
        }

        // 3. Main Loop (0 to 63)
        for (int i = 0; i < 64; ++i) {
            uint8_t F = 0;

            // Logic for F based on iteration index (PDF Page 3)
            if (i >= 0 && i <= 15) {
                F = (B & C) | ((~B) & D);
            } else if (i >= 16 && i <= 31) {
                F = (D & B) | ((~D) & C);
            } else if (i >= 32 && i <= 47) {
                F = B ^ C ^ D;
            } else if (i >= 48 && i <= 63) {
                F = C ^ (B | (~D));
            }

            // Calculate 'rnd' index for M
            // Logic:
            // x := i
            // repeat 6 times:
            //   fb := (bit5 of x) xor (bit3 of x) xor (bit1 of x)
            //   x := (x << 1) or fb
            // rnd := (bit5 of x shifted left by 1) OR (bit4 of x)
            
            uint8_t x = (uint8_t)i;
            for (int k = 0; k < 6; ++k) {
                uint8_t bit5 = (x >> 5) & 1;
                uint8_t bit3 = (x >> 3) & 1;
                uint8_t bit1 = (x >> 1) & 1;
                uint8_t fb = bit5 ^ bit3 ^ bit1;
                x = ((x << 1) | fb) & 0xFF; // Mask to keep 8-bit simulation behavior
            }
            
            // Extract rnd (2 bits needed for index 0-3)
            uint8_t rnd = (((x >> 5) & 1) << 1) | ((x >> 4) & 1);
            
            uint8_t message_part = M[rnd % 4];
            uint8_t const_val = (i < constants.size()) ? constants[i] : 0;

            // Update F (Line 30)
            // F := F + A + constant[i] + M[rnd]
            // Note: All additions modulo 256 (automatic with uint8_t)
            F = F + A + const_val + message_part;

            // Update State Variables
            // We need temporary storage because updates are simultaneous or sequential 
            // but rely on old values.
            // Algorithm says:
            // A := D
            // D := C
            // C := B
            // B := B + (Multiplication result)
            
            uint8_t old_B = B;
            uint8_t old_C = C;
            uint8_t old_D = D;

            A = D;
            D = C;
            C = B;
            
            // Multiplication Logic replacement for Rotate:
            // B := B + F[width-1:width/2] * F[width/2-1:0]
            // Width is 8, so High Nibble * Low Nibble
            uint8_t f_upper = (F >> 4) & 0x0F;
            uint8_t f_lower = F & 0x0F;
            uint8_t product = f_upper * f_lower;
            
            B = B + product;

            if (VERBOSE) {
                cout << "i=" << setw(2) << i 
                     << " rnd=" << (int)rnd 
                     << " M=" << byte_to_hex(message_part)
                     << " K=" << byte_to_hex(const_val)
                     << " F_sum=" << byte_to_hex(F)
                     << " | New State -> A:" << byte_to_hex(A) 
                     << " B:" << byte_to_hex(B) 
                     << " C:" << byte_to_hex(C) 
                     << " D:" << byte_to_hex(D) 
                     << endl;
            }
        }

        // 4. Final Digest
        // digest := A || B || C || D
        return byte_to_hex(A) + byte_to_hex(B) + byte_to_hex(C) + byte_to_hex(D);
    }
};

int main() {
    string constants_file = "constant.mem";
    string testcase_file = "testcase.txt";
    string output_hw_file = "out_hw.txt";

    HashSimulator sim(constants_file);

    ifstream inputs(testcase_file);
    ifstream expected_outputs(output_hw_file);
    
    if (!inputs.is_open()) {
        cerr << "Error: Could not open " << testcase_file << ". Please ensure it is in the current directory." << endl;
        return 1;
    }

    string input_line;
    string expected_line;
    int test_count = 0;
    int pass_count = 0;

    cout << "==========================================================================" << endl;
    cout << "                         SUDOCODE SIMULATOR                               " << endl;
    cout << "==========================================================================" << endl;
    cout << "| " << left << setw(10) << "Input" 
         << " | " << setw(10) << "Calculated" 
         << " | " << setw(10) << "Expected" 
         << " | " << "Result" << " |" << endl;
    cout << "|------------|------------|------------|--------|" << endl;

    while (getline(inputs, input_line)) {
        // Trim whitespace/newlines
        if (!input_line.empty() && input_line.back() == '\r') input_line.pop_back();
        if (input_line.empty()) continue;

        string digest = sim.calculate_digest(input_line);
        
        bool has_expected = (bool)getline(expected_outputs, expected_line);
        if (has_expected && !expected_line.empty() && expected_line.back() == '\r') expected_line.pop_back();

        cout << "| " << setw(10) << input_line 
             << " | " << setw(10) << digest 
             << " | ";
        
        if (has_expected) {
            cout << setw(10) << expected_line << " | ";
            if (digest == expected_line) {
                cout << "  OK    |";
                pass_count++;
            } else {
                cout << " FAIL   |";
            }
        } else {
            cout << "  N/A       |   ?    |";
        }
        cout << endl;
        test_count++;
    }

    cout << "==========================================================================" << endl;
    cout << "Tests Passed: " << pass_count << "/" << test_count << endl;

    return 0;
}