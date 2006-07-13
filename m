From: Kokachev Oleksiy <o.kokachev@samsung.com>
Subject: FW: sd_rescan does not re-read partitions on disk
Date: Thu, 13 Jul 2006 15:26:11 +0900
Message-ID: <004401c6a645$3c2d6500$73a5580a@swcenter.sec.samsung.co.kr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:46374 "EHLO
	mailout3.samsung.com") by vger.kernel.org with ESMTP
	id S932561AbWGMG0N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jul 2006 02:26:13 -0400
Received: from ep_mmp2 (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0J2B00ED6WJO4X@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 13 Jul 2006 15:26:12 +0900 (KST)
Received: from KOKACHEV ([10.88.165.115])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 HotFix 1.17 (built Jun 23
 2003)) with ESMTPA id <0J2B00ASVWJN3U@mmp2.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 13 Jul 2006 15:26:11 +0900 (KST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear all.
I found strange thing: why sd_rescan() does not re-read partition table?
If disk were changed, why this function syncs only info about whole disk,
but not about partitions in it?
Thanks a lot and best regards, Oleksiy.

