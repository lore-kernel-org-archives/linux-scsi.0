From: Terrence Martin <tmartin@physics.ucsd.edu>
Subject: Stock 2.6.4 with CONFIG_LBD=y and qla2xxx driver, reports wrong device
 size
Date: Wed, 24 Mar 2004 12:53:05 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4061F531.50808@physics.ucsd.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from newport.ucsd.edu ([132.239.73.89]:17088 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S261682AbUCXUxG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Mar 2004 15:53:06 -0500
Received: from physics.ucsd.edu (newport [127.0.0.1])
	by localhost.localdomain (8.12.10/8.12.10) with ESMTP id i2OKr5LH003121
	for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2004 12:53:05 -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a stock 2.6.4 kernel with CONFIG_LBD=y turned on in my kernel 
(confirmed via /proc/config.gz) but when the module is loaded I still get

SCSI device sdb: 191162368 512-byte hdwr sectors (97875 MB)
SCSI device sdb: drive cache: write through
 sdb:

I expect to get 4,287,645MB as that is what my Infortrend RAID array is 
set up for a partition size. Is there something, in addition to the LBD 
support in 2.6 that I need to do with the SCSI driver itself, in the 
case the qla2300 drivers that come with 2.6.4, to allow larger than 2TB 
block devices?

Platform is Intel Xeon dual with 2GB of RAM. Base OS is fedora core 1 
with changes to support 2.6 series kernels.

Smaller than 2TB file systems on the other hand work fine (aside from a 
strange performance issue where reads are not as fast as writes under 
both 2.4 and 2.6).

Thanks,

Terrence

