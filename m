From: Don Jessup <donj@asaca.com>
Subject: scsi::resize_dma_pool: WARNING,
Date: Mon, 15 Dec 2003 08:21:43 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031215162143.33772.qmail@web14525.mail.yahoo.com>
Reply-To: donj@asaca.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web14525.mail.yahoo.com ([216.136.224.54]:45755 "HELO
	web14525.mail.yahoo.com") by vger.kernel.org with SMTP
	id S263698AbTLOQVo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2003 11:21:44 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



  I was wondering why following message is happening and how I might be able
  to keep it from happening?    We do have a large number of scsi disk online,
  upto 48 disk online at once.     Is this problem with HBA?
  
  This is from linux kernel 2.4.22.


Dec 14 04:54:03 ITV_791477 kernel: scsi singledevice 2 0 11 0
Dec 14 04:54:03 ITV_791477 kernel: blk: queue cf21d8b4, I/O limit 4095Mb (mask
0xffffffff)
Dec 14 04:54:03 ITV_791477 kernel:   Vendor: 3ware     Model: Logical Disk 11  
Rev: 1.0
Dec 14 04:54:03 ITV_791477 kernel:   Type:   Direct-Access                     
ANSI SCSI revision: 00
Dec 14 04:54:03 ITV_791477 kernel: blk: queue cf21deb4, I/O limit 4095Mb (mask
0xffffffff)
Dec 14 04:54:03 ITV_791477 kernel: Attached scsi disk sdao at scsi2, channel 0,
id 11, lun 0
Dec 14 04:54:03 ITV_791477 kernel: scsi::resize_dma_pool: WARNING,
dma_sectors=27584, wanted=36720, scaling
Dec 14 04:54:03 ITV_791477 kernel:       WARNING, not enough memory, pool not
expanded
Dec 14 04:54:03 ITV_791477 kernel: SCSI device sdao: 488397168 512-byte hdwr
sectors (250059 MB)
Dec 14 04:54:03 ITV_791477 kernel:  sdao: sdao1


=====
Don Jessup
Asaca/Shibasoku Corp. of America
400 Corporate Circle, Unit G
Golden, CO  80401
303-278-1111 X232
donj@asaca.com
http://www.asaca.com
