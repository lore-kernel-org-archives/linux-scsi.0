Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084D439AE0;
	Wed, 31 Jan 2024 23:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706744469; cv=none; b=WXj4HuBK1fHwOnWiloDal7PIcaHyDqj/9ZnKr17QkevjhwuJt3NLTin2tg8Lvwhhj8I79CuOR7DdHYQi2j16rUL4VpsAkDFRfnB0NOKr7YJMdX1kov5ktaQ3JnLXv1+G34CK6hjmC37YV7OjtR2uEGcr8LM3/NHynrdBAqy9mGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706744469; c=relaxed/simple;
	bh=IZ55fSnJ+vlNk8FDctWI93sOwiRzA2Mw7oNSvyxfa/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gsHn9FPeoCwXeiVV7oQ+mgBrrDarGGUAJqm+XKCIDysQwe19D/da5Wc3QDavhGSIwRnHmeXV4ADcUZVe8DFlG1TdLqMh/bk4HwXWj08+fd8z9FRuklyfiUKYcgWkTFmyakT9Qn1ATs39W08G8U05Mw139JqMKMv5I7qWt3IdbiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1d94323d547so2554785ad.3;
        Wed, 31 Jan 2024 15:41:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706744466; x=1707349266;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=apK9HBfKddiGQnpCRxNfyTiq+bsIH6evBuVrHDJj0e0=;
        b=fzyysrXyyjwXKxJnJKCKDKupk8aytvNkO1nAasCw+jp+Cl3HvCdAqLv+uToOODEzwB
         FegTl7x6nMyHMiNKpkhVHScuTZ70IITx9nDui8siLnfcaOEzFBO0RjFk+BaUYvFVF+k2
         t63bOcTxX+h9qV0hdzNRYuBMLAtiQCqCYZaMfg7Tm6uDjepzmCygkH55Ae6B/pOpKzK7
         fyrJJ304UKJqqojvUDku9r2rTPTug3bsGMKeX062zCXmqHAWV4LxkngVe9nk909BhmvX
         1zncTN5Sd4vQapYciIl/Cd3R8mLwXnYfLVljm/R8Gc40MeSUW3nEq6a5TFMPOyWXpsP7
         DSIw==
X-Gm-Message-State: AOJu0YxgRrcd3rTJjJXTtTxVxWBPnJaKmsYp5BgAKYWSpzY9u5/mu0oD
	E+QXI87yZIYDDlf2VFOGq8cNqCIRDh3Oz2fEdlTSyXu6TOVajclb
X-Google-Smtp-Source: AGHT+IGsXxK94iPjkmrBlRf1RwqqMGa5mjn/yWUwzWiGBvjTfyPoe25oYhIRE9Lk6EMVB3JSMVQTyA==
X-Received: by 2002:a17:903:4286:b0:1d7:15ea:4249 with SMTP id ju6-20020a170903428600b001d715ea4249mr2902552plb.7.1706744466143;
        Wed, 31 Jan 2024 15:41:06 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWSevCHtdruHWiy3ishKrhP3WZJo11VPVH7ldSppHvUCvvXGyD+77pRc+HVJEL8mNGo5PFE2mkbwq+UZRIcLfMaFz+PwvtIFH3ph4SsLkgiIA/cItai9KIIyTUUY+ZvnDGxEJQMUisTwiJzO4y4MP0DtBzVUug5Gs8W0QX1Pg6fsGl4ad1XmM2NdbqJg2giKsZHSmJqcGYG/zynLhENJY1WNhDoM/meV1TGHmDOqJy5r4pBFcDt1WyMCxVQGBpf4FN91Hd5Q2YI0BLEoRKsLmkrfRRcL8+jyEJyW4t0k2x4ZvqkaZ6EkYLkZ+BL5YCDW8tia9YGZTbRya++Zz94Yp8lM1o4vKP/DXp4YHqQ0CryP327f1S/4wmbzuIcC1e6mKGnCdAvQ6yClmmHFHfDfgDX7+gDQuS3MmDqrAhg1o9RB6i2CaxPKz7Wml9uO6HZ7g==
Received: from ?IPV6:2601:647:4d7e:54f3:667:4981:ffa1:7be1? ([2601:647:4d7e:54f3:667:4981:ffa1:7be1])
        by smtp.gmail.com with ESMTPSA id kp8-20020a170903280800b001d94e6a7685sm52663plb.234.2024.01.31.15.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jan 2024 15:41:05 -0800 (PST)
Message-ID: <2fec1355-6570-43bd-ae9e-8e3dfcb6807a@acm.org>
Date: Wed, 31 Jan 2024 15:41:03 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: Make fair tag sharing configurable
Content-Language: en-US
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>,
 Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, Ming Lei <ming.lei@redhat.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Ed Tsai <ed.tsai@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240118073151.GA21386@lst.de>
 <434b771a-7873-4c53-9faa-c5dbc4296495@acm.org>
 <20240123091316.GA32130@lst.de>
 <ac240189-d889-448b-b5f7-7d5a13d4316d@acm.org>
 <20240124090843.GA28180@lst.de>
 <38676388-4c32-414c-a468-5f82a2e9dda4@acm.org>
 <20240131062254.GA16102@lst.de>
 <d7c1f279-464d-4ecd-8e65-87d2ced984dc@acm.org>
 <Zbq9kVEZZBD4m4ZY@kbusch-mbp.dhcp.thefacebook.com>
 <c2469774-8ebb-4faf-af3b-c9426b8591d4@acm.org>
 <ZbrR7-DcBSS7V9B7@kbusch-mbp.dhcp.thefacebook.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZbrR7-DcBSS7V9B7@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/31/24 15:04, Keith Busch wrote:
> I didn't have anything in mind; just that protocols don't require all
> commands be fast.

The default block layer timeout is 30 seconds because typical storage 
commands complete in much less than 30 seconds.

> NVMe has wait event commands that might not ever complete.

Are you perhaps referring to the NVMe Asynchronous Event Request
command? That command doesn't count because the command ID for that
command comes from another set than I/O commands. From the NVMe
driver:

static inline bool nvme_is_aen_req(u16 qid, __u16 command_id)
{
	return !qid &&
		nvme_tag_from_cid(command_id) >= NVME_AQ_BLK_MQ_DEPTH;
}

> A copy command requesting multiple terabyes won't be quick for even the
> fastest hardware (not "hours", but not fast).

Is there any setup in which such large commands are submitted? Write
commands that last long may negatively affect read latency. This is a
good reason not to make the max_sectors value too large.

> If hardware stops responding, the tags are locked up for as long as it
> takes recovery escalation to reclaim them. For nvme, error recovery
> could take over a minute by default.

If hardware stops responding, who cares about fairness of tag allocation 
since this means that request processing halts for all queues associated
with the controller that locked up?

Bart.
