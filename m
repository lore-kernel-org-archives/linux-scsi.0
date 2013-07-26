From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH 0/7] scsi: ufs: some fixes and updates
Date: Fri, 26 Jul 2013 22:44:57 +0900
Message-ID: <001b01ce8a06$514953c0$f3dbfb40$%jun@samsung.com>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com>
 <1374280885-11526-3-git-send-email-mita@fixstars.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:36832 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758829Ab3GZNo7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jul 2013 09:44:59 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MQJ00LMDQ6YKFT0@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Fri, 26 Jul 2013 22:44:58 +0900 (KST)
In-reply-to: <1374280885-11526-3-git-send-email-mita@fixstars.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

This path series contain driver's fixes and updates.

Seungwon Jeon (7):
      scsi: ufs: amend the ocs handling with fatal error
      scsi: ufs: find out sense data over scsi status values
      scsi: ufs: fix the setting interrupt aggregation counter
      scsi: ufs: add dme configuration primitives
      scsi: ufs: add unipro attribute IDs
      scsi: ufs: add operation for the uic power mode change
      scsi: ufs: configure the attribute for power mode

 drivers/scsi/ufs/ufs.h    |    1 +
 drivers/scsi/ufs/ufshcd.c |  325 +++++++++++++++++++++++++++++++++++++++------
 drivers/scsi/ufs/ufshcd.h |   54 ++++++++
 drivers/scsi/ufs/ufshci.h |   22 +++-
 drivers/scsi/ufs/unipro.h |  151 +++++++++++++++++++++
 5 files changed, 507 insertions(+), 46 deletions(-)

Thanks,
Seungwon Jeon

