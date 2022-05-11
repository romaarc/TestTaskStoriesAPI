# TestTaskStoriesAPI
# Описание
Приложение показывает первые 16 историй из Stepik API, пагинация не реализована, чтобы подгрузить другие сторисы используйте параметры page, pageSize или используйте модель Meta и поля hasNext, hasPrevious для пагинации. 

# Экраны
![hippo](https://media.giphy.com/media/x93hmivdOzgpgC5NRr/giphy.gif)

https://user-images.githubusercontent.com/28999468/167955316-1bb57016-4880-4781-8c36-c663da973e3d.MP4

## Установка

У вас должны быть установлены SPM:
* <a href="https://github.com/SnapKit/SnapKit">Snapkit</a>
* <a href="https://github.com/mxcl/PromiseKit">PromiseKit</a>
* <a href="https://github.com/onevcat/Kingfisher">Kingfisher</a>

# Детали реализации
## Deployment Target
iOS 13
## Архитектура приложения
**Clean Swift by Stepik + MVP + Coordinator + micro DI + Services (UserDefaults + URLSession PromiseKit version)**<br>
## UI
**UIKit without Storyboard and Xibs, only layout with code**<br>
