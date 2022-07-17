# Protein Final Project

Bu proje Patika- Protein Devops bootcamp bitirme projesidir. Projede basit bir react uygulaması yer almaktadır. Bu React uygulaması CI/CD pipeline'ına build ve test edilir. Daha sonra oluşturulan Dockerfile ile pipeline içerisinde dockerize edilir. Oluşturulan Docker imajı  AWS ECS servisine Pipeline ile deploy edilir. AWS ECS servisi Terraform ile declarative olarak oluşturulmuştur. Uygulama aynı zamanda K8S ortamına da deploy edilmektedir.

## Terraform & AWS 

AWS platformunda Elastic Container Service(ECS) oluşturulmuştur. ECS servisi ve ECS servisi için gerekli VPC, Security Group ve Load balancer 
Terraform ile oluşturulmuştur. Terraform dosyaları ./terraform klasörü içerisinde yer almaktadır. Terraform ile oluşturulan AWS ECS Fargate servisi ve diğer servislerin mimarisi aşağıdaki görselde gösterilmiştir.

<p align="center">
<img src="./docs/img/architecture.png">
</p>

Terraform ile görseldeki mimari servislerinin kurulması için Terraform dosyalarının bulunduğu dizinde aşağıdaki işlemler sırası ile yapılmalıdır:

### `terraform init`

Bu komut ile o dizinde terraform initialize edilmiş olur ve gerekli indirmeler yapılır. 

### `terraform plan`

Bu komut ile Terraform ile yazılmış konfigürasyon gözden geçirilir


### `terraform apply`

Bu komut ile yazılan konfigürasyon aws üzerinde gerçekleştirilir. Komut uygulandığında AWS VPC, AWS ECS, AWS ELB servisleri oluşturulur. Aşağıdaki ekran görüntülerinde Terraform ile oluşturulan servisler yer almaktadır.

AWS ECS Cluster

<p align="center">
<img src="./docs/img/cluster-last.png">
</p>


AWS VPC & Security Group

<p align="center">
<img src="./docs/img/vpc.png">
</p>

AWS ELB

<p align="center">
<img src="./docs/img/load-balancer.png">
</p>



## Gitlab Runner & CI/CD Pipeline

CI/CD pipeline shared runner olarak değil local bilgisayarda bulunan Gitlab Runner da çalışmaktadır. Gitlab Runner Docker ile local bilgisayara kurulmuştur. Gitlab Runner configure etmek için girilen komut :

<p align="center">
<img src="./docs/img/runner-register-command.png">
</p>


<p align="center">
<img src="./docs/img/config.toml.png">
</p>

CI/CD pipelineında proje build ve test aşamalarından geçmektedir. React projesi npm aracı ile build alınmakta  daha sonra test edilmektedir. Pipeline'da build ve test den sonra Docker imajının build edilmesi ve Dockerhub'a pushlanması adımı vardır. Bu adımda Docker imajı her pipeline da farklı tag almaktadır. Deploy edildiği ortamlarda bu taglerle deploy edilmektedir. Build edilen Docker imajı hem AWS ECS Fargate servisine hem de Kubernetes Clusterına deploy edilmektedir. Deploy edilen imajlar Terraform ve Kubernetes bölümlerinde gösterilmiştir. 

<p align="center">
<img src="./docs/img/gitlab-ci-pipeline.png">
</p>

## Kubernetes

Projeyi Kubernetes'e deploy etmek için Gitlab da agent oluşturulmuş ve K8S clusterına bu agent Helm ile yüklenmiştir

<p align="center">
<img src="./docs/img/k8s-agent.png">
</p>

<p align="center">
<img src="./docs/img/gitlab-runner.png">
</p>

Build edilen Docker imajı ile Deployment objesi oluşturulmuştur. deployment.yaml dosyası Kubernetes dizini içerisinde yer almaktadır. CI/CD pipelinında oluşturulan deployment objesi ve service objesi aşağıda gösterilmiştir. Oluşturulan deployment objesinin dışarıdan erişilebilmesi için Nodeport tipinde service oluşturulmuştur. 

<p align="center">
<img src="./docs/img/k8s-deployment.png">
</p>



