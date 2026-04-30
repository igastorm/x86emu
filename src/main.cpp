#include <cstddef>
#include <cstdint>
#include <cstring>
#include <iostream>
using std::cout;

class Register {
protected:
  // Registers
  enum : uint8_t { EAX, ECX, EDX, EBX, ESP, EBP, ESI, EDI, REGISTERS_COUNT };
};

class Emulator : private Register {
private:
  // GRP
  uint32_t registers[REGISTERS_COUNT];

  // EFLAGS register
  uint32_t eflags;

  // memory
  uint8_t *memory;

  // PC
  uint32_t eip;

public:
  Emulator(size_t, uint32_t, uint32_t);
  ~Emulator(void);
};

Emulator::Emulator(size_t size, uint32_t eip, uint32_t esp)
    : registers{}, eflags(0), memory(new uint8_t[size]), eip(eip) {
  this->registers[ESP] = esp;
}

Emulator::~Emulator(void) { delete[] this->memory; }

int main(int argc, char **argv) {
  cout << "Hello, x86emu!!\n";
  return 0;
}
