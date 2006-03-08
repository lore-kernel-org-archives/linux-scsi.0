From: ravi.anand@qlogic.com
Subject: [PATCH 11/11] Updated scsi/Kconfig to include qla4xxx/Kconfig path.
Date: Tue, 7 Mar 2006 16:36:08 -0800
Message-ID: <1141778163901-git-send-email-ravi.anand@qlogic.com>
References: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:39155 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S964862AbWCHAgM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2006 19:36:12 -0500
In-Reply-To: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, arjan@infradead.org
Cc: ravi.anand@qlogic.com

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>


---

 drivers/scsi/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

561680121f1a6cb28b1c770589aa18320d4689b7
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3c606cf..2ca97cf 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1340,6 +1340,7 @@ config SCSI_QLOGICPTI
 	  module will be called qlogicpti.
 
 source "drivers/scsi/qla2xxx/Kconfig"
+source "drivers/scsi/qla4xxx/Kconfig"
 
 config SCSI_LPFC
 	tristate "Emulex LightPulse Fibre Channel Support"
-- 
1.2.4.g9201-dirty


