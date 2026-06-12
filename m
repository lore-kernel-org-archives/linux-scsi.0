Received: from rcdn-iport-6.cisco.com (rcdn-iport-6.cisco.com [173.37.86.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01F7399CE2;
	Fri, 12 Jun 2026 18:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781287878; cv=none; b=qoySgEEyUXYhtQ/n3mX3wXPF/G20zXKO6WhCVHVz3/szn82v4Ovx3xl4ESUifNfZkGfq3T1ql1FigdDsv9BDFRbnJppuJJZGuiuVJeaMXXg98BsSZde5FRFv2/nkqa2H3NLzdp8Qkl07TaYaBY5/pdowHf3dGPMlGUph0S/lzdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781287878; c=relaxed/simple;
	bh=MqfsJf+1OEMmO9q7T7+jnWt5YT9gOjSmP2N52PTvYXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDgMKjvqBHJKo6syOn3kgCAXTUMoSelIMtmi6RC6bCNw4ABekIgV7JPCtgUkRHaEthPg+uRhE+rSfOs2R9BAVByZNyHqnmgkGjLJKZntojT5OrT0bZtElzMqma02FZpaUVBG1pS2IjlHiJDcMYecA5KoDeezeaxtt1IOSOd3Ozs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=WmDAIdsm; arc=none smtp.client-ip=173.37.86.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="WmDAIdsm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2380; q=dns/txt;
  s=iport01; t=1781287877; x=1782497477;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7El7txWnVBYS0oAqoczxMxdcpNQB4t7ZrPZxLFg+7Q4=;
  b=WmDAIdsmTXkUdW7t2dGb8d4RNjUV3ILV/gAejMAdEniZEr68o9P4M86P
   fZSMDqeyaXNU/naI2O00wDmOFEUQzbR8wkay72ZWkJLIgDWn1tqlFL0y1
   NsukBTcxdUqq24m/iVt1PRMS2pQ6QtVe0yYB0Q26k13o3s5IbfOdJF7Ei
   6dGyKtobPaDRsWKxBpQehF5SYy8pypZvxX4o4CejPeRTo6+uVFPv61fIY
   bnZC8SabBdBczrOooBJgoyD6AtaDFYOzHPSP+jUfZlT3Vjr5HBmK+C4H6
   sPyplwZ0hqOrR/Dwy6Qkj9pcdG+z8HOFpcjZOZuHYIYkCzrRHwwoupvzC
   w==;
X-CSE-ConnectionGUID: A2DV4sn5RiaIm/gaGbU9BA==
X-CSE-MsgGUID: RRTAU1SmR9G4/Esw5SZk4A==
X-IPAS-Result: =?us-ascii?q?A0BCAgBmSixq/4v/Ja1aglmCV4FSQxkwlCqgP4F+DwEBA?=
 =?us-ascii?q?Q9RBAEBhQYCjUMCJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBD?=
 =?us-ascii?q?hOGXIZbAgEDJwsBRhBRVhmDAoJ0A7VRgXkzgQHeQ4FmAQsUAYE4jV50hHwnF?=
 =?us-ascii?q?QaBSUSBFYNpgVKDPoV4BIMuhVCLJ0iBHgNZLAFVEw0KCwcFgWYDNRIqFW4yH?=
 =?us-ascii?q?YEjPheBDBsHBYFKgStqgQOFDSMfAzl/gXSBKGdpFTA1gQEBER0DCxgNSBEsN?=
 =?us-ascii?q?xQbBD5uB4xIFw+CPoEPgj8dk0SSLaEPhCehWxozqmyZCKNyhVCBaDyBWTMaC?=
 =?us-ascii?q?BsVgyJTGQ/aIycyPQIHAgcOAwuTZQEB?=
IronPort-Data: A9a23:o1m5AaABy+HreBVW/9jiw5YqxClBgxIJ4kV8jS/XYbTApDsmgjYDy
 DQWXDqBOPneMDGmL98kb42+oB4DupWGzdJlOVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4eGdIZvCCeA+n9BC5C5xVFkz6aEW7HgP+DNPyF1VGdMRTwo4f5Zs7ZRbrVA357jX2thh
 fuo+5eBYAH8gWYuWo4pw/vrRC1H7ayaVAww5jTSVdgT1HfCmn8cCo4oJK3ZBxPQXolOE+emc
 P3Ixbe/83mx109F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq+kTe5p0G2M80Mi+7vdkmc+dZk
 72hvbToIesg0zaldO41C3G0GAkmVUFKFSOuzXWX6aSuI0P6n3TE6q9CMh0tO9Ai++9WBCZB/
 NMSFWEnR0XW7w626OrTpuhEnM8vKozveYgYoHwllWufBvc9SpeFSKLPjTNa9G5v3YYVQrCEO
 pdfMGE+BPjDS0Un1lM/C5skgOasj3rXeDxDo1XTrq0yi4TW5FAgi+i8aoeNIbRmQ+1vpHqxm
 zv9+l6oLU1dGceAlAG38S6F07qncSTTHdh6+KeD3v5jmlC7xWEJDhASE1yhrpGRiEO8UfpbK
 koJ6mwvp610/0uuJvH4VgekoXjCphMAVsBLHusS7xuEwa7ZpQ2eAwAsRzJIa9s+s9IeXzEm1
 laV2djuAFRHsriYT3+S9ra8tz6+OSEJa2QFYEcsVwYb7sP4iJs+ghLGUpBoF6vdptn5BDf7y
 jaitzUlivMYistj/6G6+03XxjGhvJ7ESiYr6QjNGGGo9AV0YMiifYPAwVza6+tQaZ2SVVipo
 ncJgY6d4foIAJXLkzaCKNjhB5mz7PqDdTmZill1Etx5rXKm+mWoesZb5zQWyFpVD/vosATBO
 Cf70T69LrcKVJd2Rcebu76MNvk=
IronPort-HdrOrdr: A9a23:5AzYpq9NunWme7BVL29uk+ASI+orL9Y04lQ7vn2ZhyY4TiX+rb
 HLoB1173HJYVoqMk3I3OrwW5VoIkmskKKdg7NxAV7KZmCP01dAbrsSj7cKqAeOJ8SRzINg/J
 YlW7RiCdH2EFhxhdv37U2FCdo6qeP3l5xA/d2/815dCSd3dqpn8wB1TiyfEkFwWU16IKBRLu
 v72iKCzADQAUj+qa+AdwA4Y9Q=
X-Talos-CUID: 9a23:2My2sG/9avSYnlvkRGqVv2dONv55aXuA9nbZAkr/Bm9GQoDEY3bFrQ==
X-Talos-MUID: 9a23:DQIIFwXDpKpgkGPq/AXWuBhfbfxt2fWBVAcgiopbgPuHaQUlbg==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,201,1774310400"; 
   d="scan'208";a="493892503"
Received: from rcdn-l-core-02.cisco.com ([173.37.255.139])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2026 18:11:15 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.127.244])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-02.cisco.com (Postfix) with ESMTPSA id EB5FA18000350;
	Fri, 12 Jun 2026 18:11:13 +0000 (GMT)
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
Subject: [PATCH v4 04/13] scsi: fnic: Advertise NVMe initiator service parameters
Date: Fri, 12 Jun 2026 11:09:09 -0700
Message-ID: <20260612180918.8554-5-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260612180918.8554-1-kartilak@cisco.com>
References: <20260612180918.8554-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.127.244];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.127.244, [10.188.127.244]
X-Outbound-Node: rcdn-l-core-02.cisco.com

Set FC service parameters according to the selected initiator role.

Keep FCP retry and confirmation bits for FCP initiators, and advertise
NVMe initiator and SLER bits for NVMe initiators.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/fnic/fdls_fc.h   |  3 +++
 drivers/scsi/fnic/fnic_main.c | 15 ++++++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_fc.h b/drivers/scsi/fnic/fdls_fc.h
index 012f43afd083..e33c829545fb 100644
--- a/drivers/scsi/fnic/fdls_fc.h
+++ b/drivers/scsi/fnic/fdls_fc.h
@@ -39,6 +39,9 @@
 #define FNIC_FCP_SP_CONF_CMPL   0x00000080
 #define FNIC_FCP_SP_RETRY       0x00000100
 
+#define FNIC_NVME_SP_INITIATOR   0x00000020
+#define FNIC_NVME_SP_SLER        0x00000100
+
 #define FNIC_FC_CONCUR_SEQS    (0xFF)
 #define FNIC_FC_RO_INFO        (0x1F)
 
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 3a365ea455b1..5850d51b0e8f 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -1016,11 +1016,16 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	iport->max_flogi_retries = fnic->config.flogi_retries;
 	iport->max_plogi_retries = fnic->config.plogi_retries;
 	iport->plogi_timeout = fnic->config.plogi_timeout;
-	iport->service_params =
-		(FNIC_FCP_SP_INITIATOR | FNIC_FCP_SP_RD_XRDY_DIS |
-		 FNIC_FCP_SP_CONF_CMPL);
-	if (fnic->config.flags & VFCF_FCP_SEQ_LVL_ERR)
-		iport->service_params |= FNIC_FCP_SP_RETRY;
+	if (IS_FNIC_FCP_INITIATOR(fnic)) {
+		iport->service_params = (FNIC_FCP_SP_INITIATOR |
+				FNIC_FCP_SP_RD_XRDY_DIS | FNIC_FCP_SP_CONF_CMPL);
+		if (fnic->config.flags & VFCF_FCP_SEQ_LVL_ERR)
+			iport->service_params |= FNIC_FCP_SP_RETRY;
+	} else if (IS_FNIC_NVME_INITIATOR(fnic)) {
+		iport->service_params = (FNIC_NVME_SP_INITIATOR);
+		if (fnic->config.flags & VFCF_FCP_SEQ_LVL_ERR)
+			iport->service_params |= FNIC_NVME_SP_SLER;
+	}
 
 	iport->boot_time = jiffies;
 	iport->e_d_tov = fnic->config.ed_tov;
-- 
2.47.1

