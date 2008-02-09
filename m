From: Adrian Bunk <adrian.bunk@movial.fi>
Subject: scsi/arm/fas216.c compile error
Date: Sat, 9 Feb 2008 02:04:13 +0200
Message-ID: <20080209000413.GE6505@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:38978 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbYBIAD5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Feb 2008 19:03:57 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@HansenPartnership.com>, rmk@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Commit 30b0c37b27485a9cb897bfe3824f6f517b8c80d6 causes the following 
compile error:

<--  snip  -->

...
  CC      drivers/scsi/arm/fas216.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/arm/fas216.c: In function 'fas216_std_done':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/arm/fas216.c:2120: error: 'struct scsi_cmnd' has no member named 'request_bufflen'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/arm/fas216.c:2122: error: 'struct scsi_cmnd' has no member named 'use_sg'
make[4]: *** [drivers/scsi/arm/fas216.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

