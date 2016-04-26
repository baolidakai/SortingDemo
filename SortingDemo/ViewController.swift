import UIKit

class ViewController: UIViewController {
    let TOP_OFFSET = 10
    var images = [UIView](count: 10, repeatedValue: UIView())
    var NUM_BARS = 10
    var arr = [Int](count: 10, repeatedValue: 0)
    var PAUSE_TIME = 0.1
    var IS_LOCKED = false // true if anything is in progress
    
    override func viewDidLoad() {
        super.viewDidLoad();
        InitializeBars(100)
    }
    
    @IBAction func Shuffle(sender: UIButton) {
        if !IS_LOCKED {
            // Use Fisher-Yates shuffle algorithm to shuffle the array
            for i in 0..<(NUM_BARS - 1) {
                let j = Int(arc4random_uniform(UInt32(NUM_BARS - i)))
                if j != 0 {
                    swap(&arr[i], &arr[i + j])
                }
            }
            VisualizeBars()
        }
    }
    
    @IBOutlet weak var Size: UILabel!
    
    @IBAction func ChangeSize(sender: UISlider) {
        if !IS_LOCKED {
            ClearBars()
            let updatedNumBars = Int(floor(sender.value * 100 + 1))
            Size.text = "Array Size: " + String(updatedNumBars)
            InitializeBars(updatedNumBars)
        }
    }
    
    @IBAction func ChangePauseTime(sender: UISlider) {
        PAUSE_TIME = Double(1 - sender.value)
    }
    
    func InitializeBars(numBars: Int) {
        // Setup the images
        NUM_BARS = numBars
        let screenSize = UIScreen.mainScreen().bounds
        let HEIGHT = screenSize.height * 0.5
        // Initialize the array
        arr = [Int](count: NUM_BARS, repeatedValue: 0)
        for i in 0..<NUM_BARS {
            arr[i] = Int(arc4random_uniform(UInt32(round(HEIGHT))))
        }
        images = [UIView](count: NUM_BARS, repeatedValue: UIView())
        // Initialize the images
        for i in 0..<NUM_BARS {
            images[i] = UIView()
        }
        VisualizeBars()
    }
    
    func VisualizeBars() {
        let screenSize = UIScreen.mainScreen().bounds
        let WIDTH = screenSize.width
        let HEIGHT = screenSize.height * 0.5
        let BAR_WIDTH = WIDTH / CGFloat(NUM_BARS)
        for i in 0..<NUM_BARS {
            images[i].frame = CGRect(x: BAR_WIDTH * CGFloat(i), y: HEIGHT + CGFloat(self.TOP_OFFSET) - CGFloat(arr[i]), width: BAR_WIDTH, height: CGFloat(arr[i]))
            images[i].backgroundColor = UIColor.blackColor()
            self.view.addSubview(images[i])
        }
    }
    
    @IBAction func SelectionSort(sender: UIButton) {
        IS_LOCKED = true
        var records = [[Int]]()
        var pairs = [[Int]]() // The pairs that are swapped
        for i in 0..<NUM_BARS {
            var minIdx = i
            for j in i..<NUM_BARS {
                if arr[j] < arr[minIdx] {
                    minIdx = j
                }
            }
            if minIdx != i {
                records.append(arr)
                pairs.append([i, minIdx])
                swap(&arr[i], &arr[minIdx])
                records.append(arr)
                pairs.append([i, minIdx])
            }
        }
        var idx = 0
        func MoveView() {
            UIView.animateWithDuration(PAUSE_TIME, delay: 0, options: [], animations: { () -> Void in
                self.arr = records[idx]
                for i in pairs[idx] {
                    if 0 <= i && i < self.NUM_BARS {
                        self.images[i].backgroundColor = UIColor.redColor()
                    }
                }
                self.VisualizeBars()
            }) { (finished) -> Void in
                idx += 1
                if idx < records.count {
                    MoveView()
                } else {
                    self.IS_LOCKED = false
                }
            }
        }
        MoveView()
    }
    
    @IBAction func InsertionSort(sender: UIButton) {
        IS_LOCKED = true
        var records = [[Int]]()
        var pairs = [[Int]]() // The pairs that are swapped
        for i in 0..<NUM_BARS {
            var j = i
            while j != 0 && arr[j] < arr[j - 1] {
                pairs.append([j])
                swap(&arr[j], &arr[j - 1])
                j -= 1
                records.append(arr)
            }
            records.append(arr)
            pairs.append([j])
        }
        var idx = 0
        func MoveView() {
            UIView.animateWithDuration(PAUSE_TIME, delay: 0, options: [], animations: { () -> Void in
                self.arr = records[idx]
                for i in pairs[idx] {
                    if 0 <= i && i < self.NUM_BARS {
                        self.images[i].backgroundColor = UIColor.redColor()
                    }
                }
                self.VisualizeBars()
            }) { (finished) -> Void in
                idx += 1
                if idx < records.count {
                    MoveView()
                } else {
                    self.IS_LOCKED = false
                }
            }
        }
        MoveView()
    }
    
    @IBAction func MergeSort(sender: UIButton) {
        IS_LOCKED = true
        var records = [[Int]]()
        var pairs = [[Int]]() // The pairs that are swapped
        func MergeSortHelper(l: Int, r: Int) {
            // Sort from l to r inclusively, "in place"
            if l == r {
                return
            }
            let m = (l + r) / 2
            MergeSortHelper(l, r: m)
            MergeSortHelper(m + 1, r: r)
            // Merge two parts
            var mergedList = [Int]()
            var p1 = l
            var p2 = m + 1
            while p1 <= m && p2 <= r {
                if arr[p1] <= arr[p2] {
                    mergedList.append(arr[p1])
                    p1 += 1
                } else {
                    mergedList.append(arr[p2])
                    p2 += 1
                }
            }
            while p1 <= m {
                mergedList.append(arr[p1])
                p1 += 1
            }
            while p2 <= r {
                mergedList.append(arr[p2])
                p2 += 1
            }
            for i in 0..<mergedList.count {
                arr[l + i] = mergedList[i]
            }
            records.append(arr)
            pairs.append([])
        }
        MergeSortHelper(0, r: NUM_BARS - 1)
        var idx = 0
        func MoveView() {
            UIView.animateWithDuration(PAUSE_TIME, delay: 0, options: [], animations: { () -> Void in
                self.arr = records[idx]
                for i in pairs[idx] {
                    if 0 <= i && i < self.NUM_BARS {
                        self.images[i].backgroundColor = UIColor.redColor()
                    }
                }
                self.VisualizeBars()
            }) { (finished) -> Void in
                idx += 1
                if idx < records.count {
                    MoveView()
                } else {
                    self.IS_LOCKED = false
                }
            }
        }
        MoveView()
    }
    
    @IBAction func HeapSort(sender: UIButton) {
        IS_LOCKED = true
        var records = [[Int]]()
        var pairs = [[Int]]() // The pairs that are swapped
        // Construct a min-heap
        var ints = PriorityQueue<Int>(<)
        for elem in arr {
            ints.push(elem)
        }
        var extracted = [Int]()
        for i in 0..<NUM_BARS {
            extracted.append(ints.pop()!)
            records.append(extracted + arr[i + 1..<NUM_BARS])
            pairs.append([])
        }
        var idx = 0
        func MoveView() {
            UIView.animateWithDuration(PAUSE_TIME, delay: 0, options: [], animations: { () -> Void in
                self.arr = records[idx]
                for i in pairs[idx] {
                    if 0 <= i && i < self.NUM_BARS {
                        self.images[i].backgroundColor = UIColor.redColor()
                    }
                }
                self.VisualizeBars()
            }) { (finished) -> Void in
                idx += 1
                if idx < records.count {
                    MoveView()
                } else {
                    self.IS_LOCKED = false
                }
            }
        }
        MoveView()
    }

    @IBAction func QuickSort(sender: UIButton) {
        IS_LOCKED = true
        var records = [[Int]]()
        var pairs = [[Int]]() // The pairs that are swapped
        func QuickSortHelper(l: Int, r: Int) {
            // In-place quick sort from l to r inclusively
            if l >= r {
                return
            }
            let pivotIdx = l + Int(arc4random_uniform(UInt32(r - l + 1)))
            let p = arr[pivotIdx]
            var pivotTarget = l
            for i in l...r {
                if arr[i] < p {
                    pivotTarget += 1
                }
            }
            if pivotIdx != pivotTarget {
                records.append(arr)
                pairs.append([pivotIdx, pivotTarget])
                swap(&arr[pivotTarget], &arr[pivotIdx])
                records.append(arr)
                pairs.append([pivotIdx, pivotTarget])
            }
            var p1 = l
            var p2 = r
            while p1 < pivotTarget && p2 > pivotTarget {
                while arr[p1] < p && p1 < pivotTarget {
                    p1 += 1
                }
                while arr[p2] >= p && p2 > pivotTarget {
                    p2 -= 1
                }
                if p1 == pivotTarget || p2 == pivotTarget {
                    break
                }
                if p1 != p2 {
                    records.append(arr)
                    pairs.append([p1, p2])
                    swap(&arr[p1], &arr[p2])
                    records.append(arr)
                    pairs.append([p1, p2])
                }
                p1 += 1
                p2 -= 1
            }
            QuickSortHelper(l, r: pivotTarget - 1)
            QuickSortHelper(pivotTarget + 1, r: r)
        }
        QuickSortHelper(0, r: NUM_BARS - 1)
        var idx = 0
        func MoveView() {
            UIView.animateWithDuration(PAUSE_TIME, delay: 0, options: [], animations: { () -> Void in
                self.arr = records[idx]
                for i in pairs[idx] {
                    if 0 <= i && i < self.NUM_BARS {
                        self.images[i].backgroundColor = UIColor.redColor()
                    }
                }
                self.VisualizeBars()
            }) { (finished) -> Void in
                idx += 1
                if idx < records.count {
                    MoveView()
                } else {
                    self.IS_LOCKED = false
                }
            }
        }
        MoveView()
    }
    
    @IBAction func BubbleSort(sender: UIButton) {
        IS_LOCKED = true
        var records = [[Int]]()
        var pairs = [[Int]]() // The pairs that are swapped
        var finished = false
        for i in 0..<NUM_BARS {
            if !finished {
                finished = true
                for j in 0..<NUM_BARS - 1 {
                    if arr[j] > arr[j + 1] {
                        finished = false
                        records.append(arr)
                        pairs.append([j, j + 1])
                        swap(&arr[j], &arr[j + 1])
                        records.append(arr)
                        pairs.append([j, j + 1])
                    }
                }
            }
        }
        var idx = 0
        func MoveView() {
            UIView.animateWithDuration(PAUSE_TIME, delay: 0, options: [], animations: { () -> Void in
                self.arr = records[idx]
                for i in pairs[idx] {
                    if 0 <= i && i < self.NUM_BARS {
                        self.images[i].backgroundColor = UIColor.redColor()
                    }
                }
                self.VisualizeBars()
            }) { (finished) -> Void in
                idx += 1
                if idx < records.count {
                    MoveView()
                } else {
                    self.IS_LOCKED = false
                }
            }
        }
        MoveView()
    }

    @IBAction func ShellSort(sender: UIButton) {
        IS_LOCKED = true
        var records = [[Int]]()
        var pairs = [[Int]]() // The pairs that are swapped
        let gaps = [701, 301, 132, 57, 23, 10, 4, 1]
        for gap in gaps {
            if gap < NUM_BARS {
                for i in gap..<NUM_BARS {
                    var j = i
                    while j >= gap && arr[j] < arr[j - gap] {
                        records.append(arr)
                        pairs.append([j, j - gap])
                        swap(&arr[j], &arr[j - gap])
                        records.append(arr)
                        pairs.append([j, j - gap])
                        j -= gap
                    }
                }
            }
        }
        var idx = 0
        func MoveView() {
            UIView.animateWithDuration(PAUSE_TIME, delay: 0, options: [], animations: { () -> Void in
                self.arr = records[idx]
                for i in pairs[idx] {
                    if 0 <= i && i < self.NUM_BARS {
                        self.images[i].backgroundColor = UIColor.redColor()
                    }
                }
                self.VisualizeBars()
            }) { (finished) -> Void in
                idx += 1
                if idx < records.count {
                    MoveView()
                } else {
                    self.IS_LOCKED = false
                }
            }
        }
        MoveView()
    }
    
    func ClearBars() {
        for i in 0..<NUM_BARS {
            images[i].frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
    }
}