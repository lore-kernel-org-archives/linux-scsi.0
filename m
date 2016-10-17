From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH 5/7] megaraid_sas: driver version upgrade
Date: Mon, 17 Oct 2016 17:50:47 +0530
Message-ID: <04201a334e471b821892fe55c3f863b1@mail.gmail.com>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
 <1476699850-25083-6-git-send-email-sumit.saxena@broadcom.com> <acb9270b-13e0-ad6e-0af5-ce05215db139@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34204 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933453AbcJQM0H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2016 08:26:07 -0400
Received: by mail-oi0-f52.google.com with SMTP id t73so210015083oie.1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2016 05:26:07 -0700 (PDT)
In-Reply-To: <acb9270b-13e0-ad6e-0af5-ce05215db139@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>

>-----Original Message-----
>From: Hannes Reinecke [mailto:hare@suse.de]
>Sent: Monday, October 17, 2016 5:05 PM
>To: Sumit Saxena; linux-scsi@vger.kernel.org
>Cc: martin.petersen@oracle.com; thenzl@redhat.com;
jejb@linux.vnet.ibm.com;
>kashyap.desai@broadcom.com
>Subject: Re: [PATCH 5/7] megaraid_sas: driver version upgrade
>
>On 10/17/2016 12:24 PM, Sumit Saxena wrote:
>> Upgrade driver version.
>>
>> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
>> ---
>>  drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>> b/drivers/scsi/megaraid/megaraid_sas.h
>> index 43fd14f..1d4de90 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas.h
>> +++ b/drivers/scsi/megaraid/megaraid_sas.h
>> @@ -35,8 +35,8 @@
>>  /*
>>   * MegaRAID SAS Driver meta data
>>   */
>> -#define MEGASAS_VERSION				"06.811.02.00-rc1"
>> -#define MEGASAS_RELDATE				"April 12, 2016"
>> +#define MEGASAS_VERSION				"06.812.06.00-rc1"
>> +#define MEGASAS_RELDATE				"August 22, 2016"
>>
>>  /*
>>   * Device IDs
>>
>Please move this patch to the end of the series.
>Otherwise it's impossible to tell if the following patches should be part
of the new
>version or not.

Sure..I will rectify and resend the patches.
>
>Cheers,
>
>Hannes
>--
>Dr. Hannes Reinecke		   Teamlead Storage & Networking
>hare@suse.de			               +49 911 74053 688
>SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
>GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton HRB
21284 (AG
>N=C3=BCrnberg)
