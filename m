From: SL Baur <steve@kbuxd.necst.nec.co.jp>
Subject: Is the scsi-misc-2.5 BK tree corrupted?
Date: Thu, 12 Dec 2002 13:25:49 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <15864.4045.584597.590434@sofia.bsd2.kbnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgate4.nec.co.jp ([10.7.69.195])
	by TYO202.gate.nec.co.jp (8.11.6/3.7W01080315) with ESMTP id gBC4MBU25454
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2002 13:22:11 +0900 (JST)
Received: from mailsv4.nec.co.jp (mailgate51.nec.co.jp [10.7.69.196]) by mailgate4.nec.co.jp (8.11.6/3.7W-MAILGATE-NEC) with ESMTP
	id gBC4MBx07994 for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2002 13:22:11 +0900 (JST)
Received: from sv6l.kb.necst.nec.co.jp (ns1.kb.necst.nec.co.jp [10.108.80.236]) by mailsv4.nec.co.jp (8.11.6/3.7W-MAILSV4-NEC) with ESMTP
	id gBC4M6q02231 for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2002 13:22:07 +0900 (JST)
Received: from mailgw1 (mailgw1.kb.necst.nec.co.jp [172.16.1.207])
	by sv6l.kb.necst.nec.co.jp (8.11.6/8.11.6) with SMTP id gBC4M5688412
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2002 13:22:05 +0900 (JST)
	(envelope-from steve@kbuxd.necst.nec.co.jp)
Received: from ews-sv.kbuxd.necst.nec.co.jp (ews-sv.kbuxd.necst.nec.co.jp [172.16.28.93])
	by sv1.kbuxd.necst.nec.co.jp (8.11.6/3.7W) with ESMTP id gBC4M5281091
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2002 13:22:05 +0900 (JST)
Received: from sofia.bsd2.kbnes.nec.co.jp ([172.16.28.202])
	by ews-sv.kbuxd.necst.nec.co.jp (8.9.3/3.7W-02120910) with ESMTP id NAA09556
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2002 13:21:50 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am getting the following when attempting to pull from the current
scsi-misc-2.5 BK tree.


 ...
drivers/s390/block/dasd.c: 2 deltas
drivers/s390/block/dasd_eckd.c: 1 deltas
drivers/s390/char/Makefile: 1 deltas
drivers/s390/char/con3215.c BAD gzip hdr
fnext: No such file or directory

=================================== ERROR ====================================
takepatch: missing checksum line in patch, aborting.
==============================================================================


