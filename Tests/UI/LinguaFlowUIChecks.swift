//
//  LinguaFlowUIChecks.swift
//  LinguaFlow
//
//  Created by Кирилл on 04.11.2026.
//

import XCTest

final class LinguaFlowUIChecks: XCTestCase {
    @MainActor
    func testAchievementsNavigationAndKeyboard() throws {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.buttons["Настройки"].waitForExistence(timeout: 15))
        app.buttons["Настройки"].tap()
        XCTAssertTrue(app.navigationBars.staticTexts["Настройки"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Назад"].exists)
        app.buttons["Назад"].tap()
        XCTAssertTrue(app.staticTexts["home-greeting"].waitForExistence(timeout: 5))
        let homeY = app.staticTexts["home-greeting"].frame.midY

        app.tabBars.buttons["Достижения"].tap()
        let achievementsTitle = app.staticTexts["Достижения"].firstMatch
        XCTAssertTrue(achievementsTitle.waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["achievement-first-lesson"].exists)
        let achievementsY = achievementsTitle.frame.midY
        XCTAssertLessThan(abs(homeY - achievementsY), 10)
        let firstBadge = app.buttons["achievement-first-lesson"]
        firstBadge.tap()
        XCTAssertTrue(app.staticTexts["Завершить первый урок."].waitForExistence(timeout: 5))
        app.buttons["Закрыть"].tap()

        app.tabBars.buttons["Уроки"].tap()
        let lessonsTitle = app.staticTexts["Уроки"].firstMatch
        XCTAssertTrue(lessonsTitle.waitForExistence(timeout: 5))
        let lessonY = lessonsTitle.frame.midY
        app.tabBars.buttons["Практика"].tap()
        let practiceTitle = app.staticTexts["Практика"].firstMatch
        XCTAssertTrue(practiceTitle.waitForExistence(timeout: 5))
        XCTAssertLessThan(abs(lessonY - practiceTitle.frame.midY), 2)
        let addWordButton = app.buttons["Добавить слово"]
        XCTAssertTrue(addWordButton.exists)
        XCTAssertLessThan(abs(practiceTitle.frame.midY - addWordButton.frame.midY), 5)
        addWordButton.tap()
        XCTAssertTrue(app.navigationBars.staticTexts["Новая карточка"].waitForExistence(timeout: 5))
        let save = app.buttons["Сохранить"]
        XCTAssertFalse(save.isEnabled)
        XCTAssertLessThan(abs(save.frame.midX - app.frame.midX), 3)
        let word = "hello-" + UUID().uuidString.prefix(6)
        app.textFields["Например: Hola"].tap()
        app.textFields["Например: Hola"].typeText(word)
        XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 5))
        app.navigationBars.staticTexts["Новая карточка"].tap()
        XCTAssertTrue(app.keyboards.firstMatch.waitForNonExistence(timeout: 5))
        app.textFields["Например: Привет"].tap()
        app.textFields["Например: Привет"].typeText("translation")
        app.buttons["Сохранить"].tap()
        XCTAssertTrue(app.staticTexts["Поздравляем!"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.staticTexts["Первое слово"].exists)
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Achievement unlock"
        attachment.lifetime = .keepAlways
        add(attachment)
        app.buttons["Продолжить"].tap()
        XCTAssertTrue(app.buttons["Учить"].waitForExistence(timeout: 5))
        app.buttons["Учить"].tap()
        XCTAssertTrue(app.staticTexts[word].waitForExistence(timeout: 5))
        app.staticTexts[word].tap()
        app.buttons["Знаю"].tap()
        XCTAssertFalse(app.staticTexts["Поздравляем!"].exists, "Do not cover a study session")
        app.buttons["Закрыть"].tap()
        XCTAssertTrue(app.staticTexts["Поздравляем!"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.staticTexts["Сегодня начинаю"].exists)
        app.buttons["Продолжить"].tap()
        app.terminate()
        app.launch()
        XCTAssertTrue(app.buttons["Настройки"].waitForExistence(timeout: 10))
        XCTAssertFalse(app.staticTexts["Поздравляем!"].exists)
    }
}
