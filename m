Received: from rcdn-iport-6.cisco.com (rcdn-iport-6.cisco.com [173.37.86.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBF735BDDB;
	Wed, 24 Jun 2026 04:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782276294; cv=none; b=sj0lfkxXn8AX8UExxNv50w0fXMD9UWyUHD+cQxTG/SVCj9FT1m4lm+5TGclruktiFEcmo6O7SgF7Ks22BW0PhVGcrLnN4mxq3tYxzuMlQOWdKY6e/oYE7nBqkFAdE8RsFMI1vBs6i8TgJU9K7Kf1uthlq1z6kjPcHQBwASoTMoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782276294; c=relaxed/simple;
	bh=/hRIvyA8TdhzBG+AM9Z0f15OUrLJ2fSrqhgIQ7MRK88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7uBdPWLb8PnStFHyAI44Arb7SKJQyEG0J+zMw3WHlzJMesghcg3q2S+1gG5BjB7/3EBcheGirwQ4AroKi38S4mRnFFFuX8VzG8S3KXcqRr5w4flyX7ysw3a7q3JxY6GmBT/MIhjW/LXiw6HUyo0LjVx6YlEFLt/zJYBTzBpXng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=EDt8UaoI; arc=none smtp.client-ip=173.37.86.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="EDt8UaoI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=5258; q=dns/txt;
  s=iport01; t=1782276293; x=1783485893;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CVros7qsSuQxgK8aLaeIsg2UmLnwQrwomotDYMMxcek=;
  b=EDt8UaoIj1oywPKKPoOPdi3Eggb36DX+kwiJ8PGTJHb+tY+tw0T/2Nm+
   A2HJclbYtJKNaKGfOcDB3BUqDUO/ryabrneT2iqRTWjQrxgs5xDOGy1Hd
   JriSB63eHPOyQPxTKRCibdPoWXyQDwBzCJD6rI8QaiOHVle8Um8cUF4s7
   HqgJ0Vgxk8XxdNghtWnnnTb/Z8QAqyVvmAs4Nv9AKXAxVKNPMM02PjLXx
   Q+XsCAdraYtfoi0gfmXAYbCVPLyhBuV1p1SdrT/3xNcXCSlXxL+4KiGe7
   JbQSy7aUdJgq5wb7uW4GTxldu3QX0jeiolCHRzJ5HiA0AaMYrDoX4FHkE
   A==;
X-CSE-ConnectionGUID: F3Ka9gu5QXaULRbBhjFuyQ==
X-CSE-MsgGUID: 05P0nNh1SvG6wwBEJ1wjLw==
X-IPAS-Result: =?us-ascii?q?A0BCAgDmXjtq/4//Ja1aglmCV4FSQxkwlCqDN50IgX4PA?=
 =?us-ascii?q?QEBD1EEAQGFBgKNSgImNAkOAQIEAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHB?=
 =?us-ascii?q?YEOE4ZchlsCAQMnCwFGEFFWGYMCgnQDsjmBeTOBAd5DgWYBCxQBgTiNXnSEf?=
 =?us-ascii?q?CcVBoFJRIEVgnN2gVKCSYZtBIMuhX6LBEiBHgNZLAFVEw0KCwcFgWYDNRIqF?=
 =?us-ascii?q?W4yHYEjPheBDBsHBYEdgW6BBIUCIx8DOX+BP4EkZGYVMDWBAQERHwqBNQMLG?=
 =?us-ascii?q?A1IESw3FBsEPm4HjF0XD4I2B4EPgj4Bk0+SP6EPhCehWxozqmyZCKNyhVCBa?=
 =?us-ascii?q?DyBWTMaCBsVgyJTGQ/gfScyPQIHAgcOAwuGSYsggXwBAQ?=
IronPort-Data: A9a23:dKew9qvNou90hv5BvSfq70d5UOfnVKdfMUV32f8akzHdYApBsoF/q
 tZmKWqAb6uIa2Ome99wboS/8hlTuJSAzNVmGgZvpS49Ey0RgMeUXt7xwmUckM+xwmwvaGo9s
 q3yv/GZdJhcokf0/0nrav666yEgiclkf5KkYMbcICd9WAR4fykojBNnioYRj5Vh6TSDK1vlV
 eja/YuFZDdJ5xYuajhKs/zZ80s11BjPkGpwUmIWNKgjUGD2zxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0NS+7vw60c+VZk
 72hg3AfpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn3bEm51T4E8K0YIw1L1UCDBB6
 KEhGDkwSiqJreK07q+qc7w57igjBJGD0II3oHpsy3TdSP0hW52GG/uM7t5D1zB2jcdLdRrcT
 5NGMnw0M1KaPkAJYwtMYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUoDbFJ4MxhzE+
 woq+UyhXylCMvqfkAGb3SyzmcXiv3rkWqYNQejQGvlCxQf7KnYoIB0fT1aTovSjjEO6HdVFJ
 CQ8+Ccsp4A29Uq2Xp/8VRj+q3mB1jYZUsBMEut88AyRx7DP7gCxAXINRTpMLtchsaceTDAj1
 ViRmM7BHzFjsLSJD3ma89+8rza/PyUaLW4qfyIITQIZpdLkpekblB/RQ8x4OLS4gt38BXf7x
 DXihCwymrMYhMgjzLig8BbMhDfEjpzISBMlowbaRGSo6itna4O/IY+l817W6bBHNonxZl2Au
 mUU3tOV9+EmE56AjmqOTf8LEbXv4OyKWAAwmnZ1FJUnsjDo8Hm5cMUIvnd1JVxiNYAPfjqBj
 FLvhD69LaR7ZBOCBZKbqarrYyj25cAMzejYa80=
IronPort-HdrOrdr: A9a23:vwO5D6vIREZuTyUCF/rkN1mR7skDvNV00zEX/kB9WHVpmwKj+/
 xG+85rsSMc5wx+ZJhNo7q90ey7MBDhHP1OkOws1NWZPTUO0VHAROpfBMnZsl/d8kbFmdK1u5
 0MT4FOTPXtEFl3itv76gGkH9tl/MOK68mT9IDjJg9WLT1CWuVH8xpzDBqdHwldQQlLAod8Kb
 +nj/A3wQZJvR8sH7yG7r5vZZm7m+H2
X-Talos-CUID: 9a23:iWb032+UBU3OIPxyZxSVv2BPOcl0fWCA9UfZHmuCA0xpSpOIWGbFrQ==
X-Talos-MUID: 9a23:TamDlgiRPnR8njXT1YARUMMpbJpQu6KICBk2j7pYpNauGA4pJDW5k2Hi
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,221,1774310400"; 
   d="scan'208";a="499310245"
Received: from rcdn-l-core-06.cisco.com ([173.37.255.143])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jun 2026 04:44:52 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.122.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-06.cisco.com (Postfix) with ESMTPSA id C8CC2180003A1;
	Wed, 24 Jun 2026 04:44:50 +0000 (GMT)
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
Subject: [PATCH v5 03/13] scsi: fnic: Decode firmware role configuration
Date: Tue, 23 Jun 2026 21:43:24 -0700
Message-ID: <20260624044334.3079-4-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260624044334.3079-1-kartilak@cisco.com>
References: <20260624044334.3079-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.122.232];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.122.232, [10.188.122.232]
X-Outbound-Node: rcdn-l-core-06.cisco.com

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

