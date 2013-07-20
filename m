From: Akinobu Mita <mita@fixstars.com>
Subject: [PATCH v2 0/3] ufs: fix bugs in probing and removing driver paths
Date: Sat, 20 Jul 2013 09:41:22 +0900
Message-ID: <1374280885-11526-1-git-send-email-mita@fixstars.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo.fixstars.hdemail.jp ([176.34.54.138]:45347 "EHLO
	mo.fixstars.hdemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab3GTAqF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jul 2013 20:46:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <mita@fixstars.com>, Seungwon Jeon <tgih.jun@samsung.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

The changes in this patch set are almost same as the previous one
that I send on Jul 8.  But the previous version wasn't cleanly applied
to the upstream kernel because it depend on my local work in progress
patches.  So this version fixes it and it also includes another bug fix
in the same area.

Akinobu Mita (3):
  ufshcd-pci: release ioremapped region during removing driver
  ufs: don't disable_irq() if the IRQ can be shared among devices
  ufs: don't stop controller before scsi_remove_host()

 drivers/scsi/ufs/ufshcd-pci.c    | 38 +++++++++-----------------------------
 drivers/scsi/ufs/ufshcd-pltfrm.c |  1 -
 drivers/scsi/ufs/ufshcd.c        |  2 +-
 3 files changed, 10 insertions(+), 31 deletions(-)

Cc: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org

-- 
1.8.3.1

