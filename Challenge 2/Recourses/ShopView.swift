import SwiftUI

struct ShopView: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var purchasedItemName: String? = nil

    var body: some View {
        ZStack {
            PaperBackground()

            VStack(spacing: 24) {
                // Header
                HStack {
                    Button {
                        vm.resetToSpin()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(AppColor.ink)
                    }

                    Text("Shop")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Spacer()

                    CoinBadge()
                }
                .padding(.horizontal, 24)

                // Items grid
                HStack(spacing: 16) {
                    ForEach(ShopItem.allItems) { item in
                        itemCard(item)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()
            }
            .padding(.top, 60)

            // Purchase feedback
            if let name = purchasedItemName {
                purchaseFeedback(name)
            }
        }
    }

    // MARK: - Subviews

    private func itemCard(_ item: ShopItem) -> some View {
        let owned = vm.owns(item)
        let canAfford = vm.coins >= item.price

        return VStack(spacing: 8) {
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)

            Text(item.name)
                .font(.system(size: 18, weight: .bold, design: .rounded))

            if owned {
                Text("Owned")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.green)
            } else {
                Button {
                    buyItem(item)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "star.circle.fill")
                            .foregroundStyle(.yellow)
                            .font(.system(size: 14))
                        Text("\(item.price)")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(canAfford ? .white : .gray)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        canAfford ? AppColor.ink : Color.gray.opacity(0.2),
                        in: Capsule()
                    )
                }
                .disabled(!canAfford)
            }
        }
        .frame(width: 170, height: 170)
        .background(Color.lightGrayy)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .strokeBorder(owned ? Color.green.opacity(0.5) : Color.darkGrayy, lineWidth: 5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }

    private func purchaseFeedback(_ name: String) -> some View {
        Text("You got \(name)!")
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(AppColor.ink, in: Capsule())
            .transition(.scale.combined(with: .opacity))
            .offset(y: 200)
    }

    // MARK: - Actions

    private func buyItem(_ item: ShopItem) {
        guard vm.purchase(item: item) else { return }

        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            purchasedItemName = item.name
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { purchasedItemName = nil }
        }
    }
}

#Preview("With coins") {
    ShopView()
        .environmentObject(AppViewModel.preview(coins: 30))
}

#Preview("One owned") {
    ShopView()
        .environmentObject(AppViewModel.preview(coins: 10, owned: ["dodit"]))
}
