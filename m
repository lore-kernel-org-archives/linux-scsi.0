From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b7).
Date: 29 Dec 2003 11:32:46 -0600
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1072719168.1878.34.camel@mulgrave>
References: <B179AE41C1147041AA1121F44614F0B060ED8F@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060ED8F@AVEXCH02.qlogic.org>
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2003-12-05 at 19:15, Andrew Vasquez wrote:
> > A new version of the 8.x series driver for Linux 2.6.x kernels has
> > been uploaded to SourceForge: 
> > 
> > 	http://sourceforge.net/projects/linux-qla2xxx/
> >
> 
> False start.  I've uploaded 8.00.00b8 to the SF site.  This driver
> instructs the mid-layer to perform its initial scan with
> scsi_scan_host().  During testing, I disable the scan.  Sorry for
> the confusion.

OK, I've begun the BK process again.

This driver is now in BK at

bk://linux-scsi.bkbits.net/scsi-qla2xxx-2.6

I didn't see any comments about Christoph's patches, so is it OK if I
apply them?

I plan to let it mature in it's own tree for a short while with the
object being to get it into the right shape for a 2.6 inclusion
candidate.

The two items we still need to do something about are:

- Multi Pathing.  This really doesn't belong in the kernel
- The odd ioctl set to the qla device...I'd much rather see something
more standard that all FC drivers can use.

James
