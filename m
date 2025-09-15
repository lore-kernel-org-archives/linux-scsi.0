Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FB041760;
	Mon, 15 Sep 2025 21:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757973149; cv=pass; b=Ne0J9MIaCw7xSzBzBZEeFgwH7e1ZTmFT+p66inpLuYYH1jllrMtiLTa/h9tHB/eoKJyhgr2yN140IfPAO6SeCGK1Zh7QUhtHOJ3F6xRzZliXk1aIqOtoZkKO6IH2PoCtC442fAuowSaozwNcdqN0S36TCeJ/KZLiBoMtbFlmSk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757973149; c=relaxed/simple;
	bh=H8eG9vNNgGOYUacJ3pRzrjM/P8hZLWIRIGOFmSsP8lQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ix7ATMnzaPxffWzIeqbPsnwpw2QIJNZ+XC2pevoPrzV03KZIKB7skaQwd2wjKVCBMLBk5AcEHNkEHgz4oyBlTtHPi5DkINnlZTsgVsx64KJO40Mj6K2s+YUm5vh4t8Zzwp7xb6NlAexKYUlyd0vISVrehxzEoI0/xHUpDjxwawM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=Ua93P5Le; arc=pass smtp.client-ip=85.215.255.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Ua93P5Le"
ARC-Seal: i=1; a=rsa-sha256; t=1757972782; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=heC5rkStJfUUcB2sleZp1KgnNZJsfXnDO8Q+VuAUaoc8dK5/RcOuoKwsDEgoWs6VAQ
    byDtjwCImRQgTtO6/D/PZO4WLkVZu27lPEPYeLdRLMvBdOx17O8fiCEh65XBm9N/9ETE
    fXiMAwZULA1ZvEuZ4vBDUMVlyfmJPMx9CcM8eSIqkU4/NzcqKZgmDHNldjkXG6YUhwN5
    D1NHehdjezamlU/79ZFNzzsN9Q2XxKiRBdh5Ufwken+kmjwcEAc1Y+2gLGhKVfhe73Sj
    DPcIrIigp5qa6FAbj2vXM3huKCh5jidEsA2IAHgyDi838gjoaJp8t32Z+yyPnHqTjBaJ
    yt4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1757972782;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=3hUbANO2dQm6Ld9IkNKnAXNibmg5snaRbUtt2lp6UV4=;
    b=Kj9Tt+0eL+c6qu5iI2LeaClyxAUDd0Fa51LHisCZM3onr80eibAsFmE2+PNT8a8gqX
    Lgl4wWUpq82xmFq7PXyUIVlWteyEfMTloDCCec772Sry+0OYByfNIXreKCz5QHge0ati
    FNqKbgPR5Zo7intwv2xcdQlUylG+xjuCdI8KBO+f7RgccI3OBjHRrVTSMlGH0Zf/3Xn+
    3cXxU3PxlHczYSeaEaP58tYDA14nT/Gm5+CzcwJPR5cAAoccXBjJz0iBBfY9ve12Z3gO
    lwV2Dl5QeXOxVQuPtk0jC9UHov1f/KXFq+XgTTZbkJ+mqJrvF0ywIuezvTyg01+AFnUO
    LMsA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1757972782;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=3hUbANO2dQm6Ld9IkNKnAXNibmg5snaRbUtt2lp6UV4=;
    b=Ua93P5Le5+gfmBShPmb+Zyn75lmR3yvSM9L8Ak5r4Shaq+CL2s9C+FdT06mF9MKiSy
    1VFifR4NT3YIS04NlgmOwnh+g5XiNDOcTt5ptXqxhHI8ppodPSMtLqCKIOkHN9hD3u4Q
    KUyV3XzTaVkLHqvJRmpTGKdZyPRNoh8L5M3T/pSTvekbihkvZc/Ja1YVSr0fSPemHBGO
    0bN0lju/J+k+y1pB/WD1mbU+xHVv8omM7VCqTTAOHY+gOY0lWfaZ6fcuTSE5LjJg7Wi9
    gQ+2Xoa2GwSOCAQwybHgqSJ1ZYyOzdY5YC9dvvUGELQLZN2czUUNsAjo/MLyw0OrRYeC
    B+sA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O256fJ4HnWXON1RCg6IWQdI9ZW5fgNTLz+ViCLXbUTDqukxFTraA="
Received: from Munilab01-lab.speedport.ip
    by smtp.strato.de (RZmta 52.1.2 AUTH)
    with ESMTPSA id z039d318FLkM3HE
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 15 Sep 2025 23:46:22 +0200 (CEST)
From: Bean Huo <beanhuo@iokpp.de>
To: avri.altman@wdc.com,
	bvanassche@acm.org,
	alim.akhtar@samsung.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	can.guo@oss.qualcomm.com,
	ulf.hansson@linaro.org,
	jens.wiklander@linaro.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mikebi@micron.com,
	lporzio@micron.com,
	Bean Huo <beanhuo@micron.com>
Subject: [RFC PATCH v1 2/2] scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices
Date: Mon, 15 Sep 2025 23:46:14 +0200
Message-Id: <20250915214614.179313-3-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250915214614.179313-1-beanhuo@iokpp.de>
References: <20250915214614.179313-1-beanhuo@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

From: Bean Huo <beanhuo@micron.com>

This patch adds OP-TEE based RPMB support for UFS devices, similar to
the existing eMMC implementation.

This implementation currently supports RPMB region0 only. Support for
additional RPMB regions can be added in future enhancements.

Benefits of OP-TEE based RPMB implementation:
- Eliminates dependency on userspace supplicant for RPMB access
- Enables early boot secure storage access (e.g., fTPM, secure UEFI variables)
- Provides kernel-level RPMB access as soon as UFS driver is initialized
- Removes complex initramfs dependencies and boot ordering requirements
- Ensures reliable and deterministic secure storage operations
- Supports both built-in and modular fTPM configurations

This enables secure RPMB operations on UFS devices through OP-TEE,
providing the same functionality available for eMMC devices and extending
kernel-based secure storage support to UFS-based systems.

Co-developed-by: Can Guo <can.guo@oss.qualcomm.com>
Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/misc/Kconfig           |   2 +-
 drivers/ufs/core/Makefile      |   1 +
 drivers/ufs/core/ufs-rpmb.c    | 174 +++++++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h |  13 +++
 drivers/ufs/core/ufshcd.c      |  34 +++++--
 include/ufs/ufs.h              |   4 +
 include/ufs/ufshcd.h           |   1 +
 7 files changed, 222 insertions(+), 7 deletions(-)
 create mode 100644 drivers/ufs/core/ufs-rpmb.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index b9ca56930003..46ffa62eac6e 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -106,7 +106,7 @@ config PHANTOM
 
 config RPMB
 	tristate "RPMB partition interface"
-	depends on MMC
+	depends on MMC || SCSI_UFSHCD
 	help
 	  Unified RPMB unit interface for RPMB capable devices such as eMMC and
 	  UFS. Provides interface for in-kernel security controllers to access
diff --git a/drivers/ufs/core/Makefile b/drivers/ufs/core/Makefile
index cf820fa09a04..51e1867e524e 100644
--- a/drivers/ufs/core/Makefile
+++ b/drivers/ufs/core/Makefile
@@ -2,6 +2,7 @@
 
 obj-$(CONFIG_SCSI_UFSHCD)		+= ufshcd-core.o
 ufshcd-core-y				+= ufshcd.o ufs-sysfs.o ufs-mcq.o
+ufshcd-core-$(CONFIG_RPMB)		+= ufs-rpmb.o
 ufshcd-core-$(CONFIG_DEBUG_FS)		+= ufs-debugfs.o
 ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
 ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO)	+= ufshcd-crypto.o
diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
new file mode 100644
index 000000000000..d672cf83a76c
--- /dev/null
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -0,0 +1,174 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * UFS OPTEE based RPMB Driver
+ *
+ * Copyright (C) 2025 Micron Technology, Inc
+ * Copyright (C) 2025 Qualcomm Innovation Center.
+ *
+ * Authors:
+ *	Bean Huo <beanhuo@micron.com>
+ *	Can Guo <can.guo@oss.qualcomm.com>
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/rpmb.h>
+#include <linux/string.h>
+#include <ufs/ufshcd.h>
+#include <linux/unaligned.h>
+#include "ufshcd-priv.h"
+
+#define UFS_RPMB_SEC_PROTOCOL	0xEC	/* JEDEC UFS application */
+#define UFS_RPMB_REGION_0	0x01	/* SECURITY PROTOCOL SPECIFIC: RPMB Protocl ID, Region 0 */
+
+
+/* UFS RPMB device structure */
+struct ufs_rpmb_dev {
+	struct rpmb_dev *rdev;
+	struct ufs_hba *hba;
+};
+
+static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, size_t len, bool send)
+{
+	struct scsi_device *sdev = hba->ufs_rpmb_wlun;
+	u8 cdb[12] = { 0, };
+	int ret;
+
+	cdb[0] = send ? SECURITY_PROTOCOL_OUT : SECURITY_PROTOCOL_IN;
+	cdb[1] = UFS_RPMB_SEC_PROTOCOL;
+	put_unaligned_be16(spsp, &cdb[2]);
+	put_unaligned_be32(len, &cdb[6]);
+
+	ret = scsi_execute_cmd(sdev, cdb, send ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
+	                       buffer, len,  /*timeout=*/30 * HZ, 0, NULL);
+	return ret <= 0 ? ret : -EIO;
+}
+
+/* UFS RPMB route frames implementation */
+static int ufs_rpmb_route_frames(struct device *dev, u8 *req,
+				unsigned int req_len, u8 *resp, unsigned int resp_len)
+{
+	struct ufs_rpmb_dev *ufs_rpmb = dev_get_drvdata(dev);
+	struct rpmb_frame *frm_out = (struct rpmb_frame *)req;
+	struct ufs_hba *hba = ufs_rpmb->hba;
+	bool need_result_read = true;
+	u16 req_type;
+	int ret;
+
+	if (!req || !req_len || !resp || !resp_len)
+		return -EINVAL;
+
+	req_type = be16_to_cpu(frm_out->req_resp);
+	switch (req_type) {
+	case RPMB_PROGRAM_KEY:
+		if (req_len != sizeof(struct rpmb_frame) ||
+		    resp_len != sizeof(struct rpmb_frame))
+			return -EINVAL;
+		break;
+	case RPMB_GET_WRITE_COUNTER:
+		if (req_len != sizeof(struct rpmb_frame) ||
+		    resp_len != sizeof(struct rpmb_frame))
+			return -EINVAL;
+		need_result_read = false;
+		break;
+	case RPMB_WRITE_DATA:
+		if (req_len % sizeof(struct rpmb_frame) ||
+		    resp_len != sizeof(struct rpmb_frame))
+			return -EINVAL;
+		break;
+	case RPMB_READ_DATA:
+		if (req_len != sizeof(struct rpmb_frame) ||
+		    resp_len % sizeof(struct rpmb_frame))
+			return -EINVAL;
+		need_result_read = false;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = ufs_sec_submit(hba, UFS_RPMB_REGION_0, req, req_len, true);
+	if (ret)
+		return ret;
+
+	if (need_result_read) {
+		struct rpmb_frame *frm_resp = (struct rpmb_frame *)resp;
+		memset(frm_resp, 0, sizeof(*frm_resp));
+		frm_resp->req_resp = cpu_to_be16(RPMB_RESULT_READ);
+		ret = ufs_sec_submit(hba, UFS_RPMB_REGION_0, resp, resp_len, true);
+	}
+
+	if (!ret)
+		ret = ufs_sec_submit(hba, UFS_RPMB_REGION_0, resp, resp_len, false);
+
+	return ret;
+}
+
+/* UFS RPMB device registration */
+int ufs_rpmb_probe(struct ufs_hba *hba)
+{
+	struct ufs_rpmb_dev *ufs_rpmb;
+	struct rpmb_dev *rdev;
+	u32 cid[4] = { 0 };
+	u8 *sn;
+
+	if (!hba->ufs_rpmb_wlun) {
+		dev_info(hba->dev, "No RPMB LUN, skip RPMB registration\n");
+		return -ENODEV;
+	}
+	/* Get the ASCII serial number data */
+	sn = hba->dev_info.serial_number;
+	if (!sn) {
+		dev_err(hba->dev, "Serial number not available\n");
+		return -EINVAL;
+	}
+
+	dev_info(hba->dev, "Probe UFS RPMB Device Serial Number: %s\n", sn);
+	/*
+	 * Use serial number as device ID. Copy ASCII serial number data.
+	 * This provides a unique device identifier for RPMB operations.
+	 */
+	strncpy((char *)cid, sn, sizeof(cid) - 1);
+
+	struct rpmb_descr descr = {
+		.type = RPMB_TYPE_UFS,
+		.route_frames = ufs_rpmb_route_frames,
+		.dev_id = (void *)cid,
+		.dev_id_len = sizeof(cid),
+		.reliable_wr_count = hba->dev_info.rpmb_io_size,
+		.capacity = hba->dev_info.rpmb_region0_size,
+	};
+
+	ufs_rpmb = devm_kzalloc(hba->dev, sizeof(*ufs_rpmb), GFP_KERNEL);
+	if (!ufs_rpmb)
+		return -ENOMEM;
+
+	ufs_rpmb->hba = hba;
+	dev_set_drvdata(&hba->ufs_rpmb_wlun->sdev_gendev, ufs_rpmb);
+
+	/* Register RPMB device */
+	rdev = rpmb_dev_register(&hba->ufs_rpmb_wlun->sdev_gendev, &descr);
+	if (IS_ERR(rdev)) {
+		dev_err(hba->dev, "Failed to register UFS RPMB device.\n");
+		return PTR_ERR(rdev);
+	}
+
+	ufs_rpmb->rdev = rdev;
+	dev_info(hba->dev, "UFS RPMB device registered\n");
+	return 0;
+}
+
+/* UFS RPMB remove handler */
+void ufs_rpmb_remove(struct ufs_hba *hba)
+{
+	struct ufs_rpmb_dev *ufs_rpmb = dev_get_drvdata(&hba->ufs_rpmb_wlun->sdev_gendev);
+
+	if (ufs_rpmb) {
+		rpmb_dev_unregister(ufs_rpmb->rdev);
+		dev_info(hba->dev, "UFS RPMB device unregistered\n");
+	}
+}
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("UFS RPMB integration into the RPBM framework using SCSI Secure In/Out");
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index d0a2c963a27d..523828d6b1d5 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -411,4 +411,17 @@ static inline u32 ufshcd_mcq_get_sq_head_slot(struct ufs_hw_queue *q)
 	return val / sizeof(struct utp_transfer_req_desc);
 }
 
+#ifdef CONFIG_RPMB
+int ufs_rpmb_probe(struct ufs_hba *hba);
+void ufs_rpmb_remove(struct ufs_hba *hba);
+#else
+static inline int ufs_rpmb_probe(struct ufs_hba *hba)
+{
+	return 0;
+}
+static inline void ufs_rpmb_remove(struct ufs_hba *hba)
+{
+}
+#endif
+
 #endif /* _UFSHCD_PRIV_H_ */
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2e1fa8cf83f5..67c50c586729 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3823,7 +3823,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 		str[ret++] = '\0';
 
 	} else {
-		str = kmemdup(uc_str, uc_str->len, GFP_KERNEL);
+		str = kmemdup(uc_str->uc, uc_str->len, GFP_KERNEL);
 		if (!str) {
 			ret = -ENOMEM;
 			goto out;
@@ -5240,11 +5240,12 @@ static void ufshcd_lu_init(struct ufs_hba *hba, struct scsi_device *sdev)
 	    desc_buf[UNIT_DESC_PARAM_LU_WR_PROTECT] == UFS_LU_POWER_ON_WP)
 		hba->dev_info.is_lu_power_on_wp = true;
 
-	/* In case of RPMB LU, check if advanced RPMB mode is enabled */
-	if (desc_buf[UNIT_DESC_PARAM_UNIT_INDEX] == UFS_UPIU_RPMB_WLUN &&
-	    desc_buf[RPMB_UNIT_DESC_PARAM_REGION_EN] & BIT(4))
-		hba->dev_info.b_advanced_rpmb_en = true;
-
+	/* In case of RPMB LU, check if advanced RPMB mode is enabled, and get region size */
+	if (desc_buf[UNIT_DESC_PARAM_UNIT_INDEX] == UFS_UPIU_RPMB_WLUN) {
+	    	if (desc_buf[RPMB_UNIT_DESC_PARAM_REGION_EN] & BIT(4))
+			hba->dev_info.b_advanced_rpmb_en = true;
+		hba->dev_info.rpmb_region0_size = desc_buf[RPMB_UNIT_DESC_PARAM_REGION0_SIZE];
+	}
 
 	kfree(desc_buf);
 set_qdepth:
@@ -8151,8 +8152,13 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN), NULL);
 	if (IS_ERR(sdev_rpmb)) {
 		ret = PTR_ERR(sdev_rpmb);
+		hba->ufs_rpmb_wlun = NULL;
+		dev_err(hba->dev, "%s: RPMB WLUN not found\n", __func__);
 		goto remove_ufs_device_wlun;
 	}
+
+	hba->ufs_rpmb_wlun = sdev_rpmb;
+
 	ufshcd_blk_pm_runtime_init(sdev_rpmb);
 	scsi_device_put(sdev_rpmb);
 
@@ -8425,6 +8431,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 	int err;
 	u8 model_index;
 	u8 *desc_buf;
+	u8 serial_index;
+
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 
 	desc_buf = kzalloc(QUERY_DESC_MAX_SIZE, GFP_KERNEL);
@@ -8460,6 +8468,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 				UFS_DEV_HID_SUPPORT;
 
 	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
+	serial_index = desc_buf[DEVICE_DESC_PARAM_SN];
 
 	err = ufshcd_read_string_desc(hba, model_index,
 				      &dev_info->model, SD_ASCII_STD);
@@ -8469,6 +8478,13 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 		goto out;
 	}
 
+	err = ufshcd_read_string_desc(hba, serial_index, &dev_info->serial_number, SD_ASCII_STD);
+	if (err < 0) {
+		dev_err(hba->dev, "%s: Failed reading Serial Number. err = %d\n",
+			__func__, err);
+		goto out;
+	}
+
 	hba->luns_avail = desc_buf[DEVICE_DESC_PARAM_NUM_LU] +
 		desc_buf[DEVICE_DESC_PARAM_NUM_WLU];
 
@@ -8504,6 +8520,8 @@ static void ufs_put_device_desc(struct ufs_hba *hba)
 
 	kfree(dev_info->model);
 	dev_info->model = NULL;
+	kfree(dev_info->serial_number);
+	dev_info->serial_number = NULL;
 }
 
 /**
@@ -8647,6 +8665,8 @@ static int ufshcd_device_geo_params_init(struct ufs_hba *hba)
 	else if (desc_buf[GEOMETRY_DESC_PARAM_MAX_NUM_LUN] == 0)
 		hba->dev_info.max_lu_supported = 8;
 
+	hba->dev_info.rpmb_io_size = desc_buf[GEOMETRY_DESC_PARAM_RPMB_RW_SIZE];
+
 out:
 	kfree(desc_buf);
 	return err;
@@ -8832,6 +8852,7 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 
 	ufs_bsg_probe(hba);
 	scsi_scan_host(hba->host);
+	ufs_rpmb_probe(hba);
 
 out:
 	return ret;
@@ -10391,6 +10412,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 		ufshcd_rpm_get_sync(hba);
 	ufs_hwmon_remove(hba);
 	ufs_bsg_remove(hba);
+	ufs_rpmb_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
 	cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
 	blk_mq_destroy_queue(hba->tmf_queue);
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 72fd385037a6..ba61fe7fd75e 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -651,6 +651,10 @@ struct ufs_dev_info {
 	u8 rtt_cap; /* bDeviceRTTCap */
 
 	bool hid_sup;
+
+	u8 *serial_number;
+	u8 rpmb_io_size;
+	u8 rpmb_region0_size;
 };
 
 /*
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 1d3943777584..3a5cfa067c41 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -984,6 +984,7 @@ struct ufs_hba {
 	struct Scsi_Host *host;
 	struct device *dev;
 	struct scsi_device *ufs_device_wlun;
+	struct scsi_device *ufs_rpmb_wlun;
 
 #ifdef CONFIG_SCSI_UFS_HWMON
 	struct device *hwmon_device;
-- 
2.34.1

