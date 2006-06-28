From: Brian King <brking@us.ibm.com>
Subject: [PATCH 2/3] ipr: Handle new SAS error codes
Date: Wed, 28 Jun 2006 08:46:41 -0500
Message-ID: <200606281346.k5SDkgx0023359@d01av03.pok.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Add definitions for some SAS error codes that can be
logged by ipr SAS adapters.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/ipr.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_sas_errors drivers/scsi/ipr.c
--- libata-dev/drivers/scsi/ipr.c~ipr_sas_errors	2006-06-27 14:49:10.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/ipr.c	2006-06-27 14:49:10.000000000 -0500
@@ -176,6 +176,8 @@ struct ipr_error_table_t ipr_error_table
 	"Qualified success"},
 	{0x01080000, 1, 1,
 	"FFFE: Soft device bus error recovered by the IOA"},
+	{0x01088100, 0, 1,
+	"4101: Soft device bus fabric error"},
 	{0x01170600, 0, 1,
 	"FFF9: Device sector reassign successful"},
 	{0x01170900, 0, 1,
@@ -226,6 +228,8 @@ struct ipr_error_table_t ipr_error_table
 	"3109: IOA timed out a device command"},
 	{0x04088000, 0, 0,
 	"3120: SCSI bus is not operational"},
+	{0x04088100, 0, 1,
+	"4100: Hard device bus fabric error"},
 	{0x04118000, 0, 1,
 	"9000: IOA reserved area data check"},
 	{0x04118100, 0, 1,
@@ -274,6 +278,14 @@ struct ipr_error_table_t ipr_error_table
 	"9091: Incorrect hardware configuration change has been detected"},
 	{0x04678000, 0, 1,
 	"9073: Invalid multi-adapter configuration"},
+	{0x04678100, 0, 1,
+	"4010: Incorrect connection between cascaded expanders"},
+	{0x04678200, 0, 1,
+	"4020: Connections exceed IOA design limits"},
+	{0x04678300, 0, 1,
+	"4030: Incorrect multipath connection"},
+	{0x04679000, 0, 1,
+	"4110: Unsupported enclosure function"},
 	{0x046E0000, 0, 1,
 	"FFF4: Command to logical unit failed"},
 	{0x05240000, 1, 0,
@@ -320,6 +332,16 @@ struct ipr_error_table_t ipr_error_table
 	"3150: SCSI bus configuration error"},
 	{0x06678100, 0, 1,
 	"9074: Asymmetric advanced function disk configuration"},
+	{0x06678300, 0, 1,
+	"4040: Incomplete multipath connection between IOA and enclosure"},
+	{0x06678400, 0, 1,
+	"4041: Incomplete multipath connection between enclosure and device"},
+	{0x06678500, 0, 1,
+	"Incomplete multipath connection between IOA and remote IOA"},
+	{0x06678600, 0, 1,
+	"9076: Configuration error, missing remote IOA"},
+	{0x06679100, 0, 1,
+	"4050: Enclosure does not support a required multipath function"},
 	{0x06690200, 0, 1,
 	"9041: Array protection temporarily suspended"},
 	{0x06698200, 0, 1,
@@ -332,6 +354,10 @@ struct ipr_error_table_t ipr_error_table
 	"9072: Link not operational transition"},
 	{0x066B8200, 0, 1,
 	"9032: Array exposed but still protected"},
+	{0x066B9100, 0, 1,
+	"4061: Multipath redundancy level got better"},
+	{0x066B9200, 0, 1,
+	"4060: Multipath redundancy level got worse"},
 	{0x07270000, 0, 0,
 	"Failure due to other device"},
 	{0x07278000, 0, 1,
_
