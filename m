Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 699D7C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 00:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3463264DAF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 00:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhB0AAz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Feb 2021 19:00:55 -0500
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:15849 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229618AbhB0AAz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Feb 2021 19:00:55 -0500
X-Greylist: delayed 950 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2021 19:00:54 EST
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 26 Feb 2021 15:44:14 -0800
Received: from localhost (vbhakta-dev1.eng.vmware.com [10.20.72.253])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 5248F206E8;
        Fri, 26 Feb 2021 15:44:19 -0800 (PST)
From:   Vishal Bhakta <vbhakta@vmware.com>
To:     <jejb@linux.ibm.com>
CC:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jgill@vmware.com>,
        <pv-drivers@vmware.com>, <vbhakta@vmware.com>
Subject: [PATCH] scsi: vmw_pvscsi: Update maintainer
Date:   Fri, 26 Feb 2021 15:43:48 -0800
Message-ID: <20210226234347.21535-1-vbhakta@vmware.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: vbhakta@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The entries in the source files are removed as well.

Signed-off-by: Vishal Bhakta <vbhakta@vmware.com>
---
 MAINTAINERS               | 2 +-
 drivers/scsi/vmw_pvscsi.c | 2 --
 drivers/scsi/vmw_pvscsi.h | 2 --
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 97c8f2bb8de2..eb9480220e1d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18999,7 +18999,7 @@ S:	Maintained
 F:	drivers/infiniband/hw/vmw_pvrdma/
 
 VMware PVSCSI driver
-M:	Jim Gill <jgill@vmware.com>
+M:	Vishal Bhakta <vbhakta@vmware.com>
 M:	VMware PV-Drivers <pv-drivers@vmware.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 081f54ab7d86..8a79605d9652 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -17,8 +17,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
  *
- * Maintained by: Jim Gill <jgill@vmware.com>
- *
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/scsi/vmw_pvscsi.h b/drivers/scsi/vmw_pvscsi.h
index 75966d3f326e..51a82f7803d3 100644
--- a/drivers/scsi/vmw_pvscsi.h
+++ b/drivers/scsi/vmw_pvscsi.h
@@ -17,8 +17,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
  *
- * Maintained by: Jim Gill <jgill@vmware.com>
- *
  */
 
 #ifndef _VMW_PVSCSI_H_
-- 
2.25.1

