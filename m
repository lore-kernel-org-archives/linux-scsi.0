From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] RESEND: SCSI, libata: add support for ATA_16 commands
	to libata ATAPI devices
Date: Wed, 31 Jan 2007 18:44:14 -0600
Message-ID: <1170290654.3402.86.camel@mulgrave.il.steeleye.com>
References: <200701021935.07840.liml@rtr.ca>
	 <200701311346.26644.liml@rtr.ca>  <45C1356B.6000907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45C1356B.6000907@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Mark Lord <liml@rtr.ca>, Linux IDE <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2007-02-01 at 09:33 +0900, Tejun Heo wrote:
> I might have missed the discussion but can't we just set
> host->max_cmd_len to 16 unconditionally?  libata is emulating a SCSI
> device anyway and, from SCSI's POV, the situation is that any libata
> ATAPI device can do both 12 and 16 byte commands while some of them only
> allow allow ATA_16 for 16 byte command.
> 
> Also, it's not like host->max_cmd_len gives any guaranteed protection
> against CDB length.  Being a 'host' limit, it's set to the highest
> number in the host.  In that respect, it should be set to 16 too.  All
> ATA hosts can do 16 byte CDBs.

This looks like a much better proposal to me.

James


