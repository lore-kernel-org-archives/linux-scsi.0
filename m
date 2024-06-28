Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD671097B;
	Fri, 28 Jun 2024 01:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719539075; cv=none; b=N+bhNM69w3dX+IwLsqjk8KkaPCw9jfx5EBauiqwSZw++gnbEv3a/SAso1UB0TX8hx9ccf4ZmyFNl+2e35mrJMkrnHHCJWauWf5Nn31p0SKz2h5/UITuPIh7yVORFiX+E36XgVn9iVZlg2E59Ll5nSWLP85xk1SibdWKe8NWPEEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719539075; c=relaxed/simple;
	bh=2PfHdETu/HKLoYvqYe0CcjoLSuBc+PIHnlujDvorBO0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b9Ibx9s5CXfcVv9xtuzPT2OSUuu1x+wAUhnOa24Rzk/Od/UtO88eNdghuWVmS2qljpd7tKpdt8AlcnSGbACxSFHw9ShXoBxHxH0KeFRq/aFmj5uym+SjkVAXYjxkcoz2C0hIduB1QPmwtQ+IMNUMNBm5agJEeuMQq0yB+ubY4oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O/Sdalh6; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O/Sdalh6"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2c81ce83715so98156a91.3;
        Thu, 27 Jun 2024 18:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719539073; x=1720143873; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O2PlL+cNrtgBEK7e1pegCFhmRbl6FhS1f6s/BBzg990=;
        b=O/Sdalh6oaJtIsurgEA/n2GdDF4DAd6wOEPs+SZQMpuQYAgJlVts4vcE7zW052HLWE
         XDqu4S5JXMr6XRDf/CAHHeix3WC5ZiDJEdZe2jFJJWQDPRkeZNzGgn0Z5zBzITXg14Ii
         /pe2Pe3YgHlp76Gw8rZkwyu0nfRw/TWuHGGfdZISLbSHobC2VBRY/b6GD0s2CfZMYhcM
         jzMyeNsRNKVp+bWlgT21JGapgwK4RYMya0brhsrNMFij1KayRUj9VtiCCWORF5gj1k7c
         QHvnhm0Oohvb62yqtleskUe7tyeg0ySeYk/zU8fc2HxEBwvW+0WbiH7vUVwgKbpKTWQy
         Mrlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719539073; x=1720143873;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O2PlL+cNrtgBEK7e1pegCFhmRbl6FhS1f6s/BBzg990=;
        b=PzAQECwWsMmNfamSvc/QKSkS3Ev1jlgQbhhXCD5HRgfIubdcBqDnOZjhhIKBi3d6if
         JofyE6KyBrektCHc/L59FN4N04SAXvbMsmWwe8AcWiMgsK9UMeTxO0u2wM3Oaf9a0e2O
         orqvdajhIkNSXzv+2m2KRRfiPsaNXlIsDCavwlmf/7a6388ZdAMf1MZ1QdW34PxlRgmO
         0oYq3MnF/c41WyBYfh1dkGtRc4RDoMzK5R695DRDr/5Kj8nuH8Q4MHFjlXjTBxvjhLEH
         n+9evcU8KfIAse/mLAH4tCNCGVgnyf5RR3GerudRMCMeSEaabaPyKZotyAsxu1oLdMyQ
         f4dA==
X-Forwarded-Encrypted: i=1; AJvYcCXSxLqN9lUgSPCTjoVrPDZsF9QtZcqdv2AW1A6VxqlWmai9IorZHW+ZIEwafONl5Nn6rYFrBjTPDh3La8yr3UnWZ8nbDcEAfPHXBXGfUzgeSC5T4kU+EKxSnNu8k4u8TTvEGg==
X-Gm-Message-State: AOJu0YxEnlh2a/15h2o6ykFxZIIJQm+5SNWHcl8jNgNVjIOEgFXjYl7L
	VIhch5smDSPXVI688lhHHDfLP3xf74vgBHqqiAlOC/bs6M1bfeDN
X-Google-Smtp-Source: AGHT+IEtx/CFFSk+X0N5AWryCVBCAja3mFgba28EnBMHXYQs3DSPEosR+Gq2rOqRmv7IPhiaCA1Wcg==
X-Received: by 2002:a17:90b:4b92:b0:2c7:c788:d34d with SMTP id 98e67ed59e1d1-2c858275b3emr14169645a91.38.1719539072797;
        Thu, 27 Jun 2024 18:44:32 -0700 (PDT)
Received: from [0.0.0.0] (97.64.23.41.16clouds.com. [97.64.23.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c91d3bc5e7sm451019a91.36.2024.06.27.18.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jun 2024 18:44:32 -0700 (PDT)
Message-ID: <f4a0879d-0df7-44b0-8fa0-e2917532c1d4@gmail.com>
Date: Fri, 28 Jun 2024 09:44:25 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: fix ufshcd_abort_all racing issue
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>
Cc: "linux-mediatek@lists.infradead.org"
 <linux-mediatek@lists.infradead.org>,
 =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
 =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
 =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
 =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
 wsd_upstream <wsd_upstream@mediatek.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 =?UTF-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
 =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
 =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
 <Powen.Kao@mediatek.com>, =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
 <Naomi.Chu@mediatek.com>, =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
 <Qilin.Tan@mediatek.com>
References: <20240624121158.21354-1-peter.wang@mediatek.com>
 <eec48c95-aa1c-4f07-a1f3-fdc3e124f30e@acm.org>
 <4c4d10aae216e0b6925445b0317e55a3dd0ce629.camel@mediatek.com>
 <795a89bb-12eb-4ac8-93df-6ec5173fb679@acm.org>
 <0e1e0c0a4303f53a50a95aa0672311015ddeaee2.camel@mediatek.com>
 <58505ca5-5822-47f5-a77d-a517eda0c508@gmail.com>
 <147f56027997fc37c93d4a6c438da93898fd50f6.camel@mediatek.com>
Content-Language: en-US
From: Wenchao Hao <haowenchao22@gmail.com>
In-Reply-To: <147f56027997fc37c93d4a6c438da93898fd50f6.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2024/6/27 18:58, Peter Wang (王信友) wrote:
> On Thu, 2024-06-27 at 15:59 +0800, Wenchao Hao wrote:
>>
>> Hi Peter, 
>>
>> What is queue_num's offset of blk_mq_hw_ctx in your machine?
>>
>> gdb vmlinux
>>
>> (gdb) print /x (int)&((struct blk_mq_hw_ctx *)0)->queue_num
>> $5 = 0x164
>>
>> I read your descriptions and wondered a same race flow as you
>> described
>> following. But I found the offset mismatch, if the racing flow is
>> correct,
>> then the address accessed in blk_mq_unique_tag() should be 0x164, not
>> 0x194.
>> Maybe the offset is different between our machine?
>>
>> What's more, if the racing flow is correct, I did not get how your
>> changes
>> can address this racing flow.
>>
>>
> 
> Hi Wenchao Hao,
> 
> Yes, our queue_num's offset of blk_mq_hw_ctx is 0x194.
> Our kernel version is: Linux version 6.1.68
> I think the offset is different by kernel version.
> 
> (gdb) print /x (int)&((struct blk_mq_hw_ctx *)0)->queue_num
> $1 = 0x194
> 
> And yes, it only shorten the race window of step3 and step5.
> Reduce the probability of step 4 appearing between step 3 and step 5.
> 
> 

Hi Peter,

Thanks for your reply, I understand the issue now.

> Thanks.
> Peter

