From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: TRIM/UNMAP/DISCARD via ATA Passthrough
Date: Thu, 15 Sep 2016 22:52:34 +0200
Message-ID: <CAHmME9qq5vSC+hZckCystU6cdRPihO492U2B2-pozbwg=3_5nw@mail.gmail.com>
References: <CAHmME9q4TV4EVAK-4X8Fx9x_YYT3fh4zbtQgjnFR4ut7dTUUfA@mail.gmail.com>
 <yq1d1k6l43x.fsf@sermon.lab.mkp.net> <CAHmME9pX1sSdFLfsgBqunh=5ttmPg5-vAzvTEfD1Xt4NBk6JzA@mail.gmail.com>
 <yq1twdhb0zr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:51889 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751570AbcIOUwn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Sep 2016 16:52:43 -0400
In-Reply-To: <yq1twdhb0zr.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Hi Martin,

On Thu, Sep 15, 2016 at 6:07 PM, Martin K. Petersen
> But how do they signal that ATA passthrough is possible? Is there an ATA
> Information VPD page? Is REPORT SUPPORTED OPERATION CODES supported?
>
> We need really solid discovery data before we can entertain enabling
> something like this.

`sg_opcodes` said invalid request, so I think there isn't REPORT
SUPPORTED OPERATION CODES, and `sg_vpd -p ai` came up illegal too.

However, sg_sat_identify worked reliably, which means a solid way of
probing this would be to send IDENTIFY DEVICE ATA via SG_ATA_16 or
SG_ATA_12.

Let me know and I can give you access to the hardware if you're curious.

Regards,
Jason
