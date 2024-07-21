//
//  KeyboardMarginHandlingView.swift
//  ScrollContainer
//
//  Created by Ben Gottlieb on 7/20/24.
//

import Suite

@MainActor class KeyboardWatcher: NSObject, ObservableObject {
	var frame = CGRect.zero
	@Published var keyboardHeight = 0.0
	
	override init() {
		super.init()
		addAsObserver(of: UIApplication.keyboardWillShowNotification, selector: #selector(keyboardWillShow))
		addAsObserver(of: UIApplication.keyboardWillHideNotification, selector: #selector(keyboardWillHide))
	}
	
	@objc func keyboardWillShow(note: Notification) {
		if let keyboardFrame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
			let overlay = frame.intersection(keyboardFrame)
			withAnimation {
				keyboardHeight = overlay.height
			}
		}
	}
	
	@objc func keyboardWillHide(note: Notification) {
		
	}
}

struct KeyboardMarginHandlingView<Content: View>: View {
	var content: () -> Content
	@ObservedObject var keyboardWatcher = KeyboardWatcher()
	
	var body: some View {
		GeometryReader { geo in
			VStack(spacing: 0) {
				content()
				Rectangle()
					.frame(height: keyboardWatcher.keyboardHeight)
			}
			.onAppear {
				keyboardWatcher.frame = geo.frame(in: .local)
			}
		}
		.ignoresSafeArea(.keyboard)
	}
}

public extension View {
	func handlesKeyboardMargin() -> some View {
		self
		//KeyboardMarginHandlingView { self }
	}
}
