From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] RESEND: SCSI, libata: add support for ATA_16 commands
 to libata ATAPI devices
Date: Wed, 31 Jan 2007 19:53:03 -0500
Message-ID: <45C139EF.8010103@rtr.ca>
References: <200701021935.07840.liml@rtr.ca>	 <200701311346.26644.liml@rtr.ca> <45C1356B.6000907@gmail.com>	 <45C1377F.6070001@rtr.ca> <1170290907.3402.90.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1170290907.3402.90.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <htejun@gmail.com>, Linux IDE <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
>..
> In SCSI, we're very careful only to use large commands where necessary,
> so even for a >2TB array, you only see 16 byte commands for sectors
> beyond 2TB.  This essentially means that the capacity (and we do a
> careful READ_CAPACITY(10) and only move on to READ_CAPACITY(16) if we're
> told to) limits the command size.

Very cool, James.
