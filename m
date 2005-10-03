From: Karthik Sarangan <karthiks@cdac.in>
Subject: SCSI disk speed inconsistency
Date: Mon, 03 Oct 2005 14:36:51 +0530
Message-ID: <4340F4AB.3070107@cdac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.cdacindia.com ([203.199.132.35]:37615 "HELO
	mailx.cdac.ernet.in") by vger.kernel.org with SMTP id S932195AbVJCJNk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Oct 2005 05:13:40 -0400
Received: from mailhub.cdac.in ([196.1.109.254])
 by mailx.cdac.ernet.in (SAVSMTP 3.1.0.29) with SMTP id M2005100314432103550
 for <linux-scsi@vger.kernel.org>; Mon, 03 Oct 2005 14:43:22 +0530
Received: from mailhub.cdac.in (mailhub [196.1.109.254])
	by mailhub.cdac.in (8.13.4/8.13.4) with ESMTP id j939Cvr3031585
	for <linux-scsi@vger.kernel.org>; Mon, 3 Oct 2005 14:42:57 +0530
Received: from [192.168.5.68] (karthiks.htdg.cdac.ernet.in [192.168.5.68])
	by mailhub.cdac.in (8.13.4/8.13.4) with ESMTP id j939Cu0J031579
	for <linux-scsi@vger.kernel.org>; Mon, 3 Oct 2005 14:42:57 +0530
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

I get a read speed of 69MBps from my SCSI disk and a write speed of 
49MBps from the same.
An IOMeter benchmark on the net says that 68MBps is the sustained speed 
for a write.

Could someone tell me how to increase my IO speed?

I have a Linux Kernel 2.6 in a RedHat Enterprise Linux WS 4 and I used 
the foll.
Read : sg_dd if=/dev/sdb  of=/dev/null bs=262144 count=1024 dio=1
Write: sg_dd if=/dev/zero of=/dev/sdb  bs=262144 count=1024 dio=1
