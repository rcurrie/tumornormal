train-local-debug:
	docker exec -it jupyter jupyter nbconvert --to script tumornormal/train.ipynb
	docker exec -it jupyter /bin/bash -c "cd tumornormal && DEBUG=False python3 train.py"
