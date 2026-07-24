Received: from alln-iport-7.cisco.com (alln-iport-7.cisco.com [173.37.142.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873C7345CD0;
	Fri, 24 Jul 2026 17:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784915379; cv=none; b=LPajvzK88L8LqZJgM/FqnOv6pivqEvT1mKhbPcdPuxJtmDjd56aZUb563AHFZjcmWmZeJHcg0MzNyLz5WwHvmsTK1fEmdoWOWksmnKXtHe6c6V+ZpNNYLZqwXuuOa2mn8zO2BeblLrFCzJ0bRR4vVv0iyBr7wD1aVOqMeCFknCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784915379; c=relaxed/simple;
	bh=ZCNcv4P7AkVPotlXpvPK5iNoL4fsncxpnHstGG2BLQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9Tj6o3LI58fFfVwVuWBK5gOZ3MvRt1cqEu69TnMmmKc3o0Gf1v8hxlm4Tm1RTwcAizc3bEFdAkeXY0Yl3FDxjNq7eZbiefDvBda05q179P71pj75k3LHvmJSNyPmk2ALof0niM16a4et6hacwELvwFgY6N5cp0FDMQVivB+Pq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=jw4KUoyU; arc=none smtp.client-ip=173.37.142.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="jw4KUoyU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2821; q=dns/txt;
  s=iport01; t=1784915377; x=1786124977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sLADWQIE9KTz+/SzYGCIkSHf9EF3QcETYxY+2sa7yfs=;
  b=jw4KUoyUwCxVJIK1avYJDhs8qUmD6nzhpHgLdk714yY1y0PhGqVhZM/8
   9XZozEfqciQt+7lVKm70JG/AFrOYYrq1I3QGTM922hA1eRKcbsPjekk4g
   mtPRR65/YeCJAfjsvMkS5jcxHpKbJOn1viAZsr2oZD9cbYiE0AZ5ieunE
   obQ7iKk9jjZG396B4GDBbLbTgaxxDqS1Mq4PV/RUoZ8HpiIucMWHvSoiq
   UIAheJSD5Lvc3mlDrtgHV/UlvgmJupzaH+y+cln4ahFeKOFG4SAMa4exv
   azVnd/AcuNzV8AP6Mfqqb586X0eZzkEH+2V35UBMzE/WscjNFwAQZRM6o
   A==;
X-CSE-ConnectionGUID: U/wn4UvzRtO2Cq+nR+cfEA==
X-CSE-MsgGUID: JKuGs02LSTe4QUNJ649b6A==
X-IPAS-Result: =?us-ascii?q?A0BCAgBwpGNq/5AQJK1aglmCV4FSQxkwlCmgP4F+DwEBA?=
 =?us-ascii?q?Q9RBAEBhQUCjWACJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBD?=
 =?us-ascii?q?hOGXIZbAgEDJwsBRhBRVhmDAoJ1A8JJgXkzgQHeRYFmAQsUAYE4jV91hHwnF?=
 =?us-ascii?q?QaBSUSBFYNpgVKDPoV4BIMcEpI9SIEeA1ksAVUTDQoLBwWBZgM1EioVbjIdg?=
 =?us-ascii?q?SM+F4EMGwcFgR2BLHmEWCMfAzl/gS91SnctaQESF4Emg0sCgUcDCxgNSBEsN?=
 =?us-ascii?q?xQZBD5uB410I4JAgQ+BMGcok0+QHoIhoQ+EJ6FbGjOqbC6YWqlDgWg8gVkzG?=
 =?us-ascii?q?ggbFYMiUxkPji0W0jknMj0BAQcCBw4DC4FokX4BAQ?=
IronPort-Data: A9a23:EqSKwKLvuU0jztXGFE+RJ5QlxSXFcZb7ZxGr2PjKsXjdYENS0mFVm
 mAcXD+HOf/YZWP3c4xxb9jioxwPvZOEn9JhSlEd+CA2RRqmiyZq6fd1j6vUF3nPRiEWZBs/t
 63yUvGZcoZsCCSa/kvxWlTYhSEU/bmSQbbhA/LzNCl0RAt1IA8skhsLd9QR2uaEuvDnRVnQ0
 T/Oi5eHYgH9hGQoazt8B5+r8XuDgtyj4Fv0gXRmDRx7lAe2v2UYCpsZOZawIxPQKqFIHvS3T
 vr017qw+GXU5X8FUrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRuukoPD8fwXG8M49m/c3+d/
 /0W3XC4YV9B0qQhA43xWTEAe811FfUuFLMqvRFTvOTLp3AqfUcAzN1TS14wYbAG6NxrJjtl7
 L8eEnMGYD2q0rfeLLKTEoGAh+wqKM3teYdasXZ6wHSBUrAtQIvIROPB4towMDUY358VW62AI
 ZNHL2MzMHwsYDUXUrsTIJE3hvupgnD8WzZZs1mS46Ew5gA/ySQugOawboaEJIPiqcN9vGWFi
 XmepUDCPhxGDeG562TZo3jyr7qa9c/8cMdIfFGizdZqiUee7m8eEhsbUR28u/bRokyzWdh3L
 00S5zporKI3skesS7HVWhSivH+C+AYRR9dKCOA8wAaXw6HQ7kCSAW1sZjdNYd8hrMgrbSYn2
 l+Ag5XiAjkHmL+QRHSQ+beVhSm/NSgcMSkJYipsZREI/dT5u6kpgx7PR8olG6mw5vXxFSz2y
 DmMhDMjnLhVhskOv42//Fbak3evq4LPQwod+AraRCSm4xl/aYrjYJangXDf7PBdPMOCRUKAl
 GYLltLY7+0UC5yJ0iuXT40w8KqB7vKBNnjYxFVoBZRkr2vr8H+4docW6zZ7TKt0Dvs5lfbSS
 Be7kWtsCFV7ZRNGsYcfj1qNNvkX
IronPort-HdrOrdr: A9a23:OXmXjKBx8LrkC8rlHelm55DYdb4zR+YMi2TDGXocdfUzSL39qy
 nAppomPHPP4gr5HUtQ+uxoW5PwJE80l6QV3WB5B97LNzUO+lHYTr2KhrGM/9SPIUDD398Y/b
 t8cqR4Fd37BUV3gILH+gWieuxQp+VviJrJuc7ui1FwUAptd6Zsqy19CgqdDwlKYTMuP+teKH
 JZjfA33wZJvh8sH72GOkU=
X-Talos-CUID: =?us-ascii?q?9a23=3ANvjWgGr6KIRcMBwt1++XKnXmUf1ibXuB8WnCGVO?=
 =?us-ascii?q?fU01wC7uvClSe1Yoxxg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3A9fYiCAzVCNEdKurAhkSWGnneocCaqIaNFW8Wyc8?=
 =?us-ascii?q?igPWJaRVNHRXD0GW9HKZyfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,183,1779148800"; 
   d="scan'208";a="786564967"
Received: from alln-l-core-07.cisco.com ([173.36.16.144])
  by alln-iport-7.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jul 2026 17:49:36 +0000
Received: from fedora.cisco.com (unknown [10.189.189.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-07.cisco.com (Postfix) with ESMTPSA id BE9D618000352;
	Fri, 24 Jul 2026 17:49:30 +0000 (GMT)
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
Subject: [PATCH v6 02/13] scsi: fnic: Use fnic_num for non-SCSI identifiers
Date: Fri, 24 Jul 2026 10:48:00 -0700
Message-ID: <20260724174811.5118-3-kartilak@cisco.com>
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

Use SCSI host numbers only for FCP initiator paths.

Name NVMe-facing FDMI and debugfs entries with fnic_num, and record
trace events with the driver instance number.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/fnic/fdls_disc.c    | 8 ++++++--
 drivers/scsi/fnic/fnic_debugfs.c | 5 ++++-
 drivers/scsi/fnic/fnic_scsi.c    | 2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 5880ca28a0ad..f665460ef62c 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -2083,8 +2083,12 @@ static void fdls_fdmi_register_pa(struct fnic_iport_s *iport)
 	fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_MAX_FRAME_SIZE,
 		FNIC_FDMI_MFS_LEN, data, &attr_off_bytes);
 
-	snprintf(tmp_data, FNIC_FDMI_OS_NAME_LEN - 1, "host%d",
-		 fnic->host->host_no);
+	if (IS_FNIC_FCP_INITIATOR(fnic))
+		snprintf(tmp_data, FNIC_FDMI_OS_NAME_LEN - 1, "host%d",
+			fnic->host->host_no);
+	else if (IS_FNIC_NVME_INITIATOR(fnic))
+		snprintf(tmp_data, FNIC_FDMI_OS_NAME_LEN - 1, "nvfnic%d",
+			fnic->fnic_num);
 	strscpy_pad(data, tmp_data, FNIC_FDMI_OS_NAME_LEN);
 	fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_OS_NAME,
 		FNIC_FDMI_OS_NAME_LEN, data, &attr_off_bytes);
diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index ba86964fb45e..467fba29ea5f 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -681,7 +681,10 @@ int fnic_stats_debugfs_init(struct fnic *fnic)
 {
 	char name[16];
 
-	snprintf(name, sizeof(name), "host%d", fnic->host->host_no);
+	if (IS_FNIC_FCP_INITIATOR(fnic))
+		snprintf(name, sizeof(name), "host%d", fnic->host->host_no);
+	else if (IS_FNIC_NVME_INITIATOR(fnic))
+		snprintf(name, sizeof(name), "nvfnic%d", fnic->fnic_num);
 
 	fnic->fnic_stats_debugfs_host = debugfs_create_dir(name,
 						fnic_stats_debugfs_root);
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 0759540f6675..b92260583c67 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -894,7 +894,7 @@ static inline void fnic_fcpio_ack_handler(struct fnic *fnic,
 
 	spin_unlock_irqrestore(&fnic->wq_copy_lock[wq_index], flags);
 	FNIC_TRACE(fnic_fcpio_ack_handler,
-		  fnic->host->host_no, 0, 0, ox_id_tag[2], ox_id_tag[3],
+		  fnic->fnic_num, 0, 0, ox_id_tag[2], ox_id_tag[3],
 		  ox_id_tag[4], ox_id_tag[5]);
 }
 
-- 
2.47.1

