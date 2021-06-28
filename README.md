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
### `alignment` - profile views alignment. (left/right/center)
### `startFrom` - starting position profile views. (left/right)

&nbsp;&nbsp;
## Closures
### `configureCount` - (**required**) return number of profile views
```
viewProfiles.configureCount = {
    return 10
}
```
### `configureImageView` - to configure image views
```
viewProfiles.configureImageView = { cluster in
    cluster.imageView.image = something
}
```
### `configureMoreView` - to configure more label
```
viewProfiles.configureMoreView = { cluster in
    cluster.label.backgroundColor = .blue
}
```

## Contributing

Contributions are always welcome!

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
