From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 0/4] scsi_debug: fix bugs with certain module parameters
Date: Mon, 15 Jul 2013 20:52:03 +0900
Message-ID: <1373889127-17083-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:47870 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab3GOLw7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jul 2013 07:52:59 -0400
Received: by mail-pb0-f47.google.com with SMTP id rr13so11051838pbb.20
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jul 2013 04:52:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

This patch set includes bug fixes with certain module parameters of
scsi_debug.  First one fixes bug with num_parts > 0.  Others fix logical
block provisioning support with unmap_alignment != 0 and with virtual_gb > 0.

Akinobu Mita (4):
  scsi_debug: fix endianness bug in sdebug_build_parts()
  scsi_debug: fix logical block provisioning support when
    unmap_alignment != 0
  scsi_debug: fix WRITE_SAME with virtual_gb > 0
  scsi_debug: fix out of range access by Get_LBA_status with virtual_gb
    > 0

 drivers/scsi/scsi_debug.c | 41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

-- 
1.8.3.1

