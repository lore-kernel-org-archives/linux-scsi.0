Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A022B10795;
	Sat,  3 Feb 2024 04:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933353; cv=none; b=j7xg88IBe+fiWRtqmIMgilIeAvjZKmdm0PZiwsF7kj26h6C4oxfnBzzWRWvxFzhrZtYvFcQAfUZ/bxAPunfLFcnbcEXzNgJ57QHtf/cNrlnxQCMr/1TXUddbouyQKykPAJoEyLQpyReBdaMBT9TLRowF7RWjJvfbAZwL6RrKAB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933353; c=relaxed/simple;
	bh=Sd839QDrFGVIVEc2Tq2it3jl+Ag+qEE1WIjYvmCvaNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jOmOoLGtghnQiwF4WR1c3r8+dEoe25+yb3s4xkTMET2OjchgCSSkPC4D/KSGVCTe1jxlovbIhJJUrwUk99Ihkpx28KMagaDfCTfBlfmyX7Vcm3xc6SzwrU5K8BT4ut0eLvigHTYJp7y3nwC+8mexIX7/FM+dKEG7EI0kTl3szjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-295c8b795e2so2171104a91.0;
        Fri, 02 Feb 2024 20:09:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706933351; x=1707538151;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H3xNjxAc7RvjEF8zQJCF+Dz0udROGOGKCMXAfjzIDs0=;
        b=g1eVwDZdQHgR03JWrLkl+B07ls3uKctUdZ5RwAm5hHxQsJSYA20jNasdGQ/WQ1g28L
         N0pa/K9YmIm+CmAbx4fns8PI8VUSdcsaqT2++djNQID7f6wSZmtf6vlaa0Aaf/1h8YBD
         DzoVpZyFq/3UU6NIoG/LDN/2//c+vnI4tIw6dPXxUStIEI36Iw3CTCiHetJvBy9jh4mc
         GZMb+PGjbULKPQ6hsmhKL2ocW+q43TPzm0zkILV5VkktIIBZg3HTVXCdMLmq1aOboPI6
         FA+Xabq/fIta1TexDiuabKH/7g6M7IMKZ5rQqBt1pb7Swl12hbY6HWGpXVApP3Rby/J/
         2v7w==
X-Gm-Message-State: AOJu0YyNnLe+GV2W6pxtXSxw1SCcDvUHJafxmwpu9nUT+Qg6z4Cgi32R
	kCzE7EyABlG7pdzSjoGbWVDMcAc8sLlulY/RYT9oP+Gzh5YuTW86Es+27L9D
X-Google-Smtp-Source: AGHT+IFtrJAHFkRzXhfegN5ot9PSsokgayx5PV+Ui66N6omkZ+Dckp+J0tEWSC4T+PBA4FqJveeLCw==
X-Received: by 2002:a17:90b:4d11:b0:296:4fc5:9982 with SMTP id mw17-20020a17090b4d1100b002964fc59982mr2384531pjb.37.1706933350701;
        Fri, 02 Feb 2024 20:09:10 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXvftWDj7zTmOV7xhmVCvwZmF4ZQ/RMiSVlWnE8yNQjA7jaa2dsrJkBWre8Hqkm3sHyOX0V30/wyqAVudhMKVhRfgw0IPL7n/ZMUqij5b6VZGaOh1Ge+2+zlX5fEql959CXSZJ4vsYpWfzpBHipnQBxUhYvxHV6W8ZF5jJNPo3gW8SiemFlNs2NsChM8xZPEnUcEtvqcpDlONI1ZYGhQXgKZIjG0g6IyOQWVXlkabNmOa76i2/ocuizLxZOBjKHvek7NA==
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id nd6-20020a17090b4cc600b00295c60991dasm866496pjb.8.2024.02.02.20.09.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Feb 2024 20:09:10 -0800 (PST)
Message-ID: <9da5baed-acb6-4402-8123-0874c7a08bd7@acm.org>
Date: Fri, 2 Feb 2024 20:09:06 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/26] block: Introduce bio_straddle_zones() and
 bio_offset_from_zone_start()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-4-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240202073104.2418230-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/1/24 23:30, Damien Le Moal wrote:
> Implement the inline helper functions bio_straddle_zones() and
> bio_offset_from_zone_start() to respectively test if a BIO crosses a
> zone boundary (the start sector and last sector belong to different
> zones) and to obtain the oofset from a zone starting sector of a BIO.

oofset -> offset
> +static inline bool bio_straddle_zones(struct bio *bio)
> +{
> +	return bio_zone_no(bio) !=
> +		disk_zone_no(bio->bi_bdev->bd_disk, bio_end_sector(bio) - 1);
> +}

It seems to me that the above code is not intended to handle the case
where bi_size == 0, as is the case for an empty flush request. Should a
comment be added above this function or do we perhaps need to add a
WARN_ON_ONCE() statement?

Thanks,

Bart.
