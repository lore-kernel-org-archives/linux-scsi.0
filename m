Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4027172F;
	Thu, 27 Jun 2024 07:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719475154; cv=none; b=fHCeQN/KZUA/5ZDohLazkWS6VlyOFfCaByBlFiWJRWTKk/Itiw/Myr6C7hUn6J3/fTTTw1SqJry8zC9I/rbKd8Wxl0Bnb4TQ02IBXs3zRiPYM4c1MaI+je0IXfu0sCLi4uyIiuzR2rZ/uzw/q3urktoUBR3QfBQqxXvahV7p8IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719475154; c=relaxed/simple;
	bh=m7DIj1/q0ulE4iqYLAJ4TM5lyrbh/vIpzu9xdWgUNL4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mMPjoSzbR/rKvPEzywopA6lNJMJ47lz+Ek8BFVrrMnHs1tOcey4vZGX2+awEA6+6Y82qBPFq7PtMZDBBzAxdtE3lETXrB6l2FvE8f9w2gxQNTOnLbI4RyteLtTM7p/FnCUmcJ7pJNTCbk8zx5ktNyM2OpuWlgQ34CiGbuN+5Hgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TUpY3vTM; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TUpY3vTM"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1fa3bdd91c1so33315825ad.2;
        Thu, 27 Jun 2024 00:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719475153; x=1720079953; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oMPFt7qCcKlt4bBRLNTpr5RAJLhjvUZf1lQJM4mr6kc=;
        b=TUpY3vTMiy0uunQwnCqt+P8MWogO9ZvnTCOyFUtbcPtlbfrDNM6G6Mo6TT+R4uknHB
         zJnbUtNgGveGbGiYOLc18BZrKAJoUdDG/Waf3KTaY6pb13Nihec0XxmSFGX47w+ys/y1
         H/X3lWfQkmcqf8hh6WYhngBuXbU1l6kJ0+YnQkwE0Vq5t5C6HJiXQ33vyvLZei1DfW7e
         BL3dC+o3a7oRj1hR00lrXWaCgIjO96KanNFZNfrwOEAQYd0WZ+9SqWeQt9ZcvvDQzeq4
         p0uv431QYFhaPuQQbvW+REGJE7f6nNZlga5nV44ICMOltuMrprEX2ICsvPH/IFINGH32
         1p7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719475153; x=1720079953;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oMPFt7qCcKlt4bBRLNTpr5RAJLhjvUZf1lQJM4mr6kc=;
        b=eBntPjqBaZqpZ2Xh8lqrAo0935lBJ6Nwhr4P0fw7ampGaYI79tw/M7f4/eXpPgIa4Y
         TE46kZd/Uoi8Z+iTxqvi0G1DzMhsZkV2xEzqc7PO8nC/day+Wlh9zYYvtrh7SHtBS4pH
         vEAipZXBUDJ7FvIf9zPL4HEVmyukYybr1oSb5OGtYIXtzWKEKGQL2FHjfLY/NP0Efea8
         AdHCUT/dDtb5X1gzDZjNkQWMitffXeprDMVZroYRzepucMncvwO0z7Cm2iLyA7REFweJ
         3c/dAylsHYR3z8jhtQC7euVQM1vz5oyaNFi5RMXQQsye7KvaQGDbIJ7AC71sJVnlZA1R
         3Ujg==
X-Forwarded-Encrypted: i=1; AJvYcCXVXNOqUiIK2TL9TnCAOQffpSJTBcFMeEH9C2YnXqOlUHRCS4skraSAPvJRI7ruzGmi9TISlWUSXlF4f03Gc7DvnWt6NGhaKHP/9ns6412FIUEYCTpkjTVL7Cm7qODuAByzJw==
X-Gm-Message-State: AOJu0YxrglAM1oelLjnQCFFjexTkO59ow70CkY9moRQCQIK2jqLu3zV2
	BJxh1TFxnUfHTT2AgCGsnU2/RSVy2Gkc8dB8RKtd/sT5twD1SD6n
X-Google-Smtp-Source: AGHT+IGAVQN2fy7d8glYzpm7iBHWvHCXJiWGTnics/V2+00uZxGRrbWBL+pefWqwcgKthF3qW/xaSw==
X-Received: by 2002:a17:902:ea08:b0:1f9:e3e8:456f with SMTP id d9443c01a7336-1fa23ec2d5cmr150310595ad.15.1719475152792;
        Thu, 27 Jun 2024 00:59:12 -0700 (PDT)
Received: from [0.0.0.0] (97.64.23.41.16clouds.com. [97.64.23.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1faac998bb2sm7157915ad.196.2024.06.27.00.59.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jun 2024 00:59:12 -0700 (PDT)
Message-ID: <58505ca5-5822-47f5-a77d-a517eda0c508@gmail.com>
Date: Thu, 27 Jun 2024 15:59:00 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: fix ufshcd_abort_all racing issue
Content-Language: en-US
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>
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
From: Wenchao Hao <haowenchao22@gmail.com>
In-Reply-To: <0e1e0c0a4303f53a50a95aa0672311015ddeaee2.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2024/6/26 11:56, Peter Wang (王信友) wrote:
> On Tue, 2024-06-25 at 09:42 -0700, Bart Van Assche wrote:
>>
>>
>> Please include a full root cause analysis when reposting fixes for
>> the
>> reported crashes. It is not clear to me how it is possible that an
>> invalid pointer is passed to blk_mq_unique_tag() (0x194). As I
>> mentioned
>> in my previous email, freeing a request does not modify the request
>> pointer and does not modify the SCSI command pointer either. As one
>> can
>> derive from the blk_mq_alloc_rqs() call stack, memory for struct
>> request
>> and struct scsi_cmnd is allocated at request queue allocation time
>> and
>> is not freed until the request queue is freed. Hence, for a given
>> tag,
>> neither the request pointer nor the SCSI command pointer changes as
>> long
>> as a request queue exists. Hence my request for an explanation how it
>> is
>> possible that an invalid pointer was passed to blk_mq_unique_tag().
>>
>> Thanks,
>>
>> Bart.
>>
> 
> Hi Bart,
> 
> Sorry I have not explain root-cause clearly.
> I will add more clear root-cause analyze next version.
> 
> And it is not an invalid pointer is passed to blk_mq_unique_tag(),
> I means blk_mq_unique_tag function try access null pointer.
> It is differnt and cause misunderstanding.
> 
> The null pinter blk_mq_unique_tag try access is:
> rq->mq_hctx(NULL)->queue_num.
> 

Hi Peter, 

What is queue_num's offset of blk_mq_hw_ctx in your machine?

gdb vmlinux

(gdb) print /x (int)&((struct blk_mq_hw_ctx *)0)->queue_num
$5 = 0x164

I read your descriptions and wondered a same race flow as you described
following. But I found the offset mismatch, if the racing flow is correct,
then the address accessed in blk_mq_unique_tag() should be 0x164, not 0x194.
Maybe the offset is different between our machine?

What's more, if the racing flow is correct, I did not get how your changes
can address this racing flow.

> The racing flow is:
> 
> Thread A
> ufshcd_err_handler					step 1
> 	ufshcd_cmd_inflight(true)			step 3
> 	ufshcd_mcq_req_to_hwq
> 		blk_mq_unique_tag
> 			rq->mq_hctx->queue_num		step 5
> 
> Thread B				
> ufs_mtk_mcq_intr(cq complete ISR)			step 2
> 	scsi_done						
> 		...
> 		__blk_mq_free_request
> 			rq->mq_hctx = NULL;		step 4
> 
> Thanks.
> Peter
> 
> 
> 
> 

