From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] scsi: unnecessary double init_completion removed
Date: Tue, 23 Dec 2014 19:00:28 +0100
Message-ID: <1419357628-23050-1-git-send-email-der.herr@hofr.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: iscsi-driver@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
List-Id: linux-scsi@vger.kernel.org

The double call to init_completion(&ha->disable_acb_comp); looks like
an editing mistake only - dropped.

patch is against 3.18.0 linux-next

scripts/get_maintainer.pl -f drivers/scsi/qla4xxx/ql4_os.c returned
Vikas Chaudhary <vikas.chaudhary@qlogic.com> (supporter:QLOGIC QLA4XXX iS...)
but that no longer seems to be a valid e-mail address.

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/scsi/qla4xxx/ql4_os.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6d25879..0c1da76 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -8672,7 +8672,6 @@ static int qla4xxx_probe_adapter(struct pci_dev *pdev,
 	init_completion(&ha->disable_acb_comp);
 	init_completion(&ha->idc_comp);
 	init_completion(&ha->link_up_comp);
-	init_completion(&ha->disable_acb_comp);

 	spin_lock_init(&ha->hardware_lock);
 	spin_lock_init(&ha->work_lock);
--
1.7.10.4
