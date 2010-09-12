From: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: UltraStar fails detection with "Unsupported sector size 524"
Date: Sun, 12 Sep 2010 23:28:09 +0200
Message-ID: <19597.17897.19220.535260@pilspetsen.it.uu.se>
References: <19597.3653.893156.794645@pilspetsen.it.uu.se>
	<1284315504.2980.2.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fanny.its.uu.se ([130.238.4.241]:41192 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab0ILV2L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Sep 2010 17:28:11 -0400
In-Reply-To: <1284315504.2980.2.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-scsi@vger.kernel.org

James Bottomley writes:
 > On Sun, 2010-09-12 at 19:30 +0200, Mikael Pettersson wrote:
 > > I got a bunch of 72G IBM UltraStars that were taken from some
 > > kind of IBM storage server.  The Linux kernel however doesn't
 > > like them, complaining about a non-512 byte sector size:
 > > 
 > > scsi 0:0:1:0: Direct-Access     IBM      IC35L073UCDY10-0 S27N PQ: 0 ANSI: 3
 > > scsi target0:0:1: tagged command queuing enabled, command queue depth 16.
 > > scsi target0:0:1: Beginning Domain Validation
 > > scsi target0:0:1: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 8)
 > > scsi target0:0:1: Domain Validation skipping write tests
 > > scsi target0:0:1: Ending Domain Validation
 > > sd 0:0:1:0: [sdb] Unsupported sector size 524.
 > > 
 > > (that's from the 2.6.35 kernel's SYM53C8XX_2)
 > > 
 > > According to the datasheets these drives have soft-configurable
 > > sector sizes from 512 up to 528 bytes, but they don't say how
 > > that configuration is done.
 > > 
 > > Any ideas on how to reconfigure these drives for 512-byte sectors?
 > 
 > sg_format --format --size=512 /dev/<disk>

I tested that on one of the disks and solved the detection problem.

Thanks.

/Mikael
