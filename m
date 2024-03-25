Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6C97350C;
	Mon, 25 Mar 2024 22:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404813; cv=none; b=BMaD4tZCFtSySwV3DQw7JPCZeV+szYFezoFJP5e6+NZ/JokslO/mCqmSqp9dO5Jz++35JitOZ7nQcakAjdWdPYwo/7RpAOHX4pIxA46bqOd41GWOSfUc3HtcODVSfCfRpXyv6dPNR3NTjNo/MhASR/98P2LdzgBk6O5AI9DIyFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404813; c=relaxed/simple;
	bh=yq4DZOZpV+tgfo1VME0SGUbSt682+RvFZTbCx2WgCR4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W6sO0IFX7r3LXImhNOx/oxny3yI992RcNolC418L4bopU79/BJyOaLSKjgGpubNHR1VDw5NiJBnYYSIX/BZkhuuL8jLaDzjdD/0GhS8+NjHEjswSsXi8JL6ohwoNNbay1jGQsw27h6UNX3EmFFgK3guJ5NYnNryLxu5Yv83wkII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1e0d6356ce9so7001755ad.3;
        Mon, 25 Mar 2024 15:13:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711404811; x=1712009611;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yq4DZOZpV+tgfo1VME0SGUbSt682+RvFZTbCx2WgCR4=;
        b=bQH34Brtu8RGua08PrUxEMuYd1Vj4SXkEm2/PHgWG3yFJHfUj7hzTrDNCe9i44s2Dj
         n2rnDnJiTqN1k9RBKNDicalabbZN8F+OqRo3i+TY9oALj+ua6a5thHM4nosaoj4l8RJG
         P5V9Ji154SECUjKf1d0D8jsgM9tQf0w2ommhyW1A7bb9DrzB0nQNP0TBLFsgxtvdS7Sc
         hs4bEFzZWJOh+DfYlPUTfQSMNUrq0fWsOT6zJumBF6fqxnONpIvxtxwh1Cb7Gz2bu8WD
         np8R0Poy7h4bdI5nYb7KA7WGiTGQoXo674iqQU+lDOabcPZTG24ZXFiq008dB/vjdhWR
         ZkVA==
X-Forwarded-Encrypted: i=1; AJvYcCWMwRT0PlImX3H3bdaqpIsp8G+FYyf1WniCM3oWKRQDFhQNbp2D6IPQk+PBgODx+FLcyrPn8IYC30uCL+dERzZx+X9Ol/fnCZxuILbGjLKWuJY5ywjMUY6uKGaU6M/Wf6MDtTO7a+yoxk0vDpQi/dDD1xf3Btvw4WdWJEsrkg+5jET2qwkheZPvdZbqT/ely69jjWRYyuNgaO2VSMYnuN0Ryd+ggq77ymnyFOgVig+JkcTBEDZlYWFombO/cDe8jv8=
X-Gm-Message-State: AOJu0YxXHeuaHEB4gwwYvVctx/W1nyc+/+1y9EqWkQ5y8du+j175poWz
	cBpBhGRLcVkRYcdIgPan0cV/7+gC/2TOnfk32C72IXfQ4bMU49WJ
X-Google-Smtp-Source: AGHT+IFaHJC+gMGwZBDS54U2xblKvH/ZQv/lUiX2ff21oMRk0HlwTXFQX07O58x1/aW2WPYfkb1oYQ==
X-Received: by 2002:a17:902:784e:b0:1df:fda8:e0ea with SMTP id e14-20020a170902784e00b001dffda8e0eamr7291037pln.28.1711404810841;
        Mon, 25 Mar 2024 15:13:30 -0700 (PDT)
Received: from ?IPV6:2620:0:1000:8411:262:e41e:a4dd:81c6? ([2620:0:1000:8411:262:e41e:a4dd:81c6])
        by smtp.gmail.com with ESMTPSA id s19-20020a170902989300b001dd67c8e108sm5195084plp.199.2024.03.25.15.13.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 15:13:29 -0700 (PDT)
Message-ID: <bb3b5924-d266-49f5-944f-5e7ee3d3b5b7@acm.org>
Date: Mon, 25 Mar 2024 15:13:26 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/23] scsi: use the atomic queue limits API in
 scsi_add_lun
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 Takashi Sakamoto <o-takashi@sakamocchi.jp>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 "Juergen E. Fischer" <fischer@norbit.de>,
 Xiang Chen <chenxiang66@hisilicon.com>,
 HighPoint Linux Team <linux@highpoint-tech.com>,
 Tyrel Datwyler <tyreld@linux.ibm.com>, Brian King <brking@us.ibm.com>,
 Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
 Mike Christie <michael.christie@oracle.com>,
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Jack Wang <jinpu.wang@cloud.ionos.com>, Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com,
 mpi3mr-linuxdrv.pdl@broadcom.com, linux-samsung-soc@vger.kernel.org,
 linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20240324235448.2039074-1-hch@lst.de>
 <20240324235448.2039074-10-hch@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240324235448.2039074-10-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 16:54, Christoph Hellwig wrote:
> Switch scsi_add_lun to use the atomic queue limits API to update the
> max_hw_sectors for devices with quirks.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
