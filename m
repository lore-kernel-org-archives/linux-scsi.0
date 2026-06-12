Received: from rcdn-iport-8.cisco.com (rcdn-iport-8.cisco.com [173.37.86.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15493A5452;
	Fri, 12 Jun 2026 18:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781288020; cv=none; b=uxEY+2bljVV1VfVkTehzRR4x/K9SrN85EbsSMrKXbP25nEG8q8Yf1zdz7VexH2SdaS0/ViY+ThMBJnjp5tatK5FJRMwJPijb50rZW366E0YcmItZaJCtSh7DStg99SvkAZWrBc6zMJJZ/l/OsX2X6G0Cvo832OaQHlfvtTpZOEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781288020; c=relaxed/simple;
	bh=w63TqDzsRQKWwXfbnroa0ul2vPyuSQwpeRsltrgwg44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6xTfLvrzAvLZfTEk9aROX8r0SgK/yaMPRRq7g8VbTrrGS/YeNwbHK82xb1gtsNCLwQEkEGeQJTwfolEATulMjeiRzXWr6wnBl4Yq1NxZ6SMArwpdmHzKDGM04s1C3Y8IwA65RyEWOfz3ovn5KhH2F9fcX/S5qrI73YP2Z6Kvzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=gsK5zQQl; arc=none smtp.client-ip=173.37.86.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="gsK5zQQl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=3870; q=dns/txt;
  s=iport01; t=1781288018; x=1782497618;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=irt3uGD+zc1UAhy1SFvsP7ro9QE+N6DJrLAnzshgE80=;
  b=gsK5zQQlO6kNDhSY486AZa/cSPJlPlAnqsBp5UGWQerhUJRGYrrK7jPJ
   usZN0dTFIDWYlXfxe/wM/0oy2BhEIsgFw/xg9jvvKX7RGFNDBlWEDMnAU
   Cvf44R6ZAiaYlb5rUmMR4CQTXEjrnGc9jsaDeaULuTiG21lEKO5w++X+6
   M471PwmjJEFzpOtsuzObqRxgyJfRbsOrjppmZWgRTlu/HaYRL9INpknUW
   KmxE97wc1NK7Z0kmhtkn3SWfAjGWYVVkWI8MvhD96H/xpecfXapyrZYjG
   EKk69TL+a6PYW8FVqmy6AtvuXV+LYUr+ZnAd3LLB0ftsz0tYoqzKewylP
   g==;
X-CSE-ConnectionGUID: eQo2Lj3EThuCzZiAPCcYGg==
X-CSE-MsgGUID: rrJErrh2SNSBQvw6NEmmww==
X-IPAS-Result: =?us-ascii?q?A0BDAgBqSyxq/4v/Ja1aglmCV4FSQxkwlCqCIZ4eFIFqD?=
 =?us-ascii?q?wEBAQ9RBAEBhQYCjUMCJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBB?=
 =?us-ascii?q?wWBDhOGXIZbAgEDJwsBRhBRVhmDAoJ0A7VggXkzgQHeQ4FmAQsUAYE4jV50h?=
 =?us-ascii?q?HwnFQaBSUSBFYJ6b4FSgliGXgSDLpB3SIEeA1ksAVUTDQoLBwWBZgM1EioVb?=
 =?us-ascii?q?jIdgSM+F4EMGwcFgUqBK2qBA4UNIx8DOX+BdIEoZ2kVMDWBAQERHQMLGA1IE?=
 =?us-ascii?q?Sw3FBsEPm4HjEgXD4IeGQeBD0uBXRYBpg6hD4QnoVsaM4QElBeSUZkIqUKBa?=
 =?us-ascii?q?DyBWTMaCBsVgyJTGQ+OLRbLYCcyPQIHAgcOAwuTZQEB?=
IronPort-Data: A9a23:NRRGEagIwXXEzsM82tUaofIqX161kREKZh0ujC45NGQN5FlHY01je
 htvXWiPMvjeZTCmL90lO4i29xhTu5LQnYNnHlA+qysyFyhjpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+FH1dOOn9SUgvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZeDULOZ82QsaDxMtfvZ8EkHUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqUVw+EtJWMV2
 MAYNRsfXBGqv8m98Z20H7wEasQLdKEHPasFsX1miDWcBvE8TNWbGePB5MRT23E7gcUm8fT2P
 pVCL2EwKk6dPlsWYQZ/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9JozXH58JwxzHz
 o7A137jIDwALtzF8hy+2EuymbHpsCb+R51HQdVU8dYv2jV/3Fc7CBQMWHO4rOO/h0r4XMhQQ
 2QW9ygkhawz8lG7CNj3Wluzp3vslhsVQcZRFasi5R2A0LHZ5S6eHGEPSjMHY9sj3Oc/STUp0
 UeOgvvzCDBvuaHTQnWYnp+WqD60NCcVLEcYaCMERBdD6N7myKkpgwzCVM1LCqO5jtTpXzr3x
 liiqCQjgb4ai+YQyr62u1vAhlqEopnPUx5w5QjNWG+hxh12aZTjZIGy71Xfq/FaI+6xSliHo
 WhBgMOF7cgQApyX0i+AWuMAGPeu/fntDdHHqURkE59k83Gm/GSuONgKpjp/P0xudM0DfFcFf
 XPuhO+Y37cLVFPCUEO9S9vZ5xgCpUQ4KenYaw==
IronPort-HdrOrdr: A9a23:3QC+Fq6GgrVJLaszDAPXwALXdLJyesId70hD6qm+c3Bom6uj5q
 STdZsguyMc5Ax6ZJhko6HiBEDiewK4yXcW2+gs1N6ZNWGMhILrFvAB0WKI+VLd8kPFm9J15O
 NJb7V+BNrsDVJzkMr2pDWjH81I+qjhzEnRv4fj5kYoax12YKd96Ao8IAOaHkpqADRiP/MCZf
 yhDg4tnUvZRZzRBf7Lf0U4Yw==
X-Talos-CUID: 9a23:bdaIV2CKo1TpJjj6EyRe8xQwGJsITn3A52XiImaAIm1YZ7LAHA==
X-Talos-MUID: =?us-ascii?q?9a23=3AjA0h2Q6JeCFoDpgKemws/ew7xoxy+YaDEloNy64?=
 =?us-ascii?q?ggOO9KzMuHRqYiSuoF9o=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,201,1774310400"; 
   d="scan'208";a="485224527"
Received: from rcdn-l-core-02.cisco.com ([173.37.255.139])
  by rcdn-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2026 18:13:37 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.127.244])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-02.cisco.com (Postfix) with ESMTPSA id 4B47A180007D3;
	Fri, 12 Jun 2026 18:13:36 +0000 (GMT)
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
Subject: [PATCH v4 07/13] scsi: fnic: Route completions and resets by initiator role
Date: Fri, 12 Jun 2026 11:09:12 -0700
Message-ID: <20260612180918.8554-8-kartilak@cisco.com>
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

Dispatch FCPIO command, response, and ITMF completions to the FCP or
NVMe handlers based on the configured role.

Read the NVMe queue-depth and timeout retry fields from firmware config,
clean up NVMe I/O on firmware reset, and skip SCSI-only cleanup for
initiator roles that already reset firmware-owned requests.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>
---
Incorporate review comments from Hannes:
        Remove the empty line before the FLOGI completion else block.
        Add a short comment for the NVMe ERSP completion case.
---
 drivers/scsi/fnic/fnic_res.c  |  2 ++
 drivers/scsi/fnic/fnic_scsi.c | 30 ++++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_res.c b/drivers/scsi/fnic/fnic_res.c
index 18353fbb5f98..d75d7046c7f6 100644
--- a/drivers/scsi/fnic/fnic_res.c
+++ b/drivers/scsi/fnic/fnic_res.c
@@ -57,6 +57,8 @@ int fnic_get_vnic_config(struct fnic *fnic)
 	GET_CONFIG(port_down_io_retries);
 	GET_CONFIG(luns_per_tgt);
 	GET_CONFIG(intr_mode);
+	GET_CONFIG(lun_queue_depth);
+	GET_CONFIG(io_timeout_retry);
 	GET_CONFIG(wq_copy_count);
 
 	role = c->flags & FNIC_ROLE_CONFIG_MASK;
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 04ab384033b1..5ad4bb714428 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -145,8 +145,9 @@ unsigned int fnic_count_ioreqs(struct fnic *fnic, u32 portid)
 {
 	unsigned int count = 0;
 
-	fnic_scsi_io_iter(fnic, fnic_count_portid_ioreqs_iter,
-				&portid, &count);
+	if (IS_FNIC_FCP_INITIATOR(fnic))
+		fnic_scsi_io_iter(fnic, fnic_count_portid_ioreqs_iter,
+					&portid, &count);
 
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic,
 		      "portid = 0x%x count = %u\n", portid, count);
@@ -734,6 +735,8 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 	/* Clean up all outstanding io requests */
 	if (IS_FNIC_FCP_INITIATOR(fnic))
 		fnic_cleanup_io(fnic, SCSI_NO_TAG);
+	else if (IS_FNIC_NVME_INITIATOR(fnic))
+		nvfnic_cleanup_all_nvme_ios(fnic);
 
 	atomic64_set(&fnic->fnic_stats.fw_stats.active_fw_reqs, 0);
 	atomic64_set(&fnic->fnic_stats.io_stats.active_ios, 0);
@@ -1457,11 +1460,21 @@ static int fnic_fcpio_cmpl_handler(struct vnic_dev *vdev,
 		break;
 
 	case FCPIO_ICMND_CMPL: /* fw completed a command */
-		fnic_fcpio_icmnd_cmpl_handler(fnic, cq_index, desc);
+		if (IS_FNIC_FCP_INITIATOR(fnic))
+			fnic_fcpio_icmnd_cmpl_handler(fnic, cq_index, desc);
+		else if (IS_FNIC_NVME_INITIATOR(fnic))
+			nvfnic_fcpio_nvme_fast_cmpl_handler(fnic, desc);
+		break;
+
+	case FCPIO_NVME_ERSP_HW_CMPL: /* fw completed NVMe ERSP */
+		nvfnic_fcpio_ersp_cmpl_handler(fnic, desc, 1);
 		break;
 
 	case FCPIO_ITMF_CMPL: /* fw completed itmf (abort cmd, lun reset)*/
-		fnic_fcpio_itmf_cmpl_handler(fnic, cq_index, desc);
+		if (IS_FNIC_FCP_INITIATOR(fnic))
+			fnic_fcpio_itmf_cmpl_handler(fnic, cq_index, desc);
+		else if (IS_FNIC_NVME_INITIATOR(fnic))
+			nvfnic_fcpio_nvme_itmf_cmpl_handler(fnic, desc);
 		break;
 
 	case FCPIO_FLOGI_REG_CMPL: /* fw completed flogi_reg */
@@ -1650,6 +1663,15 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
 	unsigned long start_time = 0;
 	uint16_t hwq;
 
+	/*
+	 * Clean up all outstanding io requests. For FC initiator or NVME
+	 * initiator we issue firmware reset before this and all I/Os are
+	 * already freed
+	 */
+	if (IS_FNIC_FCP_INITIATOR(fnic) ||
+	    IS_FNIC_NVME_INITIATOR(fnic))
+		return;
+
 	/* get the tag reference */
 	fcpio_tag_id_dec(&desc->hdr.tag, &id);
 	id &= FNIC_TAG_MASK;
-- 
2.47.1

