From: Karthik Sarangan <karthiks@cdac.in>
Subject: accessing the scsi disk from a kernel module
Date: Fri, 30 Sep 2005 10:57:46 +0530
Message-ID: <433CCCD2.3000003@cdac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.cdacindia.com ([203.199.132.35]:63935 "HELO
	mailx.cdac.ernet.in") by vger.kernel.org with SMTP id S1751098AbVI3FeQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Sep 2005 01:34:16 -0400
Received: from mailhub.cdac.in ([196.1.109.254])
 by mailx.cdac.ernet.in (SAVSMTP 3.1.0.29) with SMTP id M2005093011040001586
 for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2005 11:04:00 +0530
Received: from mailhub.cdac.in (mailhub [196.1.109.254])
	by mailhub.cdac.in (8.13.4/8.13.4) with ESMTP id j8U5Xps7007524
	for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2005 11:03:51 +0530
Received: from [192.168.5.68] (karthiks.htdg.cdac.ernet.in [192.168.5.68])
	by mailhub.cdac.in (8.13.4/8.13.4) with ESMTP id j8U5Xo3H007521
	for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2005 11:03:50 +0530
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

what do I write in a kernel module for accessing a scsi disk device?

