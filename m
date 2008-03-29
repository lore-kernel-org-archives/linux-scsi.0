From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/5] scsi_debug: increase the amount of ram that scsi_ram can allocate
Date: Sun, 30 Mar 2008 00:59:53 +0900
Message-ID: <1206806398-22205-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:41057 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbYC2QAy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Mar 2008 12:00:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, James.Bottomley@HansenPartnership.com, dougg@torque.net, fujita.tomonori@lab.ntt.co.jp

Currently, the maximum amount of RAM that scsi_debug can actually
allocate is 4GB. This patchset increase it to 2TB.

Here's an example, scsi_debug allocates 6GB ram and exports it as if
it were 6GB disk.

fujita@rose:/sys/bus/pseudo/drivers/scsi_debug$ cat virtual_gb
0
fujita@rose:/sys/bus/pseudo/drivers/scsi_debug$ cat dev_size_mb
6144

scsi3 : scsi_debug, version 1.81 [20070104], dev_size_mb=6144, opts=0x0
scsi 3:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 ANSI: 5
sd 3:0:0:0: [sdc] 12582912 512-byte hardware sectors (6442 MB)


This patchset also include minor cleanup.

This is against scsi-misc with the scsi_build_sense_buffer helper
patchset and the scsi_debug lba fix:

http://marc.info/?l=linux-scsi&m=120640632301595&w=2

http://marc.info/?l=linux-scsi&m=120643343003171&w=2



