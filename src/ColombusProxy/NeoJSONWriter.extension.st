Extension { #name : 'NeoJSONWriter' }

{ #category : '*ColombusProxy' }
NeoJSONWriter class >> toJSONReadStream: object [
    | writeStream |
    writeStream := WriteStream on: (String new).
    (self on: writeStream) nextPut: object.
    ^ ReadStream on: writeStream contents.
]
