@legder || = {}

@ledger.defer = (arg=undefined, args...) ->
  isCallback = typeof arg == 'function' && args.length == 0
  callback = arg if isCallback
  if isCallback
    defer = Q.defer()
  else
    defer = Q.defer(arg, args...)

  # Prototype
  defer.rejectWithError = (args...) -> ledger.errors.new(args...)
  defer.onFulfilled = (callback) ->
    @promise
    .then (result) -> callback(if result != undefined then result else true)
    .fail (reason) -> callback(false, reason)
  defer.thenForward = (defer) ->
    @promise
    .then (result) => @resolve(result)
    .fail (reason) => @reject(reason)

  # CompletionClosure legacy
  defer.readonly = -> @promise
  defer.complete = (value, error) ->
    if error?
      @reject(error)
    else
      @resolve(value)
  defer.success = (args...) -> @resolve(args...)
  defer.failure = (args...) -> @reject(args...)
  defer.onComplete = defer.onFulfilled

  defer.onFulfilled(callback) if isCallback

  return defer
