Received: from rcdn-iport-8.cisco.com (rcdn-iport-8.cisco.com [173.37.86.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E121C3911C6;
	Fri, 12 Jun 2026 18:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781287840; cv=none; b=ejPMZ0Xdin+2exWVoRwyC2Ykvzc7lRSo5ElS+hyLth5Z1jerGn1VwxL7y4On1NOboXmd9gfMCWVy1bQHkRrSMSD1YBOD8euchGTqwn4ZNHUAupyHLmPgUc6dHRFfEnBZaz3Lz4vTYaSZMmpuKBK7ZZG5sUpElMPLY6sqLl76ibc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781287840; c=relaxed/simple;
	bh=ZCNcv4P7AkVPotlXpvPK5iNoL4fsncxpnHstGG2BLQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRuuunmphTxb4l+EfYqtG8WDEdRurRMErkk5hJFfO1/UOkrymsu0prNn92p8taKlPLe+XURTZVfTsvW+y9m792Qx0dznqrCS3Lk7AM/Kr4zLIHJx1cODHm7BroP5nVLv91ipVremMHoruhFKFQZ54vdaf4N2UULsupdH+wHCgDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=PuVn2Ao2; arc=none smtp.client-ip=173.37.86.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="PuVn2Ao2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2821; q=dns/txt;
  s=iport01; t=1781287836; x=1782497436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sLADWQIE9KTz+/SzYGCIkSHf9EF3QcETYxY+2sa7yfs=;
  b=PuVn2Ao2jD80Zo7taHIKnBi8TbelylGdexxMryEEE4EjMZCxLGSDMwOP
   56DnbBpYbu7jMGWV7vNZfIsmSNMmqwvrjKnhkELWCStJ+LtK0W+TrUTKi
   wlpfS6fuIhb3zQzNuC9zCwZtU7t5/GAdi6cfg2qGRxP++N005VM33JKow
   5Va876QyKZwXoqybM+P8UmCeXelY3CdHxwlo0A73V59gq0i/O0rpVh5b/
   EogsK9ehrdcIsCqCUI9TnmtW/SLdqLVn4PU/YoFA4AYjULlrRHwQCAMmD
   iua5IznbJo2+Ol3hI1aPGhWxrB9aS0+VipmviKUj4SUs6Rv41dpGMFKXH
   Q==;
X-CSE-ConnectionGUID: 1+Sp855fSuaWaX9UCfOuhA==
X-CSE-MsgGUID: C3eHL9OgTmyU1Gw7vBHKsg==
X-IPAS-Result: =?us-ascii?q?A0BCAgBmSixq/4v/Ja1aglmCV4FSQxkwlCqgP4F+DwEBA?=
 =?us-ascii?q?Q9RBAEBhQYCjUMCJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBD?=
 =?us-ascii?q?hOGXIZbAgEDJwsBRhBRVhmDAoJ0A7VRgXkzgQHeQ4FmAQsUAYE4jV50hHwnF?=
 =?us-ascii?q?QaBSUSBFYNpgVKDPoV4BIMcEpB3SIEeA1ksAVUTDQoLBwWBZgM1EioVbjIdg?=
 =?us-ascii?q?SM+F4EMGwcFgUqBK2qBA4UNIx8DOX+BdIEoZ2kVMDWBAQERHQMLGA1IESw3F?=
 =?us-ascii?q?BsEPm4HjEgXD4I+gQ+BMGcok0+QHoIhoQ+EJ6FbGjOqbC6YWqlCgWg8gVkzG?=
 =?us-ascii?q?ggbFYMiUxkPji0Wy2AnMj0BAQcCBw4DC4FokX0BAQ?=
IronPort-Data: A9a23:GaImx6ywbKqRrJCk92N6t+fGxyrEfRIJ4+MujC+fZmUNrF6WrkUHz
 jZLUG3SO66JNDT1e410PY3j9kJQ7ZPVmtVqGgA6/1hgHilAwSbn6Xt1DatR0we6dJCroJdPt
 p1GAjX4BJlqCCea/VH1buSJQUBUjcmgXqD7BPPPJhd/TAplTDZJoR94kobVuKYw6TSCK13L4
 4+aT/H3Ygf/hWYqazhMscpvlTs21BjMkGJA1rABTagjUG/2zxE9EJ8ZLKetGHr0KqE8NvK6X
 evK0Iai9Wrf+Ro3Yvv9+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+vpT2M4nVKtio27hc+adZ
 zl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CCe5xWuTpfi/xlhJBh1BpVIp7t5OnxHy
 vUoeQ0mYDeeh8vjldpXSsE07igiBNPgMIVavjRryivUSK58B5vCWK7No9Rf2V/chOgXQq2YP
 JVfM2cyKk2bMnWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZCxYIePIIfbG5k9ckCwj
 TnL30CoJR4mMc2ikBWarWyGpszUknauMG4VPPjinhJwu3WTz3YeIB4bT122pb++kEHWc9BSK
 UY8/isosLh09UauCNL6WnWQpXeeoh8aHcJdD+Ag8wyL4q3O6g2dCy4PSTspQNUqvcwxXTs3/
 kWEk9PgGXpkt7j9YXCY+7GZojOzETIYIW8LeWkPSg5ty8PuvowplTrVQ9pjGbLzhdrwcRn0z
 y2MpyE4r64OlsNN3KK+lXjDgjSxtt3KQxQz6wH/QG2o9EV6aZSjaoju7kLUhd5ELYCEXhyat
 2MFs9aR4fpIDpyXkiGJBuIXE9mUC+2tKjbQhxtrWpIm7TnooyTldoFL6zY4L0BsWioZRQLUj
 IbokVs5zPdu0LGCN8ebv6rZ5xwW8JXd
IronPort-HdrOrdr: A9a23:YQO92q1WmXCFaqhUtq4RzgqjBHgkLtp133Aq2lEZdPWaSKClfq
 eV7ZAmPHDP5gr5NEtLpTnEAtjifZq+z+8R3WByB9aftWDd0QPCEGgh1/qB/9SKIULDH4BmuJ
 tIQuxXFMDwAV9mjczz/QW0V+o7zMLvytHOuQ6n9RdQZDAvTb185AFkDQveOEh3SA5aQacdLv
 Onl6x6T/7KQwVuUix9bUN1JtT+mw==
X-Talos-CUID: 9a23:/2BV12Mui9ezTe5DAWpc7B5JR84eb3TixUeBHmS2LntpYejA
X-Talos-MUID: 9a23:Velhaga6kFwPAuBTnGThpBUzE8hU5rWTUW8Szossm+qfOnkl
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,201,1774310400"; 
   d="scan'208";a="485223964"
Received: from rcdn-l-core-02.cisco.com ([173.37.255.139])
  by rcdn-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2026 18:10:29 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.127.244])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-02.cisco.com (Postfix) with ESMTPSA id D6BBF18000360;
	Fri, 12 Jun 2026 18:10:27 +0000 (GMT)
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
Subject: [PATCH v4 02/13] scsi: fnic: Use fnic_num for non-SCSI identifiers
Date: Fri, 12 Jun 2026 11:09:07 -0700
Message-ID: <20260612180918.8554-3-kartilak@cisco.com>
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

