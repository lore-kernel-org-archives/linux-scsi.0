Received: from rcdn-iport-5.cisco.com (rcdn-iport-5.cisco.com [173.37.86.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E56E363097;
	Thu, 21 May 2026 18:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779386931; cv=none; b=AvRPLM8rkrsDpSXahwXnL692jWNvCQ7tNAKUxCFHFDPvqWHxElwHUARRxg9ulE3oZQK2bbLNPOCcIlJ2jYY8f2uAmbuXX60VxFZohAtBqcMzfRvpI52Tlf8/pZKQqV5WbRO34f1EwOwtxUwvNYVfYv/1ICuVTS+93D1wIA6LfUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779386931; c=relaxed/simple;
	bh=xNmbUWDvJMYV+qdDXbqW2HNugHfdlAZSnHTNzn7G68k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sc3RKutFiPNww+pc6cN2eS4XjPvYk+rt2s/dmtpMfnT0xmlyZ1Tc/XCqe5A42BK13W2cjdJjNRvQlM/kFeK65TVm9gQpT8zqTH0C2f3/2WMeMdsjOcWYSOGUYaPniLLAtJDsVJ9Mz8Cub2AGc+hNsDH7+13eKIPv6Z9R2WGY0CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=ORKvvReH; arc=none smtp.client-ip=173.37.86.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="ORKvvReH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=3702; q=dns/txt;
  s=iport01; t=1779386930; x=1780596530;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gIBJ7X1xPvNcqj2nTFD6tj2sxJMQHy/unRtvgYjr1gU=;
  b=ORKvvReHXih3KegFmvZP8O5khm6BsrgWZtOKc0H6sCVN9crH0OFfw5Q/
   XKAaIge8KhvjfmdAz+7Be3iNKL63vMpUGoyLoZOpse/q2CrBNn2Rpabd5
   orNV5Y6JGTQheYzOwUkxvC2HfYRXKw1uvmJFPT6xKN4XzTrOTHLKFMSoQ
   P0L7YkHSopMysQEx+zARhBy/Uora+ZYwixRwJt1BQbCyYtZKMJiu2wthb
   i4CSVN5PMWRRPhJl54ifT/Cgj+ftN2hzyLN41zF1uOPVHph9K2HJEBx/L
   Loc7opS7HTSd++9FV/D7dqmHhQjh1QhWY6Qzl06HjROzHHET5f1AWr0EF
   g==;
X-CSE-ConnectionGUID: IXxl2+uYRJ+VFIw6YzlKCg==
X-CSE-MsgGUID: mV5UIs6QTma9bVSdojtkPg==
X-IPAS-Result: =?us-ascii?q?A0BCAgDGSQ9q/5L/Ja1aglmCV4FQQxkwlCqgPxSBaw8BA?=
 =?us-ascii?q?QEPUQQBAYUGAo0yAiY0CQ4BAgQDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFg?=
 =?us-ascii?q?Q4ThlyGWwIBAycLAUYQUVYZgwKCdAO0G4F5M4EB3kGBZAELFAGBOI1cdIR7J?=
 =?us-ascii?q?xUGgUlEgRWCeW+BUoJYhl0Egy6PHEiBHgNZLAFVEw0KCwcFgWYDNRIqFW4yH?=
 =?us-ascii?q?YEjPheBCxsHBYFLgTdyaoEEhFd4IywDToEtgWsDCxgNSBEsNxQbBD5uB4p5H?=
 =?us-ascii?q?A+CKgeBD0uBdKYOoQ6EJqFYGjOEBJQVklGZBalAgWg8gVkzGggbFYMiUxkPj?=
 =?us-ascii?q?i0Wyx4nMj0CBwIHDgMLk2UBAQ?=
IronPort-Data: A9a23:aLHi7KjnktmWbLSrjF8EB7j0X1616xEKZh0ujC45NGQN5FlHY01je
 htvDGiOOvreZzD0Kd50O4S3pxsDv8SDndMxSQc+/itjHytjpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+FH1dOOn9SUgvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZeDULOZ82QsaDxMtvja8E8HUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqU5yvZzWyJTx
 MY6aw4jTw/dtvCy45m0H7wEasQLdKEHPasFsX1miDWcBvE8TNWbEuPB5MRT23E7gcUm8fT2P
 pVCL2EwKk6dPlsWZgl/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9JozWG5oMwhvEz
 o7A12HHXyw7L4Km9T+Mo3iSvePInz/4YI1HQdVU8dYv2jV/3Fc7CBQMWHO4rOO/h0r4XMhQQ
 2QY8yxopqEo7EGtUtTndxm5pneeuVgbQdU4O+836gulzqvS/hbfB2IBCDVGbbQOscYsWT0sk
 EeEg97zHjFpmLqPQHmZ+/GfqjbaESEZJGwFfSgZZREI79nqvMc4iRenZtRmHai4gd30MSv9z
 zCDsG41gLB7pdQGyaih5njdjj6sr4SPRQkwji3TUn+j5Qp/TJW4fIHu4l/ehd5ELYCEXhyCs
 WIClsy28u8DF9eOmTaLTeFLG6umj96BMTvBkRt0FIIg3yqi9mTlfo1K5jx6YkBzPa45lSTBe
 kTfv0ZVoZRUJnbvNf4xaIOqAMNsxq/lfTj4as3pghN1SsAZXGe6EOtGOyZ8A0iFfJAQrJwC
IronPort-HdrOrdr: A9a23:pkSkOqDd4q1VkVblHelm55DYdb4zR+YMi2TDGXocdfUzSL39qy
 nAppomPHPP4gr5HUtQ+uxoW5PwJE80l6QV3WB5B97LNzUO+lHYTr2KhrGM/9SPIUDD398Y/b
 t8cqR4Fd37BUV3gILH+gWieuxQp+VviJrJuc7ui1FwUAptd6Zsqy19CgqdDwlKYTMuP+teKH
 JZjfA33wZJvh8sH72GOkU=
X-Talos-CUID: =?us-ascii?q?9a23=3A8rxM9mnonvhDRdiKVFvww/2xqmjXOVzt3HOKYFK?=
 =?us-ascii?q?JM0QqdpO0VgGh6qdHuMU7zg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AYYyJEA0oWT4ThH8jyDPO1WJ13zUj5przNWEWz6w?=
 =?us-ascii?q?6vsDVPxJLNzCfkDePTdpy?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,160,1774310400"; 
   d="scan'208";a="484671454"
Received: from rcdn-l-core-09.cisco.com ([173.37.255.146])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 21 May 2026 18:08:41 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.18.181])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-09.cisco.com (Postfix) with ESMTPSA id 8434C1800023E;
	Thu, 21 May 2026 18:08:39 +0000 (GMT)
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
Subject: [PATCH 07/13] scsi: fnic: Route completions and resets by initiator role
Date: Thu, 21 May 2026 11:04:52 -0700
Message-ID: <20260521180458.5448-8-kartilak@cisco.com>
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

Dispatch FCPIO command, response, and ITMF completions to the FCP or NVMe
handlers based on the configured role.

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

