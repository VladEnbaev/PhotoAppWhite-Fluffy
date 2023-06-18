# WhiteAndFluffyTestTask
### Используемые технологии:
* URLSession, JSONDecoder
* CoreData
* Pods: SDWebImage

<<<<<<< HEAD
<img width="200" alt="Снимок экрана 2023-06-15 в 02 42 33" src="https://github.com/VladEnbaev/White-FluffyTestTask/assets/116029905/a012957e-6336-4ff4-a240-3ade2b52db9b">

<img width="200" alt="Снимок экрана 2023-06-15 в 02 42 50" src="https://github.com/VladEnbaev/White-FluffyTestTask/assets/116029905/cff4630e-dd5f-46fe-8352-718bb8217cf2">

<img width="200" alt="Снимок экрана 2023-06-15 в 02 42 23" src="https://github.com/VladEnbaev/White-FluffyTestTask/assets/116029905/b55f0ba8-d2a5-4f15-8409-e837a0388599">

<img width="200" alt="Снимок экрана 2023-06-15 в 02 58 23" src="https://github.com/VladEnbaev/White-FluffyTestTask/assets/116029905/af2769c8-1be5-4113-91f8-59eb34586a0d">
=======
<img width="200" alt="Снимок экрана 2023-06-15 в 02 42 33" src="https://github.com/VladEnbaev/White-FluffyTestTask/assets/116029905/39a9a007-d40b-43f8-92a8-76bbe0caaa34">
<img width="200" alt="Снимок экрана 2023-06-15 в 02 42 50" src="https://github.com/VladEnbaev/White-FluffyTestTask/assets/116029905/c4b332f8-e8ef-46ed-bf25-4ac60a9e0170">
<img width="200" alt="Снимок экрана 2023-06-15 в 02 42 23" src="https://github.com/VladEnbaev/White-FluffyTestTask/assets/116029905/dbe8655f-45cb-40d6-bf0e-3b0a71a0c658">
<img width="200" alt="Снимок экрана 2023-06-15 в 02 58 23" src="https://github.com/VladEnbaev/White-FluffyTestTask/assets/116029905/e20ffe03-fc66-4a0b-a59e-3cb1cf181cec">
>>>>>>> 33f77b54257acea451fd1876c798f600bcfd851d

### Описание работы приложения: 

#### Экран фотографий
Начинается с экрана с рандомными фотографиями из unslashed.com в коллекции. Есть лейбл и activity indicators, включаются во время загрузки.<br> 
Eсли есть ошибка в загрузке приходит alert c error.localized. <br> 
Фотографии загружаются и кэшируются с помощью SDWebImage.<br> 
Есть кнопка перезагрузки, которая загружает новые рандомные фотографии.<br>
С помощью SearchBar'a можно найти фотографии по запросу. <br> 
Тапнув по фотографии проверяется есть ли entity фотографии по такому id в CoreData, если есть то загружается entity,<br>
которая своим методом возращает модель с данными из бд (UI работает только с моделями, удобно переиспользовать экран детального просмотра). <br>
Затем navigation controller пушит экран детального просмотра

#### Экран детального просмотра
На экране детального просмотра есть информация про фотографию(UIButtons) и кнопка лайка.<br>
При нажатии на кнопку лайка CoreDataManager преобразует модельку в entity и сохраняет в бд.<br>
Когда лайк убирается, entity удаляется из бд.<br>


#### Экран понравившихся фотографий
Таблица с фотографиями и именами автора. <br>
Как только поставлен лайк на любой из фотографий, она сразу появлется на втором экране таббара. <br>
Фотографии туда загружаются из CoreData. <br>
Можно нажать на фотографию, появится экран детального просмотра. Можно убрать лайк, фотография сразу же удалится из бд и с основного экрана. <br>
Также фотографию можно убрать, свайпом в самой таблице.

#### Про архитектуру и паттерны: 
Использовал MVC, для простоты, но все по-максимуму обернуто протоколами (NetworkService, DataManager).<br>
AppBulder - собирает проект и внедряет зависимости, потом будет удобно внедрить координатор, пока что detail vc пушится из других контроллеров. <br>
Добавил протокол BaseViewProtocol, для структурирования верстки.

 
