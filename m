From: MShetty <mranalini.shetty@patni.com>
Subject: Executing a scsi command
Date: Thu, 07 Nov 2002 19:14:38 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DCA6E46.91894890@patni.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rakshak.patni.com (rakshak.patni.com [203.124.139.211])
	by pcsbom.patni.com (8.9.3/8.8.8) with SMTP id TAA24270
	for <linux-scsi@vger.kernel.org>; Thu, 7 Nov 2002 19:05:58 +0530 (IST)
Received: from akash.patni.com ([192.168.0.12])
 by rakshak.patni.com (NAVGW 2.5.2.12) with SMTP id M2002110719055730947
 for <linux-scsi@vger.kernel.org>; Thu, 07 Nov 2002 19:05:57 +0530
Received: from patni.com ([204.165.187.192]) by akash.patni.com (8.9.3/SCO5) with ESMTP id TAA07042 for <linux-scsi@vger.kernel.org>; Thu, 7 Nov 2002 19:05:55 +0530 (IST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hi,

I want to execute a scsi cmd from my driver. The API's that I found
(scsi_do_cmd, scsi_wait_req) require a pointer to the scsi_device or
scsi_host structure.. Any idea how I could get them.... given the major
and minor no. of the device to which the command is to be sent.

Is there an alternative way of executing a scsi_cmd ??

Would help if I could get some help on the above.

Thanks and Regards,
M Shetty

