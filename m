From: Mark Lord <lsml@rtr.ca>
Subject: libata:  BLKFLSBUF ioctl broken
Date: Thu, 21 Oct 2004 17:04:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4178244E.1060906@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpu1185.adsl.bellglobal.com ([207.236.110.166]:44422 "EHLO
	mail.rtr.ca") by vger.kernel.org with ESMTP id S270939AbUJUVGK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 17:06:10 -0400
Received: from [10.0.0.3] (ibbm.localnet [10.0.0.3])
	by mail.rtr.ca (Postfix) with ESMTP id 139B18300B7
	for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2004 17:06:10 -0400 (EDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Like the subject line says.. BLKFLSBUF (and friends) are broken for SATA.
I'm getting tons of emails about this now that 2.6.9 is out.

Jeff: any chance of you fixing this soon?

Cheers
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
