From: Maurice Volaski <mvolaski@aecom.yu.edu>
Subject: [Q] What causes an LSI card to experience a "phase change 2-7
 16@f9c95f60 resid=10"?
Date: Sat, 27 Dec 2008 23:53:06 -0500
Message-ID: <a06240407c57cb2865071@[129.98.90.227]>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.aecom.yu.edu ([129.98.1.51]:60647 "EHLO mx1.aecom.yu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbYL1FRD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Dec 2008 00:17:03 -0500
Received: from draco.aecom.yu.edu (draco.aecom.yu.edu [129.98.1.160])
	by mx1.aecom.yu.edu (Postfix) with ESMTP id 496D79F0039
	for <linux-scsi@vger.kernel.org>; Sat, 27 Dec 2008 23:54:45 -0500 (EST)
Received: from smtp2.aecom.yu.edu (smtp2.aecom.yu.edu [129.98.1.62])
	by draco.aecom.yu.edu (Symantec Mail Security) with ESMTP id D54F5718002
	for <linux-scsi@vger.kernel.org>; Sat, 27 Dec 2008 23:54:44 -0500 (EST)
Received: from [129.98.90.227] (usseinstein.aecom.yu.edu [129.98.90.227])
	by smtp2.aecom.yu.edu (Postfix) with ESMTP id A560EB66F
	for <linux-scsi@vger.kernel.org>; Sat, 27 Dec 2008 23:54:44 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I attached a hardware RAID with 3.5 TB partitions to a 64-bit Linux 
box (kernel 2.6.27) with a 53c1010 LSI HBA using the sym53c8xx 
driver, and at startup it complains with various messages:


>Dec 19 17:25:58 [kernel] [   11.512044] sd 4:0:0:5: Attached scsi 
>generic sg6 type 0
>Dec 19 17:25:58 [kernel] [   11.512594] sd 4:0:0:6: [sdh] Very big 
>device. Trying to use READ CAPACITY(16).
>Dec 19 17:25:58 [kernel] [   11.512673] sd 4:0:0:6: phase change 2-7 
>16@f9c95f60 resid=10.
>Dec 19 17:25:58 [kernel] [   11.516166] sd 4:0:0:6: [sdh] 6840264704 
>512-byte hardware sectors (3502216 MB)
>Dec 19 17:25:58 [kernel] [   11.516419] sd 4:0:0:6: [sdh] Write Protect is off
>Dec 19 17:25:58 [kernel] [   11.517326] sd 4:0:0:6: [sdh] Write 
>cache: enabled, read cache: enabled, doesn't support DPO or FUA
>Dec 19 17:25:58 [kernel] [   11.517758] sd 4:0:0:6: [sdh] Very big 
>device. Trying to use READ CAPACITY(16).
>Dec 19 17:25:58 [kernel] [   11.517838] sd 4:0:0:6: phase change 2-7 
>16@f9d0df60 resid=10.
>Dec 19 17:25:58 [kernel] [   11.517982] sd 4:0:0:6: [sdh] 6840264704 
>512-byte hardware sectors (3502216 MB)
>Dec 19 17:25:58 [kernel] [   11.518177] sd 4:0:0:6: [sdh] Write Protect is off
>Dec 19 17:25:58 [kernel] [   11.518560] sd 4:0:0:6: [sdh] Write 
>cache: enabled, read cache: enabled, doesn't support DPO or FUA
>Dec 19 17:25:58 [kernel] [   11.518564]  sdh: unknown partition table
>Dec 19 17:25:58 [kernel] [   11.519212] sd 4:0:0:6: [sdh] Attached SCSI disk
>Dec 19 17:25:58 [kernel] [   11.519357] sd 4:0:0:6: Attached scsi 
>generic sg7 type 0
>Dec 19 17:25:58 [kernel] [   11.520553] sd 4:0:0:1: extraneous data discarded.
>Dec 19 17:25:58 [kernel] [   11.520560] sd 4:0:0:1: COMMAND FAILED (87 0 1).
>Dec 19 17:25:58 [kernel] [   11.520851] sd 4:0:0:1: extraneous data discarded.
>Dec 19 17:25:58 [kernel] [   11.520855] sd 4:0:0:1: COMMAND FAILED (87 0 1).
>Dec 19 17:25:58 [kernel] [   11.561838] sd 4:0:0:1: phase change 2-7 
>16@f9c95f60 resid=10.
>Dec 19 17:25:58 [kernel] [   11.562130] end_request: I/O error, dev 
>sdc, sector 6833978240
>Dec 19 17:25:58 [kernel] [   11.562135] Buffer I/O error on device 
>sdc, logical block 854247280

This same hardware RAID runs with no problem on a very similar system 
running a 53c1030 LSI HBA and the mptspi driver.

Is there some limitation in the older 53c1010 that is tripping it up 
on this hardware, a capacity limitation, perhaps?
-- 

Maurice Volaski, mvolaski@aecom.yu.edu
Computing Support, Rose F. Kennedy Center
Albert Einstein College of Medicine of Yeshiva University
