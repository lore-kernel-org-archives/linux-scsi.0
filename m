Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF6B14B971;
	Thu, 16 May 2024 14:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715871020; cv=none; b=SucZe1pU8l97syog7hTeuhxg9Anstycgwpl4zeLfo/S7kXI5bOfiGB6l5PwgUJVTt77TnrNKBP6xNrcxMs5o4nAWg4ks/0Qg462dV21uwTO6xf3v/3QF+GgzRetfVgoDpfeKcEc1LkxM29Y9ahrfHVD2jJVvxh/pwom8whyczLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715871020; c=relaxed/simple;
	bh=Ow0v95Uup8/7MFmhGLWu6krrPJTmVr8G3Fg8RZz/dBY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ja/qy+hBQX5fpo0tMtAWVDYzMR1MkojwoWhuSPaaJYcpfsXzXMSWg6jtjpn/4M5aRw8Q4FXa0uohj8lj7zMUAVa0kr7K6CVelYq42p/NP45cVlW6lRV6rSKZWtEuGt2Aj0BLshakCd2Pl5c7v5EeN0OtYizcJjSnX1b2gvQ2pN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GKrYCfUI; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GKrYCfUI"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6f44e3fd382so269294b3a.1;
        Thu, 16 May 2024 07:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715871018; x=1716475818; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=MP0twiF5szRNTbqcyBLQLKZi2/rxtByviGx0EcGxOTI=;
        b=GKrYCfUI7qaW88Qs0Kg3VHR8/pQfFjfw/BQlJ9HCnzdP5cLiTkLppYuHuoiRNnlZxU
         DYwp28g2y8p/3+srvisoMnKTs2alkbdCdmg4lLCgnzPfWCzNpSm/eUq5GYzro/e/9Afb
         hughZC88VoHXvkXU1DHJRWhaVj80c/3IQw3VG9Q380MAv7X4jLMsHOI7yQ/UJZ7ZVEg7
         WqFbfLsDqu/4K+6vJiIOV9mjft/D8ntH3t/tx+3d3TjfwE/zhwGSqInNECoZfaJvMLUl
         vjzxPheoxafNgxAMYP439pspAYZSKY92Dtb3AZaVcy6pit+2Z+6ZqOutQyxFZfm2TDox
         e4qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715871018; x=1716475818;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MP0twiF5szRNTbqcyBLQLKZi2/rxtByviGx0EcGxOTI=;
        b=ncq4P5i/+1KRVW8fxrZWDsmCiKzBa2qzQrkNgw3DIXIT2Km8BHy9pqX4Ff9jHn29hT
         /PVnBCAEcXxU1DzB3aMmnVSXrYI0W9y/Kjz9F3f60egV6qbxH1dsX+altul1bl3knNzX
         GNuNwTQL0s4IuSBnPI1CF1B4f8Nz7xWwRISmlzzZb1klgbKjAB6MZCo3+/GPnkpHplKq
         IN/GYBeRicWe2Y+vI+nLyn2UO29s9JHP1LLq/mv9vAkWDaU3Ud/4kaeElZUkphdW8ckM
         oYP2jk75opqQMrpVehZL7rRZE0crvegXv+zOMBOb2AovBeql08KFsXPl4//wv6YaKWKo
         Am7w==
X-Forwarded-Encrypted: i=1; AJvYcCUCSHYnkX79s9BvXw++wxqb0tKy6CCfcMH0wZQ3NuOEYMDPkPJcOD6ABS0QOpaKNe6mt8Y0qrIn7Wr3nQO0vaV4ATEyZybD+88jHrUy/z6RfbuO4rxoQ6zVCGq1FNVeRwk7twJBGIfbf2i9+ow7H+RwE8C37wK3grR93bkj6JwR6fufIdCWuQVvxGKn+Tv/IN8wW2LiRaec+vglqn7BMc/XeCk9si6oLKz6NJqPpZIwH3skz3Th24v7DZUmb3d6Zhs=
X-Gm-Message-State: AOJu0YzayE+S2ckuJp4M8iuop3YS9Pn0YtlekgSNGN27Fov+iZqSJxqH
	NEq+opqfzp70FO6oUk1gdHO3FIsJQ9e6V80gwSEUm8uwy0oD11rh
X-Google-Smtp-Source: AGHT+IEjLvbm8iyXDAcWu0p+GOnFTegqjLav9pOIelHGm3MRwqZb470HN3SqNz1iNHgjhG+UV5VyqQ==
X-Received: by 2002:a05:6a20:43a3:b0:1af:ab09:c555 with SMTP id adf61e73a8af0-1afde201c7emr21317705637.47.1715871017985;
        Thu, 16 May 2024 07:50:17 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0c138b79sm140026125ad.260.2024.05.16.07.50.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 May 2024 07:50:16 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <7df05966-36ea-4d37-99bc-1cf01b4ed921@roeck-us.net>
Date: Thu, 16 May 2024 07:50:13 -0700
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
 <08beb913-f525-49e2-8ef2-f62e9d466e53@roeck-us.net>
 <ff3277c1-f3ea-4e12-aeb6-548b97d42589@oracle.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <ff3277c1-f3ea-4e12-aeb6-548b97d42589@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/16/24 06:08, John Garry wrote:
> On 15/05/2024 17:52, Guenter Roeck wrote:
>> max_segment_size is 65280; PAGE_SIZE is 65536; BLK_MAX_SEGMENT_SIZE is 65536
>> WARNING: CPU: 0 PID: 12 at block/blk-settings.c:202 blk_validate_limits+0x2d4/0x364
>> ...
>>
>> This is with PPC_BOOK3S_64 which selects a default page size of 64k.
>> Looking at the old code, I think it did what you suggested above,
>>
>> void blk_queue_max_segment_size(struct request_queue *q, unsigned int max_size)
>> {
>>          if (max_size < PAGE_SIZE) {
>>                  max_size = PAGE_SIZE;
>>                  printk(KERN_INFO "%s: set to minimum %d\n",
>>                         __func__, max_size);
>>          }
>> ...
>>
>> but assuming that the driver requested a lower limit on purpose that
>> may not be the best solution.
> 
> Right, it is relied on that PAGE_SIZE can fit into a segment.
> 
>>
>> Never mind, though - I updated my test configuration to explicitly
>> configure the page size to 4k to work around the problem. With that,
>> please consider this report a note in case someone hits the problem
>> on a real system (and sorry for the noise).
> 
> Other controllers do have a 4K segment limit and are broken on systems with 16/64K PAGE_SIZE, like:
> 
> https://lore.kernel.org/linux-block/20230612203314.17820-1-bvanassche@acm.org/
> 

Understood, only it isn't just 4k segment limit with 16/64k page size, but more
generally any system with segment limit < PAGE_SIZE.

It is a bit sad that support for affected configurations is [now ?] broken
because above patch series was rejected (and, no, that has nothing to do
with me working for the same company as the submitter of that patch series -
that is me testing the upstream kernel with qemu).

Given that various controllers are affected by that problem, would it be
acceptable to submit patches such as the following to avoid runtime failures ?

diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index 817838e2f70e..6adf9105b5fb 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -1380,6 +1380,8 @@ static int __init pata_macio_init(void)
  {
         int rc;

+       BUILD_BUG_ON(MAX_DBDMA_SEG < PAGE_SIZE);
+
         if (!machine_is(powermac))
                 return -ENODEV;

or, alternatively,

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index b595494ab9b4..d7bd64702109 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -789,6 +789,7 @@ config PATA_JMICRON
  config PATA_MACIO
         tristate "Apple PowerMac/PowerBook internal 'MacIO' IDE"
         depends on PPC_PMAC
+       depends on PAGE_SIZE_LESS_THAN_64KB
         help
           Most IDE capable PowerMacs have IDE busses driven by a variant
            of this controller which is part of the Apple chipset used on

Thanks,
Guenter

