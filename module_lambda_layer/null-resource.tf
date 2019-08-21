resource "null_resource" "demo_null_resource_clean_up_workspace" {
  provisioner "local-exec" {
    command = "cd ${path.module}/python_layers_payload/ && rm -rf python"
  }

  triggers {
    build_number = "${timestamp()}"
  }
}


resource "null_resource" "demo_null_resource_pip_download_modules" {
  provisioner "local-exec" {
    command = "cd ${path.module}/python_layers_payload/ && ${var.pip_binary_locaton} install --upgrade requests elasticsearch -t ./python"
  }
  depends_on = ["null_resource.demo_null_resource_clean_up_workspace"]

  triggers {
    build_number = "${timestamp()}"
  }
}