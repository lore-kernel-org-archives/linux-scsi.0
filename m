Received: from rcdn-iport-5.cisco.com (rcdn-iport-5.cisco.com [173.37.86.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFC47E105;
	Wed, 24 Jun 2026 04:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782276460; cv=none; b=kD77IfqnMXUiVoX8dCzIuk0B0mJvpyXA/iLWNcx3yMAHEgrKR20eth8zb/W6uYz1xvUOg9+58yRFpGbhRd6korC3FZ4l2LA2dIBPTe+O5JijVjZYV3BGOiKL5l5B9W0w4B233zBch5NcYbNtqOfHKS91nWqPyE4PZjl9bzQT8sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782276460; c=relaxed/simple;
	bh=dli4eRv3OrmQ9fIomDWj4wZNzSFlNyuG07ND7kZou7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvYDqpzevVUWNrYePf3LUz0BmpTRv2Ky8Si00wCs498DYK+DRfmK5cEO7pb6UGfooZYG1WRx/LqnqVoW8DGrAGHcwH/rob1NnDkPN8pckrM7XvmlP3vTUd1ApWlZb1bqorUOEBOV0Z2W/+RAZ2bUFK14kWDNfh4B3d7OAUemruc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=lGXFgKkp; arc=none smtp.client-ip=173.37.86.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="lGXFgKkp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=4439; q=dns/txt;
  s=iport01; t=1782276459; x=1783486059;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RMjhtnTeeBEUZYwuRZL+gh/rFtuGmQsMmUbA347DwTY=;
  b=lGXFgKkphJpDy9OKW5cV+K1jAapGuNGKURSOk5cYF+YdIpDVmLbFSUd3
   0CZbW9wPSRvuAUGbnX0G6wXClQS4a9jHYDysGHcxiopD2e+11JAJDdZvK
   JrMdHzqaRjoS5uD3TU6H2n7MgvWs3/mzKckD8N9BnT8Jm4XokYynq25xV
   bLtMmmXXQEDNjI91XuXkY1auaxkZAhhElMZfSqOX0ed5W2LHiZeeQMwKG
   mrNnDeTQj1g+MwqOegUi1SpjDy9u83TZ92efFiIyaOU52DXSUCVOJoLWW
   Aawg6M6N1dTpWyZNjk+v7iP3yilgErtaMoEsrL0tMnGSwMCDTEIiNypvN
   Q==;
X-CSE-ConnectionGUID: bjJmXWYdQbOhhEt54wEwaQ==
X-CSE-MsgGUID: QHJD4d4MTJypKZsM782ZXQ==
X-IPAS-Result: =?us-ascii?q?A0BDAgB4YDtq/4//Ja1aglmCV4FSQxkwlCqCIZ4eFIFqD?=
 =?us-ascii?q?wEBAQ9RBAEBhQYCjUoCJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBB?=
 =?us-ascii?q?wWBDhOGXIZbAgEDJwsBRhBRVhmDAoJ0A7I1gXkzgQHeQ4FmAQsUAYE4jV50h?=
 =?us-ascii?q?HwnFQaBSUSBFYJ6b4FSgliGXgSDLpECSIEeA1ksAVUTDQoLBwWBZgM1EioVb?=
 =?us-ascii?q?jIdgSM+F4EMGwcFgR2BboEEhQIjHwM5f4E/gSRkZhUwNYEBAREfCoE1AwsYD?=
 =?us-ascii?q?UgRLDcUGwQ+bgeMXRcPgh0ZBxYbXoIoFgGmDqEPhCehWxozhASUF5JRmQipQ?=
 =?us-ascii?q?oFoPIFZMxoIGxWDIlMZD44tFtI6JzI9AgcCBw4DC5NlAQE?=
IronPort-Data: A9a23:etQMxKwI+R6VbAZhVGV6t+fGxyrEfRIJ4+MujC+fZmUNrF6WrkVUm
 DAZDWyGbK2ONGL8fNhzOtvgpkgFvMDXmNVmSlZu/FhgHilAwSbn6Xt1DatR0we6dJCroJdPt
 p1GAjX4BJlqCCea/VH1buSJQUBUjcmgXqD7BPPPJhd/TAplTDZJoR94kobVuKYw6TSCK13L4
 4+aT/H3Ygf/hWYqaDlMscpvlTs21BjMkGJA1rABTagjUG/2zxE9EJ8ZLKetGHr0KqE8NvK6X
 evK0Iai9Wrf+Ro3Yvv9+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+vpT2M4nVKtio27hc+adZ
 zl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CCe5xWuTpfi/xlhJEs0H4goxdd7OGtp9
 fw1NG1RcT2cjtvjldpXSsE07igiBNPgMIVavjRryivUSK54B5vCWK7No9Rf2V/chOgXQq2YP
 JVfM2cyKk2cOHWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZCxYYuJJYHTHpg9ckCwn
 0Lk0zj1XjQmFs2H6gie1y383N3/pHauMG4VPPjinhJwu3WTz3YeIB4bT122pb++kEHWc9BSK
 UY8/isosLh09UauCNL6WnWQpXeeoh8aHcJdD+Ag8wyL4q3O6g2dCy4PSTspQNUqvcwxXTs3/
 kWEk9PgGXpkt7j9YXCY+7GZojOzETIYIW8LeWkPSg5ty8PuvowplTrVQ9pjGbLzhdrwcRn0z
 y2MpyE4r64OlsNN3KK+lXjDgjSxtt3KQxQz6wH/QG2o9EV6aZSjaoju7kLUhd5ELYCEXhyat
 2MFs9aR4fpIDpyXkiGJBuIXE9mUC+2tKjbQhxtrWpIm7TnooyDldoFL6zY4L0BsWioZRQLUj
 IbokVs5zPdu0LGCNMebv6rZ5xwW8JXd
IronPort-HdrOrdr: A9a23:pDO+76skz44DyCxNv+1y7FnG7skDvNV00zEX/kB9WHVpmwKj+/
 xG+85rsSMc5wx+ZJhNo7q90ey7MBDhHP1OkOws1NWZPTUO0VHAROpfBMnZsl/d8kbFmdK1u5
 0MT4FOTPXtEFl3itv76gGkH9tl/MOK68mT9IDjJg9WLT1CWuVH8xpzDBqdHwldQQlLAod8Kb
 +nj/A3wQZJvR8sH7yG7r5vZZm7m+H2
X-Talos-CUID: 9a23:R02pHmBa3lwMmwX6EyNl1kskJfEpS3f6zHf9PxLkFkt2QYTAHA==
X-Talos-MUID: 9a23:rxRgngb3MkWDluBTjh/OqG1uaOJUwbW2K3IWtMpW4fu0DHkl
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,221,1774310400"; 
   d="scan'208";a="499475135"
Received: from rcdn-l-core-06.cisco.com ([173.37.255.143])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jun 2026 04:47:31 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.122.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-06.cisco.com (Postfix) with ESMTPSA id 6180218000277;
	Wed, 24 Jun 2026 04:47:30 +0000 (GMT)
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
Subject: [PATCH v5 07/13] scsi: fnic: Route completions and resets by initiator role
Date: Tue, 23 Jun 2026 21:43:28 -0700
Message-ID: <20260624044334.3079-8-kartilak@cisco.com>
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

