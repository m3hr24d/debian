brew:
	sudo ./brew.sh

build:
	sudo docker build -t dockerzone/debian .

release:
	docker push dockerzone/debian