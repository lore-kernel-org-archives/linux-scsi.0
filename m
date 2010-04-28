From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 11/11] Adding MAINTAINERS for qla4xxx iSCSI driver.
Date: Wed, 28 Apr 2010 11:45:49 +0530
Message-ID: <20100428061549.GA11240@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:39025
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751021Ab0D1GTl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Apr 2010 02:19:41 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

From: Ravi Anand <ravi.anand@qlogic.com>

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 34f52a1..6f1247b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4478,6 +4478,14 @@ S:	Supported
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
1.7.0.5

