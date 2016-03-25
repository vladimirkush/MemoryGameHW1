//
//  ViewController.swift
//  MemoryGameHW1
//
//  Created by Admin on 04/03/2016.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var unflippedLabel = "X"
    var charArray = ["A","A","B","B","C","C","D","D","E","E","F","F","G","G","H","H"]
    var charMatrix = [["a","b","c","d"],["x","y","z","w"],["a","b","c","d"],["x","y","z","w"]]
    var clickCount = 0
    var cell1 = [0,0]
    var elapsedSeconds = 0
    var score = 1000
    var timer: NSTimer!
    var isPaused = false
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var collectionViewRef: UICollectionView!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTimer.text = "00:00"
        lblScore.text = "\(score)"
        
        prepareCells()
        
        timer = NSTimer.scheduledTimerWithTimeInterval( 1.0, target: self, selector:"updateTimer", userInfo: nil, repeats: true)
        
        
    }
    
    func updateTimer() {
        
        elapsedSeconds++;
        let minutes = elapsedSeconds/60
        let seconds = elapsedSeconds % 60
        
        lblTimer.text=String(format: "%02d:%02d", minutes, seconds)
        
        if elapsedSeconds%5==0{
            score--
            lblScore.text = "\(score)"
        }
    }
    
    func prepareCells(){
        var arrayCounter = 0

        charArray = charArray.shuffle()
        for(var i=0;i<4;i++){
            for (var j=0;j<4;j++){
                charMatrix[i][j] = charArray[arrayCounter]
                arrayCounter++
                }
            
        }
    }
    
    func checkGameEnded(collectionView: UICollectionView)->Bool{
       
        for(var i=0;i<4;i++){
            for (var j=0;j<4;j++){
                let  c=collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: j)) as! CollectionViewCell
                if !c.isFaceUp{
                    return false
                }
                
            }
            
        }
        return true;

    }
    
    func setNewGame(collectionView: UICollectionView){
        for(var i=0;i<4;i++){
            for (var j=0;j<4;j++){
                let  c=collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: j)) as! CollectionViewCell
                c.isFaceUp=false;
                c.hidden=false
                c.lblCelltext.text = unflippedLabel
                
            }
            
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
            cell.lblCelltext.text = unflippedLabel}
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
            setCellsEnabled(collectionView, enabled: false)
            
            //wait 1 sec
            let time=dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1*Int64(NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue()){
                self.setFaceDownWrongCell(collectionView)
                self.setCellsEnabled(collectionView, enabled: true)
                
                if self.checkGameEnded(collectionView){
                    self.finishGame()
                }
            }
            
            
        }
        
        
        //NSiindexpath is an index object
    }
    
    func finishGame(){
        timer.invalidate()
        
        alertWin()
        
    }
    
    func checkFlipedCells(cell1:String, cell2:String )->Bool{
        
        return cell1 == cell2
    }
    
    func setCellsEnabled(collectionView: UICollectionView, enabled: Bool){
        
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
                    c1.lblCelltext.text = unflippedLabel
                }
                
            }
            
        }
        
        
        
        
    }
    
    func alertWin(){
        let alertController = UIAlertController(title: "!!! You Have Won !!!", message:
            "Your score: \(score)", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "I'm the one who knocks!", style: UIAlertActionStyle.Default){
            action -> Void in
            self.restartGame()
            self.timer = NSTimer.scheduledTimerWithTimeInterval( 1.0, target: self, selector:"updateTimer", userInfo: nil, repeats: true)
            })
        
        self.presentViewController(alertController, animated: true, completion:nil)
    }
    
    @IBAction func onPauseTap(sender: UIButton) {
        if isPaused{
            timer = NSTimer.scheduledTimerWithTimeInterval( 1.0, target: self, selector:"updateTimer", userInfo: nil, repeats: true)
            setCellsEnabled(collectionViewRef, enabled: true)
            isPaused=false
            sender.setTitle("Pause", forState: .Normal)
        
            
        }else{
            timer.invalidate()
            setCellsEnabled(collectionViewRef, enabled: false)
            isPaused=true
            sender.setTitle("Resume", forState: .Normal)
        }
    }
    
    @IBAction func onRestartTap(sender: AnyObject) {
        restartGame()
    }
    
    func restartGame(){
        elapsedSeconds = 0
        score = 1000
        lblTimer.text = "00:00"
        
       
        prepareCells()
        setCellsEnabled(collectionViewRef, enabled: true)
        setNewGame(collectionViewRef)
        
        
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


