From: Douglas Gilbert <dougg@torque.net>
Subject: drop scsi_register_blocked_host() in 2.5?
Date: Fri, 21 Feb 2003 12:24:37 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E557FD5.5080708@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-50.triode.net.au [202.147.125.50])
	by iggy.triode.net.au (8.12.7/8.12.7) with ESMTP id h1L1LQVY003421
	for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2003 12:21:28 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Just doing some documentation and noticed these two functions:
   - scsi_register_blocked_host()
   - scsi_deregister_blocked_host()
that return void and do nothing. See scsi_lib.c around line 1344
for Eric's comment. These functions are exported and the
eata and u14-34f drivers call them.

Time for Christoph's razor?

Doug Gilbert

