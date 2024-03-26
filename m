Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D351CAA0;
	Tue, 26 Mar 2024 17:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711473832; cv=none; b=UtH9OT2SrMhx5FKHNysQPHrSHD/rs4q6DLh8Yq9vpVeIwSoNTFrQ/6a4reYKGEAKXihspA5uqQvCL6kIPbX7OMK2t64TfhjaNyGaWKokZZtonbAAKiAunCdu9nYLWNNKRIASXcKLy50x+8sZ9yyQEbXuX4ilgWpvEYlH7ZpXycM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711473832; c=relaxed/simple;
	bh=y+Jn18BZvFtNR884rHy0vrdkGll6bE/d3iE32Yv6pyM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m7/xXIU9qUAr8XOg/5nLgR0eFkoDkrRttszwzRhpZl8FtTGOQZa/4g+QqA4jQ/xHfxnfdanpf5gAbJxdEQQgpqCk3PZcxo9cvj7hZyNTCtjJS0wNN2NSFC/Zs+IS0JpCErMI+WzXUzVXGDr0+0VADqKZP7Pv1FbDqjaeUq+91c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6e88e4c8500so4107437b3a.2;
        Tue, 26 Mar 2024 10:23:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711473830; x=1712078630;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CbK5+D93ipMvgDtby/SY/DONORImvPAeAXEdkHS1+b8=;
        b=TgowYE51yh0Mw4USGwqhYZ2y6ANiE1NPJ5iBQNk9cvwIxH6E9eNyNaEU4cAWgZpR4E
         HMKtllE63ctGagxcffPn/vMB1CjuZpv3lx3U+oKcaEBb6UQ4SBKiIWF9dZsqJU71qr5J
         WbO5tFWoClhk5KlPTvcQcaYxIpaZPNAWhG44yQ0pLQXO/dY07ZJaznGDUY/z/uK95QRG
         mCIsxooEoVBCSZRtY//hdOE4ZpkyDxAdYUXCYfY5HljJY8LVRyZIIV5qxFLq7HKLMumb
         1f9VByxSQz+1EdzAPpYdopm1y9Ln45eMsuylc84e6GtEIGIMoLX3KCzSIxpgmPrbi+RV
         pmxw==
X-Forwarded-Encrypted: i=1; AJvYcCXw+v4kopAUrxc/9KKO0HfvCSxLCfpUGo7cew3fDSRgQjrDVzzybiBqT68WeMFCDCeTtYWnp2UhaUMU4qwuQW7CZZzZ5F/aQBrwYSLSGa/xiw03nzXMGUVZh23ZPnjxuG8SZEK6bc7e
X-Gm-Message-State: AOJu0YyNTezKvzaAcW3wti9tjFuej7Ia7XuieZpQmzyoewUOLza1N+3V
	5xJg4yo2Dytn+PaOMa7rvknwvrPsuH4pVhQwIoSOjfHWNL916fix
X-Google-Smtp-Source: AGHT+IF1a1+CI+nTKVQ/ChEFscp+C7hhSiLHGv8wry4HV4h8dI0yWHSfHNCPewRPVIDM7JHJjuoSRA==
X-Received: by 2002:a05:6a00:2d15:b0:6e7:30b0:9cc7 with SMTP id fa21-20020a056a002d1500b006e730b09cc7mr3703390pfb.15.1711473830487;
        Tue, 26 Mar 2024 10:23:50 -0700 (PDT)
Received: from ?IPV6:2620:0:1000:8411:262:e41e:a4dd:81c6? ([2620:0:1000:8411:262:e41e:a4dd:81c6])
        by smtp.gmail.com with ESMTPSA id x21-20020a056a00271500b006e7309d9831sm3908204pfv.39.2024.03.26.10.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Mar 2024 10:23:49 -0700 (PDT)
Message-ID: <c50dc0a4-190a-4780-91b7-ceedfb1aa926@acm.org>
Date: Tue, 26 Mar 2024 10:23:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/28] block: Introduce zone write plugging
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-8-dlemoal@kernel.org>
 <f3b298bb-b68a-4375-a3b4-fc91229740c1@acm.org>
 <839ebf2a-4dc6-433b-bc47-fd7915ed0ecf@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <839ebf2a-4dc6-433b-bc47-fd7915ed0ecf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/25/24 20:12, Damien Le Moal wrote:
> On 3/26/24 06:53, Bart Van Assche wrote:
>> On 3/24/24 21:44, Damien Le Moal wrote:
>>> -void disk_free_zone_bitmaps(struct gendisk *disk)
>>> +static bool disk_insert_zone_wplug(struct gendisk *disk,
>>> +				   struct blk_zone_wplug *zwplug)
>>> +{
>>> +	struct blk_zone_wplug *zwplg;
>>> +	unsigned long flags;
>>> +	unsigned int idx =
>>> +		hash_32(zwplug->zone_no, disk->zone_wplugs_hash_bits);
>>> +
>>> +	/*
>>> +	 * Add the new zone write plug to the hash table, but carefully as we
>>> +	 * are racing with other submission context, so we may already have a
>>> +	 * zone write plug for the same zone.
>>> +	 */
>>> +	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
>>> +	hlist_for_each_entry_rcu(zwplg, &disk->zone_wplugs_hash[idx], node) {
>>> +		if (zwplg->zone_no == zwplug->zone_no) {
>>> +			spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
>>> +			return false;
>>> +		}
>>> +	}
>>> +	hlist_add_head_rcu(&zwplug->node, &disk->zone_wplugs_hash[idx]);
>>> +	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
>>> +
>>> +	return true;
>>> +}
>>
>> Since this function inserts an element into disk->zone_wplugs_hash[],
>> can it happen that another thread removes that element from the hash
>> list before this function returns?
> 
> No, that cannot happen. Both insertion and deletion of plugs in the hash table
> are serialized with disk->zone_wplugs_lock. See disk_remove_zone_wplug().

I think that documenting locking assumptions with lockdep_assert_held()
would make this patch easier to review.

Thanks,

Bart.


