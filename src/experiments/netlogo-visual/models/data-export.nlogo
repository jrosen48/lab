
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Data export functions ;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; put in globals

  ModelData
  ModelDescription
  RunSeries
  DataSeries
  data-ready?

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Data export functions ;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; put in model initialization method

init-RunSeries

;;; put at beginning of main model loop

init-DataSeries

;;; put in inner model loop after times series data are generated:
;;; time, data1, data2, ...

update-DataSeries t x-dum v-dum

;;; put at exit (or exits) of model loop
;;; arguments include any local variables that are computational outputs

update-RunSeries a-max

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Data export functions ;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; put at end

to init-RunSeries
  set RunSeries "[\n  ]"
end

to init-DataSeries
  set DataSeries "[ ]"        ; this will contain triplet dummy values in json format
end

;;;
;;; Edit computationalInputs and computationalOutputs sections to
;;; list names of exported NetLogo variables.
;;;

to update-RunSeries [ a-max ]
  let postamble "\n  ]"
  let temp "\n"
  if run-number > 1 [set temp ",\n"]  ; subsequent runs need to be delimited with a comma.

  set temp (word temp "    {\n")
  set temp (word temp "      \"timeSeriesData\": " DataSeries ",\n")
  set temp (word temp "      \"computationalInputs\": [" Distance-to-steering-wheel ", " car-speed ", " airbag-size ",\n")
  set temp (word temp "        " time-to-fill-bag ", " const ", " max-time-to-stop ", " deflate-time " ],\n")
  set temp (word temp "      \"computationalOutputs\": [ " a-max ", \"" dummy-status "\" ],\n")
  set temp (word temp "      \"studentInputs\": [ \"" the-question "\" ]\n")
  set temp (word temp "    }")

  let len-rs length RunSeries
  let len-pa length postamble
  set RunSeries substring RunSeries 0 (len-rs - len-pa)
  ; set RunSeries bl RunSeries    ; strip off the final square bracket
  set RunSeries (word RunSeries temp "\n  ]")  ; add in the new DataSeries and append a final sqare bracket
end

;;;
;;; Edit argument list and method to append time series data
;;; passed as arguemnts to global variable DataSeries
;;;

to update-DataSeries [ t x-dum v-dum ]
  ; now update DataSeries
  let trip ""  if t != 0 [set trip ","] ; the first triplet doesn't have a preceding comma.
  set trip (word trip "[" t ", " x-dum ", " v-dum "]")
  set DataSeries bl DataSeries    ; strip off the final square bracket
  set DataSeries (word DataSeries trip "]")  ; add in the new triplet and append a final sqare bracket
end

to make-ModelDescription
  set data-ready? false
  let temp ""

  ;;;
  ;;; Edit timeSeriesData to describe data elements. Include
  ;;; values for "label", "units", "min", and "max-x" or "max-y"
  ;;;
  set temp (word temp "{\n")
  set temp (word temp "    \"timeSeriesData\": [\n")
  set temp (word temp "      { \"label\": \"Time\", \"units\": \"s\", \"min\": 0, \"max\": " max-x " },\n")
  set temp (word temp "      { \"label\": \"Position\", \"units\": \"m\", \"min\": 0, \"max\": " max-y " },\n")
  set temp (word temp "      { \"label\": \"Velocity\", \"units\": \"m/s\", \"min\": -10, \"max\": " 10 " }\n")
  set temp (word temp "    ],\n")

  ;;;
  ;;; Edit computationalInputs
  ;;; Include values for "label", "units", "min", "max"
  ;;; If the computational input is use din model but hidden from student
  ;;; add the "hidden" property and give it a value of true.
  ;;;

  set temp (word temp "    \"computationalInputs\": [\n")
  set temp (word temp "      { \"label\": \"Distance to steering wheel\",\"units\": \"m\", \"min\": 0.1, \"max\":0.5 },\n")
  set temp (word temp "      { \"label\": \"Car speed\",\"units\": \"m/s\", \"min\": 0, \"max\":40 },\n")
  set temp (word temp "      { \"label\": \"Airbag size\",\"units\": \"m\", \"min\": 0, \"max\":0.5 },\n")
  set temp (word temp "      { \"label\": \"Time to fill bag\",\"units\": \"s\", \"min\": 0.01, \"max\":0.05 },\n")
  set temp (word temp "      { \"label\": \"const (airbag-stiffness)\", \"hidden\": true, \"units\": \"m/s^2\", \"min\": 0, \"max\":6000 },\n")
  set temp (word temp "      { \"label\": \"Maximum time to stop\", \"hidden\": true, \"units\": \"s\", \"min\": 0.02, \"max\": 0.1 },\n")
  set temp (word temp "      { \"label\": \"Deflate time\", \"hidden\": true, \"units\": \"s\", \"min\": 0, \"max\":10 }\n")
  set temp (word temp "    ],\n")

  ;;;
  ;;; Edit computationalOutputs
  ;;; Include values for "label", "units", "min", "max"
  ;;;
  ;;; If the computational input is categorical instead of numerical:
  ;;; set value of "units" to "categorical" and if possible include a "values"
  ;;; property with a value consisting of an array of possible categories
  ;;;
  ;;; If a computational ouput is used in the model but *not* display to the user
  ;;; add the "hidden" property and give it a value of true.
  ;;;

  set temp (word temp "    \"computationalOutputs\": [\n")
  set temp (word temp "      { \"label\": \"Maximum acceleration\", \"units\": \"g\", \"min\": 0, \"max\": 200 },\n")
  set temp (word temp "      { \"label\": \"Dummy Survival\", \"units\": \"categorical\", \"values\": [\"Yes\",\"No\",\"Maybe\"]  }\n")
  set temp (word temp "    ],\n")

  ;;;
  ;;; Edit studentInputs section to include Inquiry inputs to the experiment
  ;;; These are student inputs that do not affect the computational results
  ;;; for the model such as student prediction of cateorization of their inquiry.
  ;;;

  set temp (word temp "    \"studentInputs\": [\n")
  set temp (word temp "      { \"label\": \"Goal\", \"units\": \"categorical\" }\n")
  set temp (word temp "    ],\n")

  ;;;
  ;;; Edit the modeInformation section to include version information about the
  ;;; actual model or Interactive used.
  ;;;

  set temp (word temp "    \"modelInformation\": {\n")
  set temp (word temp "      \"name\": \"airbags\",\n")
  set temp (word temp "      \"fileName\": \"airbags.v15h.nlogo\",\n")
  set temp (word temp "      \"version\": \"v15h\"\n")
  set temp (word temp "    }\n")

  set temp (word temp "  }")
  set ModelDescription temp
  set data-ready? true
end

to make-ModelData
  make-ModelDescription
  set data-ready? false
  let temp ""

  set temp (word temp "{\n")
  set temp (word temp "  \"description\": " ModelDescription ",\n")
  set temp (word temp "  \"runs\": " RunSeries "\n")
  set temp (word temp "}\n")

  set ModelData temp
  set data-ready? true
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Data export functions: Testing ;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; After running one or more model runs show JSON data available for export:
;;;
;;;   show ModelData
;;;
;;; After making changes test to see if the JSON data represent a valid JavaScript object.
;;;
;;; 1. Copy the string generated by running "show ModelData" in the NetLogo observer.
;;; 2. Open a JavaScript console in a browser and execute the following code:
;;;
;;;   data = JSON.parse(<pasted-JSON-datastring-from-clipboard>)
;;;
;;; If this fails look at the error message and fix the NetLogo DataExport methods.
;;; If this succeeds inspect the newly created data object.
;;;
;;; Here's an example expanded in the browsers JavaScript console:
;;;
;;;   Object {description: Object, runs: Array[2]}
;;;     description: Object
;;;       computationalInputs: Array[5]
;;;       computationalOutputs: Array[2]
;;;       modelInformation: Object
;;;       studentInputs: Array[1]
;;;       timeSeriesData: Array[3]
;;;     runs: Array[2]
;;;       0: Object
;;;         timeSeriesData: Array[36]
;;;         computationalInputs: Array[5]
;;;         computationalOutputs: Array[2]
;;;         studentInputs: Array[1]
;;;       1: Object
;;;         timeSeriesData: Array[34]
;;;         computationalInputs: Array[5]
;;;         computationalOutputs: Array[2]
;;;         studentInputs: Array[1]
;;;
