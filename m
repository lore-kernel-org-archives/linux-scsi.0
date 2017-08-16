From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] megaraid_sas: boot hangs while LD is offline
Date: Wed, 16 Aug 2017 15:06:40 +0200
Message-ID: <4fd0ff13-e297-a22c-8c15-72e70e34bc11@suse.de>
References: <1502798355-59330-1-git-send-email-hare@suse.de>
 <b3be70b1e3e6a64e95b846b94830dbe2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47647 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752166AbdHPNGn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Aug 2017 09:06:43 -0400
In-Reply-To: <b3be70b1e3e6a64e95b846b94830dbe2@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Kashyap Desai <kashyap.desai@broadcom.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 08/16/2017 03:05 PM, Sumit Saxena wrote:
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Tuesday, August 15, 2017 5:29 PM
>> To: Martin K. Petersen
>> Cc: Christoph Hellwig; James Bottomley; Sumit Saxena; Kashyap Desai;
>> megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org; Hannes
>> Reinecke; Hannes Reinecke
>> Subject: [PATCH] megaraid_sas: boot hangs while LD is offline
>>
>> Offline Logical drives (LDs) should not allowed to be visible to the OS,
> as the
>> OS will hang trying to send commands to it.
>> This patch skips offline LDs like it already does for non-system physical
> drives
>> (PDs).
> 
> Hi Hannes,
> 
> You have submitted this patch in past as it was part of SLES kernel but
> missing in upstream and it was concluded to drop this patch then.
> This issue was fixed in firmware 4 years back and many firmware versions
> should be available with the fix so this fix is not required in
> driver(upstream
> as well SLES kernel). Do you see any functional issue without this patch ?
> If not, I would request  to back out this patch from SLES kernel also.
> 
Okay, if you say so.
Will be removing it.

Martin, please drop this patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
