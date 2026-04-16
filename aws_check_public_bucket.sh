for bucket in $(aws s3api list-buckets --query 'Buckets[].Name' --output text); do
    # Check Public Access Block settings first
    is_blocked=$(aws s3api get-public-access-block --bucket "$bucket" --query 'PublicAccessBlockConfiguration.{BlockPublicAcls:BlockPublicAcls,IgnorePublicAcls:IgnorePublicAcls,BlockPublicPolicy:BlockPublicPolicy,RestrictPublicBuckets:RestrictPublicBuckets}' --output text 2>/dev/null)
    echo "is_blocked is $is_blocked"
    # Check Policy Status
    policy_status=$(aws s3api get-bucket-policy-status --bucket "$bucket" --query 'PolicyStatus.IsPublic' --output text 2>/dev/null)
    
    if [[ "$policy_status" == "True" ]]; then
        echo "⚠️ PUBLIC POLICY: $bucket"
    else
        echo "✅ Bucket policy is not public: $bucket" 
    fi
done
