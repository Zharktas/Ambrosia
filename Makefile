TESTS = test/*.js
test:
	@./node_modules/mocha/bin/mocha \
	--ui tdd \
	$(TESTS)

.PHONY: test
