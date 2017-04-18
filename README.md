## Simple iOS Data Persistence Using Realm
### Why [Realm](https://realm.io)?
Let's start with a little bit of introduction.
The Realm Mobile Database is a cross-platform mobile database solution designed for mobile applications and it has a lot of advantages,
for example, it is fast, easy to set up, and requires less boilerplate code.
Moreover, the Realm Object Server has been released last year and perhaps I will try the macOS version in the future.

### Schema & Model
For simplicity, I only use one table called `BookObject` within this demonstration and this table contains four attributes, including `bookID`, `name`, `comment`, and `rating`.
The following is the definition of my Realm Object.
```
final class BookObject: Object {
    dynamic var bookID: String = UUID().uuidString
    dynamic var name: String = ""
    dynamic var comment: String? = nil
    dynamic var rating: Int = 0
}
```
Because of thread safety and separation of concerns, I define another immutable model struct called `Book` and use it to present the information of each book in the database.
```
struct Book {
    enum RatingScale: Int {
        case notRecommended = 0
        case mediocre
        case good
        case veryGood
        case outstanding
    }

    let bookID: String
    let name: String
    let comment: String?
    let rating: RatingScale
}
```
It is a good practice because it removes the knowledge between my view controllers and `BookObject`.
However, it also brings a little bit of complexity: I need to transform `BookObject` to `Book` and the other way around.

### Data Manipulation
Let's put the transformations aside and implement my `Database` class at first. It contains a Realm database instance and handles data manipulation with that instance.
Again, my view controllers shouldn't know the Realm database instance so I set it as a private property and assign the property through dependency injection.
```
final class Database {    
    private let realm: Realm

    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
}
```
Generally speaking, I will implement the transformations between `Book` and `BookObject` within `Database`'s CRUD methods, for example, `-createBook` or `-fetchBook`.
Nevertheless, it's not a swifty way to handle this situation because those methods will be highly coupled with `Book` and `BookObject`.
If there comes a new model, those methods cannot be reused so it's necessary to add a bunch of new methods just for the new model itself.
A better way to solve this problem is to introduce closures as parameters of CRUD methods and these closures are responsible for the transformations between model and Realm object.
```
// Inside Database class
func createOrUpdate<Model, RealmObject: Object>(model: Model, with reverseTransformer: (Model) -> RealmObject) {
    let object = reverseTransformer(model)
    try! realm.write {
        realm.add(object, update: true)
    }
}

func fetch<Model, RealmObject: Object>(with predicate: NSPredicate?, sortDescriptors: [SortDescriptor], transformer: (Results<RealmObject>) -> Model) -> Model {
    var results = realm.objects(RealmObject.self)

    if let predicate = predicate {
        results = results.filter(predicate)
    }

    if sortDescriptors.count > 0 {
        results = results.sorted(by: sortDescriptors)
    }

    return transformer(results)
}

func delete<RealmObject: Object>(type: RealmObject.Type, with primaryKey: String) {
    let object = realm.object(ofType: type, forPrimaryKey: primaryKey)
    if let object = object {
        try! realm.write {
            realm.delete(object)
        }
    }
}
```
In addition, I also create two custom initializers of `Book` and `BookObject`, in order to actually handle the transformations.
```
extension BookObject {
    convenience init(book: Book) {
        self.init()

        // Assign properties here
    }
}

extension Book {
    init(object: BookObject) {
        // Assign properties here
    }
}
```
Finally, in order to make my codebase more readable and concise, I extract the parameters of the `-fetch` method and define a new struct called `FetchRequest`.
Thus, I am able to write an extension of `Book` and generate the request that I want.
```
struct FetchRequest<Model, RealmObject: Object> {    
    let predicate: NSPredicate?
    let sortDescriptors: [SortDescriptor]
    let transformer: (Results<RealmObject>) -> Model
}

extension Book {
    static let all = FetchRequest<[Book], BookObject>(predicate: nil, sortDescriptors: [], transformer: { $0.map(Book.init) })
}
```

### Testing
Because I integrate Realm and RealmSwift into my project via [_Carthage_](https://github.com/Carthage/Carthage),
it's important to add the variable into _Framework Search Paths_ in _Build Settings_ of my test target before writing some tests.
![framework-search-paths](https://github.com/ShengHuaWu/DataPersistence/blob/master/Resources/framework%20search%20paths.png)
It's quite dangerous to use the real Realm database instance for testing because it will mess up the real data.
Fortunately, Realm provides an in-memory database instance by setting the `inMemoryIdentifier` rather than the `fileURL` on the `Realm.Configuration`.
```
class DatabaseTests: XCTestCase {
    var database: Database!

    override func setUp() {
        super.setUp()

        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "com.shenghuawu.DataPersistence"))
        database = Database(realm: realm)
    }
}
```
After creating my Database instance with the in-memory Realm database instance, let's write some tests for Book creation and updating.
```
// Inside DatabaseTests class
func testBookCreation() {
    let newBook = Book.bigLittleLies

    database.createOrUpdate(model: newBook, with: BookObject.init)

    // Verify with assertions
}

func testBookUpdating() {
    let newBook = Book.fake
    database.createOrUpdate(model: newBook, with: BookObject.init)
    let bookInDB = database.fetch(with: Book.all).first!

    let modifiedBook = Book(bookID: bookInDB.bookID, name: "New Name", comment: "Change the rating and the name of this book.", rating: .mediocre)
    database.createOrUpdate(model: modifiedBook, with: BookObject.init)

    // Verify with assertions
}
```

### Conclusion
The sample project is [here](https://github.com/ShengHuaWu/DataPersistence).
Data persistence plays a very crucial role in every iOS app and Realm provides an ideal solution of this.
I hope this article gives a simple concept of how to implement data persistence with Realm.
However, there are still couple things which can be improved, for example, handling errors from each database write transaction or taking the advantage of Realm.Configuration to separate database from different users.
If you have any comments or questions on this article, please leave a response below. Thank you!
