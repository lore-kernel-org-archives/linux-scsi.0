Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B7F5025A;
	Wed, 15 May 2024 23:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715817156; cv=none; b=ZGSjiirBfSGHAMe16mylgHeAaBvISoxnE/VfcGOAkS0xB0ApuNDhuxed+tYR0yUU/FOdr3X9xBZ+HtoeynYho8F7QoDw46Nm8/AOlf9tavGsVUjpfAy0SGtYi4JO44bg97HJHHhPMfWtGuw+vFY26FE5K95ro23b0KZPrlcBtsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715817156; c=relaxed/simple;
	bh=aAzL0Q/mlayMx5JvOGiP2oO+DucZpK+Wy+VCGl5lVIQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n/hsZG22RBIlRIG7hNYAMuZVTS9mK6wvhoS0khX69DWPjnTel+o+mfb/mm0VjxilIBNYPKDK4gmWSVjo6/cHk65dJV9w6IteSesdFGIpQ+6rK5cSCT7tAHW/AubHK57PEdv3qaIdF0AQMJxnsMW+PyZmpBEjHtTgYoh0CUCZkdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mqCR9VvQ; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mqCR9VvQ"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1eb24e3a2d9so65903745ad.1;
        Wed, 15 May 2024 16:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715817155; x=1716421955; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=FKhifieaISK073Y1BZFKCyfNkYAdJs4Ik0qOYBYCQEw=;
        b=mqCR9VvQVsWkTp9Ud4JFChGgcUCuGoofce7HpBvQoZcqWk0u/6nvkgrs1qLT/Q9KN1
         Pi0en5kw4EkF/5kpiq9FzxDq2u4uK4VRakUxIdi2z20UiqwxDgsLUR9FpUOapnYmxu54
         Fa/nWK/An+r6t6sWCPPgxbJ9kwWR6NyVuoWYzdC7OBdwei4N3QkU/8ieYsGsmr6CAps4
         vlYVp8PeHT1ZmHpV77YNlwW9Gh5/Pkv2vMwPy2DXzsrFdN03QubXnQjH1TAhehskAW7W
         TlgDEAAYQau4401N2xuUMZUYPehOXSx9ja3pv6cid/Ca47TKtTvxFbreRv3IZ4AaQRV4
         i+2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715817155; x=1716421955;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FKhifieaISK073Y1BZFKCyfNkYAdJs4Ik0qOYBYCQEw=;
        b=YgZ+XeWvNK4Z8VOqAoHDwQy2GwzN05sMQYgMEYw+ZWOpVhJ8eCUx3xrV0xmX2XIn25
         tXBwKcvjoGiKXYDAuHk/H/ZvBa/rJRlAN31iWKqlUFUEEb9xRcMO/YV+UHpzr5Qvg3eM
         hnnhqa3texiJhvKMopMKCljmi0MlsJuJmG7M/62wTDB+ke0LOgMjATUn3dgeNVyK+wkz
         9EDErpOhq5B1op6glNmBVlVAK5Wa/DO2SauCfu8xz3LRVeu6w+dNOfwNmHHQm1brVeHU
         Q4PsREs9+BeSeqcAvKbp7Gjgrxc7RnX3l0vHdqdeU8xfzJGQ/p8jnP6AZArAxfkWePc6
         rmAA==
X-Forwarded-Encrypted: i=1; AJvYcCVsuDbqND/6wXdlj3AgFRBhlbxtUiTML6AO8QMBhvWMzJztK4VIjvOmG+zI+G9+Tz9eaYM5SYhw1P/Y4wcoe4ACcFOR1R4NRInpTHAlT9YD++TaMI7xLBgmJkzcR/PKvcrkDA6jtHA0RRuQfGqWkeRVqKdOW0N+RET2OSXGfcIDJsO/o+Tno2+LXO+w5LvHPrxfkEHXDt/qd7iCgFLSIS39s2R0Rf016KKul35vhpVc+eOI+Oy9RmU5dr1GmyRa9g8=
X-Gm-Message-State: AOJu0YwEFoI3S2na/Edon0D0+fE7C21YagmawGojq84hzfM9tUQwOrVn
	ZmAFtHELrdKzpY0b8wB27/oe0vT6JAiW0OUxL/sY2Gk/wCjphfNT
X-Google-Smtp-Source: AGHT+IGIWWSXROtGGxDqBXMxUoO3rjBRVc9W10PmL+SUXxGE3biis5LDvzz/VSs8zv1/FG1ulsfEJw==
X-Received: by 2002:a17:902:f602:b0:1e4:19e3:56cb with SMTP id d9443c01a7336-1ef43c0954cmr298417585ad.12.1715817154637;
        Wed, 15 May 2024 16:52:34 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0b9d4733sm124678615ad.54.2024.05.15.16.52.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 16:52:33 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <08beb913-f525-49e2-8ef2-f62e9d466e53@roeck-us.net>
Date: Wed, 15 May 2024 16:52:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/23] scsi: initialize scsi midlayer limits before
 allocating the queue
To: John Garry <john.g.garry@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 Takashi Sakamoto <o-takashi@sakamocchi.jp>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 "Juergen E. Fischer" <fischer@norbit.de>,
 Xiang Chen <chenxiang66@hisilicon.com>,
 HighPoint Linux Team <linux@highpoint-tech.com>,
 Tyrel Datwyler <tyreld@linux.ibm.com>, Brian King <brking@us.ibm.com>,
 Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
 Mike Christie <michael.christie@oracle.com>, Jason Yan
 <yanaijie@huawei.com>, Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Jack Wang <jinpu.wang@cloud.ionos.com>, Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
 linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net, Hannes Reinecke <hare@suse.de>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-5-hch@lst.de>
 <ce2bf6af-4382-4fe1-b392-cc6829f5ceb2@roeck-us.net>
 <a8c39499-1410-4251-bf26-36763f5f56b0@oracle.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <a8c39499-1410-4251-bf26-36763f5f56b0@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/15/24 15:16, John Garry wrote:
> On 15/05/2024 15:50, Guenter Roeck wrote:
>> Hi,
>>
>> On Tue, Apr 09, 2024 at 04:37:29PM +0200, Christoph Hellwig wrote:
>>> Turn __scsi_init_queue into scsi_init_limits which initializes
>>> queue_limits structure that can be passed to blk_mq_alloc_queue.
> 
> The previous behavior would sanitize max_segment_size < PAGE_SIZE, so I suppose you could try:
> 
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -199,6 +199,8 @@ static int blk_validate_limits(struct queue_limits *lim)
>                   */
>                  if (!lim->max_segment_size)
>                          lim->max_segment_size = BLK_MAX_SEGMENT_SIZE;
> +               else if (lim->max_segment_size < PAGE_SIZE)
> +                       lim->max_segment_size = PAGE_SIZE;
>                  if (WARN_ON_ONCE(lim->max_segment_size < PAGE_SIZE))
>                          return -EINVAL;
>          }
> 

With some debugging:

pata_macio_common_init() Calling ata_host_activate() with limit 65280
...
max_segment_size is 65280; PAGE_SIZE is 65536; BLK_MAX_SEGMENT_SIZE is 65536
WARNING: CPU: 0 PID: 12 at block/blk-settings.c:202 blk_validate_limits+0x2d4/0x364
...

This is with PPC_BOOK3S_64 which selects a default page size of 64k.
Looking at the old code, I think it did what you suggested above,

void blk_queue_max_segment_size(struct request_queue *q, unsigned int max_size)
{
         if (max_size < PAGE_SIZE) {
                 max_size = PAGE_SIZE;
                 printk(KERN_INFO "%s: set to minimum %d\n",
                        __func__, max_size);
         }
...

but assuming that the driver requested a lower limit on purpose that
may not be the best solution.

Never mind, though - I updated my test configuration to explicitly
configure the page size to 4k to work around the problem. With that,
please consider this report a note in case someone hits the problem
on a real system (and sorry for the noise).

Thanks,
Guenter

