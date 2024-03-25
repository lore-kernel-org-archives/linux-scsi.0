Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7436A76049;
	Mon, 25 Mar 2024 22:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404817; cv=none; b=Pe7hiC9+TP1LnVjV9evkWq1t8QHhXSJZq6EXVckXwpEEdB2S0XldzoPzEMxPbED7UY7SiQIvxADit2palZSxfZAfdT/kLgzQ50h4azI5M9FR+u1p+T20wXJAgJtVGkU7F5q1/GxhOXiLCd6tshAk9SacexLJ/XibRLRPcFw8C1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404817; c=relaxed/simple;
	bh=/aQ4e/dbCdS2itYvqCPdo8g2LXYfZKkrZB47BoXZEIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BVWrvAX9d6fGDRWNyp3Tqpxe1V28J0Dz2hj7K85sFoMSYHA9aAG8QPCK7AB2PmkRqWdmAPDDdyBjiSVJyxzOJ7XOFnOe6/43o/hc0YC3019KIhfi3NJo2vrt+LBhNVkM95+rBsfYvfaCSaJM2PU5akc0fnoE/6EFLvJoLlnvjwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1dfff641d10so33199075ad.2;
        Mon, 25 Mar 2024 15:13:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711404815; x=1712009615;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/aQ4e/dbCdS2itYvqCPdo8g2LXYfZKkrZB47BoXZEIg=;
        b=AaZU0bb8r2Z1qf9JawTq3jTgbvgna/sjm4Njr+h/9fzBz62Cb6HrAyfdfYYXc0Z7mI
         254eIX2TjwF3/Br3E2Ilhq88jS8FMHxqdrtDlxe2wd+KFO/AUEpzPpVAhBpV4QYoFx4y
         RnZ9CdPqYS10dTemKZGYArPRGiMjrYhv8Xr/y1B7orOtw2kJHlZGtK8fNa+VDfiJpyoc
         7QVsi4/Fj4U2yW0DDPVdf22+nZsF9vZmSC6HaVFAbCQn5oEXRZKERIS4pYsql1n5hqN4
         O0qSwultMSpkylKiJZQxVMbBGW9asw1BSJ6y+GLiva0xZ2vwfSG+S7oD0QU7EQLAuEv2
         mH3A==
X-Forwarded-Encrypted: i=1; AJvYcCW/M/PHx5ZW93BPBiM3h05B7cbaf6PSE8qtaTvQXGbuHUZ2h8nkr4qhxJvCqrMwOYc29QEfkZCzCpTWpF8nkcVEMJTbs9bDdsux8QB1y2Og0kNXu4KUWopmdnN8dhQuFjYtWnyfudDyas0cyR1pZPPQqiIY0XbZj1PKhORLpG3ApHE+k00b2VW8SFJFTg9V0cdkiViB/Fswnjifnj5qxoUuRUCLjcrraDpWBJyTvBjmGlcmc7hO3m/chfzNl4ofSGc=
X-Gm-Message-State: AOJu0YwZc2KHjJW2A5tWFs9B3FC6Waxf8iS1CZzg98a60W3Q7HQo80hW
	wg7ME2WfJ9n7hvAh6zcYGbxehvyt5e/whtqmblw13m3KEawD3JZ7
X-Google-Smtp-Source: AGHT+IGfB+WQv3DsfWzHC6sXgKWc3iOzsu5rHx4jJULxZaWi0a0lVRdY99x8OK5M+q8sweYiGRV5UA==
X-Received: by 2002:a17:902:d650:b0:1e0:d579:91df with SMTP id y16-20020a170902d65000b001e0d57991dfmr956391plh.68.1711404815577;
        Mon, 25 Mar 2024 15:13:35 -0700 (PDT)
Received: from ?IPV6:2620:0:1000:8411:262:e41e:a4dd:81c6? ([2620:0:1000:8411:262:e41e:a4dd:81c6])
        by smtp.gmail.com with ESMTPSA id s19-20020a170902989300b001dd67c8e108sm5195084plp.199.2024.03.25.15.13.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 15:13:35 -0700 (PDT)
Message-ID: <a81db761-7ed2-4e4b-834f-7641f6199fcc@acm.org>
Date: Mon, 25 Mar 2024 15:13:31 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/23] ufs-exynos: move setting the the dma alignment to
 the init method
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
 <20240324235448.2039074-9-hch@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240324235448.2039074-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 16:54, Christoph Hellwig wrote:
> Use the SCSI host's dma_alignment field and set it in ->init and remove
> the now unused config_scsi_dev method.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
