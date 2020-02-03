//
//  main.swift
//  solution
//
//  Created by Chris Downie on 1/19/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Foundation

/// Measure how long it takes to execute the `method` closure
/// - Parameter method: The method to benchmark.
func benchmarkAndPrint<T>(method: () -> T) {
    let start = Date().timeIntervalSinceReferenceDate
    let result = method()
    let end = Date().timeIntervalSinceReferenceDate
    print(String(format: "Solved in %.4fs", end - start))
    print(result)
}

func benchmark(method: () -> Void) {
    let start = Date().timeIntervalSinceReferenceDate
    method()
    let end = Date().timeIntervalSinceReferenceDate
    print(String(format: "Solved in %.4fs", end - start))
}

// Take the file name in from the arguments list
guard let fileName = ProcessInfo.processInfo.arguments.dropFirst().first else {
    preconditionFailure("Usage: solution [filename]")
}

func computeScore(forName name: String, position: Int = 1) -> Int {
    let capitalAOffset = 64
    return name.uppercased()
        .unicodeScalars.map { Int($0.value) - capitalAOffset }
        .reduce(0, +) * position
}

assert(computeScore(forName: "COLIN") == 53)
assert(computeScore(forName: "COLIN", position: 938) == 49714)

func loadFile() -> [String] {
    guard let fileData = FileManager.default.contents(atPath: fileName) else {
        print("File is empty: \(fileName)")
        return []
    }
    guard let string = String(data: fileData, encoding: .utf8) else {
        print("File wasn't a text file: \(fileName)")
        return []
    }

    let regex = try! NSRegularExpression(pattern: #"(\w+)"#, options: [])
    return regex
        .matches(in: string, options: [], range: NSRange(string.startIndex..., in: string))
        .map { String(string[Range($0.range, in: string)!]) }
}

// I can't use benchmark{} to check this without causing a seg fault on compile.
// So I'm timing it manually.
let start = Date().timeIntervalSinceReferenceDate
let sum = loadFile().sorted().enumerated().map { computeScore(forName: $0.1, position: $0.0 + 1) }.reduce(0, +)
let end = Date().timeIntervalSinceReferenceDate
print(String(format: "Solved in %.4fs", end - start))
print(sum)

// Both 'solve' methods fail to build. See [0] below for the stack trace when trying to compile this function.
//
// [0] This fails
//func shorthandSolve() -> Int {
//    loadFile()
//        .sorted()
//        .enumerated()
//        .map { computeScore(forName: $0.1, position: $0.0) }
//        .reduce(0, +)
//}

// [1] This also fails
//func solve() -> Int {
//    var file = loadFile()
//    file.sort()
//
//    let scores = file.enumerated().map { index, name -> Int in
//        computeScore(forName: name, position: index + 1)
//    }
//
//    return scores.reduce(0, +)
//}

/// # Failures
/// ## [0] Segmentation Fault 11
//Stack dump:
//0.    Program arguments: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift -frontend -c -primary-file /Users/chris/Projects/project-euler/022/solution/solution/main.swift -emit-module-path /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/Objects-normal/x86_64/main~partial.swiftmodule -emit-module-doc-path /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/Objects-normal/x86_64/main~partial.swiftdoc -serialize-diagnostics-path /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/Objects-normal/x86_64/main.dia -emit-dependencies-path /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/Objects-normal/x86_64/main.d -emit-reference-dependencies-path /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/Objects-normal/x86_64/main.swiftdeps -target x86_64-apple-macos10.15 -enable-objc-interop -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk -I /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Products/Debug -F /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Products/Debug -enable-testing -g -module-cache-path /Users/chris/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -swift-version 5 -enforce-exclusivity=checked -Onone -D DEBUG -serialize-debugging-options -Xcc -working-directory -Xcc /Users/chris/Projects/project-euler/022/solution -enable-anonymous-context-mangled-names -Xcc -I/Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/swift-overrides.hmap -Xcc -iquote -Xcc /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/solution-generated-files.hmap -Xcc -I/Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/solution-own-target-headers.hmap -Xcc -I/Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/solution-all-target-headers.hmap -Xcc -iquote -Xcc /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/solution-project-headers.hmap -Xcc -I/Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Products/Debug/include -Xcc -I/Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/DerivedSources-normal/x86_64 -Xcc -I/Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/DerivedSources/x86_64 -Xcc -I/Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/DerivedSources -Xcc -DDEBUG=1 -module-name solution -o /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/Objects-normal/x86_64/main.o -index-store-path /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Index/DataStore -index-system-modules
//1.    While emitting SIL for 'shorthandSolve()' (at /Users/chris/Projects/project-euler/022/solution/solution/main.swift:52:1)
//2.    While silgen emitFunction SIL function "@$s8solution14shorthandSolveSiyF".
// for 'shorthandSolve()' (at /Users/chris/Projects/project-euler/022/solution/solution/main.swift:52:1)
//0  swift                    0x000000011263aa63 PrintStackTraceSignalHandler(void*) + 51
//1  swift                    0x000000011263a236 SignalHandler(int) + 358
//2  libsystem_platform.dylib 0x00007fff6902142d _sigtramp + 29
//3  libsystem_platform.dylib 0x00007ffee1a0d400 _sigtramp + 2023669744
//4  swift                    0x000000010e68f621 swift::ASTVisitor<(anonymous namespace)::SILGenApply, void, void, void, void, void, void>::visit(swift::Expr*) + 8529
//5  swift                    0x000000010e69b349 (anonymous namespace)::SILGenApply::visitApplyExpr(swift::ApplyExpr*) + 1625
//6  swift                    0x000000010e68cc4d swift::Lowering::SILGenFunction::emitApplyExpr(swift::Expr*, swift::Lowering::SGFContext) + 189
//7  swift                    0x000000010e685aeb (anonymous namespace)::ArgEmitter::emit(swift::Lowering::ArgumentSource&&, swift::Lowering::AbstractionPattern) + 4187
//8  swift                    0x000000010e696bb7 (anonymous namespace)::ArgEmitter::emitTopLevel(swift::Lowering::ArgumentSource&&, swift::Lowering::AbstractionPattern) + 935
//9  swift                    0x000000010e6965bd (anonymous namespace)::CallSite::emit(swift::Lowering::SILGenFunction&, swift::Lowering::AbstractionPattern, swift::CanTypeWrapper<swift::SILFunctionType>, (anonymous namespace)::ParamLowering&, llvm::SmallVectorImpl<swift::Lowering::ManagedValue>&, llvm::SmallVectorImpl<(anonymous namespace)::DelayedArgument>&, llvm::Optional<swift::ForeignErrorConvention> const&, swift::ImportAsMemberStatus) && + 701
//10 swift                    0x000000010e69373b (anonymous namespace)::CallEmission::emitArgumentsForNormalApply(swift::CanTypeWrapper<swift::FunctionType>&, swift::Lowering::AbstractionPattern&, swift::CanTypeWrapper<swift::SILFunctionType>, llvm::Optional<swift::ForeignErrorConvention> const&, swift::ImportAsMemberStatus, llvm::SmallVectorImpl<swift::Lowering::ManagedValue>&, llvm::Optional<swift::SILLocation>&, swift::CanTypeWrapper<swift::FunctionType>&) + 1451
//11 swift                    0x000000010e6911f3 (anonymous namespace)::CallEmission::apply(swift::Lowering::SGFContext) + 3059
//12 swift                    0x000000010e68d4ab swift::Lowering::SILGenFunction::emitApplyExpr(swift::Expr*, swift::Lowering::SGFContext) + 2331
//13 swift                    0x000000010e685aeb (anonymous namespace)::ArgEmitter::emit(swift::Lowering::ArgumentSource&&, swift::Lowering::AbstractionPattern) + 4187
//14 swift                    0x000000010e696bb7 (anonymous namespace)::ArgEmitter::emitTopLevel(swift::Lowering::ArgumentSource&&, swift::Lowering::AbstractionPattern) + 935
//15 swift                    0x000000010e6965bd (anonymous namespace)::CallSite::emit(swift::Lowering::SILGenFunction&, swift::Lowering::AbstractionPattern, swift::CanTypeWrapper<swift::SILFunctionType>, (anonymous namespace)::ParamLowering&, llvm::SmallVectorImpl<swift::Lowering::ManagedValue>&, llvm::SmallVectorImpl<(anonymous namespace)::DelayedArgument>&, llvm::Optional<swift::ForeignErrorConvention> const&, swift::ImportAsMemberStatus) && + 701
//16 swift                    0x000000010e69373b (anonymous namespace)::CallEmission::emitArgumentsForNormalApply(swift::CanTypeWrapper<swift::FunctionType>&, swift::Lowering::AbstractionPattern&, swift::CanTypeWrapper<swift::SILFunctionType>, llvm::Optional<swift::ForeignErrorConvention> const&, swift::ImportAsMemberStatus, llvm::SmallVectorImpl<swift::Lowering::ManagedValue>&, llvm::Optional<swift::SILLocation>&, swift::CanTypeWrapper<swift::FunctionType>&) + 1451
//17 swift                    0x000000010e6911f3 (anonymous namespace)::CallEmission::apply(swift::Lowering::SGFContext) + 3059
//18 swift                    0x000000010e68d4ab swift::Lowering::SILGenFunction::emitApplyExpr(swift::Expr*, swift::Lowering::SGFContext) + 2331
//19 swift                    0x000000010e685aeb (anonymous namespace)::ArgEmitter::emit(swift::Lowering::ArgumentSource&&, swift::Lowering::AbstractionPattern) + 4187
//20 swift                    0x000000010e696bb7 (anonymous namespace)::ArgEmitter::emitTopLevel(swift::Lowering::ArgumentSource&&, swift::Lowering::AbstractionPattern) + 935
//21 swift                    0x000000010e6965bd (anonymous namespace)::CallSite::emit(swift::Lowering::SILGenFunction&, swift::Lowering::AbstractionPattern, swift::CanTypeWrapper<swift::SILFunctionType>, (anonymous namespace)::ParamLowering&, llvm::SmallVectorImpl<swift::Lowering::ManagedValue>&, llvm::SmallVectorImpl<(anonymous namespace)::DelayedArgument>&, llvm::Optional<swift::ForeignErrorConvention> const&, swift::ImportAsMemberStatus) && + 701
//22 swift                    0x000000010e69373b (anonymous namespace)::CallEmission::emitArgumentsForNormalApply(swift::CanTypeWrapper<swift::FunctionType>&, swift::Lowering::AbstractionPattern&, swift::CanTypeWrapper<swift::SILFunctionType>, llvm::Optional<swift::ForeignErrorConvention> const&, swift::ImportAsMemberStatus, llvm::SmallVectorImpl<swift::Lowering::ManagedValue>&, llvm::Optional<swift::SILLocation>&, swift::CanTypeWrapper<swift::FunctionType>&) + 1451
//23 swift                    0x000000010e6911f3 (anonymous namespace)::CallEmission::apply(swift::Lowering::SGFContext) + 3059
//24 swift                    0x000000010e68d4ab swift::Lowering::SILGenFunction::emitApplyExpr(swift::Expr*, swift::Lowering::SGFContext) + 2331
//25 swift                    0x000000010e685aeb (anonymous namespace)::ArgEmitter::emit(swift::Lowering::ArgumentSource&&, swift::Lowering::AbstractionPattern) + 4187
//26 swift                    0x000000010e696bb7 (anonymous namespace)::ArgEmitter::emitTopLevel(swift::Lowering::ArgumentSource&&, swift::Lowering::AbstractionPattern) + 935
//27 swift                    0x000000010e6965bd (anonymous namespace)::CallSite::emit(swift::Lowering::SILGenFunction&, swift::Lowering::AbstractionPattern, swift::CanTypeWrapper<swift::SILFunctionType>, (anonymous namespace)::ParamLowering&, llvm::SmallVectorImpl<swift::Lowering::ManagedValue>&, llvm::SmallVectorImpl<(anonymous namespace)::DelayedArgument>&, llvm::Optional<swift::ForeignErrorConvention> const&, swift::ImportAsMemberStatus) && + 701
//28 swift                    0x000000010e69373b (anonymous namespace)::CallEmission::emitArgumentsForNormalApply(swift::CanTypeWrapper<swift::FunctionType>&, swift::Lowering::AbstractionPattern&, swift::CanTypeWrapper<swift::SILFunctionType>, llvm::Optional<swift::ForeignErrorConvention> const&, swift::ImportAsMemberStatus, llvm::SmallVectorImpl<swift::Lowering::ManagedValue>&, llvm::Optional<swift::SILLocation>&, swift::CanTypeWrapper<swift::FunctionType>&) + 1451
//29 swift                    0x000000010e6911f3 (anonymous namespace)::CallEmission::apply(swift::Lowering::SGFContext) + 3059
//30 swift                    0x000000010e68d4ab swift::Lowering::SILGenFunction::emitApplyExpr(swift::Expr*, swift::Lowering::SGFContext) + 2331
//31 swift                    0x000000010e75f567 swift::Lowering::SILGenFunction::emitReturnExpr(swift::SILLocation, swift::Expr*) + 439
//32 swift                    0x000000010e75b034 swift::ASTVisitor<(anonymous namespace)::StmtEmitter, void, void, void, void, void, void>::visit(swift::Stmt*) + 10132
//33 swift                    0x000000010e75948b swift::ASTVisitor<(anonymous namespace)::StmtEmitter, void, void, void, void, void, void>::visit(swift::Stmt*) + 3051
//34 swift                    0x000000010e70f5ea swift::Lowering::SILGenFunction::emitFunction(swift::FuncDecl*) + 426
//35 swift                    0x000000010e6747b4 swift::Lowering::SILGenModule::emitFunction(swift::FuncDecl*) + 980
//36 swift                    0x000000010e67f296 swift::Lowering::SILGenModule::emitSourceFile(swift::SourceFile*) + 1238
//37 swift                    0x000000010e680cf6 swift::SILModule::constructSIL(swift::ModuleDecl*, swift::SILOptions&, swift::FileUnit*) + 1238
//38 swift                    0x000000010e2828f4 performCompile(swift::CompilerInstance&, swift::CompilerInvocation&, llvm::ArrayRef<char const*>, int&, swift::FrontendObserver*, swift::UnifiedStatsReporter*) + 28340
//39 swift                    0x000000010e278234 swift::performFrontend(llvm::ArrayRef<char const*>, char const*, void*, swift::FrontendObserver*) + 6820
//40 swift                    0x000000010e205733 main + 1219
//41 libdyld.dylib            0x00007fff68e287fd start + 1
//42 libdyld.dylib            0x0000000000000047 start + 2535290955
//error: Segmentation fault: 11 (in target 'solution' from project 'solution')



/// ## [1] Segmentation fault: 11
//Stack dump:
//0.    Program arguments: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift -frontend -c -primary-file /Users/chris/Projects/project-euler/022/solution/solution/main.swift -emit-module-path /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/Objects-normal/x86_64/main~partial.swiftmodule -emit-module-doc-path /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/Objects-normal/x86_64/main~partial.swiftdoc -serialize-diagnostics-path /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/Objects-normal/x86_64/main.dia -emit-dependencies-path /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/Objects-normal/x86_64/main.d -emit-reference-dependencies-path /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/Objects-normal/x86_64/main.swiftdeps -target x86_64-apple-macos10.15 -enable-objc-interop -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk -I /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Products/Debug -F /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Products/Debug -enable-testing -g -module-cache-path /Users/chris/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -swift-version 5 -enforce-exclusivity=checked -Onone -D DEBUG -serialize-debugging-options -Xcc -working-directory -Xcc /Users/chris/Projects/project-euler/022/solution -enable-anonymous-context-mangled-names -Xcc -I/Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/swift-overrides.hmap -Xcc -iquote -Xcc /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/solution-generated-files.hmap -Xcc -I/Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/solution-own-target-headers.hmap -Xcc -I/Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/solution-all-target-headers.hmap -Xcc -iquote -Xcc /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/solution-project-headers.hmap -Xcc -I/Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Products/Debug/include -Xcc -I/Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/DerivedSources-normal/x86_64 -Xcc -I/Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/DerivedSources/x86_64 -Xcc -I/Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/DerivedSources -Xcc -DDEBUG=1 -module-name solution -o /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Build/Intermediates.noindex/solution.build/Debug/solution.build/Objects-normal/x86_64/main.o -index-store-path /Users/chris/Library/Developer/Xcode/DerivedData/solution-cueptxamsunhxoewoblxgjmxvgcx/Index/DataStore -index-system-modules
//1.    While emitting SIL for 'solve()' (at /Users/chris/Projects/project-euler/022/solution/solution/main.swift:61:1)
//2.    While silgen emitFunction SIL function "@$s8solution5solveSiyF".
// for 'solve()' (at /Users/chris/Projects/project-euler/022/solution/solution/main.swift:61:1)
//0  swift                    0x0000000109547a63 PrintStackTraceSignalHandler(void*) + 51
//1  swift                    0x0000000109547236 SignalHandler(int) + 358
//2  libsystem_platform.dylib 0x00007fff6902142d _sigtramp + 29
//3  libsystem_platform.dylib 0x0000000000000009 _sigtramp + 2533223417
//4  swift                    0x000000010558f443 emitRawApply(swift::Lowering::SILGenFunction&, swift::SILLocation, swift::Lowering::ManagedValue, swift::SubstitutionMap, llvm::ArrayRef<swift::Lowering::ManagedValue>, swift::CanTypeWrapper<swift::SILFunctionType>, swift::Lowering::ApplyOptions, llvm::ArrayRef<swift::SILValue>, llvm::SmallVectorImpl<swift::SILValue>&) + 1555
//5  swift                    0x000000010558fab7 swift::Lowering::SILGenFunction::emitApply(std::__1::unique_ptr<swift::Lowering::ResultPlan, std::__1::default_delete<swift::Lowering::ResultPlan> >&&, swift::Lowering::ArgumentScope&&, swift::SILLocation, swift::Lowering::ManagedValue, swift::SubstitutionMap, llvm::ArrayRef<swift::Lowering::ManagedValue>, swift::Lowering::CalleeTypeInfo const&, swift::Lowering::ApplyOptions, swift::Lowering::SGFContext) + 631
//6  swift                    0x000000010559e346 (anonymous namespace)::CallEmission::apply(swift::Lowering::SGFContext) + 3398
//7  swift                    0x000000010559a4ab swift::Lowering::SILGenFunction::emitApplyExpr(swift::Expr*, swift::Lowering::SGFContext) + 2331
//8  swift                    0x00000001055f09b3 swift::Lowering::SILGenFunction::emitExprInto(swift::Expr*, swift::Lowering::Initialization*, llvm::Optional<swift::SILLocation>) + 131
//9  swift                    0x00000001055e3dac swift::Lowering::SILGenFunction::emitPatternBinding(swift::PatternBindingDecl*, unsigned int) + 268
//10 swift                    0x000000010558acad swift::ASTVisitor<swift::Lowering::SILGenFunction, void, void, void, void, void, void>::visit(swift::Decl*) + 93
//11 swift                    0x000000010566651f swift::ASTVisitor<(anonymous namespace)::StmtEmitter, void, void, void, void, void, void>::visit(swift::Stmt*) + 3199
//12 swift                    0x000000010561c5ea swift::Lowering::SILGenFunction::emitFunction(swift::FuncDecl*) + 426
//13 swift                    0x00000001055817b4 swift::Lowering::SILGenModule::emitFunction(swift::FuncDecl*) + 980
//14 swift                    0x000000010558c296 swift::Lowering::SILGenModule::emitSourceFile(swift::SourceFile*) + 1238
//15 swift                    0x000000010558dcf6 swift::SILModule::constructSIL(swift::ModuleDecl*, swift::SILOptions&, swift::FileUnit*) + 1238
//16 swift                    0x000000010518f8f4 performCompile(swift::CompilerInstance&, swift::CompilerInvocation&, llvm::ArrayRef<char const*>, int&, swift::FrontendObserver*, swift::UnifiedStatsReporter*) + 28340
//17 swift                    0x0000000105185234 swift::performFrontend(llvm::ArrayRef<char const*>, char const*, void*, swift::FrontendObserver*) + 6820
//18 swift                    0x0000000105112733 main + 1219
//19 libdyld.dylib            0x00007fff68e287fd start + 1
//20 libdyld.dylib            0x0000000000000047 start + 2535290955
//error: Segmentation fault: 11 (in target 'solution' from project 'solution')
