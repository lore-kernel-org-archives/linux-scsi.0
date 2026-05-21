Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A101388898;
	Thu, 21 May 2026 18:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779386778; cv=none; b=t7KrHA/NQo6aN4hlpvxBqcUL4MHcceJhgHLnKtpYw/PXMho6uPmag3lcAix9iRjGtyJuFo95CT81LdgO+yUnlFqZEpqTjtSmdxWRmz272Q3fSI8EP15HeXzr/RGnkIplwHIDFqZRm9XGKR5DzGzA0pWKqi3FE8A5PHLNj5cFbA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779386778; c=relaxed/simple;
	bh=Kt0SJjijzF3DxGfviEvOli1eUuoSgJky2Z7euxJir3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBLn2+gxNqRyJJ5eiMURsb5i1TJJQ7oPuFQXimlUUTs4dd7z0ymwhNQbGaOrFt9DIgiSyYYbSDI9WzCdZylw4m+EJFtye/jhsRWaem6j5htetncjakWjsejYzAZZ4XxrE82DgT5QGjbyRAidOTIN5jHfvKTwMGyaErd/9oT2Jsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=TfG00NCK; arc=none smtp.client-ip=173.37.86.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="TfG00NCK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=5108; q=dns/txt;
  s=iport01; t=1779386776; x=1780596376;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n69JzMxubxTRMtCgTK/DxC8IB4k0zOUIBrwIJCEIMP4=;
  b=TfG00NCKv7R6AWVvPnKY7RXJvUV3lI/ZkJAcgLfHB4IKGlyZEIvsu3yT
   jgeOQMBTdXp/02/dyNYd9+hRaVClsK08KCgN0R7Ak9kCFqa2kqQsG1Cwa
   +KwP9lerFuhqKSjK2lSZqku/9EACmLxGStCBsxcjA0PpVjb+EZvDgyH3h
   BpZPXkhbVp+3CBnIIDbl59SPm3m5DPxax752ohuXdABiU1mbQQALnXRP0
   Th0+OVtbhPQOakO8/g5PaDnho/JNclFxnSuHGe5/4Lw9jkjNck/iTsiGv
   YBv2lnD2imoGOzJAHLEqfZOMBxM0a67MzBCpdUjiy1+STRi7+tSso1Evm
   g==;
X-CSE-ConnectionGUID: HsUjfyeGQ0y6Govh3Krn2Q==
X-CSE-MsgGUID: YlvN9053TwmujZJi1n0w8g==
X-IPAS-Result: =?us-ascii?q?A0BCAgAqSA9q/5L/Ja1aglmCV4FQQxkwlCqDN50IgX8PA?=
 =?us-ascii?q?QEBD1EEAQGFBgKNMgImNAkOAQIEAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHB?=
 =?us-ascii?q?YEOE4ZchlsCAQMnCwFGEFFWGYMCgnQDtCWBeTOBAd5BgWQBCxQBgTiNXHSEe?=
 =?us-ascii?q?ycVBoFJRIEVgnJ2gVKCSYZsBIMujxxIgR4DWSwBVRMNCgsHBYFmAzUSKhVuM?=
 =?us-ascii?q?h2BIz4XgQsbBwWBS4E3cmqBBIRXeCMsA06BLYFrAwsYDUgRLDcUGwQ+bgeKe?=
 =?us-ascii?q?RwPgioHgQ+CP5NPkj+hDoQmoVgaM6pqmQWjcIVQgWg8gVkzGggbFYMiUxkP2?=
 =?us-ascii?q?WknMj0CBwIHDgMLhkmLIIF8AQE?=
IronPort-Data: A9a23:jThAP6rytCEhiADsnFrY1+r79XJeBmKTZBIvgKrLsJaIsI4StFCzt
 garIBmDO/ffNmP0fNF0b9mw/BgPu5XWnYAxHQM+/31kRSxDoOPIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7zdOCn9j8kif3gqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYgPNNwJcaDpOtfre8ko34JwehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86r5K255G7Q4yA2AdqjlLvhGmVSKlIFFVHT4pb+c/HKbilq/kTe4I5iXBYvQRs/ZwGyojxE4
 I4lWapc5useFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpfh660GMa04AWEX0sZsPGNA5
 PE3EWgcMD+EmeLt46i9ENA506zPLOGzVG8ekmtrwTecCbMtRorOBv2bo9RZxzw3wMtJGJ4yZ
 eJANmEpN0uGOUASfA5LVvrSn8/w7pX7Wz5Rsk6UoaM0y2PS1wd2lrPqNbI5f/TWGp0PxB7D/
 T+uE2LRMxUEEo3HlGG57XexhN3tnHr9AJ1CG+jtnhJtqBjJroAJMzUWXEG2ifq0kEizX5RYM
 UN80iYnq+45/VazQ9/hUgeQpH+CtwQbHd1KHIUS6gyPwILQ4gCEFi4FRDsHY9sj3OczTCY21
 1nPh971CCZ0vbu9TmiU/bOZ6zi1PEA9JGMLZigcShYt+dTvoIgvyBnIS75LEqu4iND6GTDY2
 T2GrCEiwb4UiKYjzail8ErcqyihqpjAUkg+4QC/dmap8wVybYiNfJGz5B7Q6vMoBIKYSESR+
 XsJgc6T6MgQApyX0i+AWuMAGPeu/fntGDndh0N/WoIq7DWF5XGuZ8ZT7St4KUMvNdwLEQIFe
 2fJsg9XoZsWN3ywYOovMsS6Ct8hyu7rEtGNuu3oU+eiq6NZLGevlByCr2bKt4wxuCDASZ0CB
 Ko=
IronPort-HdrOrdr: A9a23:CqS3Q60AnvE+iKJGG7wwZQqjBHgkLtp133Aq2lEZdPWaSKClfq
 eV7ZAmPHDP5gr5NEtLpTnEAtjifZq+z+8R3WByB9aftWDd0QPCEGgh1/qB/9SKIULDH4BmuJ
 tIQuxXFMDwAV9mjczz/QW0V+o7zMLvytHOuQ6n9RdQZDAvTb185AFkDQveOEh3SA5aQacdLv
 Onl6x6T/7KQwVuUix9bUN1JtT+mw==
X-Talos-CUID: =?us-ascii?q?9a23=3A1TM+YWsCFP4UxwVg0+MUlzFW6IsFaUDfwmbdDHb?=
 =?us-ascii?q?gGDhGT6OVEnyK/vldxp8=3D?=
X-Talos-MUID: 9a23:b9UnnAaYDLKwIuBThjvyomA6aZxU/KGzCnIvkMwA49bUOnkl
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,160,1774310400"; 
   d="scan'208";a="470220335"
Received: from rcdn-l-core-09.cisco.com ([173.37.255.146])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 21 May 2026 18:06:15 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.18.181])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-09.cisco.com (Postfix) with ESMTPSA id 1AA2618000496;
	Thu, 21 May 2026 18:06:14 +0000 (GMT)
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	aeasi@cisco.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmeneghi@redhat.com,
	revers@redhat.com,
	dan.carpenter@linaro.org,
	adakopou@redhat.com,
	lduncan@suse.com,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 03/13] scsi: fnic: Decode firmware role configuration
Date: Thu, 21 May 2026 11:04:48 -0700
Message-ID: <20260521180458.5448-4-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260521180458.5448-1-kartilak@cisco.com>
References: <20260521180458.5448-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.18.181];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.18.181, [10.188.18.181]
X-Outbound-Node: rcdn-l-core-09.cisco.com

Add FNIC_ROLE_CONFIG_MASK and use it to decode firmware role bits
when reading vNIC configuration and probing the PCI device.

Accept FCP and NVMe initiator roles, report FC target and FC-NVMe target
roles explicitly as unsupported, and keep truly undefined role settings
on the existing FC initiator default path.

Log the configured role flags and expose role names for trace output.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/fnic/fnic.h       |  1 +
 drivers/scsi/fnic/fnic_main.c  | 23 +++++++++++++++++++++--
 drivers/scsi/fnic/fnic_res.c   | 29 +++++++++++++++++++++++++++--
 drivers/scsi/fnic/fnic_trace.c |  5 +++--
 4 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index ad152fb4c15f..54ee52c453ba 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -43,6 +43,7 @@
 #define FNIC_DFLT_QUEUE_DEPTH	256
 #define	FNIC_STATS_RATE_LIMIT	4 /* limit rate at which stats are pulled up */
 #define LUN0_DELAY_TIME			9
+#define FNIC_ROLE_CONFIG_MASK   (0xFF0)
 
 /*
  * Tag bits used for special requests.
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 7c7f9ea5267b..3a365ea455b1 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -844,7 +844,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_fnic_get_config;
 	}
 
-	switch (fnic->config.flags & 0xff0) {
+	switch (fnic->config.flags & FNIC_ROLE_CONFIG_MASK) {
 	case VFCF_FC_INITIATOR:
 		{
 			host =
@@ -863,8 +863,27 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 					fnic->fnic_num);
 		}
 		break;
+	case VFCF_FC_TARGET:
+		dev_info(&fnic->pdev->dev,
+			 "fnic: %d is scsi target\n",
+			 fnic->fnic_num);
+		err = -EOPNOTSUPP;
+		goto err_out_fnic_role;
+	case VFCF_FC_NVME_INITIATOR:
+		fnic->role = FNIC_ROLE_NVME_INITIATOR;
+		dev_info(&fnic->pdev->dev, "fnic: %d is NVME initiator\n",
+			fnic->fnic_num);
+		break;
+	case VFCF_FC_NVME_TARGET:
+		dev_info(&fnic->pdev->dev,
+			 "fnic: %d is NVME target\n",
+			 fnic->fnic_num);
+		err = -EOPNOTSUPP;
+		goto err_out_fnic_role;
 	default:
-		dev_info(&fnic->pdev->dev, "fnic: %d has no role defined\n", fnic->fnic_num);
+		dev_info(&fnic->pdev->dev,
+			"fnic: %d has no role defined (0x%x)\n",
+			fnic->fnic_num, fnic->config.flags & FNIC_ROLE_CONFIG_MASK);
 		err = -EINVAL;
 		goto err_out_fnic_role;
 	}
diff --git a/drivers/scsi/fnic/fnic_res.c b/drivers/scsi/fnic/fnic_res.c
index 9801e5fbb0dd..18353fbb5f98 100644
--- a/drivers/scsi/fnic/fnic_res.c
+++ b/drivers/scsi/fnic/fnic_res.c
@@ -22,6 +22,7 @@
 int fnic_get_vnic_config(struct fnic *fnic)
 {
 	struct vnic_fc_config *c = &fnic->config;
+	u32 role;
 	int err;
 
 #define GET_CONFIG(m) \
@@ -58,9 +59,31 @@ int fnic_get_vnic_config(struct fnic *fnic)
 	GET_CONFIG(intr_mode);
 	GET_CONFIG(wq_copy_count);
 
-	if ((c->flags & (VFCF_FC_INITIATOR)) == 0) {
-		dev_info(&fnic->pdev->dev, "vNIC role not defined (def role: FC Init)\n");
+	role = c->flags & FNIC_ROLE_CONFIG_MASK;
+	switch (role) {
+	case 0:
+		dev_info(&fnic->pdev->dev,
+			 "vNIC role not defined (def role: FC Init)\n");
 		c->flags |= VFCF_FC_INITIATOR;
+		break;
+	case VFCF_FC_INITIATOR:
+	case VFCF_FC_NVME_INITIATOR:
+		break;
+	case VFCF_FC_TARGET:
+		dev_info(&fnic->pdev->dev,
+			 "vNIC role is FC Target (unsupported)\n");
+		break;
+	case VFCF_FC_NVME_TARGET:
+		dev_info(&fnic->pdev->dev,
+			 "vNIC role is FC-NVMe Target (unsupported)\n");
+		break;
+	default:
+		dev_info(&fnic->pdev->dev,
+			 "vNIC role not supported (0x%x), defaulting to FC Init\n",
+			 role);
+		c->flags &= ~FNIC_ROLE_CONFIG_MASK;
+		c->flags |= VFCF_FC_INITIATOR;
+		break;
 	}
 
 	c->wq_enet_desc_count =
@@ -163,6 +186,8 @@ int fnic_get_vnic_config(struct fnic *fnic)
 		     c->port_down_io_retries, c->port_down_timeout);
 	dev_info(&fnic->pdev->dev, "fNIC wq_copy_count: %d\n", c->wq_copy_count);
 	dev_info(&fnic->pdev->dev, "fNIC intr mode: %d\n", c->intr_mode);
+	dev_info(&fnic->pdev->dev, "fNIC role flags: 0x%x\n",
+			(c->flags & FNIC_ROLE_CONFIG_MASK));
 
 	return 0;
 }
diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index 4ed57ea1f854..ba5bfce92c15 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -30,8 +30,9 @@ int fnic_fc_tracing_enabled = 1;
 int fnic_fc_trace_cleared = 1;
 static DEFINE_SPINLOCK(fnic_fc_trace_lock);
 
-static const char * const fnic_role_str[] = {
-	[FNIC_ROLE_FCP_INITIATOR] = "FCP_Initiator",
+const char *fnic_role_str[] = {
+	[FNIC_ROLE_FCP_INITIATOR]  = "FCP_Initiator",
+	[FNIC_ROLE_NVME_INITIATOR] = "NVMeF_Initiator",
 };
 
 const char *fnic_role_to_str(unsigned int role)
-- 
2.47.1

