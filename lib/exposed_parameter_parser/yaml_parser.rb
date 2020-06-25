require 'yaml'

module ExposedParameterParser
  class YamlParser

    GLOBAL_OBJECTS = [
     'Infinity' ,
     'NaN',
     'undefined',
     'null',
     'true',
     'false',
     'eval',
     'isFinite',
     'isNaN',
     'parseFloat',
     'parseInt',
     'decodeURI',
     'decodeURIComponent',
     'encodeURI',
     'encodeURIComponent',
     'escape',
     'unescape',
     'Object',
     'Function',
     'Boolean',
     'Symbol',
     'Error',
     'EvalError',
     'RangeError',
     'ReferenceError',
     'SyntaxError',
     'TypeError',
     'URIError',
     'Number',
     'Math',
     'Date',
     'String',
     'RegExp',
     'Array',
     'Int8Array',
     'Uint8Array',
     'Uint8ClampedArray',
     'Int16Array',
     'Int32Array',
     'Uint32Array',
     'Float32Array',
     'Map',
     'Set',
     'WeakMap',
     'WeakSet',
     'ArrayBuffer',
     'SharedArrayBuffer',
     'Atomics',
     'DataView',
     'JSON',
     'Promise',
     'Reflect',
     'Proxy',
    ]

    def initialize(predefined_variables)
      @param_names = []
      @stored_variables = []
      @predefined_variables = GLOBAL_OBJECTS + predefined_variables
    end

    def parse yaml, &block
      store_values YAML.safe_load yaml
      params = []
      @param_names.each do |param_name|
        if block_given?
          element = yield(param_name)
        else
          element = { name: param_name, paramName: param_name, description: '', type: 'Text', value: '' }
        end
        params.push(element)
      end
      params
    end

    def store_values parsed_yaml
      parsed_yaml.each do |yaml_key, yaml_value|
        if yaml_value['action>'] == 'StoreValue'
          str_yaml_value = yaml_value.to_s
          @stored_variables.push yaml_value['key']
        elsif yaml_value.key?('loop>')
          str_yaml_value = yaml_value['loop>'].to_s
          @stored_variables.push 'i'
          store_values yaml_value['_do']
        elsif yaml_value.key?('for_each>')
          str_yaml_value = yaml_value['for_each>'].to_s
          value = yaml_value['for_each>']
          @stored_variables.push value.keys[0]
          store_values yaml_value['_do']
        elsif yaml_value.key?('if>')
          str_yaml_value = yaml_value['if>'].to_s
          store_values yaml_value['_do']
        else
          str_yaml_value = yaml_value.to_s
        end

        undefined_params str_yaml_value
      end
    end

    def undefined_params str_yaml_value
      str_yaml_value.scan(/\${.*?}/) do |js|
        check_js js
      end
    end

    def check_js js
      parser = JsVariableParser.new(js)
      variables = parser.variables

      undefined_variables = variables - (@stored_variables + @predefined_variables)

      @param_names.concat(undefined_variables)
      @stored_variables.concat(undefined_variables)

      @param_names.uniq!
      @stored_variables.uniq!
    end

  end
end