# Protein Final Project

Bu proje Patika- Protein Devops bootcamp bitirme projesidir. Projede basit bir react uygulaması yer almaktadır. Bu React uygulaması CI/CD pipeline'ına build ve test edilir. Daha sonra oluşturulan Dockerfile ile pipeline içerisinde dockerize edilir. Oluşturulan Docker imajı  AWS ECS servisine Pipeline ile deploy edilir. AWS ECS servisi Terraform ile declarative olarak oluşturulmuştur. Uygulama aynı zamanda K8S ortamına da deploy edilmektedir.

## Terraform & AWS 

AWS platformunda Elastic Container Service(ECS) oluşturulmuştur. ECS servisi ve ECS servisi için gerekli VPC, Security Group ve Load balancer 
Terraform ile oluşturulmuştur. Terraform dosyaları ./terraform klasörü içerisinde yer almaktadır. Terraform ile oluşturulan AWS ECS Fargate servisi ve diğer servislerin mimarisi aşağıdaki görselde gösterilmiştir.

[mimari foto]

Terraform ile görseldeki mimari servislerinin kurulması için Terraform dosyalarının bulunduğu dizinde aşağıdaki işlemler sırası ile yapılmalıdır:

### `terraform init`

Bu komut ile o dizinde terraform initialize edilmiş olur ve gerekli indirmeler yapılır. 

### `terraform plan`

Bu komut ile Terraform ile yazılmış konfigürasyon gözden geçirilir

/ belki çıktı koyulur buraya 

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

CI/CD pipeline shared runner olarak değil local bilgisayarda bulunan Gitlab Runner da çalışmaktadır. Gitlab Runner configure etmek için girilen komut :

[komutu yapıştır]


[Config toml içeriğini göster]

## Kubernetes

Projeyi Kubernetes'e deploy etmek için build edilen Docker imajı ile Deployment objesi oluşturulmuştur. deployment.yaml dosyası Kubernetes dizini içerisinde yer almaktadır. Kubectl ile localde deployment objesinin oluşturulması ve listelenmesi aşağıdaki görselde yer almaktadır:

<p align="center">
<img src="./docs/img/kubectl-deployment.png">
</p>

Oluşturulan deployment objesinin dışarıdan erişilebilmesi için Nodeport tipinde service oluşturulmuştur. 

<p align="center">
<img src="./docs/img/kubectl-service.png">
</p>