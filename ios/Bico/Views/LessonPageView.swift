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
            .background(Pico.plaster.ignoresSafeArea())
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
                        .foregroundStyle(Pico.deepForestGreen)
                    }
                }
            }
        }
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Pico.earthBrown.opacity(0.08))

                Rectangle()
                    .fill(Pico.primaryGradient)
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
                .font(.system(.title2, design: .serif, weight: .bold))
                .tracking(-0.3)
                .foregroundStyle(Pico.deepForestGreen)
                .frame(maxWidth: .infinity, alignment: .leading)

        case .subheading:
            Text(block.text)
                .font(.system(.title3, design: .serif, weight: .semibold))
                .tracking(-0.3)
                .foregroundStyle(Pico.deepForestGreen)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)

        case .paragraph:
            Text(block.text)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(Pico.deepForestGreen.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineSpacing(4)

        case .tip:
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "lightbulb.fill")
                    .font(.body)
                    .foregroundStyle(Pico.amber)
                    .padding(.top, 2)

                Text(block.text)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(Pico.deepForestGreen.opacity(0.8))
                    .lineSpacing(3)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Pico.amber.opacity(0.06), in: .rect(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Pico.amber.opacity(0.15), lineWidth: 1)
            )

        case .bullets:
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(block.items.enumerated()), id: \.offset) { _, item in
                    HStack(alignment: .top, spacing: 10) {
                        Text("•")
                            .font(.body.weight(.bold))
                            .foregroundStyle(Pico.leafGreen)
                        Text(item)
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(Pico.deepForestGreen.opacity(0.8))
                    }
                }
            }

        case .steps:
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(block.items.enumerated()), id: \.offset) { index, item in
                    HStack(alignment: .top, spacing: 12) {
                        Text("Step \(index + 1):")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundStyle(Pico.deepForestGreen)
                            .frame(width: 56, alignment: .leading)
                        Text(item)
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(Pico.deepForestGreen.opacity(0.8))
                    }
                }
            }

        case .table:
            tableView(headers: block.headers, rows: block.rows)

        case .highlight:
            Text(block.text)
                .font(.system(.subheadline, design: .rounded, weight: .medium))
                .foregroundStyle(Pico.deepForestGreen)
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Pico.leafGreen.opacity(0.06), in: .rect(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Pico.leafGreen.opacity(0.15), lineWidth: 1)
                )

        case .question:
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundStyle(Pico.leafGreen)
                    Text("Think about it")
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                        .foregroundStyle(Pico.leafGreen)
                }
                Text(block.text)
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .italic()
                    .foregroundStyle(Pico.deepForestGreen.opacity(0.8))
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Pico.leafGreen.opacity(0.06), in: .rect(cornerRadius: 12))
        }
    }

    private func tableView(headers: [String], rows: [[String]]) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(Array(headers.enumerated()), id: \.offset) { colIndex, header in
                    Text(header)
                        .font(.system(.subheadline, design: .rounded, weight: .bold))
                        .foregroundStyle(Pico.deepForestGreen)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Pico.cardSurface)
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
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(Pico.deepForestGreen.opacity(0.8))
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
                .strokeBorder(Pico.earthBrown.opacity(0.1), lineWidth: 1)
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
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(currentIndex > 0 ? Pico.deepForestGreen : Pico.deepForestGreen.opacity(0.3))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Pico.cardSurface, in: .rect(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Pico.earthBrown.opacity(0.1), lineWidth: 1)
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
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(Pico.deepForestGreen)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Pico.deepForestGreen.opacity(0.08), in: .rect(cornerRadius: 12))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Pico.plaster.opacity(0.95))
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Pico.earthBrown.opacity(0.06))
                .frame(height: 1)
        }
    }
}
