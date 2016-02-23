From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 3/7] hpsa: correct lun data caching bitmap definition
Date: Tue, 23 Feb 2016 15:16:22 -0600
Message-ID: <20160223211621.5968.86332.stgit@brunhilda>
References: <20160223210957.5968.6998.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:37169 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755221AbcBWVQX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Feb 2016 16:16:23 -0500
In-Reply-To: <20160223210957.5968.6998.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

The bitmap was changed after this definition was added
to the driver. Correcting the bitmap definition.

Reviewed-by: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Reviewed-by: Justin Lindley <justin.lindley@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa_cmd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 6a919ad..dffda96 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -289,7 +289,7 @@ struct SenseSubsystem_info {
 #define BMIC_IDENTIFY_CONTROLLER 0x11
 #define BMIC_SET_DIAG_OPTIONS 0xF4
 #define BMIC_SENSE_DIAG_OPTIONS 0xF5
-#define HPSA_DIAG_OPTS_DISABLE_RLD_CACHING 0x40000000
+#define HPSA_DIAG_OPTS_DISABLE_RLD_CACHING 0x80000000
 #define BMIC_SENSE_SUBSYSTEM_INFORMATION 0x66
 #define BMIC_SENSE_STORAGE_BOX_PARAMS 0x65
 

