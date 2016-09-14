From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: TRIM/UNMAP/DISCARD via ATA Passthrough
Date: Wed, 14 Sep 2016 14:37:38 -0400
Message-ID: <yq1d1k6l43x.fsf@sermon.lab.mkp.net>
References: <CAHmME9q4TV4EVAK-4X8Fx9x_YYT3fh4zbtQgjnFR4ut7dTUUfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9q4TV4EVAK-4X8Fx9x_YYT3fh4zbtQgjnFR4ut7dTUUfA@mail.gmail.com>
        (Jason A. Donenfeld's message of "Mon, 12 Sep 2016 20:50:22 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Jason" == Jason A Donenfeld <Jason@zx2c4.com> writes:

Jason,

Jason> These USB enclosures do not support SCSI UNMAP. However, they do
Jason> support ATA-passthrough, and `hdparm -I` shows that TRIM is
Jason> supported.

How do they signal that they support the passthrough?

-- 
Martin K. Petersen	Oracle Linux Engineering
