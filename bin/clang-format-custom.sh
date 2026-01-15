#!/bin/sh

# clang-format >= 16 allows `--style=file:<path>` 
clang-format -style="{\
BasedOnStyle: WebKit,\
IncludeBlocks: Preserve, \
ColumnLimit: 80,\
IndentCaseLabels: true,\
AlignAfterOpenBracket: Align,\
PointerAlignment: Right, \
BreakBeforeBraces: Stroustrup, \
BinPackArguments: true, \
BreakBeforeTernaryOperators: true, \
PenaltyBreakAssignment: 50, \
AllowAllArgumentsOnNextLine: true, \
AllowShortFunctionsOnASingleLine: false \
}" $@



