import pandas as pd
from snakemake.utils import validate

#### GLOBAL PARAMETERS ####

configfile: "config.yaml"
validate(config, schema="schemas/config.schema.yaml")

OUTDIR = config['outdir']
LOGDIR = config['logdir']


#### LOAD SAMPLES TABLE ###
seeds = pd.read_table(config["seeds"]).set_index("seed_ID", drop=False)
validate(seeds, schema="schemas/seeds.schema.yaml")


#### GLOBAL scope functions ####
def get_resource(rule,resource) -> int:
	'''
	Attempt to parse config.yaml to retrieve resources available for a given
	rule. It will revert to default if a key error is found. Returns an int.
	with the allocated resources available for said rule. Ex: "threads": 1
	'''

	try:
		return config['resources'][rule][resource]
	except KeyError: # TODO: LOG THIS
		print(f'Failed to resolve resource for {rule}/{resource}: using default parameters')
		return config["resources"]['default'][resource]


def get_params(rule,param) -> int:
	'''
	Attempt to parse config.yaml to retrieve parameters available for a given
	rule. It will crash otherwise.
	''' 
	try:
		return config['parameters'][rule][param]
	except KeyError: # TODO: LOG THIS
		print(f'Failed to resolve parameter for {rule}/{param}: Exiting...')
		sys.exit(1)


#### Load rules ####
include: 'rules/pyscenic.smk'


### RULES ###
rule all:
	input:
		get_all_input

