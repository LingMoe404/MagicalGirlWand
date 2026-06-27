# C++/WinRT CalculatorEngine 项目概览

这个项目把 `exprtk` 表达式解析库包装成 C++/WinRT component，让 Windows 应用可以使用高级数学表达式求值能力。

在 MagicalGirlWand 中，它主要为 CmdPal calculator extension 提供计算支持。

## 使用 exprtk

本项目使用 [exprtk](https://github.com/ArashPartow/exprtk) 作为表达式解析和求值引擎。

在本项目中使用 `exprtk`：

- `exprtk.hpp` 已包含在项目源码中。
- C++ 代码可以用 `exprtk` 解析和计算数学表达式，例如：

  ```cpp
  #include "exprtk.hpp"
  exprtk::expression<double> expression;
  exprtk::parser<double> parser;
  std::string formula = "3 + 4 * 2";
  parser.compile(formula, expression);
  double result = expression.value();
  ```

## 更新 exprtk

1. 从 [official repository](https://github.com/ArashPartow/exprtk) 下载最新 `exprtk.hpp`。
2. 用新文件替换项目中现有的 `exprtk.hpp`。
3. 重新构建项目，确认兼容性并使用更新内容。
