Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3A21847;
	Tue, 26 Dec 2023 02:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3bb7376957eso3259539b6e.1;
        Mon, 25 Dec 2023 18:22:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703557365; x=1704162165;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p0ye6VTF0bjOBBw4Oo5vJi04g00aoIv0iinplRLlxEY=;
        b=VhqVieZdY9WITAVpE3iNJRV5z0X4Powa9+xB/+9OA9QUKB+xTYFiVPuUnV4BPPzcZk
         SdCe2B7SamPL9IfOzkD7T25zglfNqdG801XdPZLahJrjfdl+HQY8EOTGzSrimmBzOA3t
         fd0v2KFBeuLyI5SG/IrCBuHc5WImkc8Wjo3KDvsf+7gADCgxwficf2y+qpPcEGZAAByg
         A9LrebqWJNlrjof+UA4FoptrtuZwgYOQAKsgVKBq9sJ/VaN1/0Rab16xHnkGz7qLduzv
         392R39kGK70CYL0a8/HgsVcJcPaiA3mHZKAP9ODsQq0H2kg5ytvVvpT2cJb4xZieA+/r
         IRgQ==
X-Gm-Message-State: AOJu0YyIqq/z/difUXEc8aUPR+PCQkQaWDc6Y6rmfv1CsIQEmmAqPSGw
	xXsnuefR3ChTYvT+nx4JDvc=
X-Google-Smtp-Source: AGHT+IGLP4ZGwUl5RZbmP0PftsjmntPMXXdWjtpN55kgwsW2mN2AemTL0C5F/x7k3R8jYsPQGOMVgQ==
X-Received: by 2002:a05:6808:1288:b0:3ba:9d:9b54 with SMTP id a8-20020a056808128800b003ba009d9b54mr8304818oiw.14.1703557364799;
        Mon, 25 Dec 2023 18:22:44 -0800 (PST)
Received: from ?IPV6:2601:647:4d7e:54f3:667:4981:ffa1:7be1? ([2601:647:4d7e:54f3:667:4981:ffa1:7be1])
        by smtp.gmail.com with ESMTPSA id u1-20020a056a00124100b006cecaff9e29sm8593323pfi.128.2023.12.25.18.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Dec 2023 18:22:44 -0800 (PST)
Message-ID: <42aab0dc-802d-4dd8-9733-20ca2c92ccca@acm.org>
Date: Mon, 25 Dec 2023 18:22:42 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: Make fair tag sharing configurable
Content-Language: en-US
To: Yu Kuai <yukuai1@huaweicloud.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
 Keith Busch <kbusch@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Ed Tsai <ed.tsai@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20231130193139.880955-1-bvanassche@acm.org>
 <20231130193139.880955-2-bvanassche@acm.org>
 <58f50403-fcc9-ec11-f52b-f11ced3d2652@huaweicloud.com>
 <8372f2d0-b695-4af4-90e6-e35b86e3b844@acm.org>
 <c1658336-f48e-5688-f0c2-f325fd5696c3@huaweicloud.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c1658336-f48e-5688-f0c2-f325fd5696c3@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/25/23 04:51, Yu Kuai wrote:
> Are you still intrested in this patchset? I really want this switch in
> our product as well.
> 
> If so, how do you think about following changes, a new field in
> blk_mq_tag_set will make synchronization much easier.

Hi Kuai,

Thanks for the reminder. I plan to continue working on this patch
series in January 2024 (after the merge window has closed).

I will take a closer look at the patch in your email.

Thanks,

Bart.

