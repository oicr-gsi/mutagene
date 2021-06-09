version 1.0

workflow mutagene {

  input {
    File vcfFile
    String outputFileNamePrefix
  }

  parameter_meta {
    vcfFile: "file to extract signatures from"
    vcfIndex: "Prefix for filename"
    outputFileNamePrefix: "the file name prefix you wish to use"
  }

  call signature {
    input:
     vcfFile = vcfFile,
     outputFileNamePrefix = outputFileNamePrefix }

  output {
    File decompositionprofile = signature.decompositionprofile
    File mutationprobabilities = signature.mutationprobabilities
    File sigactivities = signature.sigactivities
    File signatures = signature.signatures
  }

  meta {
    author: "Alexander Fortuna"
    email: "alexander.fortuna@oicr.on.ca"
    description: "Workflow to detect signatures from snvs and indels"
    dependencies: [
     {
       name: "mutagene/0.9.1.0",
       url: "https://www.ncbi.nlm.nih.gov/research/mutagene/"
     }
    ]
  }
}

task signature {

  input {
  	File inputFile
  	String outputFileNamePrefix
    String fileType
    String reference_genome = "hg38"
  	String modules = "mutagene/0.9.1.0"
	  Int jobMemory = 8
	  Int threads = 4
  	Int timeout = 1
  }

  parameter_meta {
  	inputFile: "WGS VCF or MAFfile"
    fileType: "Denote if input is VCF or MAF file"
  	outputFileNamePrefix: "Prefix for output file"
  	reference_genome: "the genome version used for variant calling"
    modules: "required environment modules"
    jobMemory: "Memory allocated for this job"
  	threads: "Requested CPU threads"
  	timeout: "hours before task timeout"
  }

  runtime {
  	modules: "~{modules}"
    memory:  "~{jobMemory} GB"
  	cpu:     "~{threads}"
  	timeout: "~{timeout}"
  }
      python3 -m mutagene profile -g $MUTAGENE_ROOT/ref/"~{reference_genome}" -i "~{inputFile}" -f "~{fileType}" > "~{outputFileNamePrefix}".profile.tsv
      python3 -m mutagene signature -g $MUTAGENE_ROOT/ref/"~{reference_genome}" -i "~{inputFile}" -f "~{fileType}" > "~{outputFileNamePrefix}".signatures.tsv
  >>>

  output {
      File decompositionprofile = "~{outputFileNamePrefix}.decomposition_profile.txt"
      File mutationprobabilities = "~{outputFileNamePrefix}.Mutation_Probabilities.txt"
  }

  meta {
    output_meta: {
        decompositionprofile: "summary of global nmf sigatures",
        mutationprobabilities: "table summarizing probability of each mutation by signature",
      }
  }
}
