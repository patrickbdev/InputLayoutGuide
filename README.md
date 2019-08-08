# InputLayoutGuide - Keyboard/InputView Handling 🎉


Don't let this minimal README fool you. 
This is a single file that fulfills all your Keyboard/InputView handling needs.
Copy the InputLayoutGuide.swift file into your project and start using it.

---

UIView Example Usage
```
NSLayoutConstraint.activate([
    scrollView.topAnchor.constraint(equalTo: topAnchor),
    scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
    scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
    scrollView.bottomAnchor.constraint(lessThanOrEqualTo: inputLayoutGuide.topAnchor),
    ])
```

UIViewController Example Usage
```
NSLayoutConstraint.activate([
    scrollView.topAnchor.constraint(equalTo: view.topAnchor),
    scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    scrollView.bottomAnchor.constraint(lessThanOrEqualTo: view.inputLayoutGuide.topAnchor),
    ])
```
