
source_dir=$1
target_dir=$2
asset_absolute_path=$3

get_relative_name="console.log '$asset_absolute_path'.replace(process.cwd(), '').replace('/$source_dir/', '')"
asset_relative_path=$(./node_modules/.bin/lsc -e "$get_relative_name")

source=$source_dir/$asset_relative_path
target=$target_dir/$asset_relative_path

echo "✗ $target"
rm -rf $target

if [ -f $source ] ; then
    echo "$source => $target"
    cp $source $target
fi
