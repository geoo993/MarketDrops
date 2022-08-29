import SwiftUI
import MarketDropsDomain
import MarketDropsDomainFixtures

struct CardNewsView: View {
    @ObservedObject var imageViewModel: ImageViewModel
    @State var article: CompanyNews.Article
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: UIConstants.cornerRadius)
                .fill(Color.blue)
            HStack {
                Unwrap(article.image) { image in
                    ImageView(viewModel: imageViewModel, imageURL: image)
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
            .padding(EdgeInsets(
                top: UIConstants.padding,
                leading: UIConstants.padding,
                bottom: UIConstants.padding,
                trailing: UIConstants.padding
            ))
        }
    }
}

struct CardNewsView_Previews: PreviewProvider {
    static var previews: some View {
        CardNewsView(imageViewModel: .init(), article: .fixture())
    }
}
