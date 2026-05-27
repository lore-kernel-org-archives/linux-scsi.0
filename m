Received: from rcdn-iport-1.cisco.com (rcdn-iport-1.cisco.com [173.37.86.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30993B19A5;
	Wed, 27 May 2026 19:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779911499; cv=none; b=cDQWbG1t49c0enMhUGI7PFaPFlLbKrfmwgbzUWg6uSpOiSxiwax9y/dTb98d0Nfu9Xe7aEzyZ1o9akRZgR0Vya3nuUNBQbxEwWrnGz63cv9l/1tRgm13XHMH/czxuvYgtse8mWXEA2EWp7NrkdRuJEAnMYg2UIWGiOHzYd4zGak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779911499; c=relaxed/simple;
	bh=Kt0SJjijzF3DxGfviEvOli1eUuoSgJky2Z7euxJir3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4f3WnC2HHGA1afwLf5desEFYSsc6GaP48rs8pHz/XlOX8p7prrSB2j1Y6f7sIgaGD2Fe9yZL1PlVV8Cp12PT7KLrTqfSn3m3fQSVd7KL7Z5UAXicsUPv8LgZRVH6pnzdw2i9eQbrEkCI2ulCoj107ZOcsQY0ch/msXVgI0S7lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=KSXb8uba; arc=none smtp.client-ip=173.37.86.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="KSXb8uba"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=5108; q=dns/txt;
  s=iport01; t=1779911497; x=1781121097;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n69JzMxubxTRMtCgTK/DxC8IB4k0zOUIBrwIJCEIMP4=;
  b=KSXb8ubay3IMi5BHWtA5P4gy+5VyvtmtL+QPiXcW970Jpyu7GV5CSU+L
   4IfHZhwxefVUSCj8DtfQUn7t/rsp9AYM38+ZGy0nYkAVkK05Zxq8FrdvG
   a4j6X43HZEjPAidXugsIIDXsEX8OI0+433I/hz27haR1VTA69zjh/PlCW
   c0mpDIyNoBMBSObCZej7be2uOfEm/7hJhyf7xYxozlCMZT+4BhXiQza8j
   QnrbWTtRzGWvxgv6QeOIucdZ8vXUKEetphVZj/asmME1yM21Db2iuHvlk
   T24lDAZz0nARKaFspomoUARAD/wFHhYuxVzO2bf+qZH1hSD/fcm7EICke
   Q==;
X-CSE-ConnectionGUID: Ltbk/ZR3RI+qxCvHalsHUg==
X-CSE-MsgGUID: NPu3jtT6T6yKiq/txiHwGg==
X-IPAS-Result: =?us-ascii?q?A0BCAgDGShdq/5P/Ja1aglmCV4FQQxkwlCqDN50IgX4PA?=
 =?us-ascii?q?QEBD1EEAQGFBgKNMgImNAkOAQIEAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHB?=
 =?us-ascii?q?YEOE4ZchlsCAQMnCwFGEFFWGYMCgnQDtFCBeTOBAd5BgWQBCxQBgTiNXHSEe?=
 =?us-ascii?q?ycVBoFJRIEVgnJ2gVKCSYZsBIMujxFIgR4DWSwBVRMNCgsHBYFmAzUSKhVuM?=
 =?us-ascii?q?h2BIz4XgQsbBwWBS3ZyaoEFhRgjJgNOgS2Bf10DCxgNSBEsNxQbBD5uB4p1G?=
 =?us-ascii?q?g+CKgeBD4I/k0+SP6EOhCahWxozqmuZBqNwhVCBaDyBWTMaCBsVgyJTGQ/dI?=
 =?us-ascii?q?ycyPQIHAgcOAwuGSYsggXwBAQ?=
IronPort-Data: A9a23:cNrDV67ji3gPp3hfkmu2ewxRtMnGchMFZxGqfqrLsTDasY5as4F+v
 mdJD26HPPuLMGPyKIgiaIy29RxQ6JaHyNdkTwVtqSw2Zn8b8sCt6fZ1gavT04J+CuWZESqLO
 u1HMoGowPgcFyGa/lH2dOC98RGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYDR7zil5
 5Wo/6UzBHf/g2Qqaj9OtPrZwP9SlK2aVA0w7wRWic9j5Dcyp1FNZLoDKKe4KWfPQ4U8NoaSW
 +bZwbilyXjS9hErB8nNuu6TnpoiG+O60aCm0xK6aoD66vRwjnVaPpUTaJLwXXxqZwChxLid/
 jniWauYEm/FNoWU8AgUvoIx/ytWZcWq85efSZSzXFD6I0DuKxPRL/tS4E4eGZES+aFFOzp01
 L8BOBsTThmHnMKLz+fuIgVsrpxLwMjDJogTvDRkiDreF/tjGMiFSKTR7tge1zA17ixMNa+BP
 IxCNnw1MUmGOkEQUrsUIMpWcOOAhXDlbzxcoVG9rqss6G+Vxwt0uFToGIaFJIDTHpgFxy50o
 Ergx3miAA0mauDB2BmE6zWwlu7vggz0Ddd6+LqQs6QCbEeo7mwaEhA+Vlahp/S9zEmkVLp3K
 UEW8AIqrK4v5AqqRNy7VBq9yFaBtwQAWtwWC+Am5RuWx6z85ByQDWwJCDVGbbQOvcM/Rjsy0
 UKhhd7lBTVz9raSTBq19LKZqz69OSk9N2IOZSYYCwAC5rHLuowtgwjUZsxuHK68kpv+HjSY6
 zSGsS41jrM7ltMQ2uOw+lWvqzatoIXZCw04/APaWkq74Q5jIo2ofYql7R7c9/koBIKYSESR+
 WMPgMm28u8DF9eOmTaLTeFLG6umj8tpKxXGilJpWp1k/DO39jv6JcZb4Sp1IwFiNcNslSLVX
 XI/cDh5vPd7VEZGp4cuC25tI6zGFZTdKOk=
IronPort-HdrOrdr: A9a23:ga1K36lvjd4hryCt5KZ5O1EbC8bpDfLm3DAbv31ZSRFFG/FwWf
 rDoB19726RtN9/Yh8dcLy7UpVoBEmslqKdgrNhWItKPjOGhILAFugLhrcKgQeQeREWndQz6U
 4PScVDIey1JURmjMr8/QmzG8stzZ266qyy7N2uqEuFNTsLV4hQqyFkFw2cDkp6ACNCBZY/Cd
 6gw/AvnUvHRZzSBf7LfkXsmIP41qT2qK4=
X-Talos-CUID: =?us-ascii?q?9a23=3A4dTZeWpY4iu+PY1Le7s+z8HmUeQ5eH6a/k2LGW7?=
 =?us-ascii?q?7EHZCVp2cTUSwxawxxg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AombiXw63+CzvSImRE1ZcPetmxoxO27n1Clwxz6l?=
 =?us-ascii?q?YquqFLGtsKza9kxu4F9o=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,172,1774310400"; 
   d="scan'208";a="486413581"
Received: from rcdn-l-core-10.cisco.com ([173.37.255.147])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 27 May 2026 19:51:30 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.14.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-10.cisco.com (Postfix) with ESMTPSA id 5D2D618000276;
	Wed, 27 May 2026 19:51:29 +0000 (GMT)
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
	adakopou@redhat.com,
	lduncan@suse.com,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH v2 03/13] scsi: fnic: Decode firmware role configuration
Date: Wed, 27 May 2026 12:49:50 -0700
Message-ID: <20260527195000.8444-4-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260527195000.8444-1-kartilak@cisco.com>
References: <20260527195000.8444-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.14.55];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.14.55, [10.188.14.55]
X-Outbound-Node: rcdn-l-core-10.cisco.com

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

