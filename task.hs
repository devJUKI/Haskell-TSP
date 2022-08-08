module MyModule where   
import qualified Data.Map as Map
import Control.Monad
import System.IO
import Data.List
import Data.Map
import qualified Data.Text as T
import System.Exit

main :: IO ()
main = do
   inputFile <- openFile "input.txt" ReadMode
   readVariant inputFile

readVariant :: Handle -> IO()
readVariant inputFile = do
   -- Input
   firstLine <- hGetLine inputFile
   let stationsNo = (read [firstLine !! 0] :: Int)
   let connectionsNo = (read [firstLine !! 2] :: Int)

   if (stationsNo == 0 && connectionsNo == 0) then exitSuccess 
   else return()

   cities <- replicateM stationsNo $ do
      line <- hGetLine inputFile 
      return line
   
   connList <- replicateM connectionsNo $ do
      line <- hGetLine inputFile
      let lineContent = T.splitOn (T.pack " ") (T.pack line)
      let conn = (lineContent !! 0) <> (lineContent !! 1)
      let price = read(T.unpack (lineContent !! 2)) :: Int

      return (conn, price)
   
   startCity <- hGetLine inputFile

   -- Perform task
   let connMap = Map.fromList connList
   let perms = permutations cities
   let viablePaths = deleteUnavailablePaths perms startCity (length cities)

   let paths = Data.List.map convertToConns viablePaths
   let prices = Data.List.map (\x -> calculatePathPrice x connMap) paths
   let positivePrices = removeNegatives prices
   
   if (length positivePrices <= 0) then print("Impossible")
   else do
      let minPathPrice = minimum positivePrices
      print(minPathPrice)

   readVariant inputFile

-- Delete paths that do not cover all cities or don't start with start city
deleteUnavailablePaths :: [[String]] -> String -> Int -> [[String]]
deleteUnavailablePaths [] _ _ = []
deleteUnavailablePaths k startCity cityCount = if ((k !! 0 !! 0) == startCity && length (k !! 0) >= cityCount)
                                       then [k !! 0] ++ deleteUnavailablePaths (Data.List.drop 1 k) startCity cityCount
                                       else [] ++ deleteUnavailablePaths (Data.List.drop 1 k) startCity cityCount

-- Convert cities list to list of connections
convertToConns :: [String] -> [[String]]
convertToConns [] = []
convertToConns [_] = []
convertToConns k = [[k !! 0, k !! 1]] ++ (convertToConns $ Data.List.drop 1 k)

-- Calculate road price (road = multiple connections between cities)
calculatePathPrice :: [[String]] -> Map T.Text Int -> Int
calculatePathPrice [] _ = 0
calculatePathPrice k map = if ((getPrice (T.pack(k !! 0 !! 0)) (T.pack(k !! 0 !! 1)) map) == -1)
   then -(10^30)
   else getPrice (T.pack(k !! 0 !! 0)) (T.pack(k !! 0 !! 1)) map + (calculatePathPrice $ Data.List.drop 1 k) map

-- Remove negative values from list
removeNegatives :: [Int] -> [Int]
removeNegatives [] = []
removeNegatives k = if (k !! 0 > 0) then [k !! 0] ++ (removeNegatives $ Data.List.drop 1 k)
   else [] ++ (removeNegatives $ Data.List.drop 1 k)

-- Parse value from Just type
fromJust :: Maybe value -> value
fromJust (Just value) = value
fromJust Nothing = error "Error in parsing Just type"

-- Get connection price
getPrice :: T.Text -> T.Text -> Map T.Text Int -> Int
getPrice city1 city2 connMap = do
   let cityString1 = city1 <> city2
   let cityString2 = city2 <> city1

   let price = if Map.member cityString1 connMap then fromJust(Map.lookup cityString1 connMap)
               else if Map.member cityString2 connMap then fromJust(Map.lookup cityString2 connMap)
               else -1
   price