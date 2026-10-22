Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792687811;
	b=gYfcFdBbjwet3FOqLkvhMrYWu9kFju6fu1pSCTeDQJHXJP4GrnlqxvnsYBC9HfO/VSKU
	 5/VPPy2L+WFonC2SuKeo4mv/ScPQvbWgjnXxR6G8cp+ch6m6s5k9GGISRFe83bIP/Kmn/
	 ZiJDcWSVNoxFjwe9ZG2J4F8TYrlMOWSqqeBaA0dwhgCCwK4jy3KzATxyaOZU3WvPDoDm9
	 Sl7fCtcKUdd6qImCG2pzavKEyaq874iRN9cMIWv4euwf+vdCCrjIZIEFALq3v8yS8OFNr
	 yT9aHhMGf27wTsB+kdLB6Lnm7Cc/ikDm8CXaDzwqZTPlh4hmf5sjhsM0MBqDlwE2eqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792687811;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DYshgIa6KnBet2+0IXua2x2TyzIJmXFM77y+p9+FuZQ=;
	b=EFg73vT6fsVAYLtoHR3pRMK18AML7VByMiUvqLxhDdqvByN8Fz3Hb9USM4GZwI5jhsU8
	 XWP+YurC6TF/7S5hU37V9IV7D2VrNKASUuVA2NJeoLk41ELpZ1y4oFPqGG8qDUyGNqML/
	 qulmfX7bC5r6jbJ8jl+CA8jkjQASh+9aodKffVs6+k02zYduFtJ3TVipiQ8bRhk0WDPCG
	 2M6+KKzq6xWBJd4WuOkZ+vkAevvUQxmUSMHEu5SYruESW3fYu47B0Ma5T703Zppt57GEb
	 bU/8au66Aa22QSEL+Gspi7XcOcDM7bsFi593oAPtqhHLjoLeb5x9NYcYASp8W1Ze5Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="nus/qRN7";
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4F6606A31D
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 16:50:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B4F6606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nus/qRN7
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ad787e0593so15809a91.3
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 09:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792687809; x=1793292609; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DYshgIa6KnBet2+0IXua2x2TyzIJmXFM77y+p9+FuZQ=;
        b=nus/qRN7Tkld78bj3tzJ6Nx4QFUDBHzOCLPO/PimuYIVcI7+dVmbPTw7K9WR+Jsww3
         o7DIsENk8rW7Peienxm8dB/tzVLd5Vum320SXU7uJN8ykGHXnF6A9vM9/seZ5upCMI77
         m+VXwJstz78OED2Wq1Yq4JlRUMInBKRz9RzW5nBLHcFqSuJqLV2cFs2/QOiQkG6p9/w3
         RHBT88gK6TMEWYhIwnZGHIO7vBEzyJLuknEwElthdRTi4tTPLnmv2Tk7JZaaGmpQKk1V
         TDX91oF8kDMwXi1IIH+Kivp5fBeXZCzYQqAmPkLrj3yLFa1Mfm/+nqPlefMpKcovBv54
         qb3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792687809; x=1793292609;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DYshgIa6KnBet2+0IXua2x2TyzIJmXFM77y+p9+FuZQ=;
        b=ea7HGETs6GlmI/YDNQ0Uk7vyH1kW7Cy533/gAMwyAh2ALrsm+4ZD/5FKG4E2JZ2y3w
         EucoLP/8bsiAyYPBUm+ZBYTBPk0kdm7icMAGTYd/Vzy06/qOsr8tnGaxc7JVmy8h7KpS
         4ic1MdBDBs1klQ+3K9B4oiT5McW8FoFUKb70040tfLwv0koYby0V+aY05jSpCG8VR/fB
         PB9QMtZPIi6pEC008BDUyxrQKXjBKPP4VF6bEZFmsEpiGoLkLv+/q1qnCSCSneIdFJai
         ZosdfgJXCxWGb/sPD5TiuKqeaXo9tKlvy7G4r7uZgrSphDgGAgDxuZMiLEMfzWaHt7RX
         X3BA==
X-Forwarded-Encrypted: i=1; AKwUvBzj51YD2wNRygZVMqdahLhiGxPS+76ufHCHtne0jRR6DzBMtiCA+jnpRusYj4DQIoQIvSCxTVegMsyf@vger.kernel.org
X-Gm-Message-State: AFq9FYK+iJJj5/78t6S6oDjwm5qWBOdjVBmATB1j/pLEq3SyjzUcfA+M
	4Afqly/0bmVGXVvHd8qvgrRHChBcuoZj1dvvdV1Ve+h6y//CTw7D/RyzhXwY0OuD
X-Gm-Gg: AYBFou3LnMLkpSKYiTCC9R1Y6L/Wz+eEyfjiENZ0eMbe4eY6MyJYmbItci+Z6Uqs2XH
	AnJr8LDIKFfPAGseBPqhwQIr6Dxb/snikL/nZ0+W+8dNLNVkJ/oQ1Pescw83xr/xZ/oZD8q9Zuh
	EEu9vv+olYMz3z34Oywq8mxYvN6R94a/FzUU5I1Z05BMklxnAB2GpubB/Jm64zNd8MjNnZ2iyhA
	E61Bh6EJCVw0psp7qII0VHPZpuZK7STtTj2yG3uC/SJhSnfqK8xopA1geHgqYPSaYuHozcQAg0+
	ZqJAiOI105eQNEPEumnHsiE8STlCfWEhETBR6g9RONxw0y9UFjsl0zMhGPBoMPRYSPESCT5jAcS
	F4rXi25hdR/hr+lh/x0v6IuanqVx9P2bTj2QhNGOC82H9qCT/tb0SLQqQnxZ9iZOKILaD6dtx1R
	d9K4Pl5CSttryM9IA51gf/UfaXqq/445mMZjzDYjLmyLcx1DkhCpnMIoHPTTC3Gp3byxs0XpA7A
	BTcn/ml4VdYN4RVB1n/bCoPCPCjFRmcraX2FfyNP3kdCoLGfh0pM+cWyuqtVfOqgpvYwQYR
X-Received: by 2002:a17:90b:4d06:b0:3ac:9e76:aa93 with SMTP id 98e67ed59e1d1-3ad86dbc0c6mr4089294a91.7.1792687809336;
        Thu, 22 Oct 2026 09:50:09 -0700 (PDT)
Received: from DESKTOP-NM9EKIA ([125.134.240.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada48bb3b6sm5160804a91.13.2026.10.22.09.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 09:50:07 -0700 (PDT)
From: Joonhoe Kim <26rote@gmail.com>
To: mani@kernel.org,
	mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	bvanassche@acm.org,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: qcom: Reprogram ESI after a host controller reset
Date: Fri, 23 Oct 2026 01:50:06 +0900
Message-ID: <20261022165006.1275-1-26rote@gmail.com>
X-Mailer: git-send-email 2.55.0.windows.5
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ufs_qcom_config_esi() returns early once the ESI interrupts are set up.
ufshcd_config_mcq() also calls it after every host controller reset,
which clears the ESI base address, the vector mask and ESI enable. After
the error handler has reset the controller, the completions then arrive
only on the legacy interrupt while mcq_esi_enabled stays set.

Allocate the MSIs and request their interrupts only once, but program
the ESI registers on every call. The MSI message is not cached for
platform MSIs, so keep the one written at allocation.

Fixes: 519b6274a777 ("scsi: ufs: qcom: Add MCQ ESI config vendor specific ops")
Signed-off-by: Joonhoe Kim <26rote@gmail.com>
---
Tested on a Lenovo Y700 Gen 5 (TB323FU, Kaanapali; out-of-tree board
support) on v7.3-rc4 with commit b52d695d0620 ("scsi: ufs: core: Keep
internal commands dispatchable during error handling") applied, forcing
a full reset through the debugfs saved_err file: before,
REG_UFS_MEM_CFG, ESILBA and ESIUBA read 0 after the reset and all
completions came on the legacy interrupt; with this patch they come on
the ESI interrupts again.

 drivers/ufs/host/ufs-qcom.c | 12 +++++++++---
 drivers/ufs/host/ufs-qcom.h |  2 ++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index fee9b54ba5e1..ea2a106cbe26 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -2414,7 +2414,9 @@ static void ufs_qcom_write_msi_msg(struct msi_desc *desc, struct msi_msg *msg)
 {
 	struct device *dev = msi_desc_to_dev(desc);
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 
+	host->esi_msg = *msg;
 	ufshcd_mcq_config_esi(hba, msg);
 }
 
@@ -2442,8 +2444,10 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba)
 	struct ufs_qcom_irq *qi;
 	int nr_irqs, ret;
 
-	if (host->esi_enabled)
-		return 0;
+	if (host->esi_enabled) {
+		ufshcd_mcq_config_esi(hba, &host->esi_msg);
+		goto enable;
+	}
 
 	/*
 	 * 1. We only handle CQs as of now.
@@ -2481,12 +2485,14 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba)
 		}
 	}
 
+	host->esi_enabled = true;
+
+enable:
 	if (host->hw_ver.major >= 6) {
 		ufshcd_rmwl(hba, ESI_VEC_MASK, FIELD_PREP(ESI_VEC_MASK, MAX_ESI_VEC - 1),
 			    REG_UFS_CFG3);
 	}
 	ufshcd_mcq_enable_esi(hba);
-	host->esi_enabled = true;
 	return 0;
 }
 
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 944b2e532a09..d2647695abe3 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -5,6 +5,7 @@
 #ifndef UFS_QCOM_H_
 #define UFS_QCOM_H_
 
+#include <linux/msi.h>
 #include <linux/reset-controller.h>
 #include <linux/reset.h>
 #include <soc/qcom/ice.h>
@@ -360,6 +361,7 @@ struct ufs_qcom_host {
 	u32 phy_gear;
 
 	bool esi_enabled;
+	struct msi_msg esi_msg;
 
 	u32 saved_tx_eq_g1_setting;
 	u32 boot_spare_cfg;

base-commit: 2efb7a11f1aa4d2dc285fe2680cca22cb9f72f64
-- 
2.43.0

