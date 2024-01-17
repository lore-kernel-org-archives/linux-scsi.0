Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309BA22EE8;
	Wed, 17 Jan 2024 21:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705527225; cv=none; b=epRgKB9ZvIjx00KCrGNscCIDtTsCFUr2NxpEJgVMRkPVpiU6WrfH84zIOGTJmSPDzaB0cFNYA/tZiy2FcEAQcjVRUXZK+Wd8k86PENEn4iRPoWNTp2kCkcoJAs+d8N/9EqiZL1aXlj9noQeYl4/xQ6p/73nAiAw8eHkR5GcnxEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705527225; c=relaxed/simple;
	bh=xHQq8VjDitsvhOIV6jTVv811Gc9PkMiGmKj0Ja4RksY=;
	h=Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding; b=D3KaWa05OrxznpVL62uXsMdUhUMb9WuT5xHTZdw6qXX1apV1ujlJuz6P3pBnoH2ua40EU+Hvu6OX2cVU8QorAyteofUMIe2u0Cv1I9xR0zUcQF0SP4tSxNFLgAzW8YU7Is8NUejLWFVP6bsJRGJcP2kS5viv9XKzyi13mrYtDFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1d5f38313f9so712225ad.1;
        Wed, 17 Jan 2024 13:33:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705527223; x=1706132023;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qKRTEGEdrJ4uSy0DPEMsw7O2DbfmPLHSdmoAR4y/Lbs=;
        b=VTkAVC2vzVgtPXRZCzw2wgg2Ev7pAUcuue6YM9iLAC69ZGTA7xonfcGFfRhrFj3C+h
         f4UDp98XvBdo11mDN44fsVFmFNhE7GzxAPmyD7OCVKffuubqcRsw6t0LncF+Tv23ssge
         D5d6P3gs3h2n1uTKf/pI07ZIH34EoTD5bE5rteERVarez/8txUdMDRh2dyJUH6oqMxqM
         uAzYQHtMAUqGvOhPo9QtllVPnQIuNpCvzqUjbXMX4+U8ez+xXid6PApWeQj6Zub3c9Yw
         5i4GAuF+bXVLZ8WxyAke/m/KqYwIVg0PtQzu1lixvCP+dVuR5tTqc7GB4pwblkAfGIMX
         U5eg==
X-Gm-Message-State: AOJu0Yy320NtuHOlpg2SDPRSfIJ1eA0E76X7EkZHl1XqEGNbf8ZHPUeK
	iGZEyAcOWZLLDw/I/DPAJ0w=
X-Google-Smtp-Source: AGHT+IGPxShij0/HAOZ8P3At6ZhQ6kIOlS3Ebm0BxPvhf5meWiuDz5mRMRPBO3ETKVp2Fgqhxw+dyg==
X-Received: by 2002:a17:902:d58c:b0:1d5:4b88:9ffc with SMTP id k12-20020a170902d58c00b001d54b889ffcmr2377964plh.1.1705527223358;
        Wed, 17 Jan 2024 13:33:43 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:718b:ab80:1dc2:cbee? ([2620:0:1000:8411:718b:ab80:1dc2:cbee])
        by smtp.gmail.com with ESMTPSA id ki4-20020a170903068400b001d5ea27932csm108599plb.77.2024.01.17.13.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jan 2024 13:33:42 -0800 (PST)
Message-ID: <86a1f9e6-d3ae-4051-8528-13a952cf74a1@acm.org>
Date: Wed, 17 Jan 2024 13:33:41 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Improving Zoned Storage Support
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 Christoph Hellwig <hch@lst.de>
References: <5b3e6a01-1039-4b68-8f02-386f3cc9ddd1@acm.org>
 <cc6999c2-2d53-4340-8e2b-c50cae1e5c3a@kernel.org>
 <43cc2e4c-1dce-40ab-b4dc-1aadbeb65371@acm.org>
 <c38ab7b2-63aa-4a0c-9fa6-96be304d8df1@kernel.dk>
 <2955b44a-68c0-4d95-8ff1-da38ef99810f@acm.org>
 <9af03351-a04a-4e61-a6d8-b58236b041a3@kernel.dk>
 <276eedc2-e3d0-40c7-b355-46232ea65662@kernel.dk>
 <39dfcd32-e5fc-45b9-a0ed-082b879a16a4@acm.org>
 <9f4a6b8a-1c17-46b7-8344-cbf4bcb406ab@kernel.dk>
 <207a985d-ad4e-4cad-ac07-961633967bfc@kernel.dk>
 <e8c32676-114b-4aaf-8753-5a6d7b04fc4b@kernel.dk>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e8c32676-114b-4aaf-8753-5a6d7b04fc4b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/17/24 13:14, Jens Axboe wrote:
>   /* Maps an I/O priority class to a deadline scheduler priority. */
> @@ -600,6 +604,10 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
>   	struct request *rq;
>   	enum dd_prio prio;
>   
> +	if (test_bit(0, &dd->dispatch_state) ||
> +	    test_and_set_bit(0, &dd->dispatch_state))
> +		return NULL;
> +
>   	spin_lock(&dd->lock);
>   	rq = dd_dispatch_prio_aged_requests(dd, now);
>   	if (rq)
> @@ -616,6 +624,7 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
>   	}
>   
>   unlock:
> +	clear_bit(0, &dd->dispatch_state);
>   	spin_unlock(&dd->lock);

Can the above code be simplified by using spin_trylock() instead of
test_bit() and test_and_set_bit()?

Please note that whether or not spin_trylock() is used, there is a
race condition in this approach: if dd_dispatch_request() is called
just before another CPU calls spin_unlock() from inside 
dd_dispatch_request() then some requests won't be dispatched until
the next time dd_dispatch_request() is called.

Thanks,

Bart.

