From: "Edwards, Scott \(GE Healthcare\)" <J.Scott.Edwards@ge.com>
Subject: Write cache on SATA drives?
Date: Thu, 30 Jun 2005 16:39:17 -0500
Message-ID: <C664ABFF405D6A458806C03AA2E0FF6B0560E7CC@MKEMLVEM01.e2k.ad.ge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ext-nj2ut-1.online-age.net ([64.14.54.230]:6538 "EHLO
	ext-nj2ut-1.online-age.net") by vger.kernel.org with ESMTP
	id S263047AbVF3VjK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2005 17:39:10 -0400
Received: from int-nj2ut-1.online-age.net (int-nj2ut-1.online-age.net [3.159.237.70])
	by ext-nj2ut-1.online-age.net (8.12.11/8.12.10/20050401-SVVS) with ESMTP id j5ULcWHs002545
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2005 16:38:33 -0500
Received: from cinmlef05.e2k.ad.ge.com (localhost.localdomain [127.0.0.1])
	by int-nj2ut-1.online-age.net (8.11.6/8.11.6/20050510-SVVS) with ESMTP id j5ULbUY23953
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2005 16:37:30 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

Can anyone tell me if the write cache on SATA drives are handled such that journaling file systems work correctly?  Back in the 2.6.5 - 2.6.7 time frame I had to disable the write cache to get ext3 to not trash things when the power was lost.  With kernel 2.6.10 would I still need to disable the write cache?

Thanks
  -Scott

