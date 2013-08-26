From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 0/2] scsi_debug: bug fixes for certain module parameters
Date: Mon, 26 Aug 2013 22:08:39 +0900
Message-ID: <1377522521-9371-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:56175 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab3HZNJ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2013 09:09:56 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so3430898pdj.36
        for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 06:09:56 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Martin Peschke <mpeschke@linux.vnet.ibm.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Hi James,

Please consider to apply these patches to your tree.  These patches are
subset of the patch set I sent before:
http://marc.info/?l=linux-scsi&m=137388918402750&w=2
I'm sending the patches which have been acked by the appropriate reviewers.
The rest of the patches need some rework, and I'll try to submit next time.

Akinobu Mita (2):
  scsi_debug: fix endianness bug in sdebug_build_parts()
  scsi_debug: fix logical block provisioning support when
    unmap_alignment != 0

 drivers/scsi/scsi_debug.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
-- 
1.8.3.1

