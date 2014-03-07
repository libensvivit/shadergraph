parse = require './parse'
compile = require './compile'

class Snippet
  @id: 0

  @namespace: () -> "_sg_#{++Snippet.id}_"

  @load: (name, code) ->
    program = parse name, code
    assembler = compile program
    new Snippet program.signatures, assembler, program

  constructor: (@signatures, @assembler, @_program) ->
    @namespace = null
    @program   = null
    @uniforms  = null
    @entry     = null
    @main      = null
    @externals = null

  clone: () ->
    new Snippet @signatures, @assembler, @_program

  apply: (uniforms, @namespace) ->
    @namespace ?= Snippet.namespace()
    @program = @assembler @namespace

    @uniforms   = {}
    @attributes = {}
    @externals  = {}

    u = (def) =>   @uniforms[@namespace + def.name] = def
    a = (def) => @attributes[@namespace + def.name] = def
    e = (def) =>  @externals[@namespace + def.name] = def
    m = (def) =>
      @main = def
      @entry = @namespace + def.name

    u(def) for def in @signatures.uniform
    a(def) for def in @signatures.attribute

    m(@signatures.main)
    e(def) for def in @signatures.external

    throw "lol error"


module.exports = Snippet