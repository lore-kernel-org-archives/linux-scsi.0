From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCH] qla4xxx: kconfig must select scsi_iscsi_attrs
Date: Fri, 11 Aug 2006 19:14:29 -0500
Message-ID: <20060812001429.23423.29164.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:38307 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S932451AbWHLATO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Aug 2006 20:19:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

From: Doug Maxey <dwm@enoyolf.org>

The qla4xxx driver depends on scsi_transport_iscsi.o which needs
SCSI_ISCSI_ATRS selected.  Make it so when building qla4xxx.

Signed-off-by: Doug Maxey <dwm@enoyolf.org>
---

 drivers/scsi/qla4xxx/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/Kconfig b/drivers/scsi/qla4xxx/Kconfig
index 6492798..e496042 100644
--- a/drivers/scsi/qla4xxx/Kconfig
+++ b/drivers/scsi/qla4xxx/Kconfig
@@ -1,5 +1,6 @@
 config SCSI_QLA_ISCSI
 	tristate "QLogic ISP4XXX host adapter family support"
 	depends on PCI && SCSI
+	select SCSI_ISCSI_ATTRS
 	---help---
 	This driver supports the QLogic 40xx (ISP4XXX) host adapter family.
