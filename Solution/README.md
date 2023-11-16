# Note

Given the assignment instructions I've refactored the application to be more readable, expandable and testable. The project follows a structured folder organization pattern. I moved bussines logic from view controller to view model. Which I've covered with tests. The view model is designed in a way that, with minor adjustments, it can be integrated with SwiftUI.

I think the critical aspect of the app is tax calculation. That's way I created a library called `TaxCalculator`. I've build it with intension to be reusable for different cases. The library is well documented and tested. It has predefined `Lithuania Salary` calculator for convenience. While I used the `Double` numeric type for calculations, one could argue that `Decimal` should be used for handling money. This [blog post](https://www.jessesquires.com/blog/2022/02/01/decimal-vs-double/) is exploring the problem in depth.

### Things worth noting:

- While I didn't touch UI, use of storyboards can be tricky and may lead to unsolvable merge conflicts, reduced reusability of components, and unclear codebase.
- The network layer could have its package, or in a highly modularized app, even a few packages, such as Service, Endpoints, and Mocks.
- The app should have a dedicated layers for navigation and any other components, that are used in the app. (Analytics, persistence, etc.)
- While Apple provided tools for testing are powerful, I'd consider writing custom abstractions or using third-party libraries to ensure testing is effective and not time-consuming, especially when testing asynchronous operations. 
- Some important aspects of the application, such as localization, linting, etc., haven't been addressed because I believe they are out of the scope of this task.
