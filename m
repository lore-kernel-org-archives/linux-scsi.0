From: MShetty <mranalini.shetty@patni.com>
Subject: Redirecting request
Date: Mon, 28 Oct 2002 19:15:47 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DBD3F8B.CDA9F96B@patni.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rakshak.patni.com (rakshak.patni.com [203.124.139.211])
	by pcsbom.patni.com (8.9.3/8.8.8) with SMTP id TAA28396
	for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2002 19:05:24 +0530 (IST)
Received: from akash.patni.com ([192.168.0.12])
 by rakshak.patni.com (NAVGW 2.5.2.12) with SMTP id M2002102819052423202
 for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2002 19:05:24 +0530
Received: from patni.com ([204.165.187.192]) by akash.patni.com (8.9.3/SCO5) with ESMTP id TAA29588 for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2002 19:05:23 +0530 (IST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hi,

In my make_request function (registered with blk_queue_make_request) I
want to redirect the current request to "sd". To achieve this is it
sufficient to write :
bh->b_rdev = MKDEV(SCSI_DISK0_MAJOR, 0);

where bh is buffer_head

Thanks and Regards,
M Shetty

