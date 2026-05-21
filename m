Received: from rcdn-iport-4.cisco.com (rcdn-iport-4.cisco.com [173.37.86.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23D736A027;
	Thu, 21 May 2026 18:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779386871; cv=none; b=jqcNB46F4QEd2vOysbOADRkAXNr+iOQtdTWPeolgj5o+5ZinBn+MIhcwBJn3LN4rQ1Auy1h9L54K+oGRaEkG6loNe+Sj8kJ85hDMeZBgZaL+Y+k7keBWMvl5uofzMwN4ciChpzfiN7a+DCU/2MOZTSfweB4QznOTauFNA6nmjBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779386871; c=relaxed/simple;
	bh=MqfsJf+1OEMmO9q7T7+jnWt5YT9gOjSmP2N52PTvYXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIZUgywWb02SfR6aln+ETcyIOv71ug+JRhAbvVuTCuvutFssOi6fIyqwHaAU5OX7vb2lMdL/SUe9Q9WH0N5rf8FylLdW9l6KTjAGthjxVLV4XIrFk+6xl1y0H1zWhyBeAqZoV68R80qSzeGF3a1fghK/1dbly4N+8VNWpETWFLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=QEo2uRfW; arc=none smtp.client-ip=173.37.86.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="QEo2uRfW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2380; q=dns/txt;
  s=iport01; t=1779386870; x=1780596470;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7El7txWnVBYS0oAqoczxMxdcpNQB4t7ZrPZxLFg+7Q4=;
  b=QEo2uRfWlqfR0fYtR59P5zNXnNxQ9jtbyhOT2mh8hhT4TsAC5SijwBzm
   rp3+k4p2YaNglXH7rxiWAHGYh18kzbwU2WTosVpX1zbNOvFSQC3/L2Yc/
   DNS/BTkdIpBByZgsZgsnF2fgkYl7AaTS+RjwuuTN12HfK3ZwEnRUWAth2
   jrwCQUzAF6uKBLPHXjdC2AmbMDeuWSaV65+fnpPQPIve2FFg1VEUkwkfw
   Ibaef+HPSAGktNh5EBrPknAzIJRhMpZ1yZ329/Rt1HLHZhFLAJo9GTVSM
   s7p8SUBtXpTHVfYlNku3mX/Cp3z7F5h3pC9gyAkn7oswl6wLZiHqMYmLW
   w==;
X-CSE-ConnectionGUID: +pFgc1AFQfymmzkhPQ4xww==
X-CSE-MsgGUID: jZPJI0xxQm+tuMGIxuz8Mg==
X-IPAS-Result: =?us-ascii?q?A0BCAgCkSA9q/5L/Ja1aglmCV4FQQxkwlCqgP4F/DwEBA?=
 =?us-ascii?q?Q9RBAEBhQYCjTICJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBD?=
 =?us-ascii?q?hOGXIZbAgEDJwsBRhBRVhmDAoJ0A7QogXkzgQHeQYFkAQsUAYE4jVx0hHsnF?=
 =?us-ascii?q?QaBSUSBFYNogVKDPoV3BIMuhjaIZkiBHgNZLAFVEw0KCwcFgWYDNRIqFW4yH?=
 =?us-ascii?q?YEjPheBCxsHBYFLgTdyaoEEhFd4IywDToEtgWsDCxgNSBEsNxQbBD5uB4p5H?=
 =?us-ascii?q?A+CMYEPgj8dk0SSLaEOhCahWBozqmqZBaNwhVCBaDyBWTMaCBsVgyJTGQ/ZY?=
 =?us-ascii?q?ScyPQIHAgcOAwuTZQEB?=
IronPort-Data: A9a23:jgRTGqvVhx+Chbhne8T8i0gHKufnVN1fMUV32f8akzHdYApBsoF/q
 tZmKW/SMvjfNzGmeNhzPInj9EtQ6pfWztBiHgs/qys9Qy9AgMeUXt7xwmUckM+xwmwvaGo9s
 q3yv/GZdJhcokf0/0nrav666yEgiclkf5KkYMbcICd9WAR4fykojBNnioYRj5Vh6TSDK1vlV
 eja/YuFZDdJ5xYuajhKs//Z8Usz1BjPkGpwUmIWNKgjUGD2zxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0NS+7vw60c+VZk
 72hg3AfpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn3bEm51T4E8K0YIwuf5ZDmoX3
 NIhJiEIawKAh9qPnKKkVbw57igjBJGD0II3oHpsy3TdSP0hW52GG/SM7t5D1zB2jcdLdRrcT
 5NGMnw0M1KaPkAJYwtJYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUoDaGZgKxxjI+
 Aoq+Uz7MCk4FYSP2QOAsW6xo8DujT7pCKcdQejQGvlCxQf7KnYoIB0fT1aTovSjjEO6HdVFJ
 CQ89iMo66M77lSmSMXwRTW8oXiNpBlaXMBfe8U45QOH4q7V5RuJQGkOS3hKb9lOnMo/XyAr0
 BmRks/kHyditpWSU3uW8rrSpjS3UQAcIWYBYjcDUCMf7tXjqZ11hRXKJv5hFaOzg9L1GBnqz
 jyKpTR4jLIW5eYR2ru250vvmT+gppHVCAUy423/Wm646AhwYqa+epelr1Pc6J5oKIefU0nEv
 3UencWaxP4BAIvLlyGXRugJWraz6J6tNDzanE4qBJI69hyz9HO5O4Nd+jdzIAFuKMlsRNPyS
 FXYtQUU4NpYO2GnKPcmJYmwEM8ti6PnELwJS8zpUzaHWbApHCfvwc2kTRf4M7zF+KT0rZwCB
 A==
IronPort-HdrOrdr: A9a23:17nng6Dg2QMAJaPlHelm55DYdb4zR+YMi2TDGXocdfUzSL39qy
 nAppomPHPP4gr5HUtQ+uxoW5PwJE80l6QV3WB5B97LNzUO+lHYTr2KhrGM/9SPIUDD398Y/b
 t8cqR4Fd37BUV3gILH+gWieuxQp+VviJrJuc7ui1FwUAptd6Zsqy19CgqdDwlKYTMuP+teKH
 JZjfA33wZJvh8sH72GOkU=
X-Talos-CUID: 9a23:NPrXj29GlDXjpJaYL9OVvw0MNM8uK1Tz9XnBJkqqCmZRceGFVkDFrQ==
X-Talos-MUID: 9a23:9OPCVQUI4NceUzrq/D3evBNDbNd42qHtFF0ovrQWptvUECMlbg==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,160,1774310400"; 
   d="scan'208";a="484571686"
Received: from rcdn-l-core-09.cisco.com ([173.37.255.146])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 21 May 2026 18:06:41 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.18.181])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-09.cisco.com (Postfix) with ESMTPSA id 8F76A18000236;
	Thu, 21 May 2026 18:06:39 +0000 (GMT)
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
Subject: [PATCH 04/13] scsi: fnic: Advertise NVMe initiator service parameters
Date: Thu, 21 May 2026 11:04:49 -0700
Message-ID: <20260521180458.5448-5-kartilak@cisco.com>
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

