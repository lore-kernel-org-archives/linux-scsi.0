Received: from rcdn-iport-9.cisco.com (rcdn-iport-9.cisco.com [173.37.86.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322CF31F9B3;
	Fri,  5 Jun 2026 23:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780703274; cv=none; b=PW/oKLvMZZMRVOK92XzDYBK7Z6Qg+WD4oedwOOjS+4b3ytrDTfLCXn+tIMlCfzp8aOqqPTBinOCgr53yW/NH+Nf2ghk6zhEAPPRY4hVeSur26au4il0u6Hvlc2iwCr55QfVuml1IfnR2TvKBQSss3KjLviTt7NuU+TTKvD9CSy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780703274; c=relaxed/simple;
	bh=+fI2qsm9hpLPjHyihG5R/qifZRcmAaoFqhA79guQuz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyDk5Rb2JF/OU/m5/qZFzmkhS5jsAgd6OhS3ZqcBE8iLXSRtOFnz71qjOzZ1S/jZnRNRvZFJahN5COJI9Sn/mVLxXoPwg4BSZeywFf3pmSYuEGGkU/bIUNsxS/xkTxF0W8ffSSvHe29NFXNsuFCUa9qjm21LNmd2M3Nop1lbPc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=PopNXjDW; arc=none smtp.client-ip=173.37.86.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="PopNXjDW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=5218; q=dns/txt;
  s=iport01; t=1780703273; x=1781912873;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wkpf3kulFcRYwv08ydoK1hhMh8wS5d9Yw0G4labmBvU=;
  b=PopNXjDWLAKjwSa4HRxl/9sezI4nsBtsa5NuIns6BBWhilEZwzzJdvpY
   k6lSKpzRf/rc4BUFPUkmXS+awYyi21yDDzvYkrnpwFknjoFQNmK5yIsFh
   SMXSsKMtvSJKzS7ZURbMChoVHp0CkIj4dEHYQhi5Wt82t5v6P80InOxQM
   nMOAcTy5nkbaXLBO0YcoB0wb4viGy+L4FbVRe1fh80vQCwlGV+N3akda1
   GEJx1keR2apoASG7XWr2b+Ge7wWiHVciNYhRes01/oZlfz3vzgVIQf7mC
   TNnUvH8r4LayHNHJmoByS+Zx7MeY9CfJ0ATJ+hE0/WqRPOcDlh//ZH/lV
   Q==;
X-CSE-ConnectionGUID: i4gC1WvzQjuH2N2wJuIgzA==
X-CSE-MsgGUID: FYVUJa8eQJ+FCojHVGAqQQ==
X-IPAS-Result: =?us-ascii?q?A0BCAgAtXyNq/5P/Ja1aglmCV4FSQxkwlCqDN50IgX4PA?=
 =?us-ascii?q?QEBD1EEAQGFBgKNMwImNAkOAQIEAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHB?=
 =?us-ascii?q?YEOE4ZchlsCAQMnCwFGEFFWGYMCgnQDtAaBeTOBAd5CgWYBCxQBgTiNXXSEe?=
 =?us-ascii?q?ycVBoFJRIEVgnJ2gVKCSYZsBIMukFxIgR4DWSwBVRMNCgsHBYFmAzUSKhVuM?=
 =?us-ascii?q?h2BIz4XgQsbBwWBSoFJaoEEhRIjHwM5gReBfIEoZ2kVMToXAwsYDUgRLDcUG?=
 =?us-ascii?q?wQ+bgeMLhcPgjAHgQ+CPgGTT5I/oQ6EJqFbGjOqa5kGo3CFUIFoPIFZMxoIG?=
 =?us-ascii?q?xWDIlMZD9Z/JzI9AgcCBw4DC4ZJiyCBfAEB?=
IronPort-Data: A9a23:1rtJMaseusYWHama235w3NFToufnVKdfMUV32f8akzHdYApBsoF/q
 tZmKWqOPK3fMWX8KYp/aYyyoRhU6sXQztUxQQFvpXtnRCgQgMeUXt7xwmUckM+xwmwvaGo9s
 q3yv/GZdJhcokf0/0nrav666yEgiclkf5KkYMbcICd9WAR4fykojBNnioYRj5Vh6TSDK1vlV
 eja/YuFZDdJ5xYuajhKs/zb9Us21BjPkGpwUmIWNKgjUGD2zxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0NS+7vw60c+VZk
 72hg3AfpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn3bEm51T4E8K0YIw+7p4Kjhx6
 +4hKi0tNDbZmMCr4b2pY7w57igjBJGD0II3oHpsy3TdSP0hW52GGv2M7t5D1zB2jcdLdRrcT
 5NGMnw0M1KaPkAJYwtIYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUoDaFJsJxR7I+
 goq+UzXMy8nFtXPxAOnsVyHge3vowzSQbsrQejQGvlCxQf7KnYoIB0fT1aTovSjjEO6HdVFJ
 CQ8+Ccsp4A29Uq2Xp/8VRj+q3mB1jYZUsBMEut88AyRx7DP7gCxAXINRTpMLtchsaceTDAj1
 ViRmM7BHzFjsLSJD3ma89+8rza/PyUaLW4qfyIITQIZpdLkpekblB/RQ8x4OLS4gt38BXf7x
 DXihCwymrMYhMgjzLig8BbMhDfEjpzISBMlowbaRGSo6itna4O/IY+l817W6bBHNonxZl2Au
 mUU3tOV9+EmE56AjmqOTf8LEbXv4OyKWAAwmnZ1FJUnsjDo8Hm5cMUJuHd1JVxiNYAPfjqBj
 FLvhD69LaR7ZBOCBZKbqaroYyj25cAMzejYa80=
IronPort-HdrOrdr: A9a23:EYXgAa+S6vYQILjjwThuk+ASI+orL9Y04lQ7vn2ZhyY4TiX+rb
 HLoB1173HJYVoqMk3I3OrwW5VoIkmskKKdg7NxAV7KZmCP01dAbrsSj7cKqAeOJ8SRzINg/J
 YlW7RiCdH2EFhxhdv37U2FCdo6qeP3l5xA/d2/815dCSd3dqpn8wB1TiyfEkFwWU16IKBRLu
 v72iKCzADQAUj+qa+AdwA4Y9Q=
X-Talos-CUID: 9a23:RUunyG6dglp4ZcjSVtss9RIbMZkabG/kzmrweWniFkR0abKHYArF
X-Talos-MUID: 9a23:iKQ59wXPHqr2jFbq/BHdugxAPZdl2obtJmsKk7U4lOCdDBUlbg==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,189,1774310400"; 
   d="scan'208";a="489643084"
Received: from rcdn-l-core-10.cisco.com ([173.37.255.147])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 05 Jun 2026 23:46:44 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.102.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-10.cisco.com (Postfix) with ESMTPSA id AF0FB18000887;
	Fri,  5 Jun 2026 23:46:42 +0000 (GMT)
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
Subject: [PATCH v3 03/13] scsi: fnic: Decode firmware role configuration
Date: Fri,  5 Jun 2026 16:45:28 -0700
Message-ID: <20260605234538.7950-4-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260605234538.7950-1-kartilak@cisco.com>
References: <20260605234538.7950-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.102.68];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.102.68, [10.188.102.68]
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
Incorporate review comments from Hannes:
	Decode target roles explicitly and report unsupported roles.
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

