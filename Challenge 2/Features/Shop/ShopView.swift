import SwiftUI

struct ShopView: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var purchasedItemName: String? = nil

    var body: some View {
        VStack(spacing: 0) {
            headerBar
            itemList
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Image("titikkertas")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .overlay(alignment: .bottom) {
            if let name = purchasedItemName {
                toastBanner(name)
            }
        }
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack(alignment: .center, spacing: 0) {
            Button {
                Menggetar.instance.Getar(style: .medium)
                vm.resetToSpin()
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .bold))
                    Text("Back")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                }
                .padding(.horizontal, 13)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial, in: Capsule())
            }
            .buttonStyle(.plain)
            .foregroundColor(Color(red: 0.14, green: 0.12, blue: 0.10))

            Spacer()

            Text("Shop")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(Color(red: 0.14, green: 0.12, blue: 0.10))

            Spacer()

            CoinBadge()
        }
        .padding(.horizontal, 24)
        .padding(.top, 60)
        .padding(.bottom, 16)
    }

    // MARK: - List

    private var itemList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(ShopItem.allItems) { item in
                    itemRow(item)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 48)
        }
    }

    // MARK: - Row

    private func itemRow(_ item: ShopItem) -> some View {
        let owned = vm.owns(item)
        let canAfford = vm.coins >= item.price

        return HStack(alignment: .center, spacing: 14) {
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .background(Color(red: 0.92, green: 0.88, blue: 0.80), in: RoundedRectangle(cornerRadius: 10))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 3) {
                Text(item.name)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.14, green: 0.12, blue: 0.10))
                Text("Wheel theme")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(Color(red: 0.55, green: 0.50, blue: 0.44))
            }

            Spacer(minLength: 0)

            if owned {
                Text("Owned")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.green)
                    .padding(.horizontal, 11)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.12), in: Capsule())
            } else {
                Button {
                    buyItem(item)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "fish.circle.fill")
                            .foregroundColor(.yellow)
                        Text("\(item.price)")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(canAfford ? .white : Color(red: 0.55, green: 0.50, blue: 0.44))
                    }
                    .padding(.horizontal, 13)
                    .padding(.vertical, 7)
                    .background(
                        canAfford
                            ? Color(red: 0.14, green: 0.12, blue: 0.10)
                            : Color.gray.opacity(0.18),
                        in: Capsule()
                    )
                }
                .buttonStyle(.plain)
                .disabled(!canAfford)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 1.00, green: 0.99, blue: 0.96))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    owned ? Color.green.opacity(0.4) : Color(red: 0.92, green: 0.88, blue: 0.80),
                    lineWidth: 1.5
                )
        }
    }

    // MARK: - Toast

    private func toastBanner(_ name: String) -> some View {
        Text("You got \(name)!")
            .font(.system(size: 17, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 22)
            .padding(.vertical, 12)
            .background(Color(red: 0.14, green: 0.12, blue: 0.10), in: Capsule())
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .padding(.bottom, 52)
    }

    // MARK: - Actions

    private func buyItem(_ item: ShopItem) {
        guard vm.purchase(item: item) else { return }
        Menggetar.instance.notifGetar(notif: .success)
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
