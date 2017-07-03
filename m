From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH 1/2] Drop legacy megaraid controller
Date: Mon, 3 Jul 2017 13:20:35 +0530
Message-ID: <0f96d4aca1a7d4c56a70607012a26a68@mail.gmail.com>
References: <1498820754-51032-1-git-send-email-hare@suse.de>
 <1498820754-51032-2-git-send-email-hare@suse.de> <20170630173347.GA11420@lst.de>
 <281a2a28-ff8d-8c65-6d53-ee393ca08e24@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35720 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752644AbdGCHui (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jul 2017 03:50:38 -0400
Received: by mail-oi0-f51.google.com with SMTP id 191so48541844oii.2
        for <linux-scsi@vger.kernel.org>; Mon, 03 Jul 2017 00:50:38 -0700 (PDT)
In-Reply-To: <281a2a28-ff8d-8c65-6d53-ee393ca08e24@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Kashyap Desai <kashyap.desai@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>-----Original Message-----
>From: Hannes Reinecke [mailto:hare@suse.de]
>Sent: Friday, June 30, 2017 11:46 PM
>To: Christoph Hellwig
>Cc: Martin K. Petersen; James Bottomley; Kashyap Desai; Sumit Saxena;
>linux-
>scsi@vger.kernel.org; Hannes Reinecke
>Subject: Re: [PATCH 1/2] Drop legacy megaraid controller
>
>On 06/30/2017 07:33 PM, Christoph Hellwig wrote:
>> On Fri, Jun 30, 2017 at 01:05:53PM +0200, Hannes Reinecke wrote:
>>> The hardware is ancient, and support for most cards has been moved to
>>> megaraid_mbox. So drop it.
>>
>>
>> This seems to drop support for the PCI_DEVICE_ID_AMI_MEGARAID and
>> PCI_DEVICE_ID_AMI_MEGARAID2 cards.  Do we have any suggestions this
>> code is so broken to not care anymore? Is there any reason why they
>> can't just work with the megaraid_mbox driver?
>>
>Hmm. Probably no good reason at all.
>I'll check which version I have here.

Hannes,
We are willing to keep only megaraid_sas driver and intent is rest of
megaraid* drivers
(it includes megaraid, megaraid_mm, megaraid_mbox) should be removed.
Broadcom(LSI) has stopped supporting hardware associated with these old
drivers.

Thanks,
Sumit
>
>Cheers,
>
>Hannes
>--
>Dr. Hannes Reinecke		   Teamlead Storage & Networking
>hare@suse.de			               +49 911 74053 688
>SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
>GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton HRB =
21284
>(AG N=C3=BCrnberg)
