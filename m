From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 27/55] scsi: Mark functions as static in
 megaraid/megaraid_sas_base.c
Date: Sat, 29 Mar 2014 23:43:49 +0530
Message-ID: <0a8952dcd884d23345a692e0f5933f6e64fe8015.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark functions as static in megaraid/megaraid_sas_base.c because they
are not used outside this file.

This eliminates the following warnings in megaraid/megaraid_sas_base.c:
drivers/scsi/megaraid/megaraid_sas_base.c:180:1: warning: no previous p=
rototype for =E2=80=98megasas_issue_dcmd=E2=80=99 [-Wmissing-prototypes=
]
drivers/scsi/megaraid/megaraid_sas_base.c:1739:6: warning: no previous =
prototype for =E2=80=98megasas_do_ocr=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/m=
egaraid/megaraid_sas_base.c
index 3b7ad10..9768deee 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -176,7 +176,7 @@ void megasas_reset_reply_desc(struct megasas_instan=
ce *instance);
 int megasas_reset_fusion(struct Scsi_Host *shost);
 void megasas_fusion_ocr_wq(struct work_struct *work);
=20
-void
+static void
 megasas_issue_dcmd(struct megasas_instance *instance, struct megasas_c=
md *cmd)
 {
 	instance->instancet->fire_cmd(instance,
@@ -1736,7 +1736,7 @@ megasas_internal_reset_defer_cmds(struct megasas_=
instance *instance);
 static void
 process_fw_state_change_wq(struct work_struct *work);
=20
-void megasas_do_ocr(struct megasas_instance *instance)
+static void megasas_do_ocr(struct megasas_instance *instance)
 {
 	if ((instance->pdev->device =3D=3D PCI_DEVICE_ID_LSI_SAS1064R) ||
 	(instance->pdev->device =3D=3D PCI_DEVICE_ID_DELL_PERC5) ||
--=20
1.7.9.5
