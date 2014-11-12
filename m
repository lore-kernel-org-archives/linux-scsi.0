From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1/7] megaraid_sas : Driver version upgrade
Date: Wed, 12 Nov 2014 14:52:18 +0100
Message-ID: <54636612.3000907@redhat.com>
References: <201411101224.sAACOcKw018039@palmhbs0.lsi.com> <546212BC.5070906@redhat.com> <b74d3f1d51c13b444c5d8c47079243d8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbaKLNwy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Nov 2014 08:52:54 -0500
In-Reply-To: <b74d3f1d51c13b444c5d8c47079243d8@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, aradford@gmail.com

On 11/12/2014 12:13 PM, Kashyap Desai wrote:
>> -----Original Message-----
>> From: Tomas Henzl [mailto:thenzl@redhat.com]
>> Sent: Tuesday, November 11, 2014 7:14 PM
>> To: Sumit.Saxena@avagotech.com; linux-scsi@vger.kernel.org
>> Cc: martin.petersen@oracle.com; hch@infradead.org;
>> jbottomley@parallels.com; kashyap.desai@avagotech.com;
>> aradford@gmail.com
>> Subject: Re: [PATCH 1/7] megaraid_sas : Driver version upgrade
>>
>> On 11/10/2014 01:21 PM, Sumit.Saxena@avagotech.com wrote:
>>> megaraid_sas driver version upgrade
>>>
>>> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
>>> ---
>>>  drivers/scsi/megaraid/megaraid_sas.h      | 2 +-
>>>  drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
>>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>> b/drivers/scsi/megaraid/megaraid_sas.h
>>> index a49914d..f3eccf1 100644
>>> --- a/drivers/scsi/megaraid/megaraid_sas.h
>>> +++ b/drivers/scsi/megaraid/megaraid_sas.h
>>> @@ -33,7 +33,7 @@
>>>  /*
>>>   * MegaRAID SAS Driver meta data
>>>   */
>>> -#define MEGASAS_VERSION				"06.805.06.00-
>> rc1"
>>> +#define MEGASAS_VERSION				"06.805.06.01-
>> rc1"
>>>  #define MEGASAS_RELDATE				"Sep. 4, 2014"
>>>  #define MEGASAS_EXT_VERSION			"Thu. Sep. 4
> 17:00:00
>> PDT 2014"
>>
>> Usually you have changed the dates too, but this not important, feel
> free to
>> ignore  it.
> Agree that we always keep  version/date sync-up in same patch.
> I think having RELDATE is not really helpful and I see only megaraid_sas
> driver use this.
>
> Probably we should keep only VERSION and remove RELDATE and EXT_VERSION

EXT_VERSION is used to print a message to log - you can change it as you wish,
I haven't noticed something similar to RELDATE in other drivers, so again
I've no problem with any change.

>
>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>> b/drivers/scsi/megaraid/megaraid_sas_base.c
>>> index f6a69a3..36f463c 100644
>>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>>> @@ -18,7 +18,7 @@
>>>   *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
> 02111-1307
>> USA
>>>   *
>>>   *  FILE: megaraid_sas_base.c
>>> - *  Version : 06.805.06.00-rc1
>>> + *  Version : 06.805.06.01-rc1
>>>   *
>>>   *  Authors: LSI Corporation
>>>   *           Sreenivas Bagalkote
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

