## flutter_ecommerce_app


![](https://github.com/SinaSys/flutter_ecommerce_app/blob/master/screenshots/screenshot.png?raw=true)


## Screenshots

Preview                    |   Home screen             |  Product Detail Screen    |  Cart Screen
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/SinaSys/flutter_ecommerce_app/blob/master/screenshots/preview.gif?raw=true)|![](https://github.com/SinaSys/flutter_ecommerce_app/blob/master/screenshots/home_screen.png?raw=true)|![](https://github.com/SinaSys/flutter_ecommerce_app/blob/master/screenshots/detail_screen.png?raw=true)|![](https://github.com/SinaSys/flutter_ecommerce_app/blob/master/screenshots/cart_screen.png?raw=true)

<br/>

## Directory Structure
```
Directory structure:
└── manhhoang8th4-user-fe-app/
    ├── README.md
    ├── analysis_options.yaml
    ├── LICENSE
    ├── pubspec.lock
    ├── pubspec.yaml
    ├── ..flutter-plugins-dependencies.icloud
    ├── ..flutter-plugins.icloud
    ├── .flutter-plugins-dependencies 2
    ├── .metadata
    ├── android/
    │   ├── gradle.properties
    │   ├── .gitignore
    │   ├── app/
    │   │   └── src/
    │   │       ├── debug/
    │   │       │   └── AndroidManifest.xml
    │   │       ├── main/
    │   │       │   ├── AndroidManifest.xml
    │   │       │   ├── kotlin/
    │   │       │   │   └── com/
    │   │       │   │       └── sinasys/
    │   │       │   │           └── e_commerce_flutter/
    │   │       │   │               └── MainActivity.kt
    │   │       │   └── res/
    │   │       │       ├── drawable/
    │   │       │       │   └── launch_background.xml
    │   │       │       ├── drawable-hdpi/
    │   │       │       ├── drawable-mdpi/
    │   │       │       ├── drawable-v21/
    │   │       │       │   └── launch_background.xml
    │   │       │       ├── drawable-xhdpi/
    │   │       │       ├── drawable-xxhdpi/
    │   │       │       ├── drawable-xxxhdpi/
    │   │       │       ├── mipmap-anydpi-v26/
    │   │       │       │   └── launcher_icon.xml
    │   │       │       ├── mipmap-hdpi/
    │   │       │       ├── mipmap-mdpi/
    │   │       │       ├── mipmap-xhdpi/
    │   │       │       ├── mipmap-xxhdpi/
    │   │       │       ├── mipmap-xxxhdpi/
    │   │       │       ├── values/
    │   │       │       │   ├── colors.xml
    │   │       │       │   └── styles.xml
    │   │       │       └── values-night/
    │   │       │           └── styles.xml
    │   │       └── profile/
    │   │           └── AndroidManifest.xml
    │   └── gradle/
    │       └── wrapper/
    │           └── gradle-wrapper.properties
    ├── assets/
    │   └── images/
    ├── lib/
    │   ├── main.dart
    │   ├── core/
    │   │   └── data/
    │   │       └── data_provider.dart
    │   ├── models/
    │   │   ├── api_response.dart
    │   │   ├── brand.dart
    │   │   ├── category.dart
    │   │   ├── coupon.dart
    │   │   ├── order.dart
    │   │   ├── poster.dart
    │   │   ├── product.dart
    │   │   ├── sub_category.dart
    │   │   └── user.dart
    │   ├── screen/
    │   │   ├── home_screen.dart
    │   │   ├── login_screen/
    │   │   │   ├── login_screen.dart
    │   │   │   └── provider/
    │   │   │       └── user_provider.dart
    │   │   ├── my_address_screen/
    │   │   │   └── my_address_screen.dart
    │   │   ├── my_order_screen/
    │   │   │   └── my_order_screen.dart
    │   │   ├── product_by_category_screen/
    │   │   │   ├── product_by_category_screen.dart
    │   │   │   └── provider/
    │   │   │       └── product_by_category_provider.dart
    │   │   ├── product_cart_screen/
    │   │   │   ├── cart_screen.dart
    │   │   │   ├── components/
    │   │   │   │   ├── buy_now_bottom_sheet.dart
    │   │   │   │   ├── cart_list_section.dart
    │   │   │   │   └── empty_cart.dart
    │   │   │   └── provider/
    │   │   │       └── cart_provider.dart
    │   │   ├── product_details_screen/
    │   │   │   ├── product_detail_screen.dart
    │   │   │   ├── components/
    │   │   │   │   └── product_rating_section.dart
    │   │   │   └── provider/
    │   │   │       └── product_detail_provider.dart
    │   │   ├── product_favorite_screen/
    │   │   │   ├── favorite_screen.dart
    │   │   │   └── provider/
    │   │   │       └── favorite_provider.dart
    │   │   ├── product_list_screen/
    │   │   │   ├── product_list_screen.dart
    │   │   │   ├── components/
    │   │   │   │   ├── category_selector.dart
    │   │   │   │   ├── custom_app_bar.dart
    │   │   │   │   └── poster_section.dart
    │   │   │   └── provider/
    │   │   │       └── product_list_provider.dart
    │   │   ├── profile_screen/
    │   │   │   ├── profile_screen.dart
    │   │   │   └── provider/
    │   │   │       └── profile_provider.dart
    │   │   └── tracking_screen/
    │   │       └── tracking_screen.dart
    │   ├── services/
    │   │   └── http_services.dart
    │   ├── utility/
    │   │   ├── app_color.dart
    │   │   ├── app_data.dart
    │   │   ├── app_theme.dart
    │   │   ├── bottom_navy_bar_item.dart
    │   │   ├── constants.dart
    │   │   ├── extensions.dart
    │   │   ├── snack_bar_helper.dart
    │   │   ├── utility_extention.dart
    │   │   └── animation/
    │   │       ├── animated_switcher_wrapper.dart
    │   │       └── open_container_wrapper.dart
    │   └── widget/
    │       ├── app_bar_action_button.dart
    │       ├── applay_coupon_btn.dart
    │       ├── carousel_slider.dart
    │       ├── compleate_order_button.dart
    │       ├── custom_dropdown.dart
    │       ├── custom_network_image.dart
    │       ├── custom_search_bar.dart
    │       ├── custom_text_field.dart
    │       ├── horizondal_list.dart
    │       ├── multi_select_drop_down.dart
    │       ├── navigation_tile.dart
    │       ├── order_tile.dart
    │       ├── page_wrapper.dart
    │       ├── product_grid_tile.dart
    │       └── product_grid_view.dart
    ├── web/
    │   ├── index.html
    │   ├── manifest.json
    │   └── icons/
    └── .github/
        └── workflows/
            └── main.yml

```




