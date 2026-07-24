Received: from alln-iport-1.cisco.com (alln-iport-1.cisco.com [173.37.142.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E535514883F;
	Fri, 24 Jul 2026 17:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784915523; cv=none; b=ij56/VC0syjQcKK4jd4CUzjtncOC7DBRqbF8qPCnJ5J8+YCk36SUHs1a/DOoAg1+tD2KK920quoduKBj65CNE4g+d2edKh8eZD1f8GwyGf6MDx5/qMIdXbqknVCohqfsDLec9AZFaaXxD3EwuLodBe67i0GxCZmaJA4p4QNzLJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784915523; c=relaxed/simple;
	bh=MqfsJf+1OEMmO9q7T7+jnWt5YT9gOjSmP2N52PTvYXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKguG/Q/7ORfWsmD2XF9ToPzDJDYZEUI+ROsooDQi+QOiJUAOqkfFtLVQrfCB01kerutvv3KFk4byGKnbBUQhXKtBgFHt8Hy8CEqQqpy32JN1FOcfixI360hCkGWJEQeWfDREtWd/eVPFJzm6EFgrHjwLsQId3gZPZBGWXPQijY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=IDIldmTC; arc=none smtp.client-ip=173.37.142.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="IDIldmTC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2380; q=dns/txt;
  s=iport01; t=1784915522; x=1786125122;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7El7txWnVBYS0oAqoczxMxdcpNQB4t7ZrPZxLFg+7Q4=;
  b=IDIldmTCYa2Y6hgKxu1L8bBSMQhWaimlpuV5txH0oom08Ced4LhUzYn8
   Eo8zl0fh6Kgeihu3LawLACjJ/jXnyuFuewo1Sl9mYJQu89qzM8/C/2Jgy
   QOCUEaQxIJWcpflbk8liG6RlGcDzpMR80kUDT39gqAQqxKn62wLhQByyq
   Q90YmkS0B+exW2ZhAJvizvYhwixrwCFOETfw/zlxqPOqLOjuX/Wad5u/k
   pOhME3dtHQpMcs5woWZrLRcxVtUJw6DlGLrJ4AQR8H9dALfloDediUWlz
   HRpjkNrEJ3b8btF7zyAV1Kvsj5krrgVN2ZUZ6PAYQJqIQSn/dM6+cl5in
   g==;
X-CSE-ConnectionGUID: +GnuCwiNStuGDNKcD7eghQ==
X-CSE-MsgGUID: /ofpLALWRVyCR3veFEmQlA==
X-IPAS-Result: =?us-ascii?q?A0BCAgBrpWNq/5AQJK1aglmCV4FSQxkwlCmgP4F+DwEBA?=
 =?us-ascii?q?Q9RBAEBhQUCjWACJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBD?=
 =?us-ascii?q?hOGXIZbAgEDJwsBRhBRVhmDAoJ1A8IwgXkzgQHeRYFmAQsUAYE4jV91hHwnF?=
 =?us-ascii?q?QaBSUSBFYNpgVKDPoV4BIMuhGONXUiBHgNZLAFVEw0KCwcFgWYDNRIqFW4yH?=
 =?us-ascii?q?YEjPheBDBsHBYEdgSx5hFgjHwM5f4EvdUp3LWkBEheBJoNLAoFPAwsYDUgRL?=
 =?us-ascii?q?DcUGQQ+bgeNdyOCQIEPgj8dk0SSLaEPhCehWxozqmyZCKNyhVGBaDyBWTMaC?=
 =?us-ascii?q?BsVgyJTGQ/gfScyPQEBBwIHDgMLgWiRfgEB?=
IronPort-Data: A9a23:ar0mr6pFcvNhsaZRMWkrqwCXRwNeBmLuZBIvgKrLsJaIsI4StFCzt
 garIBmBaareYWKnet0iPomw9EhSsMOHm9Y1GQc4/iFjHigSpePIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7zdOCn9j8kif3gqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYgLNNwJcaDpOtfrc8k825ZwehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86r5K255G7Q4yA2AdqjlLvhGmVSKlIFFVHT4pb+c/HKbilq/kTe4I5iXBYvQRs/ZwGyojxE4
 I4lWapc5useFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpfh660GMa04AWEX0qVYB3xl6
 v0+EywQQTylpOman7+0StA506zPLOGzVG8eknhkyTecCbMtRorOBv2Vo9RZxzw3wMtJGJ4yZ
 eJANmEpN0qGOkMJYwtLYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUoPbH5gMxRnI9
 woq+Uy+BR8CEPW79gC741mW3fHCsw7+YYY7QejQGvlCxQf7KnYoIB0fT1aTovSjjEO6HdVFJ
 CQ8+Ccsp4A29Uq2Xp/8VRj+q3mB1jYZUsBMEut88AyRx7DP7gCxAXINRTpMLtchsaceTDAj1
 ViRmM7BHzFjsLSJD3ma89+8rza/PyUaLW4qfyIITQIZpdLkpekblB/RQ8x4OLS4gt38BXf7x
 DXihCwymrMYhMgjzLig8BbMhDfEjpzISBMlowbaRGSo6itna4O/IY+l817W6bBHNonxZl2Au
 mUU3tOV9+EmE56AjmqOTf8LEbXv4OyKWAAwmnZmG50nsjDo8Hm5cMUIv3d1JVxiNYAPfjqBj
 FLvhD69LaR7ZBOCBZKbqarrYyj25cAMzejYa80=
IronPort-HdrOrdr: A9a23:mClgR6yhCGg4QzCAS27NKrPw5r1zdoMgy1knxilNoNJuHvBw8P
 re+MjzuiWbtN98YhsdcJW7Scq9qBDnhPtICOsqXItKNTOO0ACVxcNZnOnfKlbbdBEWmNQx6Y
 5QN4BjFdz9CkV7h87m7AT9L8wt27C8gceVbJ/lr0tFfEVNd7xq6Rt/B0KwF017QxQDOL8Cfa
 DsgPauY1GbCAwqhgPRPAh9Y9T+
X-Talos-CUID: 9a23:++HBE2/BR8Y0khCl47yVvw07HN0ObXz792vNDGOeKm1FF7CaSWbFrQ==
X-Talos-MUID: =?us-ascii?q?9a23=3A1DN/Ng0uGejkkOahrM0Q/KHeGzUjpKOgEGQktao?=
 =?us-ascii?q?8hdivD3duNhmwiQ2za9py?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,183,1779148800"; 
   d="scan'208";a="792513789"
Received: from alln-l-core-07.cisco.com ([173.36.16.144])
  by alln-iport-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jul 2026 17:50:50 +0000
Received: from fedora.cisco.com (unknown [10.189.189.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-07.cisco.com (Postfix) with ESMTPSA id 5BD78180001E7;
	Fri, 24 Jul 2026 17:50:45 +0000 (GMT)
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
Subject: [PATCH v6 04/13] scsi: fnic: Advertise NVMe initiator service parameters
Date: Fri, 24 Jul 2026 10:48:02 -0700
Message-ID: <20260724174811.5118-5-kartilak@cisco.com>
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

