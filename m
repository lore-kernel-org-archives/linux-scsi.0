Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FAF1CAB7;
	Tue, 16 Jan 2024 17:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705426593; cv=none; b=eYdJ2vCPdAaHSMKHQVf49iZK2v7M7R4xpdm7y5sWIEAB7JUeL2gl8aXOjFJGFlkkat+vKsfMfhTmO5U1oTDQihpfQ/oLSswftATbV6lT5w6v0ez2CmBgxw317I+AnNPYaJHulrGry+fri6Rlu1TcUdhaRYEXA4mhagC+n5ZG9vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705426593; c=relaxed/simple;
	bh=uEpr9L+zeOD3NLk/ozrANzTT+091eMV/fTYTDUAZuYY=;
	h=Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding; b=PanOAic6oOTuO9hQdDwvcavKUznXZdVTCYKTvwxU1BB9pHI9EG/RDQXRlPcvXbxalnw8DxC5PAYX+wnm7u79nDxdnpW1Re3UWM+DcGFb1YA871TW+AftO22h/HrNcnHQIElC05aeYeZZOnFUC+b0akav/3DWvXho4jx2DWYbFJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5ceb3fe708eso3584354a12.3;
        Tue, 16 Jan 2024 09:36:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705426591; x=1706031391;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2N6XKQRaK9E3d/TrM1mDT4T5HbKqJaaszLV9COCar4M=;
        b=TnwrVmoYDuE3F8yQ9V72vgK7e9WvKtizdI/5HpW9OoVWvfp/7I+AmrRl2aAk7A/ahv
         Fov9m+HTdnYfQEN0ZNd11CWolSwh0kJfoO8aRouKqb0x6cuHk4WlP1Umc6UExCBfJ/wM
         WMuJvX1o0tc1uANv01Cyamtl5+mSpIRxc1CV0SISTMBhNMfROar6SxeUmPWfAsDDD/4G
         YS7ZVzkgkJi5HVuv6MVavwXqTAKZby02KjBJqhqe0mdBuPFPymzpjQ6SwPBYptXNadJg
         GidKsbK1lS7DwePctGiQBAGsiXwfoOzWNoc+9S7eV4NbWCLHoP/YWOZmhDyq7uHZi6um
         jEjA==
X-Gm-Message-State: AOJu0Yw2mx/4+IabAPv7id5ECm2Uv0L2yGbgwikrozrnYFvj+kpuuHtK
	XxJS+AiDCEeYoHY1s7TUOZk=
X-Google-Smtp-Source: AGHT+IG1feQcn99GIPMPS9kRfLs0UyfdEIFbUtAOzUVIE1Z/gasi868LANR26QRJIaEG4yCTY+Y2TA==
X-Received: by 2002:a17:90a:ac03:b0:28c:37:f394 with SMTP id o3-20020a17090aac0300b0028c0037f394mr3501240pjq.62.1705426590339;
        Tue, 16 Jan 2024 09:36:30 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:bf53:62d5:82c4:7343? ([2620:0:1000:8411:bf53:62d5:82c4:7343])
        by smtp.gmail.com with ESMTPSA id w5-20020a17090ad60500b0028ce12f8cdasm12181165pju.10.2024.01.16.09.36.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jan 2024 09:36:29 -0800 (PST)
Message-ID: <aedc82bc-ef10-4bc6-b76c-bf239f48450f@acm.org>
Date: Tue, 16 Jan 2024 09:36:27 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: Make fair tag sharing configurable
Content-Language: en-US
To: Yu Kuai <yukuai1@huaweicloud.com>, Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, Ming Lei <ming.lei@redhat.com>,
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
 <1d3866af-ffca-4f97-914d-8084aca901ab@acm.org>
 <69b17db7-e9c9-df09-1022-ff7a9e5e04dd@huaweicloud.com>
 <20240112043915.GA5664@lst.de>
 <2d83fcb3-06e6-4a7c-9bd7-b8018208b72f@huaweicloud.com>
 <20240115055940.GA745@lst.de>
 <0d23e3d3-1d7a-f76b-307b-7d74b3f91e05@huaweicloud.com>
 <f1cac818-8fc8-4f24-b445-d10aa99c04ba@acm.org>
 <e0305a2c-20c1-7e0f-d25d-003d7a72355f@huaweicloud.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e0305a2c-20c1-7e0f-d25d-003d7a72355f@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/16/24 02:24, Yu Kuai wrote:
> I'll provide null_blk tests result in the next version if anyone thinks
> the approch is acceptable:
> 
> 1) add a new field 'available_tags' and update it in slow path, hence
> fast path hctx_may_queue() won't be affected.
> 2) delay tag sharing untill failed to get driver tag;
> 3) add a timer per shared tags to balance shared tags;
  My concern is that the complexity of the algorithm introduced by that patch
series is significant. I prefer code that is easy to understand. This is why
I haven't started yet with a detailed review. If anyone else wants to review
that patch series that's fine with me.

Thanks,

Bart.
