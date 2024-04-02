Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1752BB1F;
	Tue,  2 Apr 2024 06:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712040312; cv=none; b=R9RBOElhzR0nnvdCgNH+09jyxgn/kba+o7u0WBhWrFLWIIaRQBvKq8LoG/yzvFykfmmNa6Y5JeHdXcoUNY+53fcde4Q3W8KWoS+aMYQUCDRWJA6Fd1H6VDz3xRPv7FS3sZ9A87DpFDuqIL4mlif20dks+FIze4v1SZIAHYu7LH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712040312; c=relaxed/simple;
	bh=CoUgfvaStGsWej3hJDcJqjGMPB4tYC8LiYuom04jWD4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XyzBa6jMq9Iq/fW9zjA/FV9G/N0IfW5h569zfI8IOsAv1CfUk9xAkY7+wTb0usDNxViKUr1qx91/yhsyItzduTemkasDZZ+t+tgmDrxbwl866q/6xQnduwCQQKZGmgRswEAZI2aIuI3SrY7IMbDf5TTmurm7iL+/R6p+22MIHAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NFwSTWQw; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NFwSTWQw"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2a24f4757b1so508499a91.0;
        Mon, 01 Apr 2024 23:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712040310; x=1712645110; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sm53Z3L17Zu+ow15vuobEJghvq7U3t4LFtEUPD1JM3w=;
        b=NFwSTWQwHZ0ZJXHr6TpBdm12FVyu94FOnZ2TCLECUpqqDU5zjMczyAuhp2CEdn6Qyu
         Y0uxU32byfaw/sBvYPFnYRok3uRaYC9AfcNqlJWK9qTm8VAjauxYzNx5xD5nVR4U2mnV
         Xjhj6fMB3j7VN6tbQPKo00oQdgL6rOy5SjSdJfm8ju9mK/TgX5QamjM1HJBKWO5QwcOr
         lX50RHgqSX4b/sjXvB9Mvb9w9iP8B9P8WIFVhPR/bzXWmmQs3rlg0DALFJPOsbfALd6k
         JKxhz664fo8yU56AT8lVLUl8KqjWBtgQNkfhV3/MYrpvvrDxtVwIwaLlbvHP68yhKCUk
         YRPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712040310; x=1712645110;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sm53Z3L17Zu+ow15vuobEJghvq7U3t4LFtEUPD1JM3w=;
        b=HKPkZz4wsfj7fT81gG1WadrCqBI/QVqFfTqpddulWcAKHo8Bs5FBCem6ENLBurnZ4X
         B98dwUBKSJjbWfV+OJEnTH09KSMMGTcOvlVPSbjtRVaFudA0pd1dMfRBLi2l8HSQQhaU
         3Fdy5FsglBCM6cB0JK9wcnnbuga70Lq2QbE7mEJNrvxF1DOHTBfUwOiU+5uoFwdN75Mp
         HXRuww0u9J1M/GtHVF58jO3uox8UhFi5rY3Na/Ur1zaPiRceXlu4B0iMzA+vzEPvnvN2
         I7qSCrDc9hjtXsRi2t0RtfPrgI4ZS0PP4nUHkHjD+vBZu1n1FIYlh/L2x/F+zXJUMIQF
         nYBw==
X-Forwarded-Encrypted: i=1; AJvYcCUzYOEOm+9jQnVuqok4j32UkTF24nusE8nyPRMYsDwPvzKcpxF6edXVKxA/lLlsCbiLvrrxaUdSalgW3dhL6Xne+fKRwN1DPeQ8/58tcFDB6b2BL9fyDZO8DXWnIf8swiLu4FUPJryO
X-Gm-Message-State: AOJu0YzKq4LQQ2QWZ534XF2vG76g5ustUu3Zy11JE9ScRLOM3vleNxM6
	GH9Y1nvWdOUV6Q+VY4siTKV6w0gJQN7rdmISMt7+A89v8vITAMaa
X-Google-Smtp-Source: AGHT+IFF93BCBK3FIDpFKuTXhn9tbpLReSTK3uggz3k0H38wO0A6ivGxtP9jVEkKk5ulOQtfh0hUQg==
X-Received: by 2002:a17:90b:4c4c:b0:2a2:6d6e:1057 with SMTP id np12-20020a17090b4c4c00b002a26d6e1057mr24949pjb.7.1712040310359;
        Mon, 01 Apr 2024 23:45:10 -0700 (PDT)
Received: from ?IPV6:2600:8802:3800:75a0:2378:fa3f:c6b3:24d1? ([2600:8802:3800:75a0:2378:fa3f:c6b3:24d1])
        by smtp.gmail.com with ESMTPSA id l20-20020a17090a409400b0029b2e5bc1b9sm10925785pjg.23.2024.04.01.23.45.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 23:45:10 -0700 (PDT)
Message-ID: <3e159b10-170b-4c67-80ca-b833b712d91e@gmail.com>
Date: Mon, 1 Apr 2024 23:45:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 20/30] nvmet: zns: Do not reference the gendisk
 conv_zones_bitmap
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-21-dlemoal@kernel.org>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20240328004409.594888-21-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 17:43, Damien Le Moal wrote:
> The gendisk conventional zone bitmap is going away. So to check for the
> presence of conventional zones on a zoned target device, always use
> report zones.
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke<hare@suse.de>
> Reviewed-by: Christoph Hellwig<hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


