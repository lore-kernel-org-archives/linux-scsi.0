Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E45C433E1
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 17:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BB9F20774
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 17:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731680AbgFIRRz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 13:17:55 -0400
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:54520 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728783AbgFIRRy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 13:17:54 -0400
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 09 Jun 2020 10:17:53 -0700
Received: from asutoshd-linux1.qualcomm.com ([10.46.160.39])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 09 Jun 2020 10:17:53 -0700
Received: by asutoshd-linux1.qualcomm.com (Postfix, from userid 92687)
        id 1EBFA20C1D; Tue,  9 Jun 2020 10:17:53 -0700 (PDT)
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     gregkh@google.com, cang@codeaurora.org, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/1] Documentation:sysfs-ufs: Add WriteBooster documentation
Date:   Tue,  9 Jun 2020 10:17:46 -0700
Message-Id: <1591723067-22998-1-git-send-email-asutoshd@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Adds sysfs documentation for WriteBooster entries.

Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 136 +++++++++++++++++++++++++++++
 1 file changed, 136 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 016724e..d1a3521 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -883,3 +883,139 @@ Contact:	Subhash Jadavani <subhashj@codeaurora.org>
 Description:	This entry shows the target state of an UFS UIC link
 		for the chosen system power management level.
 		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/wb_presv_us_en
+Date:		June 2020
+Contact:	Asutosh Das <asutoshd@codeaurora.org>
+Description:	This entry shows if preserve user-space was configured
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/wb_shared_alloc_units
+Date:		June 2020
+Contact:	Asutosh Das <asutoshd@codeaurora.org>
+Description:	This entry shows the shared allocated units of WB buffer
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/wb_type
+Date:		June 2020
+Contact:	Asutosh Das <asutoshd@codeaurora.org>
+Description:	This entry shows the configured WB type.
+		0x1 for shared buffer mode. 0x0 for dedicated buffer mode.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb_buff_cap_adj
+Date:		June 2020
+Contact:	Asutosh Das <asutoshd@codeaurora.org>
+Description:	This entry shows the total user-space decrease in shared
+		buffer mode.
+		The value of this parameter is 3 for TLC NAND when SLC mode
+		is used as WriteBooster Buffer. 2 for MLC NAND.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb_max_alloc_units
+Date:		June 2020
+Contact:	Asutosh Das <asutoshd@codeaurora.org>
+Description:	This entry shows the Maximum total WriteBooster Buffer size
+		which is supported by the entire device.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb_max_wb_luns
+Date:		June 2020
+Contact:	Asutosh Das <asutoshd@codeaurora.org>
+Description:	This entry shows the maximum number of luns that can support
+		WriteBooster.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb_sup_red_type
+Date:		June 2020
+Contact:	Asutosh Das <asutoshd@codeaurora.org>
+Description:	The supportability of user space reduction mode
+		and preserve user space mode.
+		00h: WriteBooster Buffer can be configured only in
+		user space reduction type.
+		01h: WriteBooster Buffer can be configured only in
+		preserve user space type.
+		02h: Device can be configured in either user space
+		reduction type or preserve user space type.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb_sup_wb_type
+Date:		June 2020
+Contact:	Asutosh Das <asutoshd@codeaurora.org>
+Description:	The supportability of WriteBooster Buffer type.
+		00h: LU based WriteBooster Buffer configuration
+		01h: Single shared WriteBooster Buffer
+		configuration
+		02h: Supporting both LU based WriteBooster
+		Buffer and Single shared WriteBooster Buffer
+		configuration
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/flags/wb_enable
+Date:		June 2020
+Contact:	Asutosh Das <asutoshd@codeaurora.org>
+Description:	This entry shows the status of WriteBooster.
+		0: WriteBooster is not enabled.
+		1: WriteBooster is enabled
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/flags/wb_flush_en
+Date:		June 2020
+Contact:	Asutosh Das <asutoshd@codeaurora.org>
+Description:	This entry shows if flush is enabled.
+		0: Flush operation is not performed.
+		1: Flush operation is performed.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/flags/wb_flush_during_h8
+Date:		June 2020
+Contact:	Asutosh Das <asutoshd@codeaurora.org>
+Description:	Flush WriteBooster Buffer during hibernate state.
+		0: Device is not allowed to flush the
+		WriteBooster Buffer during link hibernate
+		state.
+		1: Device is allowed to flush the
+		WriteBooster Buffer during link hibernate
+		state
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_avail_buf
+Date:		June 2020
+Contact:	Asutosh Das <asutoshd@codeaurora.org>
+Description:	This entry shows the amount of unused WriteBooster buffer
+		available.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_cur_buf
+Date:		June 2020
+Contact:	Asutosh Das <asutoshd@codeaurora.org>
+Description:	This entry shows the amount of unused current buffer.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_flush_status
+Date:		June 2020
+Contact:	Asutosh Das <asutoshd@codeaurora.org>
+Description:	This entry shows the flush operation status.
+		00h: idle
+		01h: Flush operation in progress
+		02h: Flush operation stopped prematurely.
+		03h: Flush operation completed successfully
+		04h: Flush operation general failure
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_life_time_est
+Date:		June 2020
+Contact:	Asutosh Das <asutoshd@codeaurora.org>
+Description:	This entry shows an indication of the WriteBooster Buffer
+		lifetime based on the amount of performed program/erase cycles
+		01h: 0% - 10% WriteBooster Buffer life time used
+		...
+		0Ah: 90% - 100% WriteBooster Buffer life time used
+		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/unit_descriptor/wb_buf_alloc_units
+Date:		June 2020
+Contact:	Asutosh Das <asutoshd@codeaurora.org>
+Description:	This entry shows the configured size of WriteBooster buffer.
+		0400h corresponds to 4GB.
+		The file is read only.
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

