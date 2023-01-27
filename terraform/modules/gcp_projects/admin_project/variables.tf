variable folder_id {
    type = string
    description = "The GCP folder in which to create projects"
}

variable proj_name_prefix {
    type = string
    description = "A string prepended to project display names, e.g. the 'foo' in 'foo dev'"
}

variable proj_id_prefix {
    type = string
    description = "A string prepended to project IDs when created, e.g. the 'foo' in 'foo-dev'"
}

variable billing_account {
    type = string
    description = "Hexadecimal ID of the billing account to use"
}
