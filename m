Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AFC56B73
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jan 2024 17:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6d98ce84e18so1814464b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jan 2024 09:48:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704736093; x=1705340893;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Je+N5/eI8rc/XVLEqXPJ+Ow6eFSB68e6E3iFhj+bXrw=;
        b=YFXfpENdRbKIOIEoA/yF3Ja3Sh0pa+riOOXXl8Mw2Kou56R3rZtFGEw8HWzMLnfMgX
         ibrAfkICGxH0MGGzzOhu9uq/TwnRetzB1Fql0OjyAWrit3Tkw+3Rr/l4pDGt/M4eQwsf
         RbAsUvknSFog1UkyrgE3XimB8V1uhWkQmiCFb/1jaTymXUvQGNYxolQCpyebVnVla7X6
         zfl2rBSrY/8RwpAeOcE0wUjpOeCwnj6UY+DFwuWCXOmESOJaIy6Q/FeGqnItmEEX4rYT
         xcxsISEPEI1Bb3N63ZRbaVrSpPiY4RL06sRKrJYxGYuWgR/gP6Mg5epZZRF5osiB7qU8
         8a8w==
X-Gm-Message-State: AOJu0Yz0s/cSRqfgYw7+G92Sr8idxBZP397h+dHGANl3av+mDzAK4Gy1
	f/9mWHBj7UwnACe7gHmKLY0=
X-Google-Smtp-Source: AGHT+IFDm7PMPqAIUPZymDnRMVyJQawE1u4SgYTlSngPdmXaBBIe+2c8B66La4dA+eZNVuyJquBznw==
X-Received: by 2002:a05:6a21:a581:b0:196:5a46:4963 with SMTP id gd1-20020a056a21a58100b001965a464963mr4427256pzc.99.1704736093067;
        Mon, 08 Jan 2024 09:48:13 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:cee:c48d:78d6:ed9a? ([2620:0:1000:8411:cee:c48d:78d6:ed9a])
        by smtp.gmail.com with ESMTPSA id l8-20020a056a00140800b006dacfab07b6sm140896pfu.121.2024.01.08.09.48.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jan 2024 09:48:12 -0800 (PST)
Message-ID: <f5dc9add-4995-4a55-ace0-b091569f0f76@acm.org>
Date: Mon, 8 Jan 2024 09:48:11 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 79/80] scsi: ufs: Declare SCSI host template const
Content-Language: en-US
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
 =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>
References: <20230322195515.1267197-1-bvanassche@acm.org>
 <20230322195515.1267197-80-bvanassche@acm.org>
 <543800c0b840ac1fd2943b1bc1fe909937be3e68.camel@mediatek.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <543800c0b840ac1fd2943b1bc1fe909937be3e68.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/4/24 01:52, Peter Wang (王信友) wrote:
> On Wed, 2023-03-22 at 12:55 -0700, Bart Van Assche wrote:
>> Make it explicit that the SCSI host template is not modified.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/ufs/core/ufshcd.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 8e7dfaadc691..35a3bd95c5e4 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -8751,7 +8751,7 @@ static struct ufs_hba_variant_params
>> ufs_hba_vps = {
>>   	.ondemand_data.downdifferential	= 5,
>>   };
>>   
>> -static struct scsi_host_template ufshcd_driver_template = {
>> +static const struct scsi_host_template ufshcd_driver_template = {
>>   	.module			= THIS_MODULE,
>>   	.name			= UFSHCD,
>>   	.proc_name		= UFSHCD,
> 
> Hi Bart,
> 
> This patch change scsi_host_templete to const.
> If mediatek host want to modify deault rpm_autosuspend_delay timer,
> could you have any suggestions?

Hi Peter,

Please add a new rpm_autosuspend_delay member to struct Scsi_Host and add code
in scsi_host_alloc() for copying that member from the host template into struct
Scsi_Host. An example is available in commit b125bb99559e.

Bart.
