Received: from alln-iport-3.cisco.com (alln-iport-3.cisco.com [173.37.142.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8995C31C567;
	Fri, 24 Jul 2026 17:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784915622; cv=none; b=sLHlZQTxV2GjBLcNXuqQ5ANP7TrVS6HVjdHw5pCkjyiLc+g3ys99+wdo1FY7hJFiE4RthBWLNofdMbAiCWM6jqu41GvIeh2IMTy+BlHW1C+vByEDzqoDWtRNsR7gOGGU5dIf+4ejWdf2P0cbZh53fmKuka/RegU5lgkK+S9DFN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784915622; c=relaxed/simple;
	bh=kUBNRobFWx8XIM5NEBpHyYXC8ZifZSrREPJsQUNCWK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KO522haFofUDa5XSOdWTqXFoLQUg5lLQt0F6lxS57gdr8qsZa2DATW0XA0CKr8o3qJUtMNZzDjzb1nEakSLlb8/ZR3sQEz4S4cZaDl2S/tGuhgT70UcB91FMCeWNywP7JXiVzV1Jh5HK5tk0D9tJymtuLCqE6+7ma2zUNJHU0Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=awb2OjE3; arc=none smtp.client-ip=173.37.142.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="awb2OjE3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=4440; q=dns/txt;
  s=iport01; t=1784915620; x=1786125220;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pfh1hP8r4o+4p53AF9HISzebMrKkMR1VOT2slWFMG20=;
  b=awb2OjE3r7I9RAFDNI1DyfjMsixZTbrNtcgsbswcgMAQvfhmaeQdoq/l
   QsKM8GXLLH87htK0ThDgqbDSHYaGvi850lhkbqiOWW55QcOXMsKPak5J/
   bXrtiFBJnVTqV2iZrpaZPcdyA/Hhr5/PDc8khxSU4J6CILGNaZ6LYiStl
   Tb+2YU/4YnMH4I/DvFr95rVhmEmc4d8yTfnx5ENBVfvUAram2bHRrc5T4
   EBvhV0ovE1GJWzdhZ5F+qXWjEIEFG/t2+kKT/dANG4RORZyP21UGiLhE3
   u6kOFks87UlrHrIOW4a9+vgD/oNwLI20NmjHCplp6ciUr1LOyxxipZZ/7
   w==;
X-CSE-ConnectionGUID: /t7em8vMT12OukGAkR9U6A==
X-CSE-MsgGUID: wLFW6688R6GaZ+nea2jjBw==
X-IPAS-Result: =?us-ascii?q?A0BDAgBrpWNq/5AQJK1aglmCV4FSQxkwlCmCIZ4eFIFqD?=
 =?us-ascii?q?wEBAQ9RBAEBhQUCjWACJjQJDgECBAMCAwEBAQEBAQEBAQEBAQoBAQUBAQECA?=
 =?us-ascii?q?QcFgQ4ThlyGWwIBAycLAUYQUVYZgwKCdQPCMIF5M4EB3kWBZgELFAGBOI1fd?=
 =?us-ascii?q?YR8JxUGgUlEgRWCem+BUoJYhl4Egy6SQEiBHgNZLAFVEw0KCwcFgWYDNRIqF?=
 =?us-ascii?q?W4yHYEjPheBDBsHBYEdgSx5hFgjHwM5f4EvdUp3LWkBEheBJoNLAoFPAwsYD?=
 =?us-ascii?q?UgRLDcUGQQ+bgeNdyOCIBkHFhtegigWAaYOoQ+EJ6FbGjOEBJQXklGZCKlDg?=
 =?us-ascii?q?Wg8gVkzGggbFYMiUxkPji0W0jonMj0BAQcCBw4DC4FokX4BAQ?=
IronPort-Data: A9a23:JdnRhqsJIj4fTMLdoYSBEQFyZufnVKBfMUV32f8akzHdYApBsoF/q
 tZmKTyHPfrfM2HxLo8kbdu3/E4E65bdzYUxHVdq+C9jEH9GgMeUXt7xwmUckM+xwmwvaGo9s
 q3yv/GZdJhcokf0/0nrb/656yYghclkf5KkYMbcICd9WAR4fykojBNnioYRj5Vh6TSDK1vlV
 eja/YuFZTdJ5xYuajhKs/3Z9Eo21BjPkGpwUmIWNKgjUGD2zxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0NS+7vw60c+VZk
 72hg3AfpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn3bEm51T4E8K0YIwvfooDGQe6
 9kkcWoqcxOsruGMkY/lY7w57igjBJGD0II3s3Vky3TdSP0hW52GG/qM7t5D1zB2jcdLdRrcT
 5NGMnw0MlKZPVsWZgt/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9KoTWHJsOwh7Gz
 o7A13vdLC5EaozP82Sq+0DvgOLGxyH5cp1HQdVU8dYv2jV/3Fc7CBQMWHO4rOO/h0r4XMhQQ
 2QW9ygkhawz8lG7CNj3Wluzp3vslhsVQcZRFasi5R2A0LHZ5S6eHGEPSjMHY9sj3Oc/STUp0
 UeOgvvzCDBvuaHTQnWYnp+WqD60NCcVLEcYaCMERBdD6N7myKkpgwzCVM1LCqO5jtTpXzr3x
 liiqCQjgb4ai+YQyr62u1vAhlqEopnPUx5w5QjNWG+hxh12aZTjZIGy71Xfq/FaI+6xSliHo
 WhBgMOF7cgQApyX0i+AWuMAGPeu/fntDdHHqVdrG59k83Gm/GSuONgPpjp/P0xudM0DfFcFf
 XPuhO+Y37cLVFPCUEO9S9vZ5xgCpUQ4KenYaw==
IronPort-HdrOrdr: A9a23:rAWeVa7vdE3tN8kdRAPXwALXdLJyesId70hD6qm+c3Bom6uj5q
 STdZsguyMc5Ax6ZJhko6HiBEDiewK4yXcW2+gs1N6ZNWGMhILrFvAB0WKI+VLd8kPFm9J15O
 NJb7V+BNrsDVJzkMr2pDWjH81I+qjhzEnRv4fj5kYoax12YKd96Ao8IAOaHkpqADRiP/MCZf
 yhDg4tnUvZRZzRBf7Lf0U4Yw==
X-Talos-CUID: 9a23:U9sIIG4oA9m4jwxJ9dsss1JLF8V1bFjhlS33PkyXIGVTGYDLYArF
X-Talos-MUID: 9a23:/VyGOwq6l3MR/YFgtM4ezy5GGvg2vfT+Mh4imKdFvcSNby5yESjI2Q==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,183,1779148800"; 
   d="scan'208";a="804163406"
Received: from alln-l-core-07.cisco.com ([173.36.16.144])
  by alln-iport-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jul 2026 17:52:32 +0000
Received: from fedora.cisco.com (unknown [10.189.189.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-07.cisco.com (Postfix) with ESMTPSA id 63EDE180001C6;
	Fri, 24 Jul 2026 17:52:26 +0000 (GMT)
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
Subject: [PATCH v6 07/13] scsi: fnic: Route completions and resets by initiator role
Date: Fri, 24 Jul 2026 10:48:05 -0700
Message-ID: <20260724174811.5118-8-kartilak@cisco.com>
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

Dispatch FCPIO command, response, and ITMF completions to the FCP or
NVMe handlers based on the configured role.

Read the NVMe queue-depth and timeout retry fields from firmware
config,
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

Changes between v4 and v5:
Incorporate review comments from Sashiko:
	Count NVMe ERSP completions as firmware completions
	Gate NVMe completions by initiator role
---
 drivers/scsi/fnic/fnic_res.c  |  2 ++
 drivers/scsi/fnic/fnic_scsi.c | 32 ++++++++++++++++++++++++++++----
 2 files changed, 30 insertions(+), 4 deletions(-)

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
index 04ab384033b1..9607684bc610 100644
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
@@ -1443,6 +1446,7 @@ static int fnic_fcpio_cmpl_handler(struct vnic_dev *vdev,
 	case FCPIO_FLOGI_REG_CMPL: /* fw completed flogi_reg */
 	case FCPIO_FLOGI_FIP_REG_CMPL: /* fw completed flogi_fip_reg */
 	case FCPIO_RESET_CMPL: /* fw completed reset */
+	case FCPIO_NVME_ERSP_HW_CMPL: /* fw completed NVMe ERSP */
 		atomic64_dec(&fnic->fnic_stats.fw_stats.active_fw_reqs);
 		break;
 	default:
@@ -1457,11 +1461,22 @@ static int fnic_fcpio_cmpl_handler(struct vnic_dev *vdev,
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
+		if (IS_FNIC_NVME_INITIATOR(fnic))
+			nvfnic_fcpio_ersp_cmpl_handler(fnic, desc, 1);
 		break;
 
 	case FCPIO_ITMF_CMPL: /* fw completed itmf (abort cmd, lun reset)*/
-		fnic_fcpio_itmf_cmpl_handler(fnic, cq_index, desc);
+		if (IS_FNIC_FCP_INITIATOR(fnic))
+			fnic_fcpio_itmf_cmpl_handler(fnic, cq_index, desc);
+		else if (IS_FNIC_NVME_INITIATOR(fnic))
+			nvfnic_fcpio_nvme_itmf_cmpl_handler(fnic, desc);
 		break;
 
 	case FCPIO_FLOGI_REG_CMPL: /* fw completed flogi_reg */
@@ -1650,6 +1665,15 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
 	unsigned long start_time = 0;
 	uint16_t hwq;
 
+	/*
+	 * Clean up outstanding NVMe requests if firmware reset did not
+	 * complete them before WQ copy cleanup.
+	 */
+	if (IS_FNIC_NVME_INITIATOR(fnic)) {
+		nvfnic_cleanup_all_nvme_ios(fnic);
+		return;
+	}
+
 	/* get the tag reference */
 	fcpio_tag_id_dec(&desc->hdr.tag, &id);
 	id &= FNIC_TAG_MASK;
-- 
2.47.1

