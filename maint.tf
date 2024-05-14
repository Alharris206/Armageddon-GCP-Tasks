terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.25.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = "manifest-bit-416401"
  region = "us-east1"
  zone   = "us-east1a"
  credentials = "c:/Users/harri/OneDrive/Desktop/Theo Waf/manifest-bit-416401-b5315f9c10a5.json"
}

resource "google_storage_bucket" "plumbers-bucket-1" {
  name          = "plumberstf-bucket"
  location      = "us"
  force_destroy = true


  website {
    main_page_suffix = "index.html"
    not_found_page   = "error.html"
  }

   uniform_bucket_level_access = false 
}


// Setting the bucket ACL to public read
resource "google_storage_bucket_acl" "bucket_acl" {
  bucket         = google_storage_bucket.plumbers-bucket-1.name
  predefined_acl = "publicRead"
}

// Uploading and setting public read access for HTML files
resource "google_storage_bucket_object" "upload_html" {
  for_each     = fileset("${path.module}/", "*.html")
  bucket       = google_storage_bucket.plumbers-bucket-1.name
  name         = each.value
  source       = "${path.module}/${each.value}"
  content_type = "text/html"
}

// Public ACL for each HTML file
resource "google_storage_object_acl" "html_acl" {
  for_each       = google_storage_bucket_object.upload_html
  bucket         = google_storage_bucket_object.upload_html[each.key].bucket
  object         = google_storage_bucket_object.upload_html[each.key].name
  predefined_acl = "publicRead"
}

// Uploading and setting public read access for image files
resource "google_storage_bucket_object" "upload_images" {
  for_each     = fileset("${path.module}/", "*.jpeg") 
  bucket       = google_storage_bucket.plumbers-bucket-1.name
  name         = each.value
  source       = "${path.module}/${each.value}"
  content_type = "image/jpeg"
}

resource "google_storage_bucket_object" "upload_images_png" {
  for_each     = fileset("${path.module}/", "*.png")
  bucket       = google_storage_bucket.plumbers-bucket-1.name
  name         = each.value
  source       = "${path.module}/${each.value}"
  content_type = "image/png"
}

resource "google_storage_bucket_object" "upload_images_jpg" {
  for_each     = fileset("${path.module}/", "*.jpg")
  bucket       = google_storage_bucket.plumbers-bucket-1.name
  name         = each.value
  source       = "${path.module}/${each.value}"
  content_type = "image/jpg"
}

// Public ACL for each image file
resource "google_storage_object_acl" "image_acl" {
  for_each       = google_storage_bucket_object.upload_images
  bucket         = google_storage_bucket_object.upload_images[each.key].bucket
  object         = google_storage_bucket_object.upload_images[each.key].name
  predefined_acl = "publicRead"
}

resource "google_storage_object_acl" "image_acl_png" {
  for_each       = google_storage_bucket_object.upload_images_png
  bucket         = google_storage_bucket_object.upload_images_png[each.key].bucket
  object         = google_storage_bucket_object.upload_images_png[each.key].name
  predefined_acl = "publicRead"
}

resource "google_storage_object_acl" "image_acl_jpg" {
  for_each       = google_storage_bucket_object.upload_images_jpg
  bucket         = google_storage_bucket_object.upload_images_jpg[each.key].bucket
  object         = google_storage_bucket_object.upload_images_jpg[each.key].name
  predefined_acl = "publicRead"
}

output "website_url" {
  value = "https://storage.googleapis.com/${google_storage_bucket.plumbers-bucket-1.name}/index.html"
}