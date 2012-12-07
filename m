From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v7 3/9] Introduce scsi_device_being_removed()
Date: Fri, 07 Dec 2012 10:11:55 +0100
Message-ID: <50C1B2DB.9070001@acm.org>
References: <50C0BEEE.4040907@acm.org> <50C0BFD5.9030604@acm.org> <e6b81317b8ba62b6493cf67645cb1501@sf-mail.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:44994 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab2LGJL6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2012 04:11:58 -0500
In-Reply-To: <e6b81317b8ba62b6493cf67645cb1501@sf-mail.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

On 12/07/12 09:40, Rolf Eike Beer wrote:
>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>> index 55367b0..767dd16 100644
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -442,6 +442,11 @@ static inline int scsi_device_created(struct
>> scsi_device *sdev)
>>      return sdev->sdev_state == SDEV_CREATED ||
>>          sdev->sdev_state == SDEV_CREATED_BLOCK;
>>  }
>> +static inline int scsi_device_being_removed(struct scsi_device *sdev)
>> +{
>> +    return sdev->sdev_state == SDEV_CANCEL ||
>> +        sdev->sdev_state == SDEV_DEL;
>> +}
>>
>>  /* accessor functions for the SCSI parameters */
>>  static inline int scsi_device_sync(struct scsi_device *sdev)
>
> Newline missing before the new function.

Hello Rolf,

Well spotted. Did you realize I had left out the newline on purpose, to 
preserve consistency with the rest of the header file ?

Thanks,

Bart.

