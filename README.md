## Google AI Studio c Gemini 2.5 для создания iOS приложений на основе «картинок» из Figma

Требовалось создать iOS приложения для бронирования номера в Отеле на основе прототипов экранов из Figma, в которых использовалась "карусель" из фото.
Я использовала ИИ для разработки такого iOS приложения по прототипам из Figma. Прямо скажем, что текст на прототипах экранов не очень отчетливо виден, так что ИИ предстоит его сначала прочитать, а уже потом создать iOS приложение.

 <img src="https://github.com/BestKora/HotelGemini2_5/blob/2de19fe24000e40ee81c1c1916442265b29e21f4/HotelRooms.png" width="850">
Gemini всегда прекрасно читал тексты на изображениях ( в том числе на русском), кроме того, появилась более продвинутая Gemini 2.5 Pro Experimental -  мультимодальная, рассуждающая ИИ модель, которую компания называет самой интеллектуальной моделью на сегодняшний день.
Следовательно, был выбран Gemini 2.5 Experimental в Google AI Studio:


<img src="https://github.com/BestKora/HotelGemini2_5/blob/a9e6f5de22d766a5900889d5b5fdffff33edaac3/AIStudio.png" width="950">

<img src="https://github.com/BestKora/HotelGemini2_5/blob/76989b001302ab4f2dc9381d814bc9f22a2f1ed9/RussianTranslateGoals.png"  width="550">

Результат превзошел все возможные ожидания. Gemini 2.5 Experimental воспроизвёл в SwiftUI с поразительной точностью все стили текстов и функциональные возможности прототипов, подготовленных дизайнерами в Figma, и выдал интересный и изобретательный SwiftUI код, а не пытался отделаться "заглушками". Конечно, это лишь стартовая реализация кода данного iOS приложения, но очень перспективная.

<img src="https://github.com/BestKora/HotelGemini2_5/blob/6a14a32d5eff98b1d965d0f7551e74ab5362066d/HotelInfoView.gif" width="300">

### Бронирование номера отеля (часть 1)
Прототип экрана из Figma:

<img src="https://github.com/BestKora/HotelGemini2_5/blob/af44ee291c17e414309a5954f95958f172a494c0/BookingNew.png"  width="400">

Вот как функционирует View для бронирования номера:

<img src="https://github.com/BestKora/HotelGemini2_5/blob/cef8aca69e6bbabdd6a995ac8d31968f43c35cf3/Booking.gif" width="300">

### Бронирование номера отеля (часть 2)
Прототип экрана из Figma:

<img src="https://github.com/BestKora/HotelGemini2_5/blob/791f7414a9eb3eff35527e66be7d1ac2ff13b3f8/Tourists.png"  width="400">

Вот как функционирует View для ввода туристов:

<img src="https://github.com/BestKora/HotelGemini2_5/blob/cef8aca69e6bbabdd6a995ac8d31968f43c35cf3/Booking.gif" width="300">
