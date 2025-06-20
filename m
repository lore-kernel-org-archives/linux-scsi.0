Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B781F2D4B4F;
	Fri, 20 Jun 2025 20:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750449641; cv=none; b=Cnim8gyp4M9Vjii4DgKs0kWYkah6j7RMcBQvFy+tYGVRTvyA+dJeARnbXOk6kQNlQ1POcLVXedyb5c8q5KwT3vIANNUJjfZyzzA7CznDFJBqb5x6hN7NvboWb0KN4X0dnFGiLE0/LS9GV8HSjLAYyIPuxv5dk07aeiDjcAjSL1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750449641; c=relaxed/simple;
	bh=FnLu/zteBtcbgF39/de0UEj6CjpgRW4OwQJqSK/DCvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nc1r0c/lOEWRAGLVqt2Wt8UPbQMmBKyW4DcpKTTB7+ptFh4Sp1jESuu2iwwrpos/2qpYmRitiKI/iVaPl0x24rwCf598aX+xthsORGylJiSZcGYgEQDu6BmVAZTWcnQ31zIbf3RoI3nqP5Gnf8qctAOyduFm/qBUC4mx9Tcpxyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kGPm4+2j; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kGPm4+2j"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4a44b9b2af8so11956541cf.3;
        Fri, 20 Jun 2025 13:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750449638; x=1751054438; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cLlBLN6XYSWvjZS1MTV4Ao6ngjgsPbI1kTt9I/+kVy0=;
        b=kGPm4+2jtPjQcXkv6IxhYSGf+jGHv5IYuSksWyE6+zLw1AohSHtUYm8+uQti0FRY2i
         +WVBsj6SefnfMFxCXKFCgFta5Z8L8l3SbksgPxBqqchesdnQx2oz+xnGZzCM9D5Pim02
         tHxlX+WN1iK9ypRmryCvTulUmXepRhkJYHcg/YFtA3GhOCnhcQMCu5VnfURqokaP0Me3
         z9CMbB6VKbYwRTrvtjBVysDu9By/uf3tiB+wCMo0C8iH91xxoxqo9/VAa+sUxIU3E9vf
         zzzew9YLZtlGm6DM075ILRvzSGZ1dLCpfV+wUUDXJoohVSicMFuc1gTdIf7POYOya0a/
         vW5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750449638; x=1751054438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cLlBLN6XYSWvjZS1MTV4Ao6ngjgsPbI1kTt9I/+kVy0=;
        b=DV8X7W5uTqustYZ7U4m3qQLjPWPgLlSqgk3cQvdY1myyHopRUnhZYDDPmyWRf3aPrh
         07VhR4CxqDGh31hIonOji2Fz4m0eehP0w6UiLdIoxpJZvaKimnp1eb+TI6N1mGkoAb/c
         OeulRCVR2wtB/M2+T0bSL8f/yn6OrtgTdyV67uqxCy6/2v3iKtJ4Aj9uh6BmRCw/qzOu
         KcrFbD7Z40m+aXKM53ttymMi+o/TwZ6W8To0TcVQ7V5AxUasWVbxSzj8g/x2KG0Y8LWP
         eq2dCEQX0yZvY4UAx6FmNurOxBacFfEryV0om2L7bF/c37zZJgYnhYMs7b5H14rX+q9u
         ZQmQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrGE4a6nGHIBKbI1oWR5LTjUt35G15R41jdODqLFO214hODbdlCWuuYVY8Y+8M/9biGioORm6RwLuT5Q==@vger.kernel.org, AJvYcCXN1KutvFUhVkoeE5QoF5iDZzhEs+hDPqIsdpmzT4bDbSd5iZBBquTVZXGtOfrXYbHuTVgy7REx2XZl5Sk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyreM8Y6LXZX6wCf+hsTJOdkrEWFLQLh9pU/ecoysaM58AQIeIs
	Bo1mgT5bfySDitsuOBon3Gfb0oDq6HIhgZykALa/sVMqHNkpXq+oSJmZ
X-Gm-Gg: ASbGncvtz8Bn4F3rhxbXM+3xwWPFMM4sZDIn3f+ggavw/G7SAhuNU4+A4E1JlIDcpx8
	5WIUHMCsEAf6PaaK7kLN6owt710TA0ikIK1yIxhHVJxixv70IW2LxFDxLxyemswxktYpjY8K/xw
	bSE1jV09FzHt9Fm+lbKYCJ73jV2w6Uv5vVR2HKshA/bujZ4BcGWfDpPzEYXFwz0wA11+kLyWZ5z
	hCQkob8/8xFc049zBuFUg8eSj+A4i56lbfJwGtIjhYxsqB0fgB9osRqnFgKHkFRFJ1P1q8RG3Af
	ZmJG4o+iLuG+9RcdIva0YjyVHUTq7MERsaLhdWz8a96+rG58BOaHmwXZ3vdqO+KkowziAziljRe
	nsoQXmTLgKszvhQ==
X-Google-Smtp-Source: AGHT+IHqDuYQTela0b4PTSe5zzZAZ45fG5k1UhCMdnnTCrUP6kNd3QLPjdXdUCD8LSsV/M/1RjkAkA==
X-Received: by 2002:ac8:594d:0:b0:4a4:2f0b:d2dc with SMTP id d75a77b69052e-4a77a2083acmr74820241cf.20.1750449636505;
        Fri, 20 Jun 2025 13:00:36 -0700 (PDT)
Received: from localhost.localdomain.com (sw.attotech.com. [208.69.85.34])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a779d67360sm12659891cf.24.2025.06.20.13.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 13:00:35 -0700 (PDT)
From: Steve Siwinski <stevensiwinski@gmail.com>
X-Google-Original-From: Steve Siwinski <ssiwinski@atto.com>
To: alok.a.tiwari@oracle.com
Cc: James.Bottomley@HansenPartnership.com,
	bgrove@atto.com,
	gustavoars@kernel.org,
	kashyap.desai@broadcom.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	prayas.patel@broadcom.com,
	ranjan.kumar@broadcom.com,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	ssiwinski@atto.com,
	stevensiwinski@gmail.com,
	sumit.saxena@broadcom.com,
	tdoedline@atto.com
Subject: [PATCH v2 2/2] scsi: mpi3mr: Add initialization for ATTO 24Gb SAS HBAs
Date: Fri, 20 Jun 2025 16:00:23 -0400
Message-ID: <20250620200023.43408-1-ssiwinski@atto.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <0c9391ed-2015-41f7-850c-39c20730ca8c@oracle.com>
References: <0c9391ed-2015-41f7-850c-39c20730ca8c@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds initialization routines for ATTO 24Gb SAS HBAs.
It introduces the ATTO NVRAM structure and functions to validate
NVRAM contents.

The `mpi3mr_atto_init` function is added to handle ATTO-specific
controller initialization. This involves reading the ATTO SAS address
from Driver Page 2 and then assigning unique device names and WWIDs
to Manufacturing Page 5.

v2:
- Fixed typo and whitespace issues. (Reported by alok.a.tiwari@oracle.com)
- Changed ATTO_SAS_ADDRESS members to __le16/__le32/__le64.
  (Reported by Sparse)
- Initialized 'r' return value in mpi3mr_atto_get_sas_addr.
  (Reported by Sparse)
- Applied le16_to_cpu to return value in mpi3mr_cfg_get_page_size.
  (Reported by Sparse)
- Corrected parameter names in comments. (Reported by Sparse)

Signed-off-by: Steve Siwinski <ssiwinski@atto.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  35 ++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 310 ++++++++++++++++++++++++++++++++
 2 files changed, 345 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 9bbc7cb98ca3..35332c0bcdad 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1438,6 +1438,35 @@ struct delayed_evt_ack_node {
 	u32 event_ctx;
 };
 
+/*
+ * struct ATTO_SAS_NVRAM - ATTO NVRAM settings
+ * @signature: ATTO NVRAM signature
+ * @version: ATTO NVRAM version
+ * @checksum: NVRAM checksum
+ * @sasaddr: ATTO SAS address
+ */
+struct ATTO_SAS_NVRAM {
+	u8		signature[4];
+	u8		version;
+#define ATTO_SASNVR_VERSION		0
+
+	u8		checksum;
+#define ATTO_SASNVR_CKSUM_SEED	0x5A
+	u8		pad[10];
+	u8		sasaddr[8];
+#define ATTO_SAS_ADDR_ALIGN		64
+	u8		reserved[232];
+};
+
+#define ATTO_SAS_ADDR_DEVNAME_BIAS		63
+
+union ATTO_SAS_ADDRESS {
+	u8		b[8];
+	__le16	w[4];
+	__le32	d[2];
+	__le64	q;
+};
+
 int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc);
 void mpi3mr_cleanup_resources(struct mpi3mr_ioc *mrioc);
 int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc);
@@ -1533,10 +1562,16 @@ int mpi3mr_cfg_get_sas_io_unit_pg1(struct mpi3mr_ioc *mrioc,
 	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1, u16 pg_sz);
 int mpi3mr_cfg_set_sas_io_unit_pg1(struct mpi3mr_ioc *mrioc,
 	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1, u16 pg_sz);
+int mpi3mr_cfg_get_man_pg5(struct mpi3mr_ioc *mrioc,
+	struct mpi3_man_page5 *man_pg5, u16 pg_sz);
+int mpi3mr_cfg_set_man_pg5(struct mpi3mr_ioc *mrioc,
+	struct mpi3_man_page5 *man_pg5, u16 pg_sz);
 int mpi3mr_cfg_get_driver_pg1(struct mpi3mr_ioc *mrioc,
 	struct mpi3_driver_page1 *driver_pg1, u16 pg_sz);
 int mpi3mr_cfg_get_driver_pg2(struct mpi3mr_ioc *mrioc,
 	struct mpi3_driver_page2 *driver_pg2, u16 pg_sz, u8 page_type);
+int mpi3mr_cfg_get_page_size(struct mpi3mr_ioc *mrioc,
+	int page_type, int page_num);
 
 u8 mpi3mr_is_expander_device(u16 device_info);
 int mpi3mr_expander_add(struct mpi3mr_ioc *mrioc, u16 handle);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 1d7901a8f0e4..29b9ae547710 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -4203,6 +4203,163 @@ static int mpi3mr_enable_events(struct mpi3mr_ioc *mrioc)
 	return retval;
 }
 
+/**
+ * mpi3mr_atto_validate_nvram - validate the ATTO nvram
+ *
+ * @mrioc: Adapter instance reference
+ * @nvram: ptr to the ATTO nvram structure
+ * Return: 0 for success, non-zero for failure.
+ */
+static int mpi3mr_atto_validate_nvram(struct mpi3mr_ioc *mrioc, struct ATTO_SAS_NVRAM *nvram)
+{
+	int r = -EINVAL;
+	union ATTO_SAS_ADDRESS *sasaddr;
+	u32 len;
+	u8 *pb;
+	u8 cksum;
+
+	/* validate nvram checksum */
+	pb = (u8 *) nvram;
+	cksum = ATTO_SASNVR_CKSUM_SEED;
+	len = sizeof(struct ATTO_SAS_NVRAM);
+
+	while (len--)
+		cksum = cksum + pb[len];
+
+	if (cksum) {
+		ioc_err(mrioc, "Invalid ATTO NVRAM checksum\n");
+		return r;
+	}
+
+	sasaddr = (union ATTO_SAS_ADDRESS *) nvram->sasaddr;
+
+	if (nvram->signature[0] != 'E'
+	|| nvram->signature[1] != 'S'
+	|| nvram->signature[2] != 'A'
+	|| nvram->signature[3] != 'S')
+		ioc_err(mrioc, "Invalid ATTO NVRAM signature\n");
+	else if (nvram->version > ATTO_SASNVR_VERSION)
+		ioc_info(mrioc, "Invalid ATTO NVRAM version");
+	else if ((nvram->sasaddr[7] & (ATTO_SAS_ADDR_ALIGN - 1))
+			|| sasaddr->b[0] != 0x50
+			|| sasaddr->b[1] != 0x01
+			|| sasaddr->b[2] != 0x08
+			|| (sasaddr->b[3] & 0xF0) != 0x60
+			|| ((sasaddr->b[3] & 0x0F) | le32_to_cpu(sasaddr->d[1])) == 0) {
+		ioc_err(mrioc, "Invalid ATTO SAS address\n");
+	} else
+		r = 0;
+	return r;
+}
+
+/**
+ * mpi3mr_atto_get_sas_addr - get the ATTO SAS address from driver page 2
+ *
+ * @mrioc: Adapter instance reference
+ * @sas_address: Pointer to store the sas address
+ * Return: 0 for success, non-zero for failure.
+ */
+static int mpi3mr_atto_get_sas_addr(struct mpi3mr_ioc *mrioc, union ATTO_SAS_ADDRESS *sas_address)
+{
+	struct mpi3_driver_page2 *driver_pg2 = NULL;
+	struct ATTO_SAS_NVRAM *nvram;
+	u16 sz;
+	int r = -ENOMEM;
+	__be64 addr;
+
+	sz = mpi3mr_cfg_get_page_size(mrioc, MPI3_CONFIG_PAGETYPE_DRIVER, 2);
+	driver_pg2 = kzalloc(sz, GFP_KERNEL);
+	if (!driver_pg2)
+		goto out;
+
+	r = mpi3mr_cfg_get_driver_pg2(mrioc, driver_pg2, sz, MPI3_CONFIG_ACTION_READ_PERSISTENT);
+	if (r)
+		goto out;
+
+	nvram = (struct ATTO_SAS_NVRAM *) &driver_pg2->trigger;
+
+	r = mpi3mr_atto_validate_nvram(mrioc, nvram);
+	if (r)
+		goto out;
+
+	addr = *((__be64 *) nvram->sasaddr);
+	sas_address->q = cpu_to_le64(be64_to_cpu(addr));
+
+out:
+	kfree(driver_pg2);
+	return r;
+}
+
+/**
+ * mpi3mr_atto_init - Initialize the controller
+ * @mrioc: Adapter instance reference
+ *
+ * This the ATTO controller initialization routine
+ *
+ * Return: 0 on success and non-zero on failure.
+ */
+static int mpi3mr_atto_init(struct mpi3mr_ioc *mrioc)
+{
+	int i, bias = 0;
+	u16 sz;
+	struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0 = NULL;
+	struct mpi3_man_page5 *man_pg5 = NULL;
+	union ATTO_SAS_ADDRESS base_address;
+	union ATTO_SAS_ADDRESS dev_address;
+	union ATTO_SAS_ADDRESS sas_address;
+
+	sz = mpi3mr_cfg_get_page_size(mrioc, MPI3_CONFIG_PAGETYPE_SAS_IO_UNIT, 0);
+	sas_io_unit_pg0 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_io_unit_pg0)
+		goto out;
+
+	if (mpi3mr_cfg_get_sas_io_unit_pg0(mrioc, sas_io_unit_pg0, sz)) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out;
+	}
+
+	sz = mpi3mr_cfg_get_page_size(mrioc, MPI3_CONFIG_PAGETYPE_MANUFACTURING, 5);
+	man_pg5 = kzalloc(sz, GFP_KERNEL);
+	if (!man_pg5)
+		goto out;
+
+	if (mpi3mr_cfg_get_man_pg5(mrioc, man_pg5, sz)) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out;
+	}
+
+	mpi3mr_atto_get_sas_addr(mrioc, &base_address);
+
+	dev_address.q = base_address.q;
+	dev_address.b[0] += ATTO_SAS_ADDR_DEVNAME_BIAS;
+
+	for (i = 0; i < man_pg5->num_phys; i++) {
+		if (sas_io_unit_pg0->phy_data[i].phy_flags &
+			(MPI3_SASIOUNIT0_PHYFLAGS_HOST_PHY |
+			MPI3_SASIOUNIT0_PHYFLAGS_VIRTUAL_PHY))
+			continue;
+
+		sas_address.q = base_address.q;
+		sas_address.b[0] += bias++;
+
+		man_pg5->phy[i].device_name = dev_address.q;
+		man_pg5->phy[i].ioc_wwid = sas_address.q;
+		man_pg5->phy[i].sata_wwid = sas_address.q;
+	}
+
+	if (mpi3mr_cfg_set_man_pg5(mrioc, man_pg5, sz))
+		ioc_info(mrioc, "ATTO set manufacturing page 5 failed\n");
+
+out:
+	kfree(sas_io_unit_pg0);
+	kfree(man_pg5);
+
+	return 0;
+}
+
+
 /**
  * mpi3mr_init_ioc - Initialize the controller
  * @mrioc: Adapter instance reference
@@ -4376,6 +4533,9 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		goto out_failed;
 	}
 
+	if (mrioc->pdev->subsystem_vendor == MPI3_MFGPAGE_VENDORID_ATTO)
+		mpi3mr_atto_init(mrioc);
+
 	ioc_info(mrioc, "controller initialization completed successfully\n");
 	return retval;
 out_failed:
@@ -6293,6 +6453,118 @@ int mpi3mr_cfg_set_sas_io_unit_pg1(struct mpi3mr_ioc *mrioc,
 	return -1;
 }
 
+/**
+ * mpi3mr_cfg_get_man_pg5 - Read manufacturing page 5
+ * @mrioc: Adapter instance reference
+ * @man_pg5: Pointer to the manufacturing page 5 to read
+ * @pg_sz: Size of the memory allocated to the page pointer
+ *
+ * This is handler for config page read of manufacturing
+ * page 5.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+int mpi3mr_cfg_get_man_pg5(struct mpi3mr_ioc *mrioc,
+	struct mpi3_man_page5 *man_pg5, u16 pg_sz)
+{
+	struct mpi3_config_page_header cfg_hdr;
+	struct mpi3_config_request cfg_req;
+	u16 ioc_status = 0;
+
+	memset(man_pg5, 0, pg_sz);
+	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
+	memset(&cfg_req, 0, sizeof(cfg_req));
+
+	cfg_req.function = MPI3_FUNCTION_CONFIG;
+	cfg_req.action = MPI3_CONFIG_ACTION_PAGE_HEADER;
+	cfg_req.page_type = MPI3_CONFIG_PAGETYPE_MANUFACTURING;
+	cfg_req.page_number = 5;
+	cfg_req.page_address = 0;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
+	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
+		ioc_err(mrioc, "manufacturing page5 header read failed\n");
+		goto out_failed;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "manufacturing page5 header read failed with ioc_status(0x%04x)\n",
+		    ioc_status);
+		goto out_failed;
+	}
+
+	cfg_req.action = MPI3_CONFIG_ACTION_READ_CURRENT;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
+	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, man_pg5, pg_sz)) {
+		ioc_err(mrioc, "manufacturing page5 read failed\n");
+		goto out_failed;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "manufacturing page5 read failed with ioc_status(0x%04x)\n",
+		    ioc_status);
+		goto out_failed;
+	}
+	return 0;
+out_failed:
+	return -1;
+}
+
+/**
+ * mpi3mr_cfg_set_man_pg5 - Write manufacturing page 5
+ * @mrioc: Adapter instance reference
+ * @man_pg5: Pointer to the manufacturing page 5 to write
+ * @pg_sz: Size of the memory allocated to the page pointer
+ *
+ * This is handler for config page write for manufacturing
+ * page 5. This will modify only the current page.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+int mpi3mr_cfg_set_man_pg5(struct mpi3mr_ioc *mrioc,
+	struct mpi3_man_page5 *man_pg5, u16 pg_sz)
+{
+	struct mpi3_config_page_header cfg_hdr;
+	struct mpi3_config_request cfg_req;
+	u16 ioc_status = 0;
+
+	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
+	memset(&cfg_req, 0, sizeof(cfg_req));
+
+	cfg_req.function = MPI3_FUNCTION_CONFIG;
+	cfg_req.action = MPI3_CONFIG_ACTION_PAGE_HEADER;
+	cfg_req.page_type = MPI3_CONFIG_PAGETYPE_MANUFACTURING;
+	cfg_req.page_number = 5;
+	cfg_req.page_address = 0;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
+	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
+		ioc_err(mrioc, "manufacturing page5 header read failed\n");
+		goto out_failed;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "manufacturing page5 header read failed with ioc_status(0x%04x)\n",
+		    ioc_status);
+		goto out_failed;
+	}
+
+	cfg_req.action = MPI3_CONFIG_ACTION_WRITE_CURRENT;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
+	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, man_pg5, pg_sz)) {
+		ioc_err(mrioc, "manufacturing page5 write failed\n");
+		goto out_failed;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "manufacturing page5 write failed with ioc_status(0x%04x)\n",
+		    ioc_status);
+		goto out_failed;
+	}
+
+	return 0;
+out_failed:
+	return -1;
+}
+
 /**
  * mpi3mr_cfg_get_driver_pg1 - Read current Driver page1
  * @mrioc: Adapter instance reference
@@ -6409,3 +6681,41 @@ int mpi3mr_cfg_get_driver_pg2(struct mpi3mr_ioc *mrioc,
 	return -1;
 }
 
+/**
+ * mpi3mr_cfg_get_page_size - Get the size of requested page
+ * @mrioc: Adapter instance reference
+ * @page_type: Page type (MPI3_CONFIG_PAGETYPE_XXX)
+ * @page_num: Page number
+ *
+ * Return the specified config page size in bytes.
+ *
+ * Return: Page size in bytes, -1 on failure.
+ */
+int mpi3mr_cfg_get_page_size(struct mpi3mr_ioc *mrioc, int page_type, int page_num)
+{
+	struct mpi3_config_page_header cfg_hdr;
+	struct mpi3_config_request cfg_req;
+	u16 ioc_status = 0;
+
+	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
+	memset(&cfg_req, 0, sizeof(cfg_req));
+
+	cfg_req.function = MPI3_FUNCTION_CONFIG;
+	cfg_req.action = MPI3_CONFIG_ACTION_PAGE_HEADER;
+	cfg_req.page_type = page_type;
+	cfg_req.page_number = page_num;
+	cfg_req.page_address = 0;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
+	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
+		ioc_err(mrioc, "header read failed\n");
+		return -1;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "header read failed with ioc_status(0x%04x)\n",
+		    ioc_status);
+		return -1;
+	}
+
+	return le16_to_cpu(cfg_hdr.page_length) * 4;
+}
-- 
2.43.5

