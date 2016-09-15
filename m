From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: TRIM/UNMAP/DISCARD via ATA Passthrough
Date: Thu, 15 Sep 2016 12:07:20 -0400
Message-ID: <yq1twdhb0zr.fsf@sermon.lab.mkp.net>
References: <CAHmME9q4TV4EVAK-4X8Fx9x_YYT3fh4zbtQgjnFR4ut7dTUUfA@mail.gmail.com>
        <yq1d1k6l43x.fsf@sermon.lab.mkp.net>
        <CAHmME9pX1sSdFLfsgBqunh=5ttmPg5-vAzvTEfD1Xt4NBk6JzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16738 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750909AbcIOQH0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2016 12:07:26 -0400
In-Reply-To: <CAHmME9pX1sSdFLfsgBqunh=5ttmPg5-vAzvTEfD1Xt4NBk6JzA@mail.gmail.com>
        (Jason A. Donenfeld's message of "Thu, 15 Sep 2016 17:41:25 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

>>>>> "Jason" == Jason A Donenfeld <Jason@zx2c4.com> writes:

Jason,

>> How do they signal that they support the passthrough?

Jason> Through the usual SCSI ATA-passthrough interface, "SAT" (SCSI-ATA
Jason> Command Translation) -- ATA PASS THROUGH SCSI (16) and ATA PASS
Jason> THROUGH SCSI (12).

But how do they signal that ATA passthrough is possible? Is there an ATA
Information VPD page? Is REPORT SUPPORTED OPERATION CODES supported?

We need really solid discovery data before we can entertain enabling
something like this.

-- 
Martin K. Petersen	Oracle Linux Engineering
