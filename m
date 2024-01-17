Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E21824B25;
	Wed, 17 Jan 2024 20:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705522685; cv=none; b=CGui82qWNRi1fSnByoQI9tZklFaKdI80ASTXBDQDAXt8m1Oe2u20ttsk4OfWs+umG+Utoz+p09byz3RmdwaTcKjiSvsdQ4JOlPqN6Od6tWYyWTNXVj/Ygec8dywIEcDV75rddEVCLnazo1KBVF4axcMjtbw3qUZvVsR5FMf2XHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705522685; c=relaxed/simple;
	bh=DJxLTcZNONr4KRKLJ+M2WAs0xreKouiNgNTyIlynfwM=;
	h=Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding; b=NwMKOxGH0MMl5Ob59B2yjoXqJ2l7xXQDPQhW0fLiFj42L8vKB5y1JydByPln7kD6zb3vbNl4Vn4FmqzzUthy2rd0St59F8H2GFhg7TqHxtnKKfBoxy2KMySM21lnz1TOPH/ZIAX7tfFvP4VnbcgFAUg6kgaraYZcgkH+bGjE45Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-28e82c1f7e4so1346237a91.1;
        Wed, 17 Jan 2024 12:18:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705522684; x=1706127484;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7/Uu3y14KMTzvtlTvNxfEaBtVLCjSK7ZE6fv/xcZI+A=;
        b=ElNn3ZJ4Xmfzh4Pm8aVRQDn8RaWfTzAu0FFQRTkO33dDsnAPCLLjgnoFkdTnygNGxq
         kzA8/JBZYubzaNtDbvNGwStOnYtD34qawj8q+9yhs1RSF0TtNFlJx6IvOm0OL4gjPV8r
         5dqM507Ys5B2GNTBpHCZjniNcqAhhxiy08XG4KfYJrFRsofSQ/tS/uEZdNrxzJOGnlAX
         l6e8up5lFNRhBTKWgK5Xnp0+bSD95rfBKnhh+YEaQbn5N3qB47kUHRlH8c5RtxfFQmYV
         /HotCTxz/2RgNeqtp2M40sZxswKKitky2SCw+jt1W37y0x/jvYWcqwYsGpWbmeFNUGw6
         dcbw==
X-Gm-Message-State: AOJu0YyGwuucBAKu9vuNA3sMM8h64+JAI1d+CssjeibHVAPqp8PP7CMY
	zWo8O6NTkrpz74FCMpEzZIE=
X-Google-Smtp-Source: AGHT+IEBz6MpQH028iW4X2ZIVqDX48bTejSFEsIGLJt70ISnKU/drkjZjIUzkCKIDiA43ofqp3+BgQ==
X-Received: by 2002:a17:90a:4bc5:b0:28e:71a1:82d2 with SMTP id u5-20020a17090a4bc500b0028e71a182d2mr2197109pjl.63.1705522683567;
        Wed, 17 Jan 2024 12:18:03 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:718b:ab80:1dc2:cbee? ([2620:0:1000:8411:718b:ab80:1dc2:cbee])
        by smtp.gmail.com with ESMTPSA id i14-20020a17090332ce00b001d6f04f2b5dsm59533plr.30.2024.01.17.12.18.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jan 2024 12:18:03 -0800 (PST)
Message-ID: <39dfcd32-e5fc-45b9-a0ed-082b879a16a4@acm.org>
Date: Wed, 17 Jan 2024 12:18:01 -0800
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
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <276eedc2-e3d0-40c7-b355-46232ea65662@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/17/24 12:06, Jens Axboe wrote:
> Case in point, I spent 10 min hacking up some smarts on the insertion
> and dispatch side, and then we get:
> 
> IOPS=2.54M, BW=1240MiB/s, IOS/call=32/32
> 
> or about a 63% improvement when running the _exact same thing_. Looking
> at profiles:
> 
> -   13.71%  io_uring  [kernel.kallsyms]  [k] queued_spin_lock_slowpath
> 
> reducing the > 70% of locking contention down to ~14%. No change in data
> structures, just an ugly hack that:
> 
> - Serializes dispatch, no point having someone hammer on dd->lock for
>    dispatch when already running
> - Serialize insertions, punt to one of N buckets if insertion is already
>    busy. Current insertion will notice someone else did that, and will
>    prune the buckets and re-run insertion.
> 
> And while I seriously doubt that my quick hack is 100% fool proof, it
> works as a proof of concept. If we can get that kind of reduction with
> minimal effort, well...

If nobody else beats me to it then I will look into using separate
locks in the mq-deadline scheduler for insertion and dispatch.

Bart.


