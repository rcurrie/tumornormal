build:
	# Build jupyter image for local use
	docker build -t $(USER)-jupyter-tumor-normal .

jupyter:
	# Run jupyter notebook on local machine - change password to your own
	docker run --rm -it --name $(USER)-jupyter-tumor-normal \
		--user root \
		-e GRANT_SUDO=yes \
		-e NB_UID=`id -u` \
		-e NB_GID=`id -g` \
		-p 52820:8888 \
		-v `pwd`:/home/jovyan \
		-v `echo ~/scratch/tumornormal`:/home/jovyan/data \
		$(USER)-jupyter-tumor-normal start-notebook.sh \
		--NotebookApp.password='sha1:53987e611ec3:1a90d791daf75274c73f62f672ecfa935799bdee'

train:
	# Copy data and model to GPU machine, train, and ship the model back
	
	# Push data in case it changed
	rsync -uav data/tumor_normal.h5 rcurrieucscedu@patternlab.calit2.optiputer.net:~/data

	# Convert notebook to python, run on GPU box, and copy model and weights back
	docker exec -it jupyter jupyter nbconvert --to script tumornormal/train.ipynb
	scp train.py rcurrieucscedu@patternlab.calit2.optiputer.net:~
	ssh rcurrieucscedu@patternlab.calit2.optiputer.net "source env/bin/activate && DEBUG=False python train.py"

	# Copy model and weights back
	scp rcurrieucscedu@patternlab.calit2.optiputer.net:~/models/model.json models/
	scp rcurrieucscedu@patternlab.calit2.optiputer.net:~/models/weights.h5 models/
