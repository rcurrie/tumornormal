build:
	docker build -t jupyter .

train:
	# Push data in case it changed
	rsync -uav data/tumor_normal.h5 rcurrieucscedu@patternlab.calit2.optiputer.net:~/data

	# Convert notebook to python, run on patternlab GPU cluster, and copy model and weights back
	docker exec -it jupyter jupyter nbconvert --to script tumornormal/train.ipynb
	scp train.py rcurrieucscedu@patternlab.calit2.optiputer.net:~
	ssh rcurrieucscedu@patternlab.calit2.optiputer.net "source env/bin/activate && DEBUG=False python train.py"

	# Copy model and weights back
	scp rcurrieucscedu@patternlab.calit2.optiputer.net:~/models/model.json models/
	scp rcurrieucscedu@patternlab.calit2.optiputer.net:~/models/weights.h5 models/

importance:
	docker exec -it jupyter jupyter nbconvert --to script tumornormal/importance.ipynb
	scp importance.py rcurrieucscedu@patternlab.calit2.optiputer.net:~
	ssh rcurrieucscedu@patternlab.calit2.optiputer.net "source env/bin/activate && DEBUG=False python importance.py"
