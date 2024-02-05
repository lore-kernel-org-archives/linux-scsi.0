Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5784594A;
	Mon,  5 Feb 2024 17:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707155503; cv=none; b=qiZe3DNB1D+yu2Ce8kudjXnID179c5IBMzIankfEURtF7NQLoIx2fQUvAlq/XcEDHWyB2hxH9aN/Q9DZq9vlpHCVBK885rmnK5BWh1Zqf14GC6IMN4k8J3xAzcXC8DmR5eVUT92za6NwqEV2gBnlsDq+Bsxg+646eOXUQkp5OOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707155503; c=relaxed/simple;
	bh=xcpvtR0q2vdSHSYVN51+9eNcjtc7KwYT6wnijM0Smd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aoRJMKKbnzCAzQgsbF8jbzgGqQBfJJ9d0V0YaCfuPBL9qE26DluBjMJ3suL37IVw4OHgBnLMlzEYNV+HTABxxL3pB74wybdP131Fo4PZbgSQ5dSAAb9sl0qW5IRv+NOqLZDKIrRyXT2+WTjY8aSYzG3oakt5BTjFflQX1RH8txU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2906773c7e9so3172766a91.1;
        Mon, 05 Feb 2024 09:51:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707155501; x=1707760301;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xcpvtR0q2vdSHSYVN51+9eNcjtc7KwYT6wnijM0Smd0=;
        b=QPeaNyPBsYxC1VKAyhhMh1gPTLI1/86fBmsCN5ao9CNw/PkxnokZTKvEoQwR6g1Iia
         ySVNrm+6IYqSpupZbBjAZuVDPojKA2bi7KVocLjQYC+Tb3awCtna0aDyH68DEEEihTkC
         /WBtSrmEVMbFqhVKqVayzzX2fM6vo1hO9vW+svTbZD3YjFCQDjbTdtWO9QgiSjeMTpV0
         wmWENJa/q93cpgf3BBNnXQCBZyDmZDmlFPGqh60CsICPTknqlHcvkUtvDdxbycpavbmg
         vTngwLYq6T2VWKB9SrxduqILszsZAdYamlMMlJ/JkBzzlN330OFfMLSTE+TvhwoocitT
         6yKg==
X-Gm-Message-State: AOJu0YzBJagbYJbLzxQNB73MdXs09NuhTPy6XZbEqYm+FAOxpCulztJU
	n5em0qYN8JaXz4UcyydE15MKtEIIBaUgMtiEbF4V3RGk5yFN57QE
X-Google-Smtp-Source: AGHT+IGgaDGSUDW7iXO5w2TtVdve09NoinL3KvH6qY6x5y5YP48Ixt0AA4xKLtAiPwa6sqp87FUj+A==
X-Received: by 2002:a17:90a:ad07:b0:295:d223:ad11 with SMTP id r7-20020a17090aad0700b00295d223ad11mr125788pjq.36.1707155500976;
        Mon, 05 Feb 2024 09:51:40 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUkP32y4JnIpsczIpz3FMMvVwbB4I40DNXBEaUAxzfpBniU49vMwCr61wgurV1kysp59QRPIDm0AjDsXOlk76qmeAb/HBJ/we8iItGMEWLJfW4nXmeoNmxr+MVftwqo6o5zG/A+R5Jfp0W3WoWMqjbfXfgUB8fAXHLnSPKVTU70Rvd4wuTcFAsX1KOz9QRfgzl4LIFlVPfm8GGFSAqw8TnQH6PYOavW8+LuBjuXeG1YMSOA5GidBe2gEuTUxHxQjouHFuRuWgsByCZbwJIAiBYvsgKNIjYD
Received: from ?IPV6:2620:0:1000:8411:be2a:6ac0:4203:7316? ([2620:0:1000:8411:be2a:6ac0:4203:7316])
        by smtp.gmail.com with ESMTPSA id gb15-20020a17090b060f00b00296a4c3a7aasm1937027pjb.52.2024.02.05.09.51.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 09:51:40 -0800 (PST)
Message-ID: <f3a2f8b8-32d2-4e42-ba78-1f668d69033f@acm.org>
Date: Mon, 5 Feb 2024 09:51:39 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/26] block: Reduce zone write plugging memory usage
Content-Language: en-US
To: Hannes Reinecke <hare@suse.de>, Damien Le Moal <dlemoal@kernel.org>,
 linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-26-dlemoal@kernel.org>
 <09d99780-8311-4ea9-8f48-cf84043d23f6@suse.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <09d99780-8311-4ea9-8f48-cf84043d23f6@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/4/24 04:42, Hannes Reinecke wrote:
> On 2/2/24 15:31, Damien Le Moal wrote:
>> With this mechanism, the amount of memory used per block device for zone
>> write plugs is roughly reduced by a factor of 4. E.g. for a 28 TB SMR
>> hard disk, memory usage is reduce to about 1.6 MB.
>>
> Hmm. Wouldn't it sufficient to tie the number of available plugs to the
> number of open zones? Of course that doesn't help for drives not reporting that, but otherwise?

I have the same question. I think the number of zoned opened by filesystems
like BTRFS and F2FS is much smaller than the total number of zoned supported
by zoned drives.

Thanks,

Bart.

