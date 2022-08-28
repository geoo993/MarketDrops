import SwiftUI
import MarketDropsDomain
import MarketDropsDomainFixtures

struct CardView: View {
    @State var item: IPOCalendar.Company
    
    var body: some View {
        LazyVStack {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(item.name)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color.white)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .lineLimit(2)
                        VStack {
                            Unwrap(item.symbol) { value in
                                Text(value)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color.white)
                                    .frame(alignment: .trailing)
                                    .lineLimit(1)
                            }
                        }
                        .frame(minWidth: 0, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Unwrap(item.price) { value in
                            Text("ipo_card__price".localized(arguments: value))
                                .font(.system(size: 30, weight: .medium))
                                .foregroundColor(Color.white)
                        }
                        HStack {
                            Unwrap(item.description) { value in
                                Text(value)
                                    .font(.system(size: 12, weight: .medium))
                                    .padding(.all, 4)
                                    .foregroundColor(Color.white)
                            }
                        }
                        .padding(.top, UIConstants.mediumPadding)
                    }
                    .padding(.top, UIConstants.mediumPadding)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.all, UIConstants.padding)
        }
        .cardStyle(
            primaryColor: item.primaryColor,
            secondaryColor: item.secondaryColor,
            radius: UIConstants.cornerRadius
        )
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(item: .fixture())
    }
}
