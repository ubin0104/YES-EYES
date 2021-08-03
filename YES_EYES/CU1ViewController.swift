//
//  CUViewController.swift
//  YES_EYES
//
//  Created by mgpark on 2021/07/29.
//

import UIKit
import FirebaseDatabase

class CU1Cell : UITableViewCell{
    @IBOutlet weak var CU1Label: UILabel!
}

struct CU1Model{
    // 상품 데이터
    var title = ""
    var price = ""
    var info = ""
}

class CU1ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    public var model = [[CU1Model]]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // section 별 개수 출력
        return model[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 상품 데이터 개수만큼 라벨 출력
        return model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
    
        cell.Title.text = model[indexPath.section][indexPath.row].title
        cell.Price.text = model[indexPath.section][indexPath.row].price
        // 상품명과 가격 값을 라벨에 표시
        
////        tableView.deselectRow(at: indexPath, animated: true)
        return cell
    }

    
    @IBOutlet weak var CU1TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CU1TableView.delegate = self
        CU1TableView.dataSource = self
        
        CU1TableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell") // ItemCell xib 등록
        
        self.title = "[CU] 음료"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        //getData(model) // Firebase에서 데이터 받아 오고 싶은데 여기가 잘 안 됨
        
        /*
        for i in range() {
            model.append([CU1Model(title: "상품이름", price: "상품가격")])
            // 데이터를 받아와서 이 형식으로 반복문 생성하면 에뮬레이터 화면에 상품명과 상품가격이 뜸
         }
        */

    }
}

func getData(model: [[CU1Model]]) {
    
    var model = [[CU1Model]]()
    let ref: DatabaseReference! = Database.database().reference()
    
    ref.child("cu").child("instant").observeSingleEvent(of: .value) { snapshot in
        for child in snapshot.children {
            let snap = child as! DataSnapshot
            
            let item = snap.value as! [String: Any]
            
            let title = item["title"] ?? ""
            let price = item["price"] ?? ""
            let info = item["info"] ?? ""
            
            model.append([CU1Model(title: title as! String, price: price as! String, info: info as! String)])
            /*
            print(title)
            print(price)
            print(info)
            */
        }
        // 이 부분 위까지는 데이터 잘 받아와지는데 이게 클로저라서 여기 아래부터는 배열 안 데이터가 전부 사라져서 리턴이 안 됨 ㅠㅠ
        // 원하는 건 model 변수를 리턴해서 메인 함수에서 받아오고 싶은데 여기 수정이 잘 안 돼요.
    }
}
