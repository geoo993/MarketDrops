import SwiftUI
import MarketDropsDomain
import MarketDropsDomainFixtures

struct CardFilingView: View {
    @State var filing: CompanyFiling
    
    var body: some View {
        ZStack(alignment: .leading){
            RoundedRectangle(cornerRadius: UIConstants.cornerRadius)
                .fill(Color.blue)
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
            .padding()
        }
    }
}

struct CardFilingView_Previews: PreviewProvider {
    static var previews: some View {
        CardFilingView(filing: .fixture())
    }
}
