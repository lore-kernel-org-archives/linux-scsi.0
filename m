Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7B470CC2;
	Mon, 25 Mar 2024 22:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711405252; cv=none; b=MIfwWiifZVY4LG9V3TAN7JFkJsUk6h8XSoI7sb3ICNRM61PEevFqrAUjU9k9MAClCj5pjkbUCQJyoxiFL+zPw88d7zWPCSCoIGOvpkbvX/AHtsdsszTOfyZISoTv1apUr4U5u5j/latdonGTUx+SRawzoD56FJDhFsEExq5DAE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711405252; c=relaxed/simple;
	bh=6Ic0OY/97E82y2MO5yNzW1qCXh44+WdvVl2RS/Soo8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p8uJnJuAv7FPjlFKgPqGLPSm7xkhpB0Kn6AeeKA+SVjq2RJRioNwc2PzAqvaIugT1Ngr0znkJUGUYieo00ZkZWzMSY4QF7AgK5G77xQBwFMZx7hi29bkRn3Wt/iQzAzFCrz2op5T+0JNBImsV/HXZKLh8kue55UWgyfs0hKOGuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1e0ae065d24so15596995ad.1;
        Mon, 25 Mar 2024 15:20:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711405251; x=1712010051;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1dOJx1Zp4J5cyUuaj5fJBb2ijZj1VrN3Fadd6N6MWeI=;
        b=XU1H9528gPnXtuyNyK/gUfbI70WDAe98CCJPreL254dsxf/uXRo6spRXqeZ8jqsqi9
         /APSYFe7/+9raLDnYte5geDoF3lSQgCjAM3UJ4sQx0HEl4VzT+cfZ0ss5yKAILJEz+TT
         ChZP6FXfeS3kFdWIvbTyax3Eota5kCL88P8qEi1hA9inIcNabTLc/wRcT2jlBmEBOq36
         9yrUNoZdHwG4j7ACkz/P1TtTys60YInNSythQfw55nHIkRaRP55+1BWFwixDFSXHF/pJ
         osHrnzEl/TxfajdHk+i82aufcnYNfE9jQ0GSYXrAiBdocFAVKrGvOMm25n2Vz+3eVFdq
         xnLw==
X-Forwarded-Encrypted: i=1; AJvYcCWXDz0n/jk4rEhvFcxuHHyBFF2tza/UaFjd1haVR6Z+Z3tK0DkwftZO9KLSBd9tYkZO2RjOCPYdwXuyHwyn0ZLSYfpGHbVjoJu3v3G3Ae43MnBq4CkuoxdUyJ7du1om/YOrgkVs+iTg
X-Gm-Message-State: AOJu0YxfenPAT6neOVD1K8lOuXqj/AqoYdlDle90Enp3WSkHU9jlfogC
	5ROJAP8DAUYVtECqXEaqX7Z3rtG4pmbuIMv6LGvUbgeD1CJI7ecs1y03yEX3
X-Google-Smtp-Source: AGHT+IH6wE9DUGYzGAKfvhk+v7he4HblqsUTfSKTWYcKXWWLAk/0gRjMM40dMuxy17T78mdp9wIAkw==
X-Received: by 2002:a17:903:41c8:b0:1e0:c88f:654b with SMTP id u8-20020a17090341c800b001e0c88f654bmr3374540ple.25.1711405250675;
        Mon, 25 Mar 2024 15:20:50 -0700 (PDT)
Received: from ?IPV6:2620:0:1000:8411:262:e41e:a4dd:81c6? ([2620:0:1000:8411:262:e41e:a4dd:81c6])
        by smtp.gmail.com with ESMTPSA id w1-20020a170902e88100b001db8f7720e2sm4672631plg.288.2024.03.25.15.20.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 15:20:50 -0700 (PDT)
Message-ID: <ddc7708f-fcfa-45da-af01-601ea7ca8897@acm.org>
Date: Mon, 25 Mar 2024 15:20:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 25/28] block: Move zone related debugfs attribute to
 blk-zoned.c
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-26-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240325044452.3125418-26-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 21:44, Damien Le Moal wrote:
> diff --git a/block/blk-mq-debugfs.h b/block/blk-mq-debugfs.h
> index 9c7d4b6117d4..3ebe2c29b624 100644
> --- a/block/blk-mq-debugfs.h
> +++ b/block/blk-mq-debugfs.h
> @@ -83,7 +83,7 @@ static inline void blk_mq_debugfs_unregister_rqos(struct rq_qos *rqos)
>   }
>   #endif
>   
> -#ifdef CONFIG_BLK_DEBUG_FS_ZONED
> +#if defined(CONFIG_BLK_DEV_ZONED) && defined(CONFIG_BLK_DEBUG_FS)
>   int queue_zone_wlock_show(void *data, struct seq_file *m);
>   #else
>   static inline int queue_zone_wlock_show(void *data, struct seq_file *m)
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 03222314d649..62160a8675f4 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -22,6 +22,7 @@
>   
>   #include "blk.h"
>   #include "blk-mq-sched.h"
> +#include "blk-mq-debugfs.h"
>   
>   #define ZONE_COND_NAME(name) [BLK_ZONE_COND_##name] = #name
>   static const char *const zone_cond_name[] = {
> @@ -1745,3 +1746,22 @@ void blk_zone_dev_init(void)
>   {
>   	blk_zone_wplugs_cachep = KMEM_CACHE(blk_zone_wplug, SLAB_PANIC);
>   }
> +
> +#ifdef CONFIG_BLK_DEBUG_FS
> +
> +int queue_zone_wlock_show(void *data, struct seq_file *m)
> +{
> +	struct request_queue *q = data;
> +	unsigned int i;
> +
> +	if (!q->disk->seq_zones_wlock)
> +		return 0;
> +
> +	for (i = 0; i < q->disk->nr_zones; i++)
> +		if (test_bit(i, q->disk->seq_zones_wlock))
> +			seq_printf(m, "%u\n", i);
> +
> +	return 0;
> +}
> +
> +#endif

This patch increases the number of #ifdefs in block layer .c files so
I'm not sure that this patch can be considered an improvement.

Thanks,

Bart.
