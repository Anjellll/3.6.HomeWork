

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var data: [MenuModel] = [
        MenuModel(image: UIImage(named: "product1")!, name: "Клубника", price: 60),
        MenuModel(image: UIImage(named: "product2")!, name: "Сгущенка", price: 60),
        MenuModel(image: UIImage(named: "product3")!, name: "Творожный", price: 70),
        MenuModel(image: UIImage(named: "product4")!, name: "Йогурт", price: 60),
        MenuModel(image: UIImage(named: "product5")!, name: "Сливочный", price: 60),
        MenuModel(image: UIImage(named: "product6")!, name: "Нутелла", price: 80),
        MenuModel(image: UIImage(named: "product7")!, name: "Рафаэлло", price: 80),
        MenuModel(image: UIImage(named: "product8")!, name: "Шоколад", price: 70),
        MenuModel(image: UIImage(named: "product9")!, name: "Банан", price: 70),
        MenuModel(image: UIImage(named: "product10")!,name: "Вишня", price: 80)
    ]
    
    var cartProducts = [MenuModel]()
    var filteredProducts = [MenuModel]()
    var totalSum = 0
    var floatingButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        filteredProducts = data
        
        setupCollectionView()
        
        floatingButton.backgroundColor = .systemGreen
        floatingButton.setTitle("Корзина \(totalSum) шт", for: .normal)
        floatingButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        
        floatingButton.addTarget(self, action: #selector(goToCart), for: .touchUpInside)
        floatingButton.layer.cornerRadius = 15
        
        view.addSubview(floatingButton)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        floatingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        floatingButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        floatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupCollectionView() {
        searchBar.delegate = self 
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        //layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        collectionView.showsHorizontalScrollIndicator = false
        
        //        imageCollectionView.delegate = self
        //        imageCollectionView.dataSource = self
    }
    
    @objc func goToCart() {
        let cartScreen = SecondViewController()
        
        cartScreen.cartProducts = cartProducts
        
        present(cartScreen, animated: false)
        
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filteredProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menu_cell", for: indexPath) as! MenuCell
        
        cell.nameProductLabel.text = filteredProducts[indexPath.row].name
        cell.imageIconView.image = filteredProducts[indexPath.row].image
        cell.priceProductLabel.text = "\(filteredProducts[indexPath.row].price) coм"
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 180, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: "Количество товара", message: "Введите количество товара", preferredStyle: .alert)
        
        var textField = UITextField()
        
        alertController.addTextField { text in
            textField = text
        }
        
        let actionOk = UIAlertAction(title: "Ok", style: .cancel) { [self] action in
            //print(self.filteredNames[indexPath.row])
            
            let inputText = textField.text!
            
            if let amount = Int(inputText) {
                var counter = 0
                
                while counter < amount {
                    self.cartProducts.append(self.filteredProducts[indexPath.row])
                    
                    counter += 1
                }
                
                self.totalSum += amount
                
                self.floatingButton.setTitle("Корзина \(totalSum) шт", for: .normal)
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive) { action in
            ()
        }
        
        alertController.addAction(actionOk)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)

    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredProducts = []
        
        if searchText == "" {
            filteredProducts = data
        }
        
        for product in data {
            if product.name.uppercased().contains(searchText.uppercased()) {
                filteredProducts.append(product)
            }
        }
        
        collectionView.reloadData()
    }
}

class SecondViewController: UIViewController {
    
    var cartTableView = UITableView()
    var totalLabel = UILabel()
    
    var cartProducts = [MenuModel]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cartTableView.register(UITableViewCell.self, forCellReuseIdentifier: "menu_cell")
        view.addSubview(cartTableView)
        
        cartTableView.translatesAutoresizingMaskIntoConstraints = false
        cartTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        cartTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        cartTableView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        cartTableView.heightAnchor.constraint(equalToConstant: view.frame.height - 100).isActive = true
        
//        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        view.addSubview(totalLabel)
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        totalLabel.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
        totalLabel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        totalLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        totalLabel.font = .systemFont(ofSize: 20)
        
        var totalSum = 0
        
        for cartProduct in cartProducts {
            totalSum += cartProduct.price
        }
        totalLabel.text = "Количество товара: \(cartProducts.count) | Сумма: \(totalSum) сом"
    }
}

extension SecondViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "menu_cell")
        
        cell.imageView?.image = cartProducts[indexPath.row].image
        
        cell.imageView?.translatesAutoresizingMaskIntoConstraints = false
        cell.imageView?.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 0).isActive = true
        cell.imageView?.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
        cell.imageView?.widthAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
        cell.imageView?.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
        
        cell.textLabel?.text = "\(cartProducts[indexPath.row].name) \(cartProducts[indexPath.row].price)"
        
        cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        cell.textLabel?.leftAnchor.constraint(equalTo: cell.imageView!.rightAnchor, constant: 0).isActive = true
        cell.textLabel?.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        cell.textLabel?.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
        cell.textLabel?.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
        
        return cell
    }
}

extension SecondViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

       
         
        
        
        
        
        
        
        
        





