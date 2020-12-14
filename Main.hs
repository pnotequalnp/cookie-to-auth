{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TupleSections     #-}

import Data.ByteString (ByteString)
import Data.ByteString.Char8 as BS
import Data.Maybe (fromMaybe)
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import qualified Data.Text.IO as T
import Network.HTTP.Client (defaultManagerSettings, newManager)
import Network.HTTP.ReverseProxy (ProxyDest(..), WaiProxyResponse(..), defaultOnExc, waiProxyTo)
import Network.HTTP.Types.Header (hCookie, hAuthorization)
import Network.Wai (Request(..))
import Network.Wai.Handler.Warp (run)
import System.IO (stderr)
import Text.Read (readMaybe)
import UnliftIO.Environment (getEnv, lookupEnv)
import Web.Cookie (parseCookies)

main :: IO ()
main = do
  port     <- fromMaybe 80 . (>>= readMaybe) <$> lookupEnv "PORT"
  dest     <- BS.pack <$> getEnv "DEST"
  destPort <- read <$> getEnv "DEST_PORT"
  manager  <- newManager defaultManagerSettings
  let app' = waiProxyTo (app dest destPort) defaultOnExc manager
  T.hPutStrLn stderr $ "Running on port " <> (T.pack . show) port <> ", destination "
    <> T.decodeUtf8 dest <> ":" <> (T.pack . show) destPort
  run port app'

app :: ByteString -> Int -> Request -> IO WaiProxyResponse
app dest port req = do
  T.hPutStrLn stderr $ maybe "No token" T.decodeUtf8 jwt
  pure . WPRModifiedRequest req' $ ProxyDest dest port
  where
  headers = requestHeaders req
  cookies = parseCookies <$> lookup hCookie headers
  jwt = cookies >>= lookup "jwt"
  auth = (hAuthorization,) . (bearerBS <>) <$> jwt
  req' = case auth of
    Nothing    -> req
    Just auth' -> req { requestHeaders = auth':headers }

jwtBS :: ByteString
jwtBS = T.encodeUtf8 "jwt"

bearerBS :: ByteString
bearerBS = T.encodeUtf8 "Bearer "
