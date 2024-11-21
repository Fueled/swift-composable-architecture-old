import CustomDumpOld
import XCTest

#if canImport(CoreGraphics)
  import CoreGraphics
#endif

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

#if canImport(SwiftUI)
  import SwiftUI
#endif

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
final class DumpTests: XCTestCase {
  func testAnyType() {
    expectNoDifference(
      String(customDumping: Foo.Bar.self),
      """
      Foo.Bar.self
      """
    )

    struct Feature {
      struct State {}
    }
    expectNoDifference(
      String(customDumping: Feature.State.self),
      """
      DumpTests.Feature.State.self
      """
    )

    expectNoDifference(
      String(customDumping: (x: Double, y: Double).self),
      """
      (x: Double, y: Double).self
      """
    )

    expectNoDifference(
      String(customDumping: Double?.self),
      """
      Double?.self
      """
    )

    expectNoDifference(
      String(customDumping: [Int].self),
      """
      [Int].self
      """
    )

    expectNoDifference(
      String(customDumping: [String: Int].self),
      """
      [String: Int].self
      """
    )

    expectNoDifference(
      String(customDumping: [[Double: Double?]].self),
      """
      [[Double: Double?]].self
      """
    )

    expectNoDifference(
      String(customDumping: [[Double: Double]?].self),
      """
      [[Double: Double]?].self
      """
    )

    expectNoDifference(
      String(customDumping: [[Double: [Double]]]?.self),
      """
      [[Double: [Double]]]?.self
      """
    )

    expectNoDifference(
      String(customDumping: [[[Double: Double]]]?.self),
      """
      [[[Double: Double]]]?.self
      """
    )

    expectNoDifference(
      String(customDumping: [Double: [Double?]].self),
      """
      [Double: [Double?]].self
      """
    )

    expectNoDifference(
      String(customDumping: [Double: [Double]?].self),
      """
      [Double: [Double]?].self
      """
    )
  }

  func testClass() {
    let user = UserClass(
      id: 42,
      name: "Blob"
    )

    var dump = ""
    customDump(user, to: &dump)
    expectNoDifference(
      dump,
      """
      UserClass(
        id: 42,
        name: "Blob"
      )
      """
    )

    dump = ""
    customDump(user, to: &dump, maxDepth: 0)
    expectNoDifference(
      dump,
      """
      UserClass(…)
      """
    )

    let foo = RecursiveFoo()
    foo.foo = foo

    dump = ""
    customDump(foo, to: &dump)
    expectNoDifference(
      dump,
      """
      RecursiveFoo(
        foo: RecursiveFoo(↩︎)
      )
      """
    )
  }

  func testCollection() {
    let users = [
      User(
        id: 1,
        name: "Blob"
      ),
      User(
        id: 2,
        name: "Blob, Jr."
      ),
      User(
        id: 3,
        name: "Blob, Sr."
      ),
    ]

    var dump = ""
    customDump(users, to: &dump)
    expectNoDifference(
      dump,
      """
      [
        [0]: User(
          id: 1,
          name: "Blob"
        ),
        [1]: User(
          id: 2,
          name: "Blob, Jr."
        ),
        [2]: User(
          id: 3,
          name: "Blob, Sr."
        )
      ]
      """
    )

    dump = ""
    customDump(users, to: &dump, maxDepth: 1)
    expectNoDifference(
      dump,
      """
      [
        [0]: User(…),
        [1]: User(…),
        [2]: User(…)
      ]
      """
    )

    dump = ""
    customDump(users, to: &dump, maxDepth: 0)
    expectNoDifference(
      dump,
      """
      […]
      """
    )
  }

  func testDictionary() {
    var dump = ""
    customDump(
      [
        1: User(
          id: 1,
          name: "Blob"
        ),
        2: User(
          id: 2,
          name: "Blob, Jr."
        ),
      ],
      to: &dump
    )
    expectNoDifference(
      dump,
      """
      [
        1: User(
          id: 1,
          name: "Blob"
        ),
        2: User(
          id: 2,
          name: "Blob, Jr."
        )
      ]
      """
    )

    dump = ""
    customDump(
      [
        ID(rawValue: "deadbeef"): User(
          id: 1,
          name: "Blob"
        ),
        ID(rawValue: "beefdead"): User(
          id: 2,
          name: "Blob, Jr."
        ),
      ],
      to: &dump
    )
    expectNoDifference(
      dump,
      """
      [
        ID(rawValue: "beefdead"): User(
          id: 2,
          name: "Blob, Jr."
        ),
        ID(rawValue: "deadbeef"): User(
          id: 1,
          name: "Blob"
        )
      ]
      """
    )

    dump = ""
    customDump(
      OrderedDictionary(
        pairs: [
          2: User(
            id: 2,
            name: "Blob, Jr."
          ),
          1: User(
            id: 1,
            name: "Blob"
          ),
        ] as KeyValuePairs),
      to: &dump
    )
    expectNoDifference(
      dump,
      """
      [
        2: User(
          id: 2,
          name: "Blob, Jr."
        ),
        1: User(
          id: 1,
          name: "Blob"
        )
      ]
      """
    )
  }

  func testDictionary_Nested() {
    struct NestedDictionary {
      let content: [String: Int]
    }

    expectNoDifference(
      """
      DumpTests.NestedDictionary(
        content: [
          "a": 5,
          "b": 9,
          "c": 1,
          "d": -3,
          "e": 12
        ]
      )
      """,
      String(
        customDumping: NestedDictionary(
          content: ["a": 5, "b": 9, "c": 1, "d": -3, "e": 12]
        )
      )
    )
  }

  func testEnum() {
    var dump = ""
    customDump(Enum.foo, to: &dump)
    expectNoDifference(
      dump,
      """
      Enum.foo
      """
    )

    dump = ""
    customDump(Enum.bar(42), to: &dump)
    expectNoDifference(
      dump,
      """
      Enum.bar(42)
      """
    )

    dump = ""
    customDump(Enum.fu(bar: 42), to: &dump)
    expectNoDifference(
      dump,
      """
      Enum.fu(bar: 42)
      """
    )

    dump = ""
    customDump(Enum.baz(fizz: 0.9, buzz: "2"), to: &dump)
    expectNoDifference(
      dump,
      """
      Enum.baz(
        fizz: 0.9,
        buzz: "2"
      )
      """
    )

    dump = ""
    customDump(Enum.fizz(0.9, buzz: "2"), to: &dump)
    expectNoDifference(
      dump,
      """
      Enum.fizz(
        0.9,
        buzz: "2"
      )
      """
    )

    dump = ""
    customDump(Nested.nest(.fizz(0.9, buzz: "2")), to: &dump)
    expectNoDifference(
      dump,
      """
      Nested.nest(
        .fizz(
          0.9,
          buzz: "2"
        )
      )
      """
    )
  }

  func testOptional() {
    var dump = ""
    customDump(User?(.init(id: 42, name: "Blob")), to: &dump)
    expectNoDifference(
      dump,
      """
      User(
        id: 42,
        name: "Blob"
      )
      """
    )

    dump = ""
    customDump(User?(nil), to: &dump)
    expectNoDifference(
      dump,
      """
      nil
      """
    )
  }

  func testSet() {
    var dump = ""
    customDump(Set([1, 2, 3]), to: &dump)
    expectNoDifference(
      dump,
      """
      Set([
        1,
        2,
        3
      ])
      """
    )
  }

  func testSingleValue() {
    var dump = ""
    customDump(1, to: &dump)
    expectNoDifference(
      dump,
      """
      1
      """
    )

    dump = ""
    customDump(true, to: &dump)
    expectNoDifference(
      dump,
      """
      true
      """
    )
  }

  func testStruct() {
    let user = User(
      id: 42,
      name: "Blob"
    )

    var dump = ""
    customDump(user, to: &dump)
    expectNoDifference(
      dump,
      """
      User(
        id: 42,
        name: "Blob"
      )
      """
    )

    dump = ""
    customDump(user, to: &dump, maxDepth: 0)
    expectNoDifference(
      dump,
      """
      User(…)
      """
    )

    let pair = Pair(
      driver: User(
        id: 1,
        name: "Blob"
      ),
      passenger: User(
        id: 2,
        name: "Blob, Jr."
      )
    )

    dump = ""
    customDump(pair, to: &dump)
    expectNoDifference(
      dump,
      """
      Pair(
        driver: User(
          id: 1,
          name: "Blob"
        ),
        passenger: User(
          id: 2,
          name: "Blob, Jr."
        )
      )
      """
    )

    dump = ""
    customDump(pair, to: &dump, maxDepth: 1)
    expectNoDifference(
      dump,
      """
      Pair(
        driver: User(…),
        passenger: User(…)
      )
      """
    )
  }

  func testTuple() {
    var dump = ""
    customDump((1, 2), to: &dump)
    expectNoDifference(
      dump,
      """
      (
        1,
        2
      )
      """
    )

    dump = ""
    customDump((x: 1, y: 2, ()), to: &dump)
    expectNoDifference(
      dump,
      """
      (
        x: 1,
        y: 2,
        ()
      )
      """
    )
  }

  func testString() {
    var dump = ""
    customDump("Hello!", to: &dump)
    expectNoDifference(
      dump,
      #""Hello!""#
    )

    dump = ""
    customDump(#"Hello, "world!""#, to: &dump)
    expectNoDifference(
      dump,
      ##"#"Hello, "world!""#"##
    )

    dump = ""
    customDump(####"This has a "### in it"####, to: &dump)
    expectNoDifference(
      dump,
      #####"####"This has a "### in it"####"#####
    )

    dump = ""
    customDump("This has a \\ in it", to: &dump)
    expectNoDifference(
      dump,
      ##"#"This has a \ in it"#"##
    )

    dump = ""
    customDump("This has no special characters in it", to: &dump)
    expectNoDifference(
      dump,
      "\"This has no special characters in it\""
    )

    dump = ""
    customDump("This has a \t in it", to: &dump)
    expectNoDifference(
      dump,
      "\"This has a \\t in it\""
    )
  }

  func testMultilineString() {
    var dump = ""
    customDump("Hello,\nWorld!", to: &dump)
    expectNoDifference(
      dump,
      #"""
      """
      Hello,
      World!
      """
      """#
    )

    dump = ""
    customDump("Hello,\nWorld!"[...], to: &dump)
    expectNoDifference(
      dump,
      #"""
      """
      Hello,
      World!
      """
      """#
    )

    dump = ""
    customDump(
      Email(
        subject: "RE: Upcoming Event",
        body: """
          To whom it may concern,

          Look forward to it!

          Yours,
          Blob
          """
      ),
      to: &dump
    )
    expectNoDifference(
      dump,
      """
      Email(
        subject: "RE: Upcoming Event",
        body: \"\"\"
          To whom it may concern,
          \n\
          Look forward to it!
          \n\
          Yours,
          Blob
          \"\"\"
      )
      """
    )

    dump = ""
    customDump(
      ##"""
      print(
        #"""
        Hello, world!
        """#
      )
      """##,
      to: &dump
    )
    expectNoDifference(
      dump,
      ###"""
      ##"""
      print(
        #"""
        Hello, world!
        """#
      )
      """##
      """###
    )
  }

  func testAnyHashable() {
    var dump = ""
    customDump(AnyHashable(42), to: &dump)
    expectNoDifference(
      dump,
      """
      42
      """
    )

    dump = ""
    customDump(
      [
        AnyHashable(1): User(id: 1, name: "Blob"),
        AnyHashable("Blob, Jr."): User(id: 2, name: "Blob, Jr."),
      ],
      to: &dump
    )
    expectNoDifference(
      dump,
      """
      [
        "Blob, Jr.": User(
          id: 2,
          name: "Blob, Jr."
        ),
        1: User(
          id: 1,
          name: "Blob"
        )
      ]
      """
    )
  }

  func testKeyPath() {
    // NB: While this should run on >=5.9, it currently crashes CI on Xcode 15
    #if swift(>=5.10) && (os(iOS) || os(macOS) || os(tvOS) || os(watchOS))
      var dump = ""
      if #available(macOS 13.3, iOS 16.4, watchOS 9.4, tvOS 16.4, *) {
        dump = ""
        customDump(\UserClass.name, to: &dump)
        expectNoDifference(
          dump,
          #"""
          \UserClass.name
          """#
        )

        dump = ""
        customDump(\Pair.driver.name, to: &dump)
        expectNoDifference(
          dump,
          #"""
          \Pair.driver.name
          """#
        )

        dump = ""
        customDump(\(x: Double, y: Double).x, to: &dump)
        expectNoDifference(
          dump,
          #"""
          \(x: Double, y: Double).x
          """#
        )

        #if DEBUG
          dump = ""
          customDump(\User.name.count, to: &dump)
          expectNoDifference(
            dump,
            #"""
            \User.name.count
            """#
          )

          dump = ""
          customDump(\Item.$isInStock, to: &dump)
          expectNoDifference(
            dump,
            #"""
            \Item.$isInStock
            """#
          )

          dump = ""
          customDump(\Wrapped<String>.count, to: &dump)
          expectNoDifference(
            dump,
            #"""
            \Wrapped<String>.subscript(dynamicMember: <unknown>)
            """#
          )
        #endif

        return
      } else {
        dump = ""
        customDump(\UserClass.name, to: &dump)
        expectNoDifference(
          dump,
          #"""
          \UserClass.name
          """#
        )

        dump = ""
        customDump(\Pair.driver.name, to: &dump)
        expectNoDifference(
          dump,
          #"""
          \Pair.driver.name
          """#
        )

        dump = ""
        customDump(\User.name.count, to: &dump)
        expectNoDifference(
          dump,
          #"""
          KeyPath<User, Int>
          """#
        )

        dump = ""
        customDump(\(x: Double, y: Double).x, to: &dump)
        expectNoDifference(
          dump,
          #"""
          WritableKeyPath<(x: Double, y: Double), Double>
          """#
        )

        dump = ""
        customDump(\Item.$isInStock, to: &dump)
        expectNoDifference(
          dump,
          #"""
          KeyPath<Item, Wrapped<Bool>>
          """#
        )

        dump = ""
        customDump(\Wrapped<String>.count, to: &dump)
        expectNoDifference(
          dump,
          #"""
          KeyPath<Wrapped<String>, Int>
          """#
        )
      }
    #endif
  }

  func testNamespacedTypes() {
    var dump = ""
    customDump(
      Namespaced.Class(x: 0),
      to: &dump
    )
    expectNoDifference(
      dump,
      """
      Namespaced.Class(x: 0)
      """
    )

    dump = ""
    customDump(
      Namespaced.Enum.x(0),
      to: &dump
    )
    expectNoDifference(
      dump,
      """
      Namespaced.Enum.x(0)
      """
    )

    dump = ""
    customDump(
      Namespaced.Struct(x: 0),
      to: &dump
    )
    expectNoDifference(
      dump,
      """
      Namespaced.Struct(x: 0)
      """
    )
  }

  func testGenerics() {
    var dump = ""
    customDump(
      Result<Result<Int, Error>, Error>.success(.success(42)),
      to: &dump
    )
    expectNoDifference(
      dump,
      """
      Result.success(
        .success(42)
      )
      """
    )
  }

  func testUnknownContexts() {
    struct Inline {}

    var dump = ""
    customDump(
      Inline.self,
      to: &dump
    )
    expectNoDifference(
      dump,
      """
      DumpTests.Inline.self
      """
    )

    dump = ""
    customDump(
      Inline(),
      to: &dump
    )
    expectNoDifference(
      dump,
      """
      DumpTests.Inline()
      """
    )
  }

  func testCustomMirror() {
    var dump = ""
    customDump(Button(), to: &dump)
    expectNoDifference(
      dump,
      """
      Button.cancel(
        action: nil,
        label: "Cancel"
      )
      """
    )

    dump = ""
    customDump(
      LoginState(
        email: "blob@pointfree.co",
        password: "bl0bisawesome!",
        token: "secret"
      ),
      to: &dump
    )
    expectNoDifference(
      dump,
      """
      LoginState(
        email: "blob@pointfree.co",
        password: <redacted>
      )
      """
    )
  }

  func testCustomOverride() {
    var dump = ""
    customDump(Wrapper(rawValue: 42), to: &dump)
    expectNoDifference(
      dump,
      """
      42
      """
    )
  }

  func testStandardLibrary() {
    var dump = ""
    customDump("©" as Character, to: &dump)
    expectNoDifference(
      dump,
      """
      "©"
      """
    )

    dump = ""
    customDump("Blob" as StaticString, to: &dump)
    expectNoDifference(
      dump,
      """
      "Blob"
      """
    )

    dump = ""
    customDump("©" as UnicodeScalar, to: &dump)
    expectNoDifference(
      dump,
      """
      "©"
      """
    )
  }

  func testSuperclass() {
    var dump = ""
    class Human {
      let name = "John"
      let email = "john@me.com"
      let age = 97
    }

    class Doctor: Human {
      let field = "Podiatry"
    }

    customDump(Doctor(), to: &dump)

    expectNoDifference(
      dump,
      """
      DumpTests.Doctor(
        name: "John",
        email: "john@me.com",
        age: 97,
        field: "Podiatry"
      )
      """
    )
  }

  func testLayersOfInheritance() {
    var dump = ""
    class Human {
      let name = "John"
      let email = "john@me.com"
      let age = 97
    }

    class Doctor: Human {
      let field = "Podiatry"
    }

    class Surgeon: Doctor {
      let skillLevel = "Expert"
    }

    customDump(Surgeon(), to: &dump)

    expectNoDifference(
      dump,
      """
      DumpTests.Surgeon(
        name: "John",
        email: "john@me.com",
        age: 97,
        field: "Podiatry",
        skillLevel: "Expert"
      )
      """
    )
  }

  func testRecursion() {
    class Human {
      let name: String

      init(name: String) {
        self.name = name
      }
    }

    class Child: Human {
      weak var parent: Parent?
    }

    class Parent: Human {
      let children: [Human]

      init(name: String, children: [Child]) {
        self.children = children
        super.init(name: name)

        children.forEach {
          $0.parent = self
        }
      }
    }

    let subject = Parent(
      name: "Arthur",
      children: [
        Child(name: "Virginia"),
        Child(name: "Ronald"),
        Child(name: "Fred"),
        Child(name: "George"),
        Child(name: "Percy"),
        Child(name: "Charles"),
      ])

    var dump = ""
    customDump(subject, to: &dump)

    expectNoDifference(
      dump,
      """
      DumpTests.Parent(
        name: "Arthur",
        children: [
          [0]: DumpTests.Child(
            name: "Virginia",
            parent: DumpTests.Parent(↩︎)
          ),
          [1]: #1 DumpTests.Child(
            name: "Ronald",
            parent: DumpTests.Parent(↩︎)
          ),
          [2]: #2 DumpTests.Child(
            name: "Fred",
            parent: DumpTests.Parent(↩︎)
          ),
          [3]: #3 DumpTests.Child(
            name: "George",
            parent: DumpTests.Parent(↩︎)
          ),
          [4]: #4 DumpTests.Child(
            name: "Percy",
            parent: DumpTests.Parent(↩︎)
          ),
          [5]: #5 DumpTests.Child(
            name: "Charles",
            parent: DumpTests.Parent(↩︎)
          )
        ]
      )
      """
    )
  }

  func testRepetition() {
    class Human {
      let name = "John"
    }

    class User: Human {
      let email = "john@me.com"
      let age = 97

      let human: Human

      init(human: Human) {
        self.human = human
      }
    }

    let human = Human()
    let human2 = Human()

    let user = User(human: human)
    let user2 = User(human: human2)

    var dump = ""
    customDump(
      [
        human,
        human,
        human,
        human2,
        human2,
        human2,
        user,
        user,
        user,
        user2,
        user2,
        user2,
      ], to: &dump)

    expectNoDifference(
      dump,
      """
      [
        [0]: DumpTests.Human(name: "John"),
        [1]: DumpTests.Human(↩︎),
        [2]: DumpTests.Human(↩︎),
        [3]: #1 DumpTests.Human(name: "John"),
        [4]: #1 DumpTests.Human(↩︎),
        [5]: #1 DumpTests.Human(↩︎),
        [6]: DumpTests.User(
          name: "John",
          email: "john@me.com",
          age: 97,
          human: DumpTests.Human(↩︎)
        ),
        [7]: DumpTests.User(↩︎),
        [8]: DumpTests.User(↩︎),
        [9]: #1 DumpTests.User(
          name: "John",
          email: "john@me.com",
          age: 97,
          human: #1 DumpTests.Human(↩︎)
        ),
        [10]: #1 DumpTests.User(↩︎),
        [11]: #1 DumpTests.User(↩︎)
      ]
      """
    )
  }

  #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
    func testDuration() {
      guard #available(macOS 13, iOS 16, watchOS 9, tvOS 16, *) else { return }

      expectNoDifference(
        String(customDumping: Duration.seconds(5)),
        """
        5 seconds
        """
      )

      expectNoDifference(
        String(customDumping: Duration.seconds(5) + .milliseconds(123)),
        """
        5 seconds, 123 milliseconds
        """
      )
    }
  #endif

  #if canImport(CoreGraphics)
    func testCoreGraphics() {
      var dump = ""
      customDump(
        CGRect(x: 0.5, y: 0.5, width: 1.5, height: 1.5),
        to: &dump
      )
      expectNoDifference(
        dump,
        """
        CGRect(
          origin: CGPoint(
            x: 0.5,
            y: 0.5
          ),
          size: CGSize(
            width: 1.5,
            height: 1.5
          )
        )
        """
      )
    }
  #endif

  #if canImport(SwiftUI)
    func testSwiftUI() {
      var dump = ""
      customDump(
        Animation.easeInOut,
        to: &dump
      )
      expectNoDifference(
        dump,
        """
        Animation.easeInOut
        """
      )
    }
  #endif

  func testObservationRegistrarFiltered() {
    struct ObservationRegistrar {}
    class Object {
      let name = "Blob Sr."
      let _$observationRegistrar = ObservationRegistrar()
    }
    expectNoDifference(
      String(customDumping: Object()),
      """
      DumpTests.Object(
        name: "Blob Sr."
      )
      """
    )
    struct Value {
      let name = "Blob Jr."
      let _$observationRegistrar = ObservationRegistrar()
    }
    expectNoDifference(
      String(customDumping: Value()),
      """
      DumpTests.Value(
        name: "Blob Jr."
      )
      """
    )
  }

  func testExplicitFilteredPropertyPreserved() {
    struct ObservationRegistrar {}
    class Object: CustomDumpReflectable {
      let name = "Blob Sr."
      let _$observationRegistrar = ObservationRegistrar()

      var customDumpMirror: Mirror {
        Mirror(
          self,
          children: ["name": self.name, "_$observationRegistrar": self._$observationRegistrar],
          displayStyle: .class
        )
      }
    }
    expectNoDifference(
      String(customDumping: Object()),
      """
      DumpTests.Object(
        name: "Blob Sr.",
        _$observationRegistrar: DumpTests.ObservationRegistrar()
      )
      """
    )
  }

  func testDiffableObject() {
    struct Login {
      var email: String
    }

    class DiffableObject: _CustomDiffObject {
      var _customDiffValues: (Any, Any) {
        (Login(email: "blob@pointfree.co"), Login(email: "admin@pointfree.co"))
      }
    }

    struct DiffableObjects {
      var obj1: DiffableObject
      var obj2: DiffableObject
    }

    struct DiffableObjectsParent {
      var objs1: DiffableObjects
      var objs2: DiffableObjects
    }

    let obj1 = DiffableObject()
    let obj2 = DiffableObject()

    expectNoDifference(
      String(
        customDumping: DiffableObjectsParent(
          objs1: DiffableObjects(obj1: obj1, obj2: obj1),
          objs2: DiffableObjects(obj1: obj2, obj2: obj2)
        )
      ),
      """
      DumpTests.DiffableObjectsParent(
        objs1: DumpTests.DiffableObjects(
          obj1: #1 DumpTests.Login(email: "admin@pointfree.co"),
          obj2: #1 DumpTests.Login(↩︎)
        ),
        objs2: DumpTests.DiffableObjects(
          obj1: #2 DumpTests.Login(email: "admin@pointfree.co"),
          obj2: #2 DumpTests.Login(↩︎)
        )
      )
      """
    )

    expectNoDifference(
      String(
        customDumping: DiffableObjectsParent(
          objs1: DiffableObjects(obj1: obj1, obj2: obj2),
          objs2: DiffableObjects(obj1: obj2, obj2: obj1)
        )
      ),
      """
      DumpTests.DiffableObjectsParent(
        objs1: DumpTests.DiffableObjects(
          obj1: #1 DumpTests.Login(email: "admin@pointfree.co"),
          obj2: #2 DumpTests.Login(email: "admin@pointfree.co")
        ),
        objs2: DumpTests.DiffableObjects(
          obj1: #2 DumpTests.Login(↩︎),
          obj2: #1 DumpTests.Login(↩︎)
        )
      )
      """
    )
  }

  func testDiffableObject_Primitive() {
    class DiffableObject: _CustomDiffObject {
      var _customDiffValues: (Any, Any) {
        ("before", "after")
      }
      static func == (lhs: DiffableObject, rhs: DiffableObject) -> Bool {
        false
      }
    }

    struct DiffableObjects {
      var obj1: DiffableObject
      var obj2: DiffableObject
    }

    struct DiffableObjectsParent {
      var objs1: DiffableObjects
      var objs2: DiffableObjects
    }

    let obj1 = DiffableObject()
    let obj2 = DiffableObject()
    let objs1 = DiffableObjects(obj1: obj1, obj2: obj1)
    let objs2 = DiffableObjects(obj1: obj2, obj2: obj2)
    let objsParent = DiffableObjectsParent(objs1: objs1, objs2: objs2)

    expectNoDifference(
      String(customDumping: objsParent),
      """
      DumpTests.DiffableObjectsParent(
        objs1: DumpTests.DiffableObjects(
          obj1: #1 "after",
          obj2: #1 String(↩︎)
        ),
        objs2: DumpTests.DiffableObjects(
          obj1: #2 "after",
          obj2: #2 String(↩︎)
        )
      )
      """
    )
  }
}