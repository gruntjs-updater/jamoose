###
  ======== A Handy Little Nodeunit Reference ========
  https://github.com/caolan/nodeunit

  Test methods:
    test.expect(numAssertions)
    test.done()
  Test assertions:
    test.ok(value, [message])
    test.equal(actual, expected, [message])
    test.notEqual(actual, expected, [message])
    test.deepEqual(actual, expected, [message])
    test.notDeepEqual(actual, expected, [message])
    test.strictEqual(actual, expected, [message])
    test.notStrictEqual(actual, expected, [message])
    test.throws(block, [error], [message])
    test.doesNotThrow(block, [error], [message])
    test.ifError(value)
###

jamoose = require '../src/jamoose'

Mailer = null

testTplName = '123'
testTplData = name: 'asdf'
testBadTplName = 'bad_template'
testBadTplData =
  node:
    name: 'bad'


exports.jamoose_test =
  setUp: (done) ->
    Mailer = new jamoose
      tplPath: __dirname + '/../.tmp/'
      fromEmail: 'sender@example.org'

    done()

  getHtml: (test) ->
    test.expect 2

    Mailer.getHtml testTplName, testTplData, (err, html) ->
      test.ifError err
      test.ok /<h1>asdf<\/h1>/.test(html)

      test.done()

  getHtmlWithBadTemplate: (test) ->
    test.expect 1

    Mailer.getHtml testBadTplName, testBadTplData, (err, html) ->
      test.ok err?

      test.done()

  send: (test) ->
    test.expect 1

    Mailer.send 'to@example.org', 'Test Sub', testTplName, testTplData, (err) ->
      test.ifError err

      test.done()

  sendDevelopment: (test) ->
    test.expect 1

    tmpNE = process.env.NODE_ENV
    process.env.NODE_ENV = 'development'

    Mailer.send 'to@example.org', 'Test Development', testTplName, testTplData, (err) ->
      process.env.NODE_ENV = tmpNE

      test.ifError err

      test.done()
