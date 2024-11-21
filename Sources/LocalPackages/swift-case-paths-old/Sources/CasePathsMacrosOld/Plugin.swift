import SwiftCompilerPluginOld
import SwiftSyntaxMacrosOld

@main
struct CasePathsPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    CasePathableMacroOld.self
  ]
}
