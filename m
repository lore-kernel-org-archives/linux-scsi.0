From: Hannes Reinecke <hare@suse.de>
Subject: Re: TRIM/UNMAP/DISCARD via ATA Passthrough
Date: Fri, 16 Sep 2016 13:16:35 +0200
Message-ID: <5af202ea-a632-28c2-515f-c361e27de5da@suse.de>
References: <CAHmME9q4TV4EVAK-4X8Fx9x_YYT3fh4zbtQgjnFR4ut7dTUUfA@mail.gmail.com>
 <yq1d1k6l43x.fsf@sermon.lab.mkp.net>
 <CAHmME9pX1sSdFLfsgBqunh=5ttmPg5-vAzvTEfD1Xt4NBk6JzA@mail.gmail.com>
 <yq1twdhb0zr.fsf@sermon.lab.mkp.net>
 <CAHmME9qq5vSC+hZckCystU6cdRPihO492U2B2-pozbwg=3_5nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33463 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759269AbcIPLQl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Sep 2016 07:16:41 -0400
In-Reply-To: <CAHmME9qq5vSC+hZckCystU6cdRPihO492U2B2-pozbwg=3_5nw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On 09/15/2016 10:52 PM, Jason A. Donenfeld wrote:
> Hi Martin,
> 
> On Thu, Sep 15, 2016 at 6:07 PM, Martin K. Petersen
>> But how do they signal that ATA passthrough is possible? Is there an ATA
>> Information VPD page? Is REPORT SUPPORTED OPERATION CODES supported?
>>
>> We need really solid discovery data before we can entertain enabling
>> something like this.
> 
> `sg_opcodes` said invalid request, so I think there isn't REPORT
> SUPPORTED OPERATION CODES, and `sg_vpd -p ai` came up illegal too.
> 
> However, sg_sat_identify worked reliably, which means a solid way of
> probing this would be to send IDENTIFY DEVICE ATA via SG_ATA_16 or
> SG_ATA_12.
> 
> Let me know and I can give you access to the hardware if you're curious.
> 
Sadly, that's not sufficient.
linux is not the only provider of an SATL (mpt3sas being the most
prominent other one).
And while they might support ATA_12/ATA_16, there is no indication that
you can pass DSM TRIM that way.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
