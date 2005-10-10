From: Karthik Sarangan <karthiks@cdac.in>
Subject: ioctl for max_sectors
Date: Mon, 10 Oct 2005 10:09:03 +0530
Message-ID: <4349F067.1010007@cdac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.cdacindia.com ([203.199.132.35]:26617 "HELO
	mailx.cdac.ernet.in") by vger.kernel.org with SMTP id S932344AbVJJEp7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Oct 2005 00:45:59 -0400
Received: from mailhub.cdac.in ([196.1.109.254])
 by mailx.cdac.ernet.in (SAVSMTP 3.1.0.29) with SMTP id M2005101010153923449
 for <linux-scsi@vger.kernel.org>; Mon, 10 Oct 2005 10:15:39 +0530
Received: from mailhub.cdac.in (mailhub [196.1.109.254])
	by mailhub.cdac.in (8.13.4/8.13.4) with ESMTP id j9A4jMQC021979
	for <linux-scsi@vger.kernel.org>; Mon, 10 Oct 2005 10:15:22 +0530
Received: from [192.168.5.68] (karthiks.htdg.cdac.ernet.in [192.168.5.68])
	by mailhub.cdac.in (8.13.4/8.13.4) with ESMTP id j9A4jLY1021966
	for <linux-scsi@vger.kernel.org>; Mon, 10 Oct 2005 10:15:21 +0530
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

With what ioctl can I retrieve the max_sectors count of struct 
Scsi_Host_Template?

