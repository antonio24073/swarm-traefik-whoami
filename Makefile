
up:
	sudo bash -c "echo -e '\n#ini docker-traefik-localhost-multi-containers-example' >> /etc/hosts"
	sudo bash -c "echo '0.0.0.0 whoami.local' >> /etc/hosts"
	sudo bash -c "echo '0.0.0.0 traefik.local' >> /etc/hosts"
	sudo bash -c "echo '#end docker-traefik-localhost-multi-containers-example' >> /etc/hosts"

	docker network create -d overlay traefik_overlay;

	docker stack deploy -c traefik/docker-compose.yml tr;
	docker stack deploy -c whoami/docker-compose.yml wh;

	
rm:
	sudo sed -z -i 's/\n#ini docker-traefik-localhost-multi-containers-example\n//g' /etc/hosts 
	sudo sed -z -i 's/0.0.0.0 traefik.local\n//g' /etc/hosts 
	sudo sed -z -i 's/0.0.0.0 whoami.local\n//g' /etc/hosts 
	sudo sed -z -i 's/#end docker-traefik-localhost-multi-containers-example\n//g' /etc/hosts 

	docker stack rm tr
	docker stack rm wh

	docker network rm traefik_overlay

test:
	curl -m 2 -skI -XGET 'http://traefik.local' | awk 'NR==1' & \
	curl -m 2 -skI -XGET 'http://whoami.local' | awk 'NR==1' & \
	wait
