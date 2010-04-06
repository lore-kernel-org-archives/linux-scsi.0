From: Ravi Anand <ravi.anand@qlogic.com>
Subject: [PATCH 12/12] Adding MAINTAINERS for qla4xxx iSCSI driver.
Date: Tue, 6 Apr 2010 03:14:47 -0700
Message-ID: <20100406101447.GS22922@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:27639 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab0DFKQ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2010 06:16:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 28d4bf0..70b05fd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4562,6 +4562,14 @@ S:	Supported
 F:	Documentation/scsi/LICENSE.qla2xxx
 F:	drivers/scsi/qla2xxx/
 
+QLOGIC QLA4XXX iSCSI DRIVER
+M:	Ravi Anand <ravi.anand@qlogic.com>
+M:	Vikas Chaudhary <vikas.chaudhary@qlogic.com>
+M:	iscsi-driver@qlogic.com
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/qla4xxx/
+
 QLOGIC QLA3XXX NETWORK DRIVER
 M:	Ron Mercer <ron.mercer@qlogic.com>
 M:	linux-driver@qlogic.com
-- 
1.6.0.2

----- End forwarded message -----
