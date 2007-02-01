From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] RESEND: SCSI, libata: add support for ATA_16 commands
 to libata ATAPI devices
Date: Thu, 01 Feb 2007 03:30:10 -0500
Message-ID: <45C1A512.8070602@garzik.org>
References: <200701021935.07840.liml@rtr.ca> <200701311346.26644.liml@rtr.ca> <45C1356B.6000907@gmail.com> <45C1377F.6070001@rtr.ca> <45C138E8.1040706@gmail.com> <45C13BCD.8080003@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45C13BCD.8080003@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Tejun Heo <htejun@gmail.com>, Linux IDE <linux-ide@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Mark Lord wrote:
> Tejun Heo wrote:
>> Anyways, this has never been guaranteed because
>> the limit is host wide.
> 
> But until very very recently, "host wide" meant just a single device
> for libata.  I was just assuming we did all of the fiddling to ensure
> a minimal value there for some real reason.
> 
> But, yes, now we have PATA (2 drives per host), and PMP (many more
> drives per host), so just maxing out the limit seems sensible.

No, we can't just assume that all host controller CDB FIFOs (if indeed 
that's the implementation) support 16-byte CDBs.

Gotta do a controller-by-controller check.

There are both /host/ and /device/ limits.

	Jeff



