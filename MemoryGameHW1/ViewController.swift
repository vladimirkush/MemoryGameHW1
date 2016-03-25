//
//  ViewController.swift
//  MemoryGameHW1
//
//  Created by Admin on 04/03/2016.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var currentPlayer = "X"
    var charArray = ["A","A","B","B","C","C","D","D","E","E","F","F","G","G","H","H"]
    var charMatrix = [["a","b","c","d"],["x","y","z","w"],["a","b","c","d"],["x","y","z","w"]]
    var clickCount=0
    var cell1 = [0,0]
    var elapsedSeconds=0
    var timer: NSTimer!
    @IBOutlet weak var lblTimer: UILabel!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTimer.text = "00:00"
        var arrayCounter = 0
        // Do any additional setup after loading the view, typically from a nib.
       charArray = charArray.shuffle()
        for(var i=0;i<4;i++){
            for (var j=0;j<4;j++)
            {
                charMatrix[i][j] = charArray[arrayCounter]
                arrayCounter++
            }
            
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval( 1.0, target: self, selector:"updateCountdown", userInfo: nil, repeats: true)
        

    }
    
    func updateCountdown() {
        
        elapsedSeconds++;
        let minutes = elapsedSeconds/60
        let seconds = elapsedSeconds % 60
        
        lblTimer.text=String(format: "%02d:%02d", minutes, seconds)
        
        if elapsedSeconds == 0 {
            self.timer.invalidate()
            self.timer = nil
            lblTimer.text="00:00"
        }
    }
   
    
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
            if(checkFlipedCells(charMatrix[indexPath.section][indexPath.row],cell2: charMatrix[cell1[0]][cell1[1]]) && !(indexPath.section == cell1[0] &&  cell1[1] == indexPath.row)){
                cell.isFaceUp=true
                
                let  c1=collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: cell1[1], inSection: cell1[0])) as! CollectionViewCell
                c1.isFaceUp=true
                
            }
            setCellsEnabledCells(collectionView, enabled: false)
            
            //wait 1 sec
            let time=dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1*Int64(NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue()){
                self.setFaceDownWrongCell(collectionView)
                self.setCellsEnabledCells(collectionView, enabled: true)
            }
            
            
        }
        
        
        //NSiindexpath is an index object
    }
    
    func checkFlipedCells(cell1:String, cell2:String )->Bool{
        
        return cell1 == cell2
    }
    
    func setCellsEnabledCells(collectionView: UICollectionView, enabled: Bool){
        
        for(var i=0;i<4;i++){
            for (var j=0;j<4;j++){
                let  c=collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: j)) as! CollectionViewCell
                c.userInteractionEnabled=enabled;

            }
            
        }

    }
    
    
    
    
    func setFaceDownWrongCell(collectionView: UICollectionView){
        
        for(var i=0;i<4;i++){
            for (var j=0;j<4;j++)
            {
                let  c1=collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: j)) as! CollectionViewCell
                if(c1.isFaceUp)
                {
                    c1.hidden=true
                }
                else{
                    c1.lblCelltext.text = "X"
                }
                
            }
            
        }

        
        
        
    }
    

}

// MARK: extention methods

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}


