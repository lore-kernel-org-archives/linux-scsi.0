From: "Ju, Seokmann" <sju@lsil.com>
Subject: RE: legacy megaraid driver bug in mm-series
Date: Wed, 7 Sep 2005 13:00:38 -0400
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703662B18@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:62866 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932069AbVIGRAx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2005 13:00:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Andrew Morton' <akpm@osdl.org>, linux-scsi@vger.kernel.org
Cc: Jack Byer <ojbyer@usa.net>

Hi Andrew,
On Wednesday, September 07, 2005 5:53 AM, Andrew Morton forwarded:
> 2.6.11-mm1:	works
> 2.6.11-mm4:	works
> 2.6.12-rc5-mm1:	will not compile
> 2.6.12-rc6-mm1:	works
> 2.6.12-mm1:	will not compile megaraid driver
> 2.6.12-mm2:	broken
> 2.6.13-mm1:	broken
> 
> 2.6.12:		works
> 2.6.13:		works
Is there any precedence rule on the kernels?.
I wonder which kernel is latest in between 2.6.12 and 2.6.12-mmx.
I assume 2.6.12-mmx is later than 2.6.12.
I'll try to dig out further if this is true, please confirm this.

Thank you,

Seokmann

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@osdl.org] 
> Sent: Wednesday, September 07, 2005 5:53 AM
> To: linux-scsi@vger.kernel.org
> Cc: Jack Byer
> Subject: Fw: legacy megaraid driver bug in mm-series
> 
> 
> 
> Begin forwarded message:
> 
> Date: Mon, 05 Sep 2005 21:05:40 -0400
> From: Jack Byer <ojbyer@usa.net>
> To: linux-kernel@vger.kernel.org
> Subject: legacy megaraid driver bug in mm-series
> 
> 
> My AMI megaraid card no longer works with recent mm-series 
> kernels. The
> bug appears on mm- kernels newer than 2.6.12-rc6-mm1; mainline kernels
> are not affected.
> 
> The driver will load and detect both devices on the card (sda 
> and sdb).
> It will scan each device and read the partition table successfully,
> however the megaraid driver message will include the following errors:
> 
> sda: sector size 0 reported, assuming 512.
> sda: asking for cache data failed.
> sda: assuming drive cache: write through
> 
> When the kernel tries to mount the root file system, I get 
> the following
> error:
> 
> ReiserFS: sda3: warning: sh-2006: read_super_block: bread failed (dev
> sda3, block 2, size 4096)
> ReiserFS: sda3: warning: sh-2006: read_super_block: bread failed (dev
> sda3, block 16, size 4096)
> VFS: Cannot open root device "sda3" or unknown-block(0,3)
> 
> Here is a summary of the kernels I have tested for this bug:
> 
> 2.6.11-mm1:	works
> 2.6.11-mm4:	works
> 2.6.12-rc5-mm1:	will not compile
> 2.6.12-rc6-mm1:	works
> 2.6.12-mm1:	will not compile megaraid driver
> 2.6.12-mm2:	broken
> 2.6.13-mm1:	broken
> 
> 2.6.12:		works
> 2.6.13:		works
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
