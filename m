From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Wed, 15 Jan 2003 12:40:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E259CFD.8010305@splentec.com>
References: <MPESCHKE@de.ibm.com> <OFD72246CF.E2385102-ONC1256CAF.0050D1E1@de.ibm.com> <200301151552.h0FFqp402401@localhost.localdomain> <20030115171233.GC1910@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, patmans@us.ibm.com, linux-scsi@vger.kernel.org

Mike Anderson wrote:
 >
> object. A transport specific lib could contain common routines
> which the LLDD could use or provide there own ops.

Uuuuh, I think that this will be too bulky for its purpose.

All we want is to present the target port/device name/identifier,
aka ``target ID'', and the LUN.  Both of those are fairly simple
and trivial to implement.

I do not think that the LLDD should be burdened with more callbacks
for this.  This makes it too messy and too complicated for no reason.

As was suggested before by someone, and I concurred, SCSI Core can
do translations for old and dumb drivers, but newer LLDD, would
accept an actual LUN (64 bits), and an actual target identifier.

I.e. the LLDD shouldn't know what hit them.

Latest news is that SPI is completely going away from SPC-3 and SAM-3
which would make it more worthwhile to get this going.

-- 
Luben



