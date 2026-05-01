#include <cstddef>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iostream>
using std::basic_filebuf;
using std::cout;

// 1MB
constexpr size_t MEMORY_SIZE = 1024 * 1024;

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

  // Init complete flag
  bool ok;

public:
  Emulator(size_t, uint32_t, uint32_t) noexcept;
  ~Emulator(void) noexcept;
  bool is_ok(void) const;
};

Emulator::Emulator(size_t size, uint32_t eip, uint32_t esp) noexcept
    : registers{}, eflags(0), memory(nullptr), eip(eip), ok(false) {
  this->registers[ESP] = esp;
  if ((this->memory = new (std::malloc(size)) uint8_t) != nullptr) {
    this->ok = true;
  }
}

Emulator::~Emulator(void) noexcept {
  std::free(this->memory);
  this->memory = nullptr;
}

bool Emulator::is_ok(void) const { return this->ok; };

int main(int argc, char **argv) {
  if (argc != 2) {
    std::cerr << "Usage: x86emu filename\n";
    return 1;
  }

  Emulator emulator(MEMORY_SIZE, 0x0000, 0x7c00);
  if (!emulator.is_ok()) {
    cout << "Failed to allocate emulator memory\n";
    return 1;
  }

  basic_filebuf<char> fb;
  if (fb.open(argv[1], std::ios::in | std::ios::out | std::ios::binary) ==
      nullptr) {
    std::cerr << "Can't open file: " << argv[1] << "\n";
    return 1;
  }

  fb.close();
  cout << "Hello, x86emu!!\n";
  return 0;
}
