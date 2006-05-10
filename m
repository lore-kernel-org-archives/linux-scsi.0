From: Mirko Benz <mirko.benz@web.de>
Subject: LSI megaraid sas performance
Date: Wed, 10 May 2006 16:03:44 +0200
Message-ID: <4461F2C0.3090903@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 162.237.80.212.versanetonline.de ([212.80.237.162]:10412 "EHLO
	cheetah.dd.xiranet.com") by vger.kernel.org with ESMTP
	id S1751393AbWEJOEA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 May 2006 10:04:00 -0400
Received: from [192.168.0.242] (dhcp242.dd.xiranet.com [192.168.0.242])
	(authenticated bits=0)
	by cheetah.dd.xiranet.com (8.13.4/8.13.4/Debian-1) with ESMTP id k4AE3oiT001856
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 10 May 2006 16:03:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

We are testing the LSI 8480E SAS RAID controller with the following setup:
-  Dual XEON server, 1 GB RAM
- 12 SATA II disks in Promise J300S SAS JBOD connected with a single x4 
SAS cable
- stripe size is 64k, write back caching enabled

Measured with IOMETER. First two values are for read/write with 64 kb 
block size with sequential I/O. Default test is RANDOM I/O 2/3 read + 
1/3 write at 2k block size.

- Windows 2003 Server-64 bit:
RAID 0 - R: 606 MB/s, W: 335 MB/s, Default: 820 IOPS
RAID 5 - R: 593 MB/s, W: 304 MB/s, Default: 475 IOPS
//RAID 0 write should be better but otherwise ok

- Linux 2.6.16.9-64 bit:
RAID 0 - R: 165 MB/s, W: 373 MB/s, Default: 76 IOPS
RAID 5 - R: 147 MB/s, W: 285 MB/s, Default: 74 IOPS

READ performance is bad. Random I/O is like a single disk. The 8408 
(internal version) shows the same behaveour. Has anyone else results for 
this controller or suggestions to improve this?

Thanks,
Mirko
