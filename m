From: Pat LaVarre <p.lavarre@ieee.org>
Subject: 2 KiB/block loopback found where
Date: 29 Sep 2003 09:50:00 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064850600.25057.7.camel@patehci2>
References: <1064271322.4797.9.camel@patehci2>
	 <1064847281.24854.2.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:37761 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263466AbTI2Pto
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2003 11:49:44 -0400
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 1F9A917FA
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2003 09:49:44 -0600 (MDT)
In-Reply-To: <1064847281.24854.2.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I want a 2 KiB/block loopback device to help debug udf.ko.

I get 0.5 KiB/block.  Did I fail to find an option or an appropriate
kernel patch, I do I have to write my own patch?  I'm guessing I'll find
2 KiB/block easy to fake, since 0.5 KiB divides evenly into 2 KiB.

Specifically, I want to see 2048 where now I see 512 in response to my
query `blockdev --getss`.  A more complete example console log follows:

Pat LaVarre

$
$ dd of=dd.bin bs=1M count=1 if=/dev/zero
1+0 records in
1+0 records out
$
$ ls -l dd.bin
-rw-rw-r--    1 pat      pat       1048576 Sep 29 09:43 dd.bin
$
$ sudo /sbin/losetup /dev/loop0 dd.bin
$
$ sudo blockdev --getss /dev/loop0
512
$



