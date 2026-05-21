Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EE7383991;
	Thu, 21 May 2026 18:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779386827; cv=none; b=c+eUNEiMfa1KjORNDJjOlHGhlM334kyDjJzL1/j4DsYKbywKroGDkr2o2//5VADHIGQuPhhYYIUt12W94G25bjQWbohNIl+AOZIecNOsEcCBlgwMXpEVNhobsv7wqwV/GvdwBUl7tC67W+hr9NIC+q1KYVzNXUFkNXrsno5N/3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779386827; c=relaxed/simple;
	bh=pOWAlkEoIShbwgg1lGGpW7DquvZe80UlLsSxgw2rQCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcsQDk5XSfux9djTyn1Y3Qz2cZfTPOA0qZJD/B03gFnmld/tg9HE2Lq+1U+n97WNKH5yculmSZFu8xOW3bEIjMSE19q+qfFZUz5WGP3+j1S0RZEU4bE2XId36yRQea/7XCntXB0odPAPazYyW7JSkyv5NHifGClb8eJEowQumS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=kcSQjNJG; arc=none smtp.client-ip=173.37.86.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="kcSQjNJG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2821; q=dns/txt;
  s=iport01; t=1779386825; x=1780596425;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VSNrcLjqRYsKd5NwYY0fI+ZO1scQ8J/2qIt99al3qBk=;
  b=kcSQjNJGiVRqzSymiqfPKYH4J3JK93EhuGbNQezssPl1sbTWiZg1yDsB
   v1GaHJZfFPkJXPh2btpK5psmnef7gC3Xr1kogxbW9Y16wHAKZS8oldz8y
   Ui3PnBf1lEPettNplGMb2fddrr+mdaUDVkFTcqd3mxVYOqRcjq/wSwCmS
   l81Qs6msLLIRvfYD+p0JD7qfbrS4bYcj44zgOX+L5giy7Rlo2/RFrIHhz
   l1gu9mDfz8j3li8a5qd3Xp2lBvEEJGTYerzie/9zw634zzGZpmwFcAMVs
   QHc3Hjt6bdenbWPpofHW7SNOwwZm7vZ7/AqLBCRTdpQ2JBOQW6jlyBfat
   A==;
X-CSE-ConnectionGUID: p/Dk/127ToumpE/f9S6qoA==
X-CSE-MsgGUID: Ti3jedHTQiacxaVM29xgYA==
X-IPAS-Result: =?us-ascii?q?A0BCAgAqSA9q/5L/Ja1aglmCV4FQQxkwlCqgP4F/DwEBA?=
 =?us-ascii?q?Q9RBAEBhQYCjTICJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBD?=
 =?us-ascii?q?hOGXIZbAgEDJwsBRhBRVhmDAoJ0A7QlgXkzgQHeQYFkAQsUAYE4jVx0hHsnF?=
 =?us-ascii?q?QaBSUSBFYNogVKDPoV3BIMcEo8cSIEeA1ksAVUTDQoLBwWBZgM1EioVbjIdg?=
 =?us-ascii?q?SM+F4ELGwcFgUuBN3JqgQSEV3gjLANOgS2BawMLGA1IESw3FBsEPm4HinkcD?=
 =?us-ascii?q?4IxgQ+BMGcok0+QHoIhoQ6EJqFYGjOqai6YV6lAgWg8gVkzGggbFYMiUxkPj?=
 =?us-ascii?q?i0WyyYnMj0BAQcCBw4DC4FokX0BAQ?=
IronPort-Data: A9a23:Qd9pC6xoIFWsZzXqoxh6t+e8xyrEfRIJ4+MujC+fZmUNrF6WrkVRn
 DFND2qEOPfYNGbyKo93a4rl80gFuJDdz4QxTgo6+1hgHilAwSbn6Xt1DatR0we6dJCroJdPt
 p1GAjX4BJlqCCea/VH1buSJQUBUjcmgXqD7BPPPJhd/TAplTDZJoR94kobVuKYw6TSCK13L4
 4+aT/H3Ygf/hWYpaDtMt8pvlTs21BjMkGJA1rABTagjUG/2zxE9EJ8ZLKetGHr0KqE8NvK6X
 evK0Iai9Wrf+Ro3Yvv9+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+vpT2M4nVKtio27hc+adZ
 zl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CCe5xWuTpfi/xlhJFlxEY5fo7woPWZT8
 OQ1bz5cVU6agMvjldpXSsE07igiBNPgMIVavjRryivUSK53B5vCWK7No9Rf2V/chOgXQq2YP
 JVfM2cyKk2cPXWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZCxb4KPIITQGZQ9ckCwm
 mOd/Wn1Ii0jNdWU2TO71yj9luD+tHauMG4VPPjinhJwu3WTz3YeIB4bT122pb++kEHWc95WL
 Qof8zA2oK4u+VaDStj7Vge/5nmesXY0WddSGcU+6QeQ2uzV6QPfDW8BJhZEYcY6tclwXTE22
 0WSktXBAiZmu7mYD3ma89+8pD+7Oi8NKnIqfyIITQIZpdLkpekbjBfCSNtsEK+dlND5GTjsh
 TuNqUAWnbgNgNQQ/7+28VDOn3SnoZ2hZgo5+wPcV2SN9R5iaciuYInAwVza6+tQaYWUVF+Mu
 FAalMWEquMDF5eAkGqKWuplNLWo4euVdSbXml9HAZYs7XKu9mSlcIQW5ytxTHqFKe4ecjPvJ
 UuWsgRL6doLbT2hbLR8ZMS6DMFCIbXcKOkJn8v8NrJmCqWdvifdlM2yTSZ8B1zQrXU=
IronPort-HdrOrdr: A9a23:gloDfKoSBzJ2OWT03IBzKhAaV5rheYIsimQD101hICG9vPb1qy
 nIpoV+6faaslgssR0b8+xofZPwIk80lqQFhLX5X43CYOCOggLBR72Kr7GSoQEIcBeQygcy78
 pdWpk7IMHsDFR8kMbx6BS1HpId2tWdmZrY4ts2t00McShaL4d98gx+FgGXVmdyRAVAGN4FMa
 D03Lsgm9JlEk5nFvhSwRI+LpH+m+E=
X-Talos-CUID: 9a23:Nxf79G5AAa1cWruDEtss7Ak4GYd8KCLhy2rVO2L/BzdSFqSSYArF
X-Talos-MUID: 9a23:YkEt3wqIAXJIEMVAWlQezw1jb8Vl74SSMUEEmoUPhezeZDx/Ch7I2Q==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,160,1774310400"; 
   d="scan'208";a="470220249"
Received: from rcdn-l-core-09.cisco.com ([173.37.255.146])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 21 May 2026 18:05:57 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.18.181])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-09.cisco.com (Postfix) with ESMTPSA id 9BB7518000233;
	Thu, 21 May 2026 18:05:55 +0000 (GMT)
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
Subject: [PATCH 02/13] scsi: fnic: Use fnic_num for non-SCSI identifiers
Date: Thu, 21 May 2026 11:04:47 -0700
Message-ID: <20260521180458.5448-3-kartilak@cisco.com>
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

Use SCSI host numbers only for FCP initiator paths.

Name NVMe-facing FDMI and debugfs entries with fnic_num, and record trace
events with the driver instance number.

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
index d22cd4ffe3fb..48b37748f44a 100644
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

