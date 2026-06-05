Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B63834029E;
	Fri,  5 Jun 2026 23:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780703345; cv=none; b=CqgjxvdD6lnF9HULHaj7PbsW9TSBHU/k1KuhHyq+Pgf/DgkFHahPCes7KfZHaVlDWYKY1Y8JbU+cnxljepmZQO9E7e+jz5PrDZ9fh45R99SXHB97AIiy2DkSDhSwH92Q9PHxHBTvG90VBoeYa5rZKDMa6Z2FmsEN0bX0fOjYWJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780703345; c=relaxed/simple;
	bh=w63TqDzsRQKWwXfbnroa0ul2vPyuSQwpeRsltrgwg44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rx7hUKKEIrPB/mWuZ23k3POC4MaAndA37DHjhzJBNTdmy2pFFLv0DpoHPe3Pn48oOQO2j2JG7EvCT2J8fFbI/wULHL0V8qrU9GCcT7PagjLZj85sku7qNAt/DY5ex2FoI7A5VNFBI4isQVeEq4eq5CDTrX9CnUuwOHnwAHlscmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=Vgaud3mK; arc=none smtp.client-ip=173.37.86.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="Vgaud3mK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=3870; q=dns/txt;
  s=iport01; t=1780703344; x=1781912944;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=irt3uGD+zc1UAhy1SFvsP7ro9QE+N6DJrLAnzshgE80=;
  b=Vgaud3mKABZm1QOXOV6gLqYs/TCb70AoAyVOJ3yVNf/4u9tOhrPKl0Jk
   fah/xr8zJ1I8ak3JcmVNHf+OqgwjRc7ReTnrQg5xc6Arc9K2spFcomZeq
   u3E99iv8Afj9olE3dtRpsw9KxEYzaPcKXUdziEEQsGR2EGTTBAvkE+KeW
   w/+ItfEkwbE2ZtW1EZA9bl4Lh97QqRLQsnAcHpzwlw49tndmwwifaTB4l
   PFOgMX93nft8pJSvbrk5q1BCtZxzO8h+OWh8BwdL+Es4D/vM5LEbee+DT
   Y3k1ipUKPtUZ8yHuu1W3W5Ph0d4iPaTMkwRFUfHovD1OGXpWgChrDpq56
   Q==;
X-CSE-ConnectionGUID: EoEWWqpwSayD5BzzJF8LxA==
X-CSE-MsgGUID: moTuk5hwSXy9RyyaCR5qsA==
X-IPAS-Result: =?us-ascii?q?A0BDAgAtXyNq/5P/Ja1aglmCV4FSQxkwlCqCIZ4eFIFqD?=
 =?us-ascii?q?wEBAQ9RBAEBhQYCjTMCJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBB?=
 =?us-ascii?q?wWBDhOGXIZbAgEDJwsBRhBRVhmDAoJ0A7QGgXkzgQHeQoFmAQsUAYE4jV10h?=
 =?us-ascii?q?HsnFQaBSUSBFYJ5b4FSgliGXQSDLpBcSIEeA1ksAVUTDQoLBwWBZgM1EioVb?=
 =?us-ascii?q?jIdgSM+F4ELGwcFgUqBSWqBBIUSIx8DOYEXgXyBKGdpFTE6FwMLGA1IESw3F?=
 =?us-ascii?q?BsEPm4HjC4XD4IXGQeBD0uBXRYBpg6hDoQmoVsaM4QElBaSUZkGqUCBaDyBW?=
 =?us-ascii?q?TMaCBsVgyJTGQ+OLRbIPCcyPQIHAgcOAwuTZQEB?=
IronPort-Data: A9a23:YohkwazyVc4Awhec4IB6t+fGxyrEfRIJ4+MujC+fZmUNrF6WrkUBm
 DYeWz2AMviJZjf3eYh0bNu+8EwFv8LcmocxTgpuqlhgHilAwSbn6Xt1DatR0we6dJCroJdPt
 p1GAjX4BJlqCCea/VH1buSJQUBUjcmgXqD7BPPPJhd/TAplTDZJoR94kobVuKYw6TSCK13L4
 4+aT/H3Ygf/hWYqaj9MsspvlTs21BjMkGJA1rABTagjUG/2zxE9EJ8ZLKetGHr0KqE8NvK6X
 evK0Iai9Wrf+Ro3Yvv9+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+vpT2M4nVKtio27hc+adZ
 zl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CCe5xWuTpfi/xlhJGwxELIn4/5oOmhf2
 aEyOiIvQECnl8vjldpXSsE07igiBNPgMIVavjRryivUSK9+B5vCWK7No9Rf2V/chOgXQq2YP
 JVfM2cyKk2cPHWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZCxb4SPKoLSG5U9ckCwo
 2X64mekAg4hBM3O8yuU+1mW2/bUtHauMG4VPPjinhJwu3WTz3YeIB4bT122pb++kEHWc9BSK
 UY8/isosLh09UauCNL6WnWQpXeeoh8aHcJdD+Ag8wyL4q3O6g2dCy4PSTspQNUqvcwxXTs3/
 kWEk9PgGXpkt7j9YXCY+7GZojOzETIYIW8LeWkPSg5ty8PuvowplTrVQ9pjGbLzhdrwcRn0z
 y2MpyE4r64OlsNN3KK+lXjDgjSxtt3KQxQz6wH/QG2o9EV6aZSjaoju7kLUhd5ELYCEXhyat
 2MFs9aR4fpIDpyXkiGJBuIXE9mUC+2tKjbQhxtrWpIm7TnooibldoFL6zY4L0BsWioZRQLUj
 IbokVs5zPdu0LGCN8ebv6rZ5xwW8JXd
IronPort-HdrOrdr: A9a23:0x0Sxqkyk74r9iwHwvBh6UU/KWzpDfLm3DAbv31ZSRFFG/FwWf
 rDoB19726RtN9/Yh8dcLy7UpVoBEmslqKdgrNhWItKPjOGhILAFugLhrcKgQeQeREWndQz6U
 4PScVDIey1JURmjMr8/QmzG8stzZ266qyy7N2uqEuFNTsLV4hQqyFkFw2cDkp6ACNCBZY/Cd
 6gw/AvnUvHRZzSBf7LfkXsmIP41qT2qK4=
X-Talos-CUID: 9a23:GUimSWMJxA0Hpu5DdS5Ky3ENAt8ee2zxkV3CMW2WWUJ5YejA
X-Talos-MUID: =?us-ascii?q?9a23=3AzSraVw1FIHqDF0+Rb4FOd+XpxDUj5qOSFUNQkYo?=
 =?us-ascii?q?9i9jVDz1hMhyn0S2sa9py?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,189,1774310400"; 
   d="scan'208";a="476286068"
Received: from rcdn-l-core-10.cisco.com ([173.37.255.147])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 05 Jun 2026 23:49:03 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.102.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-10.cisco.com (Postfix) with ESMTPSA id 9DF3E18000887;
	Fri,  5 Jun 2026 23:49:01 +0000 (GMT)
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
Subject: [PATCH v3 07/13] scsi: fnic: Route completions and resets by initiator role
Date: Fri,  5 Jun 2026 16:45:32 -0700
Message-ID: <20260605234538.7950-8-kartilak@cisco.com>
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

