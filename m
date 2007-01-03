From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI, libata: add support for ATA_16
	commands	to	libata ATAPI devices
Date: Wed, 03 Jan 2007 09:57:30 -0600
Message-ID: <1167839851.2789.17.camel@mulgrave.il.steeleye.com>
References: <200701021935.07840.liml@rtr.ca>
	 <1167788405.3687.25.camel@mulgrave.il.steeleye.com>
	 <459B4243.5080804@rtr.ca>
	 <1167838307.2789.12.camel@mulgrave.il.steeleye.com>
	 <459BCF82.5000906@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <459BCF82.5000906@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Lord <liml@rtr.ca>, Linux IDE <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2007-01-03 at 10:45 -0500, Jeff Garzik wrote:
> James Bottomley wrote:
> > On Wed, 2007-01-03 at 00:42 -0500, Mark Lord wrote:
> >> James Bottomley wrote:
> >>> I don't think I quite understand what you're trying to do here.  My
> >>> understanding is that ATA_12 and ATA_16 are part of the SAT layer. i.e.
> >>> they're used when we're speaking SCSI to an underlying ATA device to
> >>> send taskfiles.  However, ATAPI devices don't use SAT ... every SCSI
> >>> command you send to an ATAPI device goes out as an ATA PACKET command
> >>> without being translated.
> >> ATAPI devices also implement quite a few ATA (non-packet) commands.
> >> This patch gives us a way to issue them in response to SG_IO ATA passthru
> >> and the existing (non working) libata HDIO_DRIVE_CMD and HDIO_DRIVE_TASK
> >> ioctl calls.
> > 
> > I know that ... but when you send ATA_16 down to an ATAPI device via
> > SG_IO  the code paths in libata don't unwrap it and send it out as a
> > taskfile ... they put ATA_16 out as a packet command.
> 
> He is aware of that.  That's what his two patches address.

Er I've only seen one patch ... I did ask if there was another to add
the ATA_16 interpretation ... did that get lost by the SCSI reflector?

James


