# Automatic Profile cluster view
Fully automatic managed circular image array.

## []()
![alt tag](https://github.com/chanonly123/ProfileClusterView/blob/main/ProfileClusterDemo.gif)

## Usage

### From Interface Builder
• Drag `ProfileClusterView.swift` file into your project  
• Add a `UIView` into interface builder  
• Set it's class to `ProfileClusterView`  

### From code
```
let profileCluster = ProfileCluster()
```

&nbsp;&nbsp;
## Options
### `spacing` - spacing between profile views.
### `alignment` - profile views alignment. (left/right/center/justify)
### `startFrom` - starting position profile views. (left/right)
### `maxVisible` - Maximum visible items. (0 means no limit)

&nbsp;&nbsp;
## Closures
### `configureCount` - (**required**) return number of profile views
```
viewProfiles.configureCount = {
    return 10
}
```
### `configureImageView` or `configureImageViewCustom` - to configure image views
```
viewProfiles.configureImageView = { cluster in
    cluster.imageView.image = something
}
// or
viewProfiles.configureImageViewCustom = { cluster in
    let view = UIView() // create your view
    cluster.view.addSubview(view)
}
```
### `configureMoreView` or `configureMoreViewCustom` - to configure more label
```
viewProfiles.configureMoreView = { cluster in
    cluster.label.backgroundColor = .blue
}
// or
viewProfiles.configureImageViewCustom = { cluster in
    let lbl = UILabel()
    lbl.text = "+\(cluster.more)"
    cluster.view.addSubview(lbl)
}
```

## Contributing

Contributions are always welcome!

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
