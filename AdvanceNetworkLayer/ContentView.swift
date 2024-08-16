//
//  ContentView.swift
//  AdvanceNetworkLayer
//
//  Created by Ponthota, Viswanath Reddy (Cognizant) on 14/08/24.
//

import SwiftUI

struct ContentView: View {
    @State var products: [Product] = []
    
    var body: some View {
        VStack {
            List(products, id: \.id) { product in
                HStack {
                    Text("\(product.id)")
                    Text(product.title)
                }
            }
        }
        .padding()
        .task {
            await fetchProducts()
        }
    }
    
    func fetchProducts() async {
        do {
            // 1
            let requestManager = RequestManager(
                apiManager:  APIManager(
                    urlSession: CustomURLSession().build()
                )
            )
            let productsContainer: ProductsContainer =
            try await requestManager.perform(ProductsRequest.getProducts)
            // 2
            self.products = productsContainer.products
            // 3
        } catch {}
    }
}

#Preview {
    ContentView()
}
