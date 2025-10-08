Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4289D224AEB;
	Wed,  8 Oct 2025 14:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759935561; cv=pass; b=pRHIWo/u/4ZoN9LkX3VOaZgv4z10L9MewD42ffP+dXoDJVTViwT2P6K2fReO8PuFN7mdxSvyhPm1S1BAPMC3nE27xiuyeJV9CDbB2flUDIkwW77vduh+04/gKll/wsolR/yyorXyY/XYDfqMy3i6YxaljhSuzOw0RuDxDd1xT9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759935561; c=relaxed/simple;
	bh=g7ZBQzS+z479sHcONPo3AN6q36xCD7okk8NgOnzj10U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=llbrd1i0xKqgPQ5gRUHgNkdQipvi61MaGDzsFpvrvjB6w3uVTa/y2MPf+zwCq/VHFvC2urjMkcB8QwRJZ2YsWA4kdjNutrhI4HlOK1fcZPFQRyRd53ZvoFTbuE9V52e/NRDRY8uZX+pT3V1IeJEiP3/in/KjL4afiBoXkY9mmBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=augwGA1i; arc=pass smtp.client-ip=85.215.255.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="augwGA1i"
ARC-Seal: i=1; a=rsa-sha256; t=1759935550; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Bqkot7G5KcQSjXRLlPojAS6ikEjAiAoO9rOOn9F0lTaOPHSi0n5E2A+NgwT2bdeqcO
    hP2xQYh4gtw6tLKDOkBMu0KG92YsGO13H2qvvsMxm0dhJDOqb2jhoYS7EasfqK/l38Xd
    eBo40OFCCdeS7BtaAiLEPi6GJZuRzl1tmvVdiHT8wLk0kgH6dNUAeFm/KCPDV9WCRtJ3
    +axda0ZxG3toJqaxDkRAChglbj/qkaulbDt1DCdwOlAyrefeolqYG/mqldfjcIRKMcku
    FuiCM4x5o2aZ8IAFeZkWfh6nmmsbgClnwHMJyuQsPHSV+81Nml6oYqYZsAs890db0w+I
    FbZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1759935550;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=j7JA+/HcethoRCoF7XenciHUXixtBQ7n3pPNMAEgEHI=;
    b=qDaJznmPBOsCs+uRg1ktEGgC9yzs7e+48djzSfGn8Z4jBZ0kxvYqBoNPj7egdMA/Rd
    XTf1lgtyoFkoTn/ksge26Xtn/irSB2Bx6exdQ1aWW7fw7jEsgmlSoJzKVXnccNp4k02n
    VJ1cQasDsXN/aKQri5LVvlV9fD+36jHNF8bzyXEuUedhxf15tp3mHarNG+Ls6crRNtkT
    T6YOE4//aAUtou9APTKuPWpbiYDs7is/KmQXtS4JRRLvbqPnt+ymsho/zmepRgb7GfG5
    KhQkITMqgM9QYHmhnvnTsIywPc+onqPgDEPIA2TI3vfCzeyv0L6TUM8bZH/xBMgJnmhy
    qBUA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1759935550;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=j7JA+/HcethoRCoF7XenciHUXixtBQ7n3pPNMAEgEHI=;
    b=augwGA1ideSGvqGC8Ja8OR+J6Q5oCyxUEHRT2WvT83DLAujg6AoSBVqj2OWSh9BQs+
    7a3CeCfGxtRzmzYUzNctVEQjnc5Kiql2fMXjirqXCBxl5OqDF1NS9dKxAtSHSv9J6LVC
    IPl0mjamyMyIfbJT2eFa7QPq2NRpihW/ZbCXZ/JmL9zBYXfd3JXcf6kTNB4NAwtFyOGj
    M42RBN1q0eIY2S8MqJNMlYnAgDShA6ZJj/vGkfs5TNUMwIqrWcGRcvCKyl9EW9ZpDy4e
    MMG2lY0gohrssXtgeEvwQvnkh9q/I9e+xhn9oOLENS9Y3YdYKqDldjivWL1BjDDqXyqF
    8FXw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O2J2YOom0XQaPis+nU/5K"
Received: from Munilab01-lab.micron.com
    by smtp.strato.de (RZmta 53.4.2 AUTH)
    with ESMTPSA id z293fb198Ex92Tj
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 8 Oct 2025 16:59:09 +0200 (CEST)
From: Bean Huo <beanhuo@iokpp.de>
To: avri.altman@wdc.com,
	avri.altman@sandisk.com,
	bvanassche@acm.org,
	alim.akhtar@samsung.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	can.guo@oss.qualcomm.com,
	ulf.hansson@linaro.org,
	beanhuo@micron.com,
	jens.wiklander@linaro.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices
Date: Wed,  8 Oct 2025 16:58:54 +0200
Message-Id: <20251008145854.68510-4-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251008145854.68510-1-beanhuo@iokpp.de>
References: <20251008145854.68510-1-beanhuo@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

From: Bean Huo <beanhuo@micron.com>

This patch adds OP-TEE based RPMB support for UFS devices. This enables secure RPMB operations on
UFS devices through OP-TEE, providing the same functionality available for eMMC devices and
extending kernel-based secure storage support to UFS-based systems.

Benefits of OP-TEE based RPMB implementation:
- Eliminates dependency on userspace supplicant for RPMB access
- Enables early boot secure storage access (e.g., fTPM, secure UEFI variables)
- Provides kernel-level RPMB access as soon as UFS driver is initialized
- Removes complex initramfs dependencies and boot ordering requirements
- Ensures reliable and deterministic secure storage operations
- Supports both built-in and modular fTPM configurations

Co-developed-by: Can Guo <can.guo@oss.qualcomm.com>
Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/misc/Kconfig           |   2 +-
 drivers/ufs/core/Makefile      |   1 +
 drivers/ufs/core/ufs-rpmb.c    | 249 +++++++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h |  13 ++
 drivers/ufs/core/ufshcd.c      |  30 +++-
 include/ufs/ufs.h              |   4 +
 include/ufs/ufshcd.h           |   8 +-
 7 files changed, 300 insertions(+), 7 deletions(-)
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
index 000000000000..98cad0fa0290
--- /dev/null
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -0,0 +1,249 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * UFS OP-TEE based RPMB Driver
+ *
+ * Copyright (C) 2025 Micron Technology, Inc.
+ * Copyright (C) 2025 Qualcomm Technologies, Inc.
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
+#include <linux/list.h>
+#include <ufs/ufshcd.h>
+#include <linux/unaligned.h>
+#include "ufshcd-priv.h"
+
+#define UFS_RPMB_SEC_PROTOCOL		0xEC	/* JEDEC UFS application */
+#define UFS_RPMB_SEC_PROTOCOL_ID	0x01	/* JEDEC UFS RPMB protocol ID, CDB byte3 */
+
+static const struct bus_type ufs_rpmb_bus_type = {
+	.name = "ufs_rpmb",
+};
+
+/* UFS RPMB device structure */
+struct ufs_rpmb_dev {
+	u8 region_id;
+	struct device dev;
+	struct rpmb_dev *rdev;
+	struct ufs_hba *hba;
+	struct list_head node;
+};
+
+static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, size_t len, bool send)
+{
+	struct scsi_device *sdev = hba->ufs_rpmb_wlun;
+	u8 cdb[12] = { };
+
+	cdb[0] = send ? SECURITY_PROTOCOL_OUT : SECURITY_PROTOCOL_IN;
+	cdb[1] = UFS_RPMB_SEC_PROTOCOL;
+	put_unaligned_be16(spsp, &cdb[2]);
+	put_unaligned_be32(len, &cdb[6]);
+
+	return scsi_execute_cmd(sdev, cdb, send ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
+				buffer, len, /*timeout=*/30 * HZ, 0, NULL);
+}
+
+/* UFS RPMB route frames implementation */
+static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_len, u8 *resp,
+					unsigned int resp_len)
+{
+	struct ufs_rpmb_dev *ufs_rpmb = dev_get_drvdata(dev);
+	struct rpmb_frame *frm_out = (struct rpmb_frame *)req;
+	bool need_result_read = true;
+	u16 req_type, protocol_id;
+	struct ufs_hba *hba;
+	int ret;
+
+	if (!ufs_rpmb) {
+		dev_err(dev, "Missing driver data\n");
+		return -ENODEV;
+	}
+
+	hba = ufs_rpmb->hba;
+
+	req_type = be16_to_cpu(frm_out->req_resp);
+
+	switch (req_type) {
+	case RPMB_PROGRAM_KEY:
+		if (req_len != sizeof(struct rpmb_frame) || resp_len != sizeof(struct rpmb_frame))
+			return -EINVAL;
+		break;
+	case RPMB_GET_WRITE_COUNTER:
+		if (req_len != sizeof(struct rpmb_frame) || resp_len != sizeof(struct rpmb_frame))
+			return -EINVAL;
+		need_result_read = false;
+		break;
+	case RPMB_WRITE_DATA:
+		if (req_len % sizeof(struct rpmb_frame) || resp_len != sizeof(struct rpmb_frame))
+			return -EINVAL;
+		break;
+	case RPMB_READ_DATA:
+		if (req_len != sizeof(struct rpmb_frame) || resp_len % sizeof(struct rpmb_frame))
+			return -EINVAL;
+		need_result_read = false;
+		break;
+	default:
+		dev_err(dev, "Unknown request type=0x%04x\n", req_type);
+		return -EINVAL;
+	}
+
+	protocol_id = ufs_rpmb->region_id << 8 | UFS_RPMB_SEC_PROTOCOL_ID;
+
+	ret = ufs_sec_submit(hba, protocol_id, req, req_len, true);
+	if (ret) {
+		dev_err(dev, "Command failed with ret=%d\n", ret);
+		return ret;
+	}
+
+	if (need_result_read) {
+		struct rpmb_frame *frm_resp = (struct rpmb_frame *)resp;
+
+		memset(frm_resp, 0, sizeof(*frm_resp));
+		frm_resp->req_resp = cpu_to_be16(RPMB_RESULT_READ);
+		ret = ufs_sec_submit(hba, protocol_id, resp, resp_len, true);
+		if (ret) {
+			dev_err(dev, "Result read request failed with ret=%d\n", ret);
+			return ret;
+		}
+	}
+
+	if (!ret) {
+		ret = ufs_sec_submit(hba, protocol_id, resp, resp_len, false);
+		if (ret)
+			dev_err(dev, "Response read failed with ret=%d\n", ret);
+	}
+
+	return ret;
+}
+
+static void ufs_rpmb_device_release(struct device *dev)
+{
+	struct ufs_rpmb_dev *ufs_rpmb = dev_get_drvdata(dev);
+
+	rpmb_dev_unregister(ufs_rpmb->rdev);
+}
+
+/* UFS RPMB device registration */
+int ufs_rpmb_probe(struct ufs_hba *hba)
+{
+	struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;
+	struct rpmb_dev *rdev;
+	u8 cid[16] = { };
+	int region;
+	u8 *sn;
+	u32 cap;
+	int ret;
+
+	if (!hba->ufs_rpmb_wlun || hba->dev_info.b_advanced_rpmb_en) {
+		dev_info(hba->dev, "Skip OP-TEE RPMB registration\n");
+		return -ENODEV;
+	}
+
+	/* Get the UNICODE serial number data */
+	sn = hba->dev_info.serial_number;
+	if (!sn) {
+		dev_err(hba->dev, "Serial number not available\n");
+		return -EINVAL;
+	}
+
+	INIT_LIST_HEAD(&hba->rpmbs);
+
+	/* Copy serial number into device ID (max 15 chars + NUL). */
+	strscpy(cid, sn);
+
+	struct rpmb_descr descr = {
+		.type = RPMB_TYPE_UFS,
+		.route_frames = ufs_rpmb_route_frames,
+		.dev_id_len = sizeof(cid),
+		.reliable_wr_count = hba->dev_info.rpmb_io_size,
+	};
+
+	for (region = 0; region < ARRAY_SIZE(hba->dev_info.rpmb_region_size); region++) {
+		cap = hba->dev_info.rpmb_region_size[region];
+		if (!cap)
+			continue;
+
+		ufs_rpmb = devm_kzalloc(hba->dev, sizeof(*ufs_rpmb), GFP_KERNEL);
+		if (!ufs_rpmb) {
+			ret = -ENOMEM;
+			goto err_out;
+		}
+
+		ufs_rpmb->hba = hba;
+		ufs_rpmb->dev.parent = &hba->ufs_rpmb_wlun->sdev_gendev;
+		ufs_rpmb->dev.bus = &ufs_rpmb_bus_type;
+		ufs_rpmb->dev.release = ufs_rpmb_device_release;
+		dev_set_name(&ufs_rpmb->dev, "ufs_rpmb%d", region);
+
+		/* Set driver data BEFORE device_register */
+		dev_set_drvdata(&ufs_rpmb->dev, ufs_rpmb);
+
+		ret = device_register(&ufs_rpmb->dev);
+		if (ret) {
+			dev_err(hba->dev, "Failed to register UFS RPMB device %d\n", region);
+			put_device(&ufs_rpmb->dev);
+			goto err_out;
+		}
+
+		/* Make CID unique for this region by appending region numbe */
+		cid[sizeof(cid) - 1] = region;
+		descr.dev_id = cid;
+		descr.capacity = cap;
+
+		/* Register RPMB device */
+		rdev = rpmb_dev_register(&ufs_rpmb->dev, &descr);
+		if (IS_ERR(rdev)) {
+			dev_err(hba->dev, "Failed to register UFS RPMB device.\n");
+			device_unregister(&ufs_rpmb->dev);
+			ret = PTR_ERR(rdev);
+			goto err_out;
+		}
+
+		ufs_rpmb->rdev = rdev;
+		ufs_rpmb->region_id = region;
+
+		list_add_tail(&ufs_rpmb->node, &hba->rpmbs);
+
+		dev_info(hba->dev, "UFS RPMB region %d registered (capacity=%u)\n", region, cap);
+	}
+
+	return 0;
+err_out:
+	list_for_each_entry_safe(it, tmp, &hba->rpmbs, node) {
+		list_del(&it->node);
+		device_unregister(&it->dev);
+	}
+
+	return ret;
+}
+
+/* UFS RPMB remove handler */
+void ufs_rpmb_remove(struct ufs_hba *hba)
+{
+	struct ufs_rpmb_dev *ufs_rpmb, *tmp;
+
+	if (list_empty(&hba->rpmbs))
+		return;
+
+	/* Remove all registered RPMB devices */
+	list_for_each_entry_safe(ufs_rpmb, tmp, &hba->rpmbs, node) {
+		dev_info(hba->dev, "Removing UFS RPMB region %d\n", ufs_rpmb->region_id);
+		/* Remove from list first */
+		list_del(&ufs_rpmb->node);
+		/* Unregister device */
+		device_unregister(&ufs_rpmb->dev);
+	}
+
+	dev_info(hba->dev, "All UFS RPMB devices unregistered\n");
+}
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("OP-TEE UFS RPMB driver");
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index cadee685eb5e..0eb8b04d64af 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -408,4 +408,17 @@ static inline u32 ufshcd_mcq_get_sq_head_slot(struct ufs_hw_queue *q)
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
index 79c7588be28a..ec1670d94946 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5240,10 +5240,15 @@ static void ufshcd_lu_init(struct ufs_hba *hba, struct scsi_device *sdev)
 	    desc_buf[UNIT_DESC_PARAM_LU_WR_PROTECT] == UFS_LU_POWER_ON_WP)
 		hba->dev_info.is_lu_power_on_wp = true;
 
-	/* In case of RPMB LU, check if advanced RPMB mode is enabled */
-	if (desc_buf[UNIT_DESC_PARAM_UNIT_INDEX] == UFS_UPIU_RPMB_WLUN &&
-	    desc_buf[RPMB_UNIT_DESC_PARAM_REGION_EN] & BIT(4))
-		hba->dev_info.b_advanced_rpmb_en = true;
+	/* In case of RPMB LU, check if advanced RPMB mode is enabled, and get region size */
+	if (desc_buf[UNIT_DESC_PARAM_UNIT_INDEX] == UFS_UPIU_RPMB_WLUN) {
+		if (desc_buf[RPMB_UNIT_DESC_PARAM_REGION_EN] & BIT(4))
+			hba->dev_info.b_advanced_rpmb_en = true;
+		hba->dev_info.rpmb_region_size[0] = desc_buf[RPMB_UNIT_DESC_PARAM_REGION0_SIZE];
+		hba->dev_info.rpmb_region_size[1] = desc_buf[RPMB_UNIT_DESC_PARAM_REGION1_SIZE];
+		hba->dev_info.rpmb_region_size[2] = desc_buf[RPMB_UNIT_DESC_PARAM_REGION2_SIZE];
+		hba->dev_info.rpmb_region_size[3] = desc_buf[RPMB_UNIT_DESC_PARAM_REGION3_SIZE];
+	}
 
 
 	kfree(desc_buf);
@@ -8151,8 +8156,11 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN), NULL);
 	if (IS_ERR(sdev_rpmb)) {
 		ret = PTR_ERR(sdev_rpmb);
+		hba->ufs_rpmb_wlun = NULL;
+		dev_err(hba->dev, "%s: RPMB WLUN not found\n", __func__);
 		goto remove_ufs_device_wlun;
 	}
+	hba->ufs_rpmb_wlun = sdev_rpmb;
 	ufshcd_blk_pm_runtime_init(sdev_rpmb);
 	scsi_device_put(sdev_rpmb);
 
@@ -8425,6 +8433,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 	int err;
 	u8 model_index;
 	u8 *desc_buf;
+	u8 serial_index;
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 
 	desc_buf = kzalloc(QUERY_DESC_MAX_SIZE, GFP_KERNEL);
@@ -8460,6 +8469,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 				UFS_DEV_HID_SUPPORT;
 
 	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
+	serial_index = desc_buf[DEVICE_DESC_PARAM_SN];
 
 	err = ufshcd_read_string_desc(hba, model_index,
 				      &dev_info->model, SD_ASCII_STD);
@@ -8469,6 +8479,12 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 		goto out;
 	}
 
+	err = ufshcd_read_string_desc(hba, serial_index, &dev_info->serial_number, SD_RAW);
+	if (err < 0) {
+		dev_err(hba->dev, "%s: Failed reading Serial Number. err = %d\n", __func__, err);
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
index 72fd385037a6..1d44e2b32253 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -651,6 +651,10 @@ struct ufs_dev_info {
 	u8 rtt_cap; /* bDeviceRTTCap */
 
 	bool hid_sup;
+
+	u8 *serial_number;
+	u8 rpmb_io_size;
+	u8 rpmb_region_size[4];
 };
 
 /*
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 1d3943777584..3c860a6dcf7f 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -851,6 +851,7 @@ enum ufshcd_mcq_opr {
  * @host: Scsi_Host instance of the driver
  * @dev: device handle
  * @ufs_device_wlun: WLUN that controls the entire UFS device.
+ * @ufs_rpmb_wlun: RPMB WLUN SCSI device
  * @hwmon_device: device instance registered with the hwmon core.
  * @curr_dev_pwr_mode: active UFS device power mode.
  * @uic_link_state: active state of the link to the UFS device.
@@ -965,8 +966,8 @@ enum ufshcd_mcq_opr {
  * @pm_qos_enabled: flag to check if pm qos is enabled
  * @critical_health_count: count of critical health exceptions
  * @dev_lvl_exception_count: count of device level exceptions since last reset
- * @dev_lvl_exception_id: vendor specific information about the
- * device level exception event.
+ * @dev_lvl_exception_id: vendor specific information about the device level exception event.
+ * @rpmbs: list of OP-TEE RPMB devices (one per RPMB region)
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -984,6 +985,7 @@ struct ufs_hba {
 	struct Scsi_Host *host;
 	struct device *dev;
 	struct scsi_device *ufs_device_wlun;
+	struct scsi_device *ufs_rpmb_wlun;
 
 #ifdef CONFIG_SCSI_UFS_HWMON
 	struct device *hwmon_device;
@@ -1140,6 +1142,8 @@ struct ufs_hba {
 	int critical_health_count;
 	atomic_t dev_lvl_exception_count;
 	u64 dev_lvl_exception_id;
+
+	struct list_head rpmbs;
 };
 
 /**
-- 
2.34.1

