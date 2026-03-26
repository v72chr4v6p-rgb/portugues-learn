import SwiftUI

struct LessonPageView: View {
    let lessons: [LessonPage]
    @State private var currentIndex: Int
    @Environment(\.dismiss) private var dismiss

    init(lessons: [LessonPage], startIndex: Int) {
        self.lessons = lessons
        _currentIndex = State(initialValue: startIndex)
    }

    private var currentLesson: LessonPage? {
        guard currentIndex < lessons.count else { return nil }
        return lessons[currentIndex]
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                progressBar

                if let lesson = currentLesson {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(lesson.blocks) { block in
                                blockView(block)
                            }
                        }
                        .padding(20)
                        .padding(.bottom, 80)
                    }
                }

                Spacer(minLength: 0)

                navigationBar
            }
            .navigationTitle("Lesson")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.body.weight(.semibold))
                            Text("Close")
                        }
                        .foregroundStyle(Theme.tangerine)
                    }
                }
            }
        }
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(.systemGray5))

                Rectangle()
                    .fill(Theme.tangerine)
                    .frame(width: lessons.count > 0
                        ? geo.size.width * CGFloat(currentIndex + 1) / CGFloat(lessons.count)
                        : 0
                    )
                    .animation(.spring(response: 0.4), value: currentIndex)
            }
        }
        .frame(height: 4)
    }

    @ViewBuilder
    private func blockView(_ block: ContentBlock) -> some View {
        switch block.type {
        case .heading:
            Text(block.text)
                .font(.title2.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)

        case .subheading:
            Text(block.text)
                .font(.title3.weight(.semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)

        case .paragraph:
            Text(block.text)
                .font(.body)
                .foregroundStyle(.primary.opacity(0.85))
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineSpacing(4)

        case .tip:
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "lightbulb.fill")
                    .font(.body)
                    .foregroundStyle(Theme.tangerine)
                    .padding(.top, 2)

                Text(block.text)
                    .font(.subheadline)
                    .foregroundStyle(.primary.opacity(0.8))
                    .lineSpacing(3)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.tangerine.opacity(0.08), in: .rect(cornerRadius: 12))

        case .bullets:
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(block.items.enumerated()), id: \.offset) { _, item in
                    HStack(alignment: .top, spacing: 10) {
                        Text("•")
                            .font(.body.weight(.bold))
                            .foregroundStyle(Theme.tangerine)
                        Text(item)
                            .font(.body)
                            .foregroundStyle(.primary.opacity(0.85))
                    }
                }
            }

        case .steps:
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(block.items.enumerated()), id: \.offset) { index, item in
                    HStack(alignment: .top, spacing: 12) {
                        Text("Step \(index + 1):")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.tangerine)
                            .frame(width: 56, alignment: .leading)
                        Text(item)
                            .font(.body)
                    }
                }
            }

        case .table:
            tableView(headers: block.headers, rows: block.rows)

        case .highlight:
            Text(block.text)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Theme.tangerine)
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.tangerine.opacity(0.06), in: .rect(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Theme.tangerine.opacity(0.2), lineWidth: 1)
                )

        case .question:
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundStyle(Theme.sage)
                    Text("Think about it")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.sage)
                }
                Text(block.text)
                    .font(.body.weight(.medium))
                    .italic()
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.sage.opacity(0.08), in: .rect(cornerRadius: 12))
        }
    }

    private func tableView(headers: [String], rows: [[String]]) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(Array(headers.enumerated()), id: \.offset) { colIndex, header in
                    Text(header)
                        .font(.subheadline.weight(.bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(.tertiarySystemBackground))
                    if colIndex < headers.count - 1 {
                        Divider()
                    }
                }
            }

            Divider()

            ForEach(Array(rows.enumerated()), id: \.offset) { rowIndex, row in
                HStack(spacing: 0) {
                    ForEach(Array(row.enumerated()), id: \.offset) { colIndex, cell in
                        Text(cell)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 9)
                        if colIndex < row.count - 1 {
                            Divider()
                        }
                    }
                }

                if rowIndex < rows.count - 1 {
                    Divider()
                }
            }
        }
        .clipShape(.rect(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color(.separator).opacity(0.5), lineWidth: 1)
        )
    }

    private var navigationBar: some View {
        HStack(spacing: 16) {
            Button {
                withAnimation(.spring(response: 0.35)) {
                    currentIndex = max(0, currentIndex - 1)
                }
                HapticService.selection()
            } label: {
                Text("Previous")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(currentIndex > 0 ? .primary : .secondary)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        Color(.secondarySystemBackground),
                        in: .rect(cornerRadius: 12)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color(.separator).opacity(0.3), lineWidth: 1)
                    )
            }
            .disabled(currentIndex <= 0)

            Button {
                if currentIndex < lessons.count - 1 {
                    withAnimation(.spring(response: 0.35)) {
                        currentIndex += 1
                    }
                    HapticService.selection()
                } else {
                    dismiss()
                }
            } label: {
                Text(currentIndex < lessons.count - 1 ? "Next lesson" : "Done")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.tangerine)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        Theme.tangerine.opacity(0.12),
                        in: .rect(cornerRadius: 12)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }
}
