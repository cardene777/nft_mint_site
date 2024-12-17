
object "YulSample" {
    code {
        function addNumbers(a, b) -> result {
            result := add(a, b) // 2つの引数を加算
        }

        // 関数呼び出し
        let sum := addNumbers(5, 10)

        // 結果をメモリに保存して返す
        mstore(0x40, sum)
        return(0x40, 32)
    }
}
