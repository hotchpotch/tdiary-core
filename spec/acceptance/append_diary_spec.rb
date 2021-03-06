# -*- coding: utf-8 -*-
require File.expand_path('../acceptance_helper', __FILE__)

feature '日記の追記' do
	background do
		setup_tdiary
	end

	scenario '更新画面のデフォルト表示' do
		visit '/'
		click_link '追記'
		page.should have_content('日記の更新')

		y, m, d = Date.today.to_s.split('-').map {|t| t.sub(/^0+/, "") }
		within('div.day div.form') {
			within('span.year') { page.should have_field('year', :with => y) }
			within('span.month') { page.should have_field('month', :with => m) }
			within('span.day') { page.should have_field('day', :with => d) }
		}
	end

	scenario '今日の日記を書く' do
		append_default_diary

		visit '/'
		within('div.day span.title'){ page.should have_content "tDiaryのテスト" }
		within('div.day div.section'){
			within('h3') { page.should have_content "さて、テストである。" }
			page.should have_content "とりあえず自前の環境ではちゃんと動いているが、きっと穴がいっぱいあるに違いない:-P"
		}

		click_link "#{Date.today.strftime('%Y年%m月%d日')}"
		within('div.day span.title'){ page.should have_content "tDiaryのテスト" }
		within('div.day div.section'){
			within('h3') { page.should have_content "さて、テストである。" }
			page.should have_content "とりあえず自前の環境ではちゃんと動いているが、きっと穴がいっぱいあるに違いない:-P"
		}
	end

	scenario '日付を指定して新しく日記を書く' do
		append_default_diary('2001-04-23')

		visit '/'
		click_link "#{Date.parse('20010423').strftime('%Y年%m月%d日')}"
		within('div.day span.title'){ page.should have_content "tDiaryのテスト" }
		within('div.day div.section'){
			within('h3') { page.should have_content "さて、テストである。" }
			page.should have_content "とりあえず自前の環境ではちゃんと動いているが、きっと穴がいっぱいあるに違いない:-P"
		}
	end

	scenario '今日の日記を追記する' do
		append_default_diary

		visit '/'
		click_link '追記'
		within('div.day div.form') {
			within('div.title') { fill_in "title", :with => "Hikiのテスト" }
			within('div.textarea') {
				fill_in "body", :with => <<-BODY
!さて、Hikiのテストである。
とみせかけてtDiary:-)
BODY
			}
		}

		click_button "追記"
		page.should have_content "Click here!"

		visit '/'
		within('div.day span.title'){ page.should have_content "Hikiのテスト" }
		within('div.body'){
			page.should have_content "さて、テストである。"
			page.should have_content "とりあえず自前の環境ではちゃんと動いているが、きっと穴がいっぱいあるに違いない:-P"
			page.should have_content "さて、Hikiのテストである。"
			page.should have_content "とみせかけてtDiary:-)"
		}
	end

	scenario '日記のプレビュー' do
		visit '/'
		click_link '追記'
		within('div.day div.form') {
			within('div.title') { fill_in "title", :with => "tDiaryのテスト" }
			within('div.textarea') {
				fill_in "body", :with => <<-BODY
!さて、テストである。
とりあえず自前の環境ではちゃんと動いているが、きっと穴がいっぱいあるに違いない:-P
BODY
			}
		}

		click_button 'プレビュー'
		within('div.day span.title'){ page.should have_content "tDiaryのテスト" }
		within('div.day div.section'){
			within('h3') { page.should have_content "さて、テストである。" }
			page.should have_content "とりあえず自前の環境ではちゃんと動いているが、きっと穴がいっぱいあるに違いない:-P"
		}
	end
end
