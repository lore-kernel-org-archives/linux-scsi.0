Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793794259;
	b=F0TdTzhDixdb6c/TVSgxV9Ab+2blF2w4YXQY21eCRYew/4X+lE0pIC0JWAldYCAgzPE0
	 SIKpeMjSSOsI1Ugwt53QoC68qXU5EEvTCS/w2QlymShC86HqalUI6JdBx3Swy1f2cQUnI
	 Axmyw5mftAcwIK0QaXPh+TwNeNOO+QU3zV+VtT+mqN5l9QZi4M0NzZx23SMVHvQyJUBAE
	 cZXPt2PFRfUU6OUYyANppEUKX9bXDE7gK5kQ+IRjshKxxNaZBDMSDspKFvW2Xtv55uq9b
	 dyz8FyG0+5tKV00ed6CsPxwxvW+/tZhvGkBo4H994rOUcOZCcLuB1lK90m/o8RYk1mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793794259;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=Q6d7mX52ZIS3nYrkqsRL0QIyJ6xOO1u5oHUZ/QcUNHM=;
	b=FoMP3z88GB6Dz6a1tBXQ1f5wpdST9nR6Mj5zn9Oe7uGBOfUyKjljxmkA5Jx9FqELWBr+
	 oKeAsLejDSmpGQXL+A1ydn+3gAq7AaXVn89/eFJxdzsLm/jSl/OJg2mYL9HydLoPV5zWp
	 Wa0e5sa4pJLN+5ZmBjcLE5bNdLVvho8FtViBlIdVzWf3twKcf3W6n0yAGybBD0VqJ6EF/
	 fEZzAYOqBBEA7BlZ0CMz1kF3S5NjjLHxMTCx/fbPG7PNfXnb37qKv/5aWA2K3avuf6nS1
	 ZWfTLOGbk2gE6XvHJAH0rABIImnxzihc9xj+1KkkPxF0jOzMsJwgY68ANINeYXjmSWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=B0RQplVm;
	arc=none smtp.remote-ip=209.85.128.228
Received: from mail-yw1-f228.google.com (mail-yw1-f228.google.com [209.85.128.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F9B606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 12:10:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55F9B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=B0RQplVm
Received: by mail-yw1-f228.google.com with SMTP id 00721157ae682-8b10d24345dso5435617b3.3
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793794258; x=1794399058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q6d7mX52ZIS3nYrkqsRL0QIyJ6xOO1u5oHUZ/QcUNHM=;
        b=RgjZZvMkg1WLDxDILV8pyqYTf9oDLlP6zsg1xWqVOLieq3/SKyQVAaYaG17CLlY/xX
         DiS0wADXwznUXAzucf02TF3I5H60U7wbFNMHPzcNYkTxqBLqQFOOvnfaERRlvO9BsMcQ
         UBaO6OtEYP4sZEzmQUC2sE7hT/u6IGcbRSpxSdOOU45SEuUnngrR3KJfI2NMoOsCPEUR
         AoO6vQLSAlvO9XIBfK4V0DUlJB+QNY2y8dJ1L62GD1JiR5PyjH0Kh+aTrc1TvnTZstDS
         jAwxAct7schj/ZdyH4L+bQP9EKHtWe/RNUpp6xbo6uzojIVGijJJgOXpXV0WILrlHatL
         679g==
X-Gm-Message-State: APuU4Z+xmhN9ugFUUuTz1aTR5TBVunVk4rRVdUGvHYqZWtxQQh55c+GQ
	l4iFP1mYu9ChlAWFzpMORYGm0l0tbamYwvQZM9opgEQB4w/ZB6VXY9FJkhpMF0XrmrmiMBoShbn
	N6d0wAvkHVwMd3X250e98aw2bDt7JtN77gNXOPyAKpaBRCy8R6tkza8dQslZ0yp2o3ZC5lkUMNM
	xGYRkdpSmPfu5BVtfj9pM5q752vln8KHmAj+W0ZdpSk7IiAPHK8sLjRiDJMpX9BKgAbhDFfI68+
	P7IbzAYNeZsrO/u
X-Gm-Gg: AYBFou2PGE/AnldYrsbnH7wWQ0XMVir+B4xAzgrJXMFNPLacwVdZA94y6/J/EsOpsWQ
	uDpWagupC7Sz9QfsJJUn9/uMqibhrQSvp5tD/Zs+MESW8s5dvZmYT69hf/7QBxCG0fE10om4c24
	XJhFvPYQhMaR3Xy+7FlcowcJDlBEREwBQluabeV2xD7AgzPb2ETYW4WqZJY58F48T6SfvLWXQeL
	vLqTDI0N5hNzmtaQbCR4cJQ5kAxfB9UdjxOTg4bMc0E7w9wBtg4BuZWkDOjMEo6M8fjNz1vSeK6
	TzPMOvPs55p3Z3NY8W4OgoLvaaRPIfT4h8aWAePS8gBCDoGv2niVpnYjVGU8Ttmpz7MQAxjHl9B
	PlQ2+HOFwCfVAVZoiwq16fb/Z/DpfoEYJvigJnfbqzQ1Sw+K0U8B6SNJGMx4a7czzPxuJogDnI3
	HfapuXSn/nItmPqEHFZqO57LV1k0+LdCoRQag=
X-Received: by 2002:a05:690c:d83:b0:8b2:fde5:d95e with SMTP id 00721157ae682-8b2fde5e72dmr28894127b3.63.1793794258150;
        Wed, 04 Nov 2026 04:10:58 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-8b309d400c1sm180897b3.27.2026.11.04.04.10.57
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:10:58 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-147be78cd56so524829c88.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 04:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793794257; x=1794399057; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q6d7mX52ZIS3nYrkqsRL0QIyJ6xOO1u5oHUZ/QcUNHM=;
        b=B0RQplVmSLuXk3fqgw++DUXQpFCjqyepiqv4C6B4VRNbPWFxBHzJUp56s5UDt7FYoA
         OPU1lAcuvxMe/MwqQkkSV26A4ViX8/+on0wfSfQ9f00Sz4SDsS/TFgBa0+9SEuk/IQh7
         AtmMOCwdDGOlq1KxjWcad4BGNyka5a9rhoPfg=
X-Received: by 2002:a05:7022:3b88:b0:16d:1e24:5cc3 with SMTP id a92af1059eb24-1ac5c64c610mr26813545c88.19.1793794256619;
        Wed, 04 Nov 2026 04:10:56 -0800 (PST)
X-Received: by 2002:a05:7022:3b88:b0:16d:1e24:5cc3 with SMTP id a92af1059eb24-1ac5c64c610mr26813480c88.19.1793794255169;
        Wed, 04 Nov 2026 04:10:55 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm9377095c88.21.2026.11.04.04.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:10:54 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH 19/21] scsi: mpi3mr: Fix byte order handling in the NVMe passthrough commands
Date: Wed,  4 Nov 2026 17:31:00 +0530
Message-ID: <20261104120103.503871-20-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104120103.503871-1-ranjan.kumar@broadcom.com>
References: <20261104120103.503871-1-ranjan.kumar@broadcom.com>
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The NVMe passthrough code reads the command dword that selects PRP or SGL
and applies the SGE modifier to the addresses without converting between
CPU and little endian byte order. On a big endian host the wrong data
format is chosen and the modifier bits end up in the wrong place of the
address.

Convert the command dword when reading it, and keep the modifier mask and
value in little endian form like the address fields they are applied to.

Fixes: 7dbd0dd8cde3 ("scsi: mpi3mr: Add support for NVMe passthrough")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=2
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 310ead2c644e..2dc6fad7a37b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1969,7 +1969,7 @@ static unsigned int mpi3mr_get_nvme_data_fmt(
 {
 	u8 format = 0;
 
-	format = ((nvme_encap_request->command[0] & 0xc000) >> 14);
+	format = ((le32_to_cpu(nvme_encap_request->command[0]) & 0xc000) >> 14);
 	return format;
 
 }
@@ -1998,10 +1998,10 @@ static int mpi3mr_build_nvme_sgl(struct mpi3mr_ioc *mrioc,
 	u16 available_sges = 0, i;
 	u32 sge_element_size = sizeof(struct mpi3mr_nvme_pt_sge);
 	struct mpi3mr_buf_map *drv_buf_iter = drv_bufs;
-	u64 sgemod_mask = ((u64)((mrioc->facts.sge_mod_mask) <<
-			    mrioc->facts.sge_mod_shift) << 32);
-	u64 sgemod_val = ((u64)(mrioc->facts.sge_mod_value) <<
-			  mrioc->facts.sge_mod_shift) << 32;
+	__le64 sgemod_mask = cpu_to_le64(((u64)((mrioc->facts.sge_mod_mask) <<
+			    mrioc->facts.sge_mod_shift) << 32));
+	__le64 sgemod_val = cpu_to_le64(((u64)(mrioc->facts.sge_mod_value) <<
+			  mrioc->facts.sge_mod_shift) << 32);
 	u32 size;
 
 	nvme_sgl = (struct mpi3mr_nvme_pt_sge *)
@@ -2097,10 +2097,10 @@ static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
 	size_t length = 0, desc_len;
 	u8 count;
 	struct mpi3mr_buf_map *drv_buf_iter = drv_bufs;
-	u64 sgemod_mask = ((u64)((mrioc->facts.sge_mod_mask) <<
-			    mrioc->facts.sge_mod_shift) << 32);
-	u64 sgemod_val = ((u64)(mrioc->facts.sge_mod_value) <<
-			  mrioc->facts.sge_mod_shift) << 32;
+	__le64 sgemod_mask = cpu_to_le64(((u64)((mrioc->facts.sge_mod_mask) <<
+			    mrioc->facts.sge_mod_shift) << 32));
+	__le64 sgemod_val = cpu_to_le64(((u64)(mrioc->facts.sge_mod_value) <<
+			  mrioc->facts.sge_mod_shift) << 32);
 	u16 dev_handle = le16_to_cpu(nvme_encap_request->dev_handle);
 	struct mpi3mr_tgt_dev *tgtdev;
 	u16 desc_count = 0;
-- 
2.47.3

