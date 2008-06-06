From: Huang Weiyi <weiyi.huang@gmail.com>
Subject: include/scsi/scsi_cmnd.h: removed duplicated include
Date: Sat, 07 Jun 2008 07:37:19 +0800
Message-ID: <20080607073620.A07F.WEIYI.HUANG@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:60673 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757389AbYFFXhT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 19:37:19 -0400
Received: by wa-out-1112.google.com with SMTP id j37so905058waf.23
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jun 2008 16:37:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

Removed duplicated include <linux/blkdev.h>
in include/scsi/scsi_cmnd.h

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

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

