Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1DF21A0A;
	Tue,  2 Apr 2024 06:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712040137; cv=none; b=AN/tKB5MV0Xu3MDYrUN9FFxUPM1Ds5bi4q3DyEQFneXBJp9T2VI4rGi/uxsLZz79prRHyDtJS+16PzP1S0eBQn14SusAumw2ZpB5otiLhE0qTkSks3t+qGLBZ4n1TFQ9KEBa/20vsWIrW5rS8m/8Bj2obPGBqencgYtVSX3MmuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712040137; c=relaxed/simple;
	bh=JjAntBOnD5xFGFnRblpAkq+2VumhA3Hem++jWk6Y4W8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=OjQ43iDkNikw2IBWiEq3gOmz0quouZs9NzHMpUDxKVN1YykU5KMSdfEEhFpEDXEKl+jyeLAuywHi9QT/u6YtuxDlsG8/v8kQgE+Hbs4ZSA3jsB8SchYmbivqJp7bRWghJP12Iz+ON8KR2wn4WaybBDDz8L1Zw/iR8ZShT6FtcPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e8SG8eiH; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e8SG8eiH"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3c4f55a1bd6so121126b6e.0;
        Mon, 01 Apr 2024 23:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712040135; x=1712644935; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uU48DJgFaHLx1/2t1/ZicKir2GW9GbUz5ocKNaf/XsY=;
        b=e8SG8eiH75xFw97HMQqlhXyt8LhRsy2fM8LrZlpIwM28mqdeV2kLIYy7SeyrM29Pp6
         wrQA8h5cogCN1W1ubeaZnOQcX9KUxoC6+tcSL5GBcq2E4U59WpyXu01CDbq1Sgj98FdD
         rFLLoJ7ayWMC93Wevz1cgI0pZbHNZO9NeQ9h/2+emsFPUU8snN3AS74JCwA5EGKH+i//
         mZUne/Yjhc1aSIjrc2s9ixeflaUGcfTrifPvU/zmF/8wHFmdi6FmzVYfeZ3ZCMvfDzML
         h8YK3udx4vj4+EZAQ9xnDGWDweOMpFpVMEeI2FggLV7oOmZf343jw4Utk+H8x9cWScrh
         bUFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712040135; x=1712644935;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uU48DJgFaHLx1/2t1/ZicKir2GW9GbUz5ocKNaf/XsY=;
        b=mAigbHLwTCLAC/etor7BOsHQMzbVJp4RZ3fNGBFnsSff8cw09WnavVG+qa929uuL+o
         TDOKjBsqZqFPXihNWcCiL+Jiw2mMFPu9zwElUPjtimNvzwIFAwi2r4vDu5Fgh4o4fPLK
         80CjK+0QJsEOARsmUlhvdab6YptLFEcBDE4oftAtGj9E2KDPty9WOgbGPjwccyJNwveg
         bSXmwK/fmMM/HfGJDUR49ZhTelsXTFRXoD774jTooSJ4i+Wz5EEyTXXYD+BQ4pYFZiK6
         JXwS2rtX9Dvdwpmk1C9DVOZBT+cP/nKdltVT5lIRji+II7XGHfsIRmPDSNonyLGwHchX
         R47w==
X-Forwarded-Encrypted: i=1; AJvYcCXxhtVqke1Flms5zyU2Wtpo5g2nhr4fSGAQwCTeRyGcKSvA2RaBg3dTSEUaqMYRPXMmWpoejXZDE39VFFjUGcn6h35Sa7Ly7m23wQ==
X-Gm-Message-State: AOJu0YwirphHbnkDsNdlxTMbptz53qI22/aeuvdRx/nFf8au5dZVhST6
	sKVyLVK4FilYAwUeQP37f6r0XOKj3wH74Eg3T/WlJ1bq1bmGmLdT
X-Google-Smtp-Source: AGHT+IFJBRPUzzyLOZ+Iz+JssAjGs8OrSAfHCaYLwSwDXfN3nVO69I7ZzxGjs/eatznGecPM52vC8Q==
X-Received: by 2002:a05:6808:19a1:b0:3c3:e621:4bd2 with SMTP id bj33-20020a05680819a100b003c3e6214bd2mr14487788oib.8.1712040135376;
        Mon, 01 Apr 2024 23:42:15 -0700 (PDT)
Received: from ?IPV6:2600:8802:3800:75a0:2378:fa3f:c6b3:24d1? ([2600:8802:3800:75a0:2378:fa3f:c6b3:24d1])
        by smtp.gmail.com with ESMTPSA id z9-20020a63e549000000b005cd8044c6fesm8907652pgj.23.2024.04.01.23.42.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 23:42:14 -0700 (PDT)
Message-ID: <f502ece5-4120-40dd-999f-2904ca5d0b38@gmail.com>
Date: Mon, 1 Apr 2024 23:42:13 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/30] null_blk: Introduce fua attribute
To: Damien Le Moal <dlemoal@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-20-dlemoal@kernel.org>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20240328004409.594888-20-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 17:43, Damien Le Moal wrote:
> Add the fua configfs attribute and module parameter to allow
> configuring if the device supports FUA or not. Using this attribute
> has an effect on the null_blk device only if memory backing is enabled
> together with a write cache (cache_size option).
> 
> This new attribute allows configuring a null_blk device with a write
> cache but without FUA support. This is convenient to test the block
> layer flush machinery.
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke<hare@suse.de>


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck



