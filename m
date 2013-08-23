From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH v2 0/6] scsi: ufs: some fixes and updates
Date: Fri, 23 Aug 2013 22:00:01 +0900
Message-ID: <002b01cea000$ade40890$09ac19b0$%jun@samsung.com>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com>
 <1374280885-11526-3-git-send-email-mita@fixstars.com>
 <001b01ce8a06$514953c0$f3dbfb40$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:42431 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab3HWNAD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Aug 2013 09:00:03 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MRZ00CU8IS23ZT0@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Fri, 23 Aug 2013 22:00:02 +0900 (KST)
In-reply-to: <001b01ce8a06$514953c0$f3dbfb40$%jun@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

This path series contain driver's fixes and updates.

Changes in v2:
- [scsi: ufs: amend the ocs handling with fatal error] is excluded.
   Host behavior needs to be defined clearly in UFSHCI specification.
- Some minor changes are applied with comments from Subhash, Sujit and Santosh.

Seungwon Jeon (6):
      scsi: ufs: find out sense data over scsi status values
      scsi: ufs: fix the setting interrupt aggregation counter
      scsi: ufs: add dme configuration primitives
      scsi: ufs: add unipro attribute IDs
      scsi: ufs: add operation for the uic power mode change
      scsi: ufs: configure the attribute for power mode

 drivers/scsi/ufs/ufs.h    |    1 +
 drivers/scsi/ufs/ufshcd.c |  336 ++++++++++++++++++++++++++++++++++++++-------
 drivers/scsi/ufs/ufshcd.h |   54 +++++++
 drivers/scsi/ufs/ufshci.h |   22 +++-
 drivers/scsi/ufs/unipro.h |  151 ++++++++++++++++++++
 5 files changed, 513 insertions(+), 51 deletions(-)

Thanks,
Seungwon Jeon

