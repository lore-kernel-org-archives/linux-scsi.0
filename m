From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Stock 2.6.4 with CONFIG_LBD=y and qla2xxx driver, reports wrong
	device size
Date: 24 Mar 2004 16:25:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080163517.1783.106.camel@mulgrave>
References: <4061F531.50808@physics.ucsd.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:8601 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261918AbUCXV2d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Mar 2004 16:28:33 -0500
In-Reply-To: <4061F531.50808@physics.ucsd.edu>
List-Id: linux-scsi@vger.kernel.org
To: Terrence Martin <tmartin@physics.ucsd.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-03-24 at 15:53, Terrence Martin wrote:
> I have a stock 2.6.4 kernel with CONFIG_LBD=y turned on in my kernel 
> (confirmed via /proc/config.gz) but when the module is loaded I still get
> 
> SCSI device sdb: 191162368 512-byte hdwr sectors (97875 MB)
> SCSI device sdb: drive cache: write through
>  sdb:
> 
> I expect to get 4,287,645MB as that is what my Infortrend RAID array is 
> set up for a partition size. Is there something, in addition to the LBD 
> support in 2.6 that I need to do with the SCSI driver itself, in the 
> case the qla2300 drivers that come with 2.6.4, to allow larger than 2TB 
> block devices?

This looks to be a failure of the device.  It's obviously reporting a
size smaller than it actually is for some reason.

The LDB code has been successfully tested with SCSI on >2TB arrays.

James


