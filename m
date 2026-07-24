Received: from alln-iport-5.cisco.com (alln-iport-5.cisco.com [173.37.142.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4A831618C;
	Fri, 24 Jul 2026 17:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784915474; cv=none; b=iK/NIL9Hmtp23p6m1pQv2ts2qnbCbyECnUNXD9wNaxqzYhCJENmKp9GraoXzz+IadaRoVEDRYtUmS1qmBCZPMmoXuslWDPbdCA/QdPpf/3+0FNCycTVnib/4JYsfywLMJH3VA9CYwWCkco1gVHNkHrv1XO48oWPLy0JqDFJwlLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784915474; c=relaxed/simple;
	bh=LYzcPesBTVRMIYuTLBcffosYZiw4HQptOWFk52MsR0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3hBOY2NnwaW3oew4eFfby1yCnRn64hx6cyguR3jEeMEGr2vK4cwaRlG2kGezx7Eac5oUzZ2PGxEdrEYeLdSLnmSgduqS3jajrHigHtGZRNbZ0m97BGnl9XADVFsKLR2VkRDRaY0ujQNhxqATGiZdJtL30d3FbjyTLVGVTxJnn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=Z4OzBdzU; arc=none smtp.client-ip=173.37.142.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="Z4OzBdzU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=5259; q=dns/txt;
  s=iport01; t=1784915472; x=1786125072;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sIXhqXAXuiZRaP2Z2ACu2eWSpsZzxZsHHTLfERAvWhA=;
  b=Z4OzBdzUSQDteRtujA9Zsq3cgX5zQASvejIFlX0G+3lLV6yac6/wE+EB
   BcMsiMLnrVMZb8wN0LrvEI68EEC85u+y5eJ25t9F3tRvJ98l9ST9MZ/A5
   ZHkF3nE6uhnkQ0Yxnf++WUOoRkVgF1uzmrxLIbooJ0eMZzv8KsYV75RdO
   Tsijihq89lMnW05+o/mDczu57DfaJItg6EWdQKOnaKLU9gEFT1JXYYz+8
   Dz8hRAsuT7W9GPbEZR7+3NfyXCPxuaKnm4Rf0uWimjf10A2+fEKHoXvXW
   AYYc64XnaG7wwg+qeedYjez/BXo4a67To94+nIzacxNYw6O4zvc2Ks5UO
   Q==;
X-CSE-ConnectionGUID: U0ZBDvDiS82TUMfQWVdrPg==
X-CSE-MsgGUID: Gac+qMpzRKK3GkXQwgJEOQ==
X-IPAS-Result: =?us-ascii?q?A0BCAgD1pGNq/5AQJK1aglmCV4FSQxkwlCmDN50IgX4PA?=
 =?us-ascii?q?QEBD1EEAQGFBQKNYAImNAkOAQIEAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHB?=
 =?us-ascii?q?YEOE4ZchlsCAQMnCwFGEFFWGYMCgnUDwk6BeTOBAd5FgWYBCxQBgTiNX3WEf?=
 =?us-ascii?q?CcVBoFJRIEVgnN2gVKCSYZtBIMuhUWMe0iBHgNZLAFVEw0KCwcFgWYDNRIqF?=
 =?us-ascii?q?W4yHYEjPheBDBsHBYEdgSx5hFgjHwM5f4EvdUp3LWkBEheBJoNLAoFPAwsYD?=
 =?us-ascii?q?UgRLDcUGQQ+bgeNdyOCOQeBD4I+AZNPkj+hD4QnoVsaM6psmQijcoVRgWg8g?=
 =?us-ascii?q?VkzGggbFYMiUxkP4HwnMj0BAQcCBw4DC4FohGGLIIF9AQE?=
IronPort-Data: A9a23:I5FFoqD0tX1MxBVW/9/iw5YqxClBgxIJ4kV8jS/XYbTApGsn0DFWm
 2EdDT+GPfmCYzegc4skbdiw/B9UuJfcyNNnOVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4eGdIZvCCeA+n9BC5C5xVFkz6aEW7HgP+DNPyF1VGdMRTwo4f5Zs7ZRbrVA357jXmthh
 fuo+5eBYAD/h2ctWo4pw/vrRC1H7ayaVAww5jTSVdgT1HfCmn8cCo4oJK3ZBxPQXolOE+emc
 P3Ixbe/83mx109F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq+kTe5p0G2M80Mi+7vdkmc+dZk
 72hvbToIesg0zaldO41C3G0GAkmVUFKFSOuzXWX6aSuI0P6n3TE/q1cJm0oEYwjqrxLPERAz
 MMmJCo1YUXW7w626OrTpuhEj8AnKozveYgYoHwllW6fBvc9SpeFSKLPjTNa9G5v3YYVQ7CHO
 YxANWYHgBfoO3WjPn8UAYgineOhhVH0ciZTrxSeoq9fD237k1whjeGyYIOPEjCMbepclQWBg
 3rUxUfaWT4ZBOWAxhio1Uv504cjmgu+Aur+DoaQ9vdwjXWQy3YVBRlQUkG0ydG7h0y0c9ZeL
 VEEvCskqO4580nDZtz0RQG5pjicswIRQcFdFcU98giGzqeS6AGcbkANQjdCb8QhqecsSDAq3
 0PPlNTsbRRttbCTRH2d95+OoD+yMDRTJmgHDQceQBUI+cLLuow/jhvTCN1kFcaditHoHzr5x
 RiRsTMzwb4UiKYj06S94ECCgD+2oJXNZhA66x+RXW+/6A59Iom/aOSA7Vnd8OYFN42CT3Gfs
 3Ue3cuT9uYDCdeKjiPlfQkWNLit4/DANHjXhkRiWsF+sT+s4HWkO4tX5VmSOXtUDyrNQhexC
 Ge7hO+bzMY70KeCBUOvX7+MNg==
IronPort-HdrOrdr: A9a23:y17JZqNYazXJvcBcTgujsMiBIKoaSvp037Dk7SxMoHtuA6ilfq
 +V8sjzuSWftN9VYgBCpTniAtjkfZq/z/9ICOAqVN/IYOClghrLEGgI1+TfKlPbdhHWx6p0yb
 pgf69iCNf5EFR2yfrh7BLQKadG/DD+ysCVrNab6WtxRgd3bKwlxQJ4BgGHVnBSfmB9dPwE/F
 723Ls+m9JmEk5nF/iGOg==
X-Talos-CUID: =?us-ascii?q?9a23=3ANVdjsGh98eqZJTvYl9dbnI4zijJuTyXv5lvOD06?=
 =?us-ascii?q?DWTxVdZibcGCu9LlcnJ87?=
X-Talos-MUID: =?us-ascii?q?9a23=3AgoRBiAx/2tCKzjUeMrszF5O+Xa6aqIunAwMUtI0?=
 =?us-ascii?q?UgeqnbgNzCw6CgxaaZbZyfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,183,1779148800"; 
   d="scan'208";a="788517812"
Received: from alln-l-core-07.cisco.com ([173.36.16.144])
  by alln-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jul 2026 17:50:01 +0000
Received: from fedora.cisco.com (unknown [10.189.189.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-07.cisco.com (Postfix) with ESMTPSA id 4A74518000352;
	Fri, 24 Jul 2026 17:49:54 +0000 (GMT)
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
Subject: [PATCH v6 03/13] scsi: fnic: Decode firmware role configuration
Date: Fri, 24 Jul 2026 10:48:01 -0700
Message-ID: <20260724174811.5118-4-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260724174811.5118-1-kartilak@cisco.com>
References: <20260724174811.5118-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.189.189.81];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.189.189.81, [10.189.189.81]
X-Outbound-Node: alln-l-core-07.cisco.com

Add FNIC_ROLE_CONFIG_MASK and use it to decode firmware role bits
when reading vNIC configuration and probing the PCI device.

Accept FCP and NVMe initiator roles, report FC target and FC-NVMe
target
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
Incorporate review comments from Hannes:
	Decode target roles explicitly and report unsupported roles.

Changes between v3 and v4:
Incorporate review comments from Sashiko:
	Keep role strings private and const
---
 drivers/scsi/fnic/fnic.h       |  1 +
 drivers/scsi/fnic/fnic_main.c  | 23 +++++++++++++++++++++--
 drivers/scsi/fnic/fnic_res.c   | 29 +++++++++++++++++++++++++++--
 drivers/scsi/fnic/fnic_trace.c |  3 ++-
 4 files changed, 51 insertions(+), 5 deletions(-)

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
index 4ed57ea1f854..a3f583703664 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -31,7 +31,8 @@ int fnic_fc_trace_cleared = 1;
 static DEFINE_SPINLOCK(fnic_fc_trace_lock);
 
 static const char * const fnic_role_str[] = {
-	[FNIC_ROLE_FCP_INITIATOR] = "FCP_Initiator",
+	[FNIC_ROLE_FCP_INITIATOR]  = "FCP_Initiator",
+	[FNIC_ROLE_NVME_INITIATOR] = "NVMeF_Initiator",
 };
 
 const char *fnic_role_to_str(unsigned int role)
-- 
2.47.1

