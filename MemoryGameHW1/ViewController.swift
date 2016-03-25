//
//  ViewController.swift
//  tic-tac-toe
//
//  Created by Admin on 04/03/2016.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var currentPlayer = "X"
    var charMatrix = [["a","b","c","d"],["a","b","c","d"],["a","b","c","d"],["a","b","c","d"]]
    var clickCount=0
    var cell1 = [0,0]
    var cell2 = [0,0]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // func prepareMatrixforTheGam(){
    //     for (var i:int =0;i<4;i++){
    //         for(var j:int =0;j<4;j++)
    //
    //     }
    
    // }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellID", forIndexPath: indexPath) as! CollectionViewCell
        //here we setting the initial text
        if(!cell.isFaceUp){
            cell.lblCelltext.text = "X"}
        else{
            cell.lblCelltext.text=charMatrix[indexPath.section][indexPath.row]}
        
        
        //charMatrix[indexPath.section][indexPath.row]
        //"\(indexPath.row), \(indexPath.section)"
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Row \(indexPath.row), section: \(indexPath.section)")
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        clickCount++
        cell.lblCelltext.text=charMatrix[indexPath.section][indexPath.row]
        
        if(clickCount==1){
            cell1[0]=indexPath.section
            cell1[1]=indexPath.row
        }
            
        else if(clickCount==2){
            clickCount=0
            if(checkFlipedCells(charMatrix[indexPath.section][indexPath.row],cell2: charMatrix[cell1[0]][cell1[1]])){
                cell.isFaceUp=true
                
                let  c1=collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: cell1[1], inSection: cell1[0])) as! CollectionViewCell
                c1.isFaceUp=true
                
            }
            
            
            //wait 2 sec
            setFaceDownWrongCell(collectionView)
            
        }
        
        
        //NSiindexpath is an index object
    }
    
    func checkFlipedCells(cell1:String, cell2:String )->Bool{
        
        return cell1 == cell2
    }
    
    func setFaceDownWrongCell(collectionView: UICollectionView){
        
        
        for(var i=0;i<4;i++){
            for (var j=0;j<4;j++)
            {
                let  c1=collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: j)) as! CollectionViewCell
                if(c1.isFaceUp)
                {
                    c1.lblCelltext.text = charMatrix[j][i]
                    c1.hidden=true
                }
                else{
                    c1.lblCelltext.text = "X"
                }
                
            }
            
        }
        
        
        
        
    }
    
    
    
}

