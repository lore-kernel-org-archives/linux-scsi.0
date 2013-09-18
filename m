From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 0/5] scsi_debug: several fixes related to data integrity support
Date: Wed, 18 Sep 2013 21:27:23 +0900
Message-ID: <1379507248-15929-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:34292 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3IRM2c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Sep 2013 08:28:32 -0400
Received: by mail-pd0-f170.google.com with SMTP id x10so7027567pdj.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Sep 2013 05:28:31 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Joe Perches <joe@perches.com>, Fengguang Wu <fengguang.wu@intel.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

This patch set includes bug fixes and a warning fix which are related
to the data integrity support for scsi_debug.

Akinobu Mita (5):
  scsi_debug: fix buffer overrun when DIF/DIX is enabled and virtual_gb
    > 0
  scsi_debug: factor out copying PI from dif_storep to prot_sglist
  scsi_debug: avoid partial copying PI from prot_sglist to dif_storep
  scsi_debug: fix invalid value check for guard module parameter
  scsi_debug: fix sparse warnings related to data integrity field

 drivers/scsi/scsi_debug.c | 137 ++++++++++++++++++++++++----------------------
 1 file changed, 73 insertions(+), 64 deletions(-)

Cc: Joe Perches <joe@perches.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

-- 
1.8.3.1

