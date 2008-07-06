From: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: [PATCH] scsi_cmnd.h: remove double inclusion of linux/blkdev.h
Date: Sun, 6 Jul 2008 17:01:34 +0400
Message-ID: <a4423d670807060601sa56948ak812c4569297fada6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.231]:59170 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbYGFNBf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jul 2008 09:01:35 -0400
Received: by wx-out-0506.google.com with SMTP id h29so676139wxd.4
        for <linux-scsi@vger.kernel.org>; Sun, 06 Jul 2008 06:01:34 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

From: Alexander Beregalov <a.beregalov@gmail.com>

Remove double inclusion of linux/blkdev.h

 include/scsi/scsi_cmnd.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 3e46dfa..66c9448 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -7,7 +7,6 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
-#include <linux/blkdev.h>

 struct Scsi_Host;
 struct scsi_device;
