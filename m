From: Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH linux/linux-next] [SCSI] mvsas: Fix compile warnings by using correct enums
Date: Wed, 20 Feb 2013 11:35:32 -0700
Message-ID: <1361385332-48092-1-git-send-email-tim.gardner@canonical.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:3580 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818Ab3BTSf5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Feb 2013 13:35:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Dan Williams <dan.j.williams@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jack Wang <jack_wang@usish.com>, linux-scsi@vger.kernel.org

Use enum symbols of the same value, but from the correct enum type definition.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jack Wang <jack_wang@usish.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/scsi/mvsas/mv_sas.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 078c639..90f3a77 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1153,10 +1153,10 @@ void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st)
 			phy->identify.device_type =
 				phy->att_dev_info & PORT_DEV_TYPE_MASK;
 
-			if (phy->identify.device_type == SAS_END_DEV)
+			if (phy->identify.device_type == SAS_END_DEVICE)
 				phy->identify.target_port_protocols =
 							SAS_PROTOCOL_SSP;
-			else if (phy->identify.device_type != NO_DEVICE)
+			else if (phy->identify.device_type != SAS_PHY_UNUSED)
 				phy->identify.target_port_protocols =
 							SAS_PROTOCOL_SMP;
 			if (oob_done)
-- 
1.7.9.5

