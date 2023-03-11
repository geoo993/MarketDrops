import SwiftUI
import MarketDropsDomain
import MarketDropsDomainFixtures
import ComposableArchitecture

struct CardNewsView: View {
    let store: StoreOf<ImageLoading>
    @State var article: CompanyNews.Article
    
    var body: some View {
        HStack {
            Unwrap(article.image) { image in
                ImageView(store: store, imageUrl: image)
                .frame(width: 120, height: 90)
            }
            VStack(alignment: .leading, spacing: UIConstants.spacing) {
                Text(article.title)
                    .bold()
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text(article.description)
                    .font(.caption2)
                    .foregroundColor(Color.white)
                Spacer()
            }
        }
        .padding(.all, UIConstants.padding)
        .cardStyle(
            primaryColor: Color("brandBlue"),
            secondaryColor: Color("brandBlueDarker"),
            radius: UIConstants.cornerRadius
        )
    }
}
