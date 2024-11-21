add_swift_syntax_library(SwiftSyntaxMacroExpansionOld
  BasicMacroExpansionContext.swift
  FunctionParameterUtils.swift
  IndentationUtils.swift
  MacroArgument.swift
  MacroExpansion.swift
  MacroExpansionDiagnosticMessages.swift
  MacroReplacement.swift
  MacroSpec.swift
  MacroSystem.swift
)

target_link_swift_syntax_libraries(SwiftSyntaxMacroExpansionOld PUBLIC
  SwiftBasicFormatOld
  SwiftDiagnosticsOld
  SwiftOperatorsOld
  SwiftSyntaxOld
  SwiftSyntaxBuilderOld
  SwiftSyntaxMacrosOld
)
