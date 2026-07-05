import Foundation

struct SampleListItem: Identifiable, Hashable {
    let id: Int
    let title: String
    let detail: String
}

struct SamplePerson: Identifiable, Hashable {
    let id: Int
    let name: String
    let role: String
    let location: String
}

enum SamplePreviewData {
    static let listItems = [
        SampleListItem(id: 1, title: "Overview", detail: "Project summary"),
        SampleListItem(id: 2, title: "Design", detail: "Interface notes"),
        SampleListItem(id: 3, title: "Implementation", detail: "Open tasks"),
        SampleListItem(id: 4, title: "Testing", detail: "Verification plan"),
        SampleListItem(id: 5, title: "Release", detail: "Ship checklist"),
        SampleListItem(id: 6, title: "Archive", detail: "Reference material"),
        SampleListItem(id: 7, title: "Settings", detail: "Local preferences"),
        SampleListItem(id: 8, title: "Support", detail: "Maintenance notes")
    ]

    static let people = [
        SamplePerson(id: 1, name: "Avery Chen", role: "Design", location: "Seattle"),
        SamplePerson(id: 2, name: "Morgan Lee", role: "Engineering", location: "Austin"),
        SamplePerson(id: 3, name: "Riley Smith", role: "Product", location: "New York"),
        SamplePerson(id: 4, name: "Jordan Patel", role: "QA", location: "Boston"),
        SamplePerson(id: 5, name: "Casey Kim", role: "Support", location: "Denver"),
        SamplePerson(id: 6, name: "Taylor Nguyen", role: "Research", location: "Portland")
    ]
}
