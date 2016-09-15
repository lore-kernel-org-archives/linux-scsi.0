From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: TRIM/UNMAP/DISCARD via ATA Passthrough
Date: Thu, 15 Sep 2016 17:41:25 +0200
Message-ID: <CAHmME9pX1sSdFLfsgBqunh=5ttmPg5-vAzvTEfD1Xt4NBk6JzA@mail.gmail.com>
References: <CAHmME9q4TV4EVAK-4X8Fx9x_YYT3fh4zbtQgjnFR4ut7dTUUfA@mail.gmail.com>
 <yq1d1k6l43x.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:53277 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751990AbcIOPli (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Sep 2016 11:41:38 -0400
In-Reply-To: <yq1d1k6l43x.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Wed, Sep 14, 2016 at 8:37 PM, Martin K. Petersen
> How do they signal that they support the passthrough?

Through the usual SCSI ATA-passthrough interface,  "SAT"  (SCSI-ATA
Command  Translation) -- ATA PASS THROUGH SCSI (16) and ATA PASS
THROUGH SCSI (12).

I can use hdparm to treat /dev/sdb as an ATA interface:

zx2c4@thinkpad ~ $ sudo hdparm -I /dev/sdb | grep TRIM
           *    Data Set Management TRIM supported
