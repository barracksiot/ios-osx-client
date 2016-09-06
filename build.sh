if [ -d client ]; then
git -C client pull origin master
else
git clone --depth 1 --branch master https://github.com/barracksiot/ios-osx-client.git client
fi

pod update --project-directory=$PWD/client

cd client && jazzy --config ../.jazzy.json --clean --output ../docs --module-version "master"
