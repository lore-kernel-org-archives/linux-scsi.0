From: Thomas Tonino <ttonino@users.sf.net>
Subject: MPT Fusion performance
Date: Mon, 03 Mar 2003 15:17:10 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E6363E6.7070504@users.sf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from users.sf.net ([24.132.6.5]) by amsfep11-int.chello.nl
          (InterMail vM.5.01.05.17 201-253-122-126-117-20021021) with ESMTP
          id <20030303141710.FULS9305.amsfep11-int.chello.nl@users.sf.net>
          for <linux-scsi@vger.kernel.org>; Mon, 3 Mar 2003 15:17:10 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Our server manufacturer changed from Adaptec to the LSI53C1030 controller for 
the on board SCSI in their new models.

We see a performance problem; there seems to be a throughput limit around 15 to 
20 megabytes a second, with 2.4.20 and 2.4.20aa1 kernels, when writing to a 
single drive.

The same kernels perform much better on the old systems with AIC driver. We 
tried updating to driver 2.04 from lsil.com, and running the Red Hat Phoebe beta 
on the box.

Write speed with the latter fuctuates between 16 and 20 megabytes a second on a 
single drive. Read speed is fine: 54 MB/second on the same drive and file system.

Above performance was measured with iostat -x 5 and doing a dd if=/dev/zero 
of=testfile2 bs=10240 count=202400 on a reiserfs file system.

I wouldn't have expected an improvement goint to U320 SCSI, but neither this 
degradation. Any suggestions on what to try next?


Thomas

