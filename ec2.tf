# ==========================================
# 🛡️ Grupo de Segurança (Firewall da EC2)
# ==========================================
resource "aws_security_group" "web_sg" {
  name        = "servidor-web-sg" 
  description = "Permitir trafego SSH e HTTP para a EC2"
  vpc_id      = aws_vpc.main.id

  # Regra de Entrada: Permite SSH (Porta 22) vindo de qualquer lugar (para testes)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Regra de Entrada: Permite HTTP (Porta 80) para acessar o site
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regra de Saída: Permite que a máquina baixe atualizações na internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" significa todos os protocolos
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-web-producao"
  }
}

# ==========================================
# 💻 A Instância EC2
# ==========================================
resource "aws_instance" "web_server" {
  ami           = var.ami_id        # Pega o valor lá do variables.tf
  instance_type = var.instance_type # Pega o valor lá do variables.tf

  # Coloca a EC2 dentro da Subnet Pública 1A que criamos no main.tf
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Script de Inicialização (User Data):
  # Atualiza a máquina, instala o servidor web Apache e cria uma página inicial
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install apache2 -y
              sudo systemctl start apache2
              sudo systemctl enable apache2
              echo "<h1>Minha EC2 na minha propria VPC via Terraform! 🚀</h1>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name        = "servidor-web-01"
    Environment = "Production"
  }
}

# ==========================================
# 📢 Output (O Terraform vai cuspir o IP na tela)
# ==========================================
output "ec2_public_ip" {
  description = "Copie este IP e cole no seu navegador para testar"
  value       = aws_instance.web_server.public_ip
}