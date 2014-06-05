From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/4] ARM randconfig fixes for SCSI
Date: Thu,  5 Jun 2014 23:29:45 +0200
Message-ID: <1402003789-1990031-1-git-send-email-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:52306 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbaFEVa1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2014 17:30:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>, Matthew Wilcox <matthew@wil.cx>, Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>

Hi James,

These are some fixes for ancient randconfig build bugs I
ran into on ARM. Clearly none of these are urgent, but it
would be nice to have them merged for 3.17 if they look
good to you.

Arnd Bergmann (4):
  [SCSI] Don't build AdvanSys on ARM
  [SCSI] pas16: don't call free_dma()
  [SCSI] qlogicfas: don't call free_dma()
  [SCSI] NCR53c406a: don't call free_dma() by default

 drivers/scsi/Kconfig      | 2 +-
 drivers/scsi/NCR53c406a.c | 2 +-
 drivers/scsi/pas16.c      | 2 --
 drivers/scsi/qlogicfas.c  | 2 --
 4 files changed, 2 insertions(+), 6 deletions(-)

-- 
1.8.3.2

Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Michael Schmitz <schmitzmic@gmail.com>
