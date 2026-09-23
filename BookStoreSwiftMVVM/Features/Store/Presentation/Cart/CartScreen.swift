//
//  CartScreen.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

import SwiftUI

struct CartScreen : View {
    @State var viewModel : CartViewModel

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Carrito")
                .toolbar {
                    if !viewModel.items.isEmpty {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Vaciar", role: .destructive) {
                                Task { await viewModel.clear() }
                            }
                        }
                    }
                }
        }
        .actionErrorAlert(viewModel.actionError) {
            viewModel.dismissActionError()
        }
        .task {
            await viewModel.getCart()
        }
    }

    @ViewBuilder
    private var content : some View {
        switch viewModel.state {
        case .loading : LoaderView()
        case .error(let errorMessage): ErrorView(errorMenssage: errorMessage)
        case .empty: EmptyStateView()
        case .loaded(let items) :
            VStack(spacing: 0) {
                List {
                    ForEach(items) { item in
                        CartItemRow(
                            item: item,
                            onIncrease: { await viewModel.increase(item) },
                            onDecrease: { await viewModel.decrease(item) }
                        )
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                Task { await viewModel.remove(item) }
                            } label: {
                                Label("Quitar", systemImage: "trash")
                            }
                        }
                    }
                }

                totalBar
            }
        }
    }

    private var totalBar : some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Total")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("\(viewModel.items.unitCount) artículo(s)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(viewModel.total, format: .currency(code: "USD"))
                .font(.title3.weight(.semibold))
                .monospacedDigit()
        }
        .padding()
        .background(.bar)
        .accessibilityElement(children: .combine)
    }
}
