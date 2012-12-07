From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH v7 3/9] Introduce =?UTF-8?Q?scsi=5Fdevice=5Fbeing=5Fre?=
 =?UTF-8?Q?moved=28=29?=
Date: Fri, 07 Dec 2012 11:02:40 +0100
Message-ID: <35b212f7c176c6782f048f01fe7e75dd@sf-mail.de>
References: <50C0BEEE.4040907@acm.org> <50C0BFD5.9030604@acm.org>
 <e6b81317b8ba62b6493cf67645cb1501@sf-mail.de> <50C1B2DB.9070001@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:51294 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384Ab2LGKCo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2012 05:02:44 -0500
In-Reply-To: <50C1B2DB.9070001@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

Am , schrieb Bart Van Assche:
> On 12/07/12 09:40, Rolf Eike Beer wrote:
>>> diff --git a/include/scsi/scsi_device.h 
>>> b/include/scsi/scsi_device.h
>>> index 55367b0..767dd16 100644
>>> --- a/include/scsi/scsi_device.h
>>> +++ b/include/scsi/scsi_device.h
>>> @@ -442,6 +442,11 @@ static inline int scsi_device_created(struct
>>> scsi_device *sdev)
>>>      return sdev->sdev_state == SDEV_CREATED ||
>>>          sdev->sdev_state == SDEV_CREATED_BLOCK;
>>>  }
>>> +static inline int scsi_device_being_removed(struct scsi_device 
>>> *sdev)
>>> +{
>>> +    return sdev->sdev_state == SDEV_CANCEL ||
>>> +        sdev->sdev_state == SDEV_DEL;
>>> +}
>>>
>>>  /* accessor functions for the SCSI parameters */
>>>  static inline int scsi_device_sync(struct scsi_device *sdev)
>>
>> Newline missing before the new function.
>
> Hello Rolf,
>
> Well spotted. Did you realize I had left out the newline on purpose,
> to preserve consistency with the rest of the header file ?

Well, there is already a newline between scsi_device_created() and 
scsi_device_sync() where you insert your stuff so this sort of 
consistency is hard to spot.

Eike
