import SwiftUI
import MarketDropsDomain
import MarketDropsDomainFixtures

struct CardFilingView: View {
    @State var filing: CompanyFiling
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: UIConstants.spacing) {
                Text(filing.symbol)
                    .foregroundColor(.white)
                    .font(.body)
                    .fontWeight(.bold)
                Text(filing.accessNumber)
                    .foregroundColor(.white)
                    .font(.subheadline)
                Unwrap(filing.form) { _ in
                    Text(filing.filingDescription)
                        .foregroundColor(.white)
                        .font(.footnote)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.all, UIConstants.padding)
        .cardStyle(
            primaryColor: Color("brandBlue"),
            secondaryColor: Color("brandBlueDarker"),
            radius: UIConstants.cornerRadius
        )
    }
}

struct CardFilingView_Previews: PreviewProvider {
    static var previews: some View {
        CardFilingView(filing: .fixture())
    }
}
