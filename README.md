# 👩‍👦 MummyLang


> A beginner-friendly programming language built with Flex & Bison — designed to teach both **programming fundamentals** and **compiler design**, using simple Hindi-style syntax.

---

## ✨ Overview

**MummyLang** is a custom-designed programming language that simplifies programming concepts using natural, human-like phrases such as:

* `mummy bolo` → print
* `mummy pucho` → input
* `jab tak` → while loop
* `agar` → if condition

This project serves a dual purpose:

### 🧠 Learn Programming (From Scratch)

MummyLang lowers the barrier to entry for beginners by replacing complex syntax with intuitive, readable constructs.
It allows new learners to focus on:

* Logical thinking
* Control flow
* Problem-solving

without being overwhelmed by syntax-heavy languages like C/C++.

---

### ⚙️ Understand How Compilers Work

```id="flow1"
Source Code → Lexer → Parser → TAC Generation → Interpreter → Output
```

MummyLang implements:

* Lexical Analysis (Flex)
* Syntax Parsing (Bison)
* Three Address Code (TAC)
* Execution via interpreter

---

## 🚀 Key Features

* Human-readable Hindi-inspired syntax
* Beginner-friendly design
* Full compiler pipeline
* TAC generation + execution
* Supports:

  * Variables
  * Arithmetic
  * Conditions
  * Loops
  * Input/Output

---

## 🧾 Language Syntax

### Variable Declaration

```id="code1"
mummy ye he x;
mummy ye he x = 10;
```

### Input / Output

```id="code2"
mummy pucho x;
mummy bolo x;
```

### Assignment

```id="code3"
x = x + 1;
```

### If / Else

```id="code4"
mummy agar (x > 5)
    mummy bolo x;
end
nahi to
    mummy bolo 0;
end
```

### While Loop

```id="code5"
mummy jab tak (i < 5)
    mummy bolo i;
    i = i + 1;
end
```

---

## 📄 Example

```id="code6"
mummy ye he x = 10;
mummy ye he i = 0;
mummy ye he y;
mummy pucho y;

mummy jab tak (i < 5)
    mummy agar (i > 2)
        mummy bolo y;
    end
    nahi to
        mummy bolo i;
    end 
    i = i + 1;
end
```

---

## 🏗️ Architecture

| Component   | Role                     |
| ----------- | ------------------------ |
| Lexer (.l)  | Tokenization             |
| Parser (.y) | Grammar + TAC generation |
| TAC Engine  | Intermediate code        |
| Interpreter | Execution                |

---

## 🛠️ Getting Started

### 🔹 Option 1: Build from Source

#### ✅ Prerequisites

Make sure you have the following installed:

* Flex
* Bison
* GCC (or any C compiler)

---

### 🐧 Linux (Ubuntu / Debian)

Install dependencies:

```bash
sudo apt update
sudo apt install flex bison gcc
```

Build and run:

```bash
bison -d mummy.y
flex mummy.l
gcc lex.yy.c mummy.tab.c -o mummy
./mummy test.mum
```

---

### 🍎 macOS

Install dependencies using Homebrew:

```bash
brew install flex bison gcc
```

> ⚠️ Note: macOS may use older system versions of flex/bison. You might need to use Homebrew paths:

```bash
export PATH="/opt/homebrew/opt/flex/bin:/opt/homebrew/opt/bison/bin:$PATH"
```

Build and run:

```bash
bison -d mummy.y
flex mummy.l
gcc lex.yy.c mummy.tab.c -o mummy
./mummy test.mum
```

---

### 🪟 Windows (Using WSL - Recommended)

1. Install **WSL (Windows Subsystem for Linux)**
   Open PowerShell as Administrator:

   ```powershell
   wsl --install
   ```

2. Open Ubuntu (WSL terminal) and install dependencies:

   ```bash
   sudo apt update
   sudo apt install flex bison gcc
   ```

3. Navigate to your project folder and build:

   ```bash
   bison -d mummy.y
   flex mummy.l
   gcc lex.yy.c mummy.tab.c -o mummy
   ./mummy test.mum
   ```

---

### 🪟 Windows (Alternative: MinGW)

1. Install **MinGW** or **MSYS2**
2. Install flex, bison, and gcc via MSYS2:

   ```bash
   pacman -S mingw-w64-x86_64-flex mingw-w64-x86_64-bison mingw-w64-x86_64-gcc
   ```
3. Build:

   ```bash
   bison -d mummy.y
   flex mummy.l
   gcc lex.yy.c mummy.tab.c -o mummy.exe
   mummy.exe test.mum
   ```

---

### 🔹 Option 2: Use Executable (No Setup)

If you prefer not to install Flex, Bison, or GCC, you can directly use the precompiled executable to run MummyLang programs.

#### Step-by-step Instructions:

1. Download the file:

   * `mummy.exe` from the repository

2. Create a folder on your system (recommended):

   ```
   C:\MummyLang\
   ```

3. Move `mummy.exe` into this folder.

4. Add the folder to your system PATH:

   * Press `Win + S` and search for **Environment Variables**
   * Click **Edit the system environment variables**
   * Click **Environment Variables**
   * Under **System Variables**, find and select `Path`, then click **Edit**
   * Click **New** and add:

     ```
     C:\MummyLang\
     ```
   * Click **OK** to save all changes

5. Restart your terminal (Command Prompt / PowerShell) so the PATH updates take effect.

6. Verify installation:

   ```bash
   mummy
   ```

   If configured correctly, it should run without errors or show usage info.

7. Run your MummyLang program:

   ```bash
   mummy test.mum
   ```

---

## 📦 Repo Structure

```id="tree1"
MummyLang/
├── mummy.l
├── mummy.y
├── mummy.tab.c
├── mummy.tab.h
├── lex.yy.c
├── mummy.exe
├── test.mum

README.md
```

---

## 📌 Supported

* Integers
* Arithmetic
* Conditions
* Loops
* I/O
* TAC execution

---

## ⚠️ Limitations

* No float / string
* No arrays
* No functions
* Minimal error handling

---

## 🎯 Purpose

* Learn programming basics
* Understand compilers
* Practice logic building

---

## ⭐ Support

Give a ⭐ if you like the project!
