Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A3017F504;
	Wed, 12 Jun 2024 15:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718205184; cv=none; b=TxLOCN862KLWr442vL5xdXUH0rdQ81Gdnw6wzTm/zhTIVcX3lWNHhPPwE8Jzl19C0p//PkAVSMIyKesLQGEdmB9LelOp+SGmOAu1a7DHCZmcAWkw9UOzHlHKC4oYiVt/LeMbht7EywgkDbJglK6NNgR9Q61Plv/4sRYW71MPyCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718205184; c=relaxed/simple;
	bh=CI3a4ZTH6QkNb6fo8QvVrdnNkzWsdTGrepojuhjTqcg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eGrV1p5+a8G/4QvejpAEHfmilOFurabcTFBNwIIpdkohy2gruf74kO8F2SIt+shoBnKS609A1Zc3ZoHX7qK01gIBi+qmOAisbE9rH1BA10V1UuzXuHjMu2bIqBhq3LBCn6WBxQBOSKN/v26kqsGnttl8B22atkg6TcoD3CaOavo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SdBt74Ka; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SdBt74Ka"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4415e623653so4632791cf.1;
        Wed, 12 Jun 2024 08:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718205182; x=1718809982; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XHQXmqxHeWpd8OXnf/8HM51by6gwtLJcxhrxbZ3GwFA=;
        b=SdBt74KapjbuSKBX7YwpNEAXKm3gUpfJFyGuE5v9YAEVrYDctykXGsBEXoZSuKgcYc
         M+ZGEzcxOFX5GQcmCWqKMSS1drco3GyphI5wYO+w8j/cMlwsIkj4jSTWxMeZdI5K1D8D
         87u/qjFCA/pbKAJznJe41F94OG+WuzWGoTOIH5sr9mJTsSL0n6q3zX9ByQZd/HYAXbXP
         UHK1sV8fKAU6I7YmBQe+btnLdKbBOHxBsnKoankODLMS48swxIfpQxI2NrZtKRmBv15p
         3WuKSZIRrdkfSpe6cbQVBezb/1pin57YvKnL+UdTXB1sQG1FJek7PPDoFxVu9tTRF+zu
         MLmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718205182; x=1718809982;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XHQXmqxHeWpd8OXnf/8HM51by6gwtLJcxhrxbZ3GwFA=;
        b=utFVhfPj+dXDfEJEYGVxNUmlzXUeR1I1wsL5GXATmhCQxKpWy55QmBufTK7c92+fLj
         4zeg7uwdL/U7Ao4XvIqJpl4E4KvIPlmfGpTuxd0M2Sgef9TgWvghyaEZzDytvyc/f1uQ
         dUUicufAqTUNNoAxk7hpCZtbvL4ujSAvhkEoZsmxshgHIiIzYMDdvitiRZPdKCL91mdy
         Ra8S5TV8V4M9+hoB9+Rl7pMcE0KM0oCry/rk4ZqFFrVsl09CziwjHfn1LyceM6z30Syk
         Ei0v0Mw0VKHfcdhseKmHN/dH7aaYtn4eV0wf+gG7QcXrbDl6SxQqGZbdmk393ZPx0UEX
         Zz3w==
X-Forwarded-Encrypted: i=1; AJvYcCVGEXCxiM1f++kTqWlWRd8rF2aOaPLVs+BuaA41V3/7qKADqXvCky2r/sdLx+clc7Jg/j5uprwCc48nQC6ooJTDZhYSynj/K8Pq1AZnBKe+QFO51HImfsaFXQgrxEb3t/iy/j8L5EmF7Q==
X-Gm-Message-State: AOJu0Yyk9t09yTdjXTQCQuWE13jPJ1hghtg8bWCMlQqteuSg9uhdq8zo
	9YyjDCNUMRYPLUJ0fVkefXN9E71xeANTePLA/2VxuINqLeZcbbFI
X-Google-Smtp-Source: AGHT+IHfUqkiFUdNB7o+p/EPi7/QHlTHXRBGuw+7U9oYj8NY19HT4c3Kg9utIq6uyPK27o/gfKaG5w==
X-Received: by 2002:a05:622a:148c:b0:43f:ee8c:b2e with SMTP id d75a77b69052e-44159b68890mr34943721cf.29.1718205181674;
        Wed, 12 Jun 2024 08:13:01 -0700 (PDT)
Received: from [0.0.0.0] (97.64.23.41.16clouds.com. [97.64.23.41])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4403895aa9asm56189961cf.7.2024.06.12.08.12.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 08:13:01 -0700 (PDT)
Message-ID: <68b4dbc5-18ee-4dc7-85da-dd420df9bf16@gmail.com>
Date: Wed, 12 Jun 2024 23:12:56 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/3] scsi: scsi_error: Fix wrong statistic when print
 error info
To: Hannes Reinecke <hare@suse.de>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240605091731.3111195-1-haowenchao22@gmail.com>
 <20240605091731.3111195-3-haowenchao22@gmail.com>
 <15f0fb9b-3b30-413d-9f30-81c246b6bae1@suse.de>
Content-Language: en-US
From: Wenchao Hao <haowenchao22@gmail.com>
In-Reply-To: <15f0fb9b-3b30-413d-9f30-81c246b6bae1@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 6/12/24 4:34 PM, Hannes Reinecke wrote:
> On 6/5/24 11:17, Wenchao Hao wrote:
>> shost_for_each_device() would skip devices which is in progress of
>> removing, so commands of these devices would be ignored in
>> scsi_eh_prt_fail_stats().
>>
>> Fix this issue by using shost_for_each_device_include_deleted()
>> to iterate devices in scsi_eh_prt_fail_stats().
>>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
>> ---
>>   drivers/scsi/scsi_error.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index 612489afe8d2..a61fd8af3b1f 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -409,7 +409,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
>>       int cmd_cancel = 0;
>>       int devices_failed = 0;
>>   -    shost_for_each_device(sdev, shost) {
>> +    shost_for_each_device_include_deleted(sdev, shost) {
>>           list_for_each_entry(scmd, work_q, eh_entry) {
>>               if (scmd->device == sdev) {
>>                   ++total_failures;
> 
> That is wrong. We should rather add a failure counter to the SCSI host, and have the scsi device increase it every time a failure occurs.
> Then we can avoid this loop completely.
> 

This function would print the total failure commands and the number of device like following:

scsi host4: Total of 3 commands on 2 devices require eh work

Just add a failure counter to the SCSI host can not record the number of devices.

> Cheers,
> 
> Hannes

