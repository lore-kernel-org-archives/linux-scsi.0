Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB8A138495;
	Thu, 13 Jun 2024 07:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718262622; cv=none; b=JDbpZi99p4Tuyya//1ZQpiIsUTeK8H0SAVcBD2hqHbMMxqXOuuCSy7ago6nK5FSKTXqMJlGhO9L8AlIy1H9HuD9JDxFQePYzySA+Ww1xzHE9bPXLCYv1smKop/eTuF5HRdEA3TzoutxrAchzBFf1u6L3F57F+RdF4Ck1enhzOZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718262622; c=relaxed/simple;
	bh=rI64L27Y3tt6nheA2eTSiYMpyZxmtyiSZSGbQT4gFms=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MsWkuJB7R9W5vTOksAXxUER79A/IZlKI7fToB8W+nVxNmhNLFdYoKS+UmD3zWLITszxhqGDdKYLsrrkclLnxlTYxyfD6ZNIJncLB4e2Zt8n+mXvFhEwqYRy5z6lzGxdvtixUjBrIi2hhdziTufU40lJVAiLE0TxDuAbx00iJvBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZktmIvHM; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZktmIvHM"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6f4603237e0so506174b3a.0;
        Thu, 13 Jun 2024 00:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718262620; x=1718867420; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B54RJv0cgqP2/sc/ro0r9cZHvykjV6un/kfq4GUh9QU=;
        b=ZktmIvHMivnuzjArEFeRPCziJZYLO2Q+++XA0RSgCLOyhGvlxaaKr+NENe/e+LbZS1
         6ynoqRIWNCwxv+oykW26aqh7wPvrjb3tURRPt4uwXm8IvLfGQoammdahR6QsM5KNSuNP
         9svW4SAAj2KGVCD6/C5h1GSN1hLlmXUnwHnUHeCdD3mlDKYMn9fhWQ0EaCyXqZiccFCU
         M6HaFKalycEtFWheLGmwVBISe2oU27kR8Bq6yyf1RBTdOwily0patulB58M9bzThyDvG
         ukOb78cuAoTiTTcKSxyWp0Wg1sXBAEfMeCPEXS5fXd3tD5IHoRt1EuBmOVcUKeQNZzJP
         qQ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718262620; x=1718867420;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B54RJv0cgqP2/sc/ro0r9cZHvykjV6un/kfq4GUh9QU=;
        b=U4x5IklXmsTVE2LcTCZmd0JlP/dY2nVtAg+lufqRHe+00WewPewmBniu3CV37RV4ao
         Qn7mItG9LKBsXsQbSohgBE9j2Z5JArYctZ7xIL5meDldTW9CBtrQD4wnZgr+Z/b7G4Q/
         hIxlqKs7mS+tuPxlY9J7MIdmTuxGJ8DtxCBViDV5+G0sEeANODAllpYjPQxHvFFYOglc
         mZSok4OaoQts0ff9t4h7WuBfvm4mCpQQEsEgwbFjKou7xKZHl1ZmyaCyrpCRWSAOlzhh
         vA8vQoMz0g5M/j2R6NZG6pFoSEtgXatR5E6A5OkLf14L7J06JjZByuldKngaWZI5jHC/
         pzrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUft2VrrCiXjX3YhAO2AlHpMM36bhU7V5nbNdZBM20txLy3b/D+48rp8Kl0qaZEBoK1/yHpAOqA2n1Aedfg4anX6/TnW/FyXcaU0LnjH5RKurrmkmLjVK7kC0FnFDVQQQG9wju1A6U9QA==
X-Gm-Message-State: AOJu0YzVlvwuyEHIrbBwGpCvbj/9UeaSzEgbBWTiEQqsAxjVC7ZH4vWS
	cT/wIKeZgDomA0MD4xzbUpZXKcv+sSex/5Lt0g0rVClX+ZWRy1AX
X-Google-Smtp-Source: AGHT+IHF16EZMKsNFZ4Z+Y7m3/eNgMs3V+TGo+PzKINWwcvq+yLbHtR6sJoX3Vy/BrdgYLDuzRQjEA==
X-Received: by 2002:a05:6a00:2e0d:b0:705:aec4:605f with SMTP id d2e1a72fcca58-705c935948dmr2490765b3a.2.1718262620105;
        Thu, 13 Jun 2024 00:10:20 -0700 (PDT)
Received: from [0.0.0.0] (97.64.23.41.16clouds.com. [97.64.23.41])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb78581sm692108b3a.179.2024.06.13.00.10.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jun 2024 00:10:19 -0700 (PDT)
Message-ID: <cb9b64a1-4c51-481a-ae5a-c20df70360ea@gmail.com>
Date: Thu, 13 Jun 2024 15:10:14 +0800
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
 <c1ecd21b-7b97-4ef6-94a1-86b2cf520a67@gmail.com>
 <698d4b22-719c-4e57-94ed-f507e425ee12@suse.de>
Content-Language: en-US
From: Wenchao Hao <haowenchao22@gmail.com>
In-Reply-To: <698d4b22-719c-4e57-94ed-f507e425ee12@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/6/13 14:27, Hannes Reinecke wrote:
> On 6/12/24 17:06, Wenchao Hao wrote:
>> On 6/12/24 4:33 PM, Hannes Reinecke wrote:
>>> On 6/5/24 11:17, Wenchao Hao wrote:
>>>> shost_for_each_device() would skip devices which is in SDEV_CANCEL or
>>>> SDEV_DEL state, for some scenarios, we donot want to skip these 
>>>> devices,
>>>> so add a new macro shost_for_each_device_include_deleted() to handle 
>>>> it.
>>>>
>>>> Following changes are introduced:
>>>>
>>>> 1. Rework scsi_device_get(), add new helper __scsi_device_get() which
>>>>      determine if skip deleted scsi_device by parameter "skip_deleted".
>>>> 2. Add new parameter "skip_deleted" to __scsi_iterate_devices() which
>>>>      is used when calling __scsi_device_get()
>>>> 3. Update shost_for_each_device() to call __scsi_iterate_devices() with
>>>>      "skip_deleted" true
>>>> 4. Add new macro shost_for_each_device_include_deleted() which call
>>>>      __scsi_iterate_devices() with "skip_deleted" false
>>>>
>>>> Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
>>>> ---
>>>>    drivers/scsi/scsi.c        | 46 
>>>> ++++++++++++++++++++++++++------------
>>>>    include/scsi/scsi_device.h | 25 ++++++++++++++++++---
>>>>    2 files changed, 54 insertions(+), 17 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>>>> index 3e0c0381277a..5913de543d93 100644
>>>> --- a/drivers/scsi/scsi.c
>>>> +++ b/drivers/scsi/scsi.c
>>>> @@ -735,20 +735,18 @@ int scsi_cdl_enable(struct scsi_device *sdev, 
>>>> bool enable)
>>>>        return 0;
>>>>    }
>>>>    -/**
>>>> - * scsi_device_get  -  get an additional reference to a scsi_device
>>>> +/*
>>>> + * __scsi_device_get  -  get an additional reference to a scsi_device
>>>>     * @sdev:    device to get a reference to
>>>> - *
>>>> - * Description: Gets a reference to the scsi_device and increments 
>>>> the use count
>>>> - * of the underlying LLDD module.  You must hold host_lock of the
>>>> - * parent Scsi_Host or already have a reference when calling this.
>>>> - *
>>>> - * This will fail if a device is deleted or cancelled, or when the 
>>>> LLD module
>>>> - * is in the process of being unloaded.
>>>> + * @skip_deleted: when true, would return failed if device is deleted
>>>>     */
>>>> -int scsi_device_get(struct scsi_device *sdev)
>>>> +static int __scsi_device_get(struct scsi_device *sdev, bool 
>>>> skip_deleted)
>>>>    {
>>>> -    if (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == 
>>>> SDEV_CANCEL)
>>>> +    /*
>>>> +     * if skip_deleted is true and device is in removing, return 
>>>> failed
>>>> +     */
>>>> +    if (skip_deleted &&
>>>> +        (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == 
>>>> SDEV_CANCEL))
>>>>            goto fail;
>>>
>>> Nack.
>>> SDEV_DEL means the device is about to be deleted, so we _must not_ 
>>> access it at all.
>>>
>>
>> Sorry I added SDEV_DEL here at hand without understanding what it means.
>> Actually, just include scsi_device which is in SDEV_CANCEL would fix the
>> issues I described.
>>
>> The issues are because device removing concurrent with error handle.
>> Normally, error handle would not be triggered when scsi_device is in
>> SDEV_DEL. Below is my analysis, if it is wrong, please correct me.
>>
>> If there are scsi_cmnd remain unfinished when removing scsi_device,
>> the removing process would waiting for all commands to be finished.
>> If commands error happened and trigger error handle, the removing
>> process would be blocked until error handle finished, because
>> __scsi_remove_device called  del_gendisk() which would wait all
>> requests to be finished. So now scsi_device is in SDEV_CANCEL.
>>
>> If the scsi_device is already in SDEV_DEL, then no scsi_cmnd has been
>> dispatched to this scsi_device, then error handle would never triggered.
>>
>> I want to change the new function __scsi_device_get() as following,
>> please help to review.
>>
>> /*
>>   * __scsi_device_get  -  get an additional reference to a scsi_device
>>   * @sdev:    device to get a reference to
>>   * @skip_canceled: when true, would return failed if device is deleted
>>   */
>> static int __scsi_device_get(struct scsi_device *sdev, bool 
>> skip_canceled)
>> {
>>     /*
>>      * if skip_canceled is true and device is in removing, return failed
>>      */
>>     if (sdev->sdev_state == SDEV_DEL ||
>>         (sdev->sdev_state == SDEV_CANCEL && skip_canceled))
>>         goto fail;
>>     if (!try_module_get(sdev->host->hostt->module))
>>         goto fail;
>>     if (!get_device(&sdev->sdev_gendev))
>>         goto fail_put_module;
>>     return 0;
>>
>> fail_put_module:
>>     module_put(sdev->host->hostt->module);
>> fail:
>>     return -ENXIO;
>> }
>>
> I don't think that's required.
> With your above analysis, wouldn't the problem be solved with:
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 775df00021e4..911fcfa80d69 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1470,6 +1470,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
>          if (sdev->sdev_state == SDEV_DEL)
>                  return;
> 
> +       scsi_block_when_processing_errors(sdev);
> +
>          if (sdev->is_visible) {
>                  /*
>                   * If scsi_internal_target_block() is running 
> concurrently,
> 
> Hmm?
> 

We can not make sure no scsi_cmnd remain unfinished after 
scsi_block_when_processing_errors(). For example, there is a
command has been dispatched but it's not timeouted when removing
device, no error happened. After scsi_device is set to SDEV_CANCEL,
the removing process would be blocked by del_gendisk() because there
is still a request.

Then the request timeout and abort failed, error handle would be 
triggered, now scsi_device is SDEV_CANCEL.

The error handle would skip this scsi_device when doing device reset.

> Cheers,
> 
> Hannes

