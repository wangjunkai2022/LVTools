from read_config import get_config

emby = get_config("emby")
emby_domain = emby.get('domain')
emby_key = emby.get('api')

aws = get_config("aws")
aws_access_key_id = aws.get("aws_access_key_id")
aws_secret_access_key = aws.get("aws_secret_access_key")
