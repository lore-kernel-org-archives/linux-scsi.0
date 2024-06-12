Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D479517F51B;
	Wed, 12 Jun 2024 15:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718204800; cv=none; b=EeVLF5w8foCpcIhaBnxQLKeEtzb0xZEYPpdWvCUZ27xoAeC1WdTJp4KJCdDmzZ6Zs5dhvH6o6eAZvEo5atfp7zxyn2VeQ7R4FBnSo0QAHWT9qTr2Pd5MRGRFc/CLKbJk2YxLyCv0R5YNh2/OCETPkCuh29XSbgli2kPgZjQCyaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718204800; c=relaxed/simple;
	bh=jkHUOy0jhF9iKQSn4Uu62FIZLVbp/zdIJ0bTg4ydZI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XtzYap5LfWCL/ZElU5K8vEGVCQO0DcnqHr31k7aHL5Tm29OpG3P/8dv4AWOj06cGXRy+VxC7M3ojy8jZUsjZ35ydk3692dgVz7l2fC8kmzH+pPPaX+WifI5QU3/AjjGkVrWONik/0qBxLyzI7uRTM+zcL9HmhLi7xSzLU8kkDaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tlh23BqB; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tlh23BqB"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6b06f1f9a06so21795706d6.3;
        Wed, 12 Jun 2024 08:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718204798; x=1718809598; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IQClpDxm/c7cuKd+IuHQ1WVx4rLH2zJT3N3b7A20RT8=;
        b=Tlh23BqBfvKXkka3mn9cXfjRK4+4dvGXtVCWqREIzt00mjD6BeGwhKGQa2Z9SmhwZS
         fCKurSu0O2SiBPYDfnXlDyHnrE8Gx4orMsXmlV9oYF72XMESqm2f+WCNt9IxqSc/PSqP
         z49htqAISAUYzbLBCVSgt4XOvWN/lXLuyRqh7IfmNf2R+6t0iMwuHPYiELS6fEAZ0dG0
         vBl7lEqzpzNmCQvq7cSi+izW2e8brKu94n+3w3ET3WJF7v+E0Nqq2xEfw76fR0OKuM4k
         pS7CUTMD2uIPffbkewzCfu6fEVMRKW0t93NL6TREGo0rvVsZaowK+W+gNtz/rKaQqUJe
         xrBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718204798; x=1718809598;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IQClpDxm/c7cuKd+IuHQ1WVx4rLH2zJT3N3b7A20RT8=;
        b=DRuJRbM83+JyoHV97dXl6IUALnYXKdyYJK/oTlVb1xZ/8xCutNTp3e/ff3TqOGl0co
         uWNfLIKCv3HJFNM6pjDeHC30gLPRjvirYE0gQukQ9f7JRxfHA9EQKE8eo9pb1+FM94vv
         xucL8NLmKftIlOrlK+9dbZn+iXkAeQxc8cZGWigfJoOBVn7m4SKrF1doXv1t5/NLnpTi
         9ykvsnVghRUsmcoRHFb2QOdRhXrgd7f4MKSSM5n9Pap7+iDGeOjmLUPs3MKLZZ3HRBey
         U9X8cCrl+6OTSQLnswu334bL9pk5Crwz5yETcjN9Fq7aIEx5+LLMJ0gOUyQUPXpA2PoT
         mKCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCN+RO69bm0ObvycqGNiOxWg2JOjPUruU4P8gn+zXj0Ohpx5pjIXuBt/e/lPlkYMDnkUk/F875r3pB9yb9vjLBxOPugHR68x5Sv0Vqs/r5EEZQOK+DG94kZ3zQYkdt/zfml0YYqp7EqA==
X-Gm-Message-State: AOJu0YyyMaZi/LjI6sTHytam6kwX7Y1WBvhtn+MIDL45Pshy3fz293fh
	5v+u2pAw0KMGzrnyQzsZ/CzfUwl8wDEOj+VVUFsBZkx76qToaoSO
X-Google-Smtp-Source: AGHT+IFjYJkX8ZZHw1/ZCg2gb95t4DY57/UyebplIiKq8PMX9OttGHR5BfwZajl9emSP2lz80cZNHg==
X-Received: by 2002:a05:6214:5b0c:b0:6b0:646d:5d65 with SMTP id 6a1803df08f44-6b1a7fb1120mr20033826d6.51.1718204797450;
        Wed, 12 Jun 2024 08:06:37 -0700 (PDT)
Received: from [0.0.0.0] (97.64.23.41.16clouds.com. [97.64.23.41])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4415a043804sm6403331cf.35.2024.06.12.08.06.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 08:06:37 -0700 (PDT)
Message-ID: <c1ecd21b-7b97-4ef6-94a1-86b2cf520a67@gmail.com>
Date: Wed, 12 Jun 2024 23:06:31 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] scsi: core: Add new helper to iterate all devices
 of host
To: Hannes Reinecke <hare@suse.de>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240605091731.3111195-1-haowenchao22@gmail.com>
 <20240605091731.3111195-2-haowenchao22@gmail.com>
 <3b24ef4a-996b-4a8b-89f3-385872573039@suse.de>
Content-Language: en-US
From: Wenchao Hao <haowenchao22@gmail.com>
In-Reply-To: <3b24ef4a-996b-4a8b-89f3-385872573039@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 6/12/24 4:33 PM, Hannes Reinecke wrote:
> On 6/5/24 11:17, Wenchao Hao wrote:
>> shost_for_each_device() would skip devices which is in SDEV_CANCEL or
>> SDEV_DEL state, for some scenarios, we donot want to skip these devices,
>> so add a new macro shost_for_each_device_include_deleted() to handle it.
>>
>> Following changes are introduced:
>>
>> 1. Rework scsi_device_get(), add new helper __scsi_device_get() which
>>     determine if skip deleted scsi_device by parameter "skip_deleted".
>> 2. Add new parameter "skip_deleted" to __scsi_iterate_devices() which
>>     is used when calling __scsi_device_get()
>> 3. Update shost_for_each_device() to call __scsi_iterate_devices() with
>>     "skip_deleted" true
>> 4. Add new macro shost_for_each_device_include_deleted() which call
>>     __scsi_iterate_devices() with "skip_deleted" false
>>
>> Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
>> ---
>>   drivers/scsi/scsi.c        | 46 ++++++++++++++++++++++++++------------
>>   include/scsi/scsi_device.h | 25 ++++++++++++++++++---
>>   2 files changed, 54 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>> index 3e0c0381277a..5913de543d93 100644
>> --- a/drivers/scsi/scsi.c
>> +++ b/drivers/scsi/scsi.c
>> @@ -735,20 +735,18 @@ int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
>>       return 0;
>>   }
>>   -/**
>> - * scsi_device_get  -  get an additional reference to a scsi_device
>> +/*
>> + * __scsi_device_get  -  get an additional reference to a scsi_device
>>    * @sdev:    device to get a reference to
>> - *
>> - * Description: Gets a reference to the scsi_device and increments the use count
>> - * of the underlying LLDD module.  You must hold host_lock of the
>> - * parent Scsi_Host or already have a reference when calling this.
>> - *
>> - * This will fail if a device is deleted or cancelled, or when the LLD module
>> - * is in the process of being unloaded.
>> + * @skip_deleted: when true, would return failed if device is deleted
>>    */
>> -int scsi_device_get(struct scsi_device *sdev)
>> +static int __scsi_device_get(struct scsi_device *sdev, bool skip_deleted)
>>   {
>> -    if (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL)
>> +    /*
>> +     * if skip_deleted is true and device is in removing, return failed
>> +     */
>> +    if (skip_deleted &&
>> +        (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL))
>>           goto fail;
> 
> Nack.
> SDEV_DEL means the device is about to be deleted, so we _must not_ access it at all.
> 

Sorry I added SDEV_DEL here at hand without understanding what it means.
Actually, just include scsi_device which is in SDEV_CANCEL would fix the
issues I described.

The issues are because device removing concurrent with error handle.
Normally, error handle would not be triggered when scsi_device is in
SDEV_DEL. Below is my analysis, if it is wrong, please correct me.

If there are scsi_cmnd remain unfinished when removing scsi_device,
the removing process would waiting for all commands to be finished.
If commands error happened and trigger error handle, the removing
process would be blocked until error handle finished, because
__scsi_remove_device called  del_gendisk() which would wait all
requests to be finished. So now scsi_device is in SDEV_CANCEL.

If the scsi_device is already in SDEV_DEL, then no scsi_cmnd has been
dispatched to this scsi_device, then error handle would never triggered.

I want to change the new function __scsi_device_get() as following,
please help to review.

/*
 * __scsi_device_get  -  get an additional reference to a scsi_device
 * @sdev:	device to get a reference to
 * @skip_canceled: when true, would return failed if device is deleted
 */
static int __scsi_device_get(struct scsi_device *sdev, bool skip_canceled)
{
	/*
	 * if skip_canceled is true and device is in removing, return failed
	 */
	if (sdev->sdev_state == SDEV_DEL ||
	    (sdev->sdev_state == SDEV_CANCEL && skip_canceled))
		goto fail;
	if (!try_module_get(sdev->host->hostt->module))
		goto fail;
	if (!get_device(&sdev->sdev_gendev))
		goto fail_put_module;
	return 0;

fail_put_module:
	module_put(sdev->host->hostt->module);
fail:
	return -ENXIO;
}

> Cheers,
> 
> Hannes

