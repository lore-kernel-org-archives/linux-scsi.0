Received: from rcdn-iport-7.cisco.com (rcdn-iport-7.cisco.com [173.37.86.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E024071D5;
	Fri,  5 Jun 2026 23:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780703299; cv=none; b=NvU4UOn13DF5Nu/S0Ve00u62y91LDX70Z4/e2dr6jE9wSCgn7cOamC2DUzpy0uJXJNVBOjrd7e5Dznbp7Di39FFb0TNIcu75Oblp8ARB0vCTdTar3hzjwKU35dMbbwwLkOSSlque/sQ0DwxYiLQip+7aTEUREFTqXVsW4eXnBFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780703299; c=relaxed/simple;
	bh=MqfsJf+1OEMmO9q7T7+jnWt5YT9gOjSmP2N52PTvYXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2im2UhTqRe02OfkJ/EI3ObXn7olO4T6XpYGCtAvC5oRWufRtWzYR1538EZL0/BlDzn3LderF5Iez8ebGgmqI6pnjqcum2Z2vr9m73b0Rr5VS3AI1QMx0l4IvrCnaeX/La7pCwq312Wx1+gJ9kUg0ldfTHKo3/S68Jqo6oCpqBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=K2e2Ic4L; arc=none smtp.client-ip=173.37.86.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="K2e2Ic4L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2380; q=dns/txt;
  s=iport01; t=1780703298; x=1781912898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7El7txWnVBYS0oAqoczxMxdcpNQB4t7ZrPZxLFg+7Q4=;
  b=K2e2Ic4Lrr3eBLa1wvcZFTcP2Mn7+KfMfcOq78cN+cAp7Kks4a0wIcab
   g+CsxWt0+KbJckgTMg1nyCh0Zaqav9LeVRPw5fCDg+xCRzI0R6ILaz5OB
   fTMpq+hhsR1VQz/s9Y+grcpXBDz5RSICq4P7YONiPw+pfCr3lqbzUcej/
   mzvGWsfhjXJll1WS1FBpPVR2MpORLIXpbtReGGzkRB0q7P96cPxvlciV+
   GybGVVzygNuv8hXTxZ6+OXLsnVxnWbwqs/DZqO+uZitgSMnaIz7kfP9MM
   nU2iDt9b7GFEdpxRKfZ8tVlt4lmzT0HAmip7IGLnswDDIElOArKzLElOz
   w==;
X-CSE-ConnectionGUID: m89aPL93SJehadglBj6r+Q==
X-CSE-MsgGUID: jMOeFO80S5OTqhgpq5TLUA==
X-IPAS-Result: =?us-ascii?q?A0BCAgAtXyNq/5P/Ja1aglmCV4FSQxkwlCqgP4F+DwEBA?=
 =?us-ascii?q?Q9RBAEBhQYCjTMCJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBD?=
 =?us-ascii?q?hOGXIZbAgEDJwsBRhBRVhmDAoJ0A7QGgXkzgQHeQoFmAQsUAYE4jV10hHsnF?=
 =?us-ascii?q?QaBSUSBFYNogVKDPoV3BIMuhXyKYEiBHgNZLAFVEw0KCwcFgWYDNRIqFW4yH?=
 =?us-ascii?q?YEjPheBCxsHBYFKgUlqgQSFEiMfAzmBF4F8gShnaRUxOhcDCxgNSBEsNxQbB?=
 =?us-ascii?q?D5uB4wuFw+CN4EPgj8dk0SSLaEOhCahWxozqmuZBqNwhVCBaDyBWTMaCBsVg?=
 =?us-ascii?q?yJTGQ/WfycyPQIHAgcOAwuTZQEB?=
IronPort-Data: A9a23:bHtWBaOyg9v9+IPvrR1UlsFynXyQoLVcMsEvi/4bfWQNrUp00DAGm
 jFJCG6BbP+MYGKjKo0gbd6zoE0EuMPdzddqQXM5pCpnJ55oRWUpJjg4wmPYZX76whjrFRo/h
 ykmQoCeaphyFTmE+kvF3oHJ9RFUzbuPSqf3FNnKMyVwQR4MYCo6gHqPocZh6mJTqYb/WV/lV
 e/a+ZWFZgf7g2Msawr41orawP9RlKWq0N8nlgRWicBj5Df2i3QTBZQDEqC9R1OQapVUBOOzW
 9HYx7i/+G7Dlz91Yj9yuu+mGqGiaue60Tmm0hK6aYD76vRxjnBaPpIACRYpQRw/ZwNlMDxG4
 I4lWZSYEW/FN0BX8QgXe0Ew/ypWZcWq9FJbSJSymZT78qHIT5fj6/A+XUgOGdxDwcR6AWhC+
 vgyKm4XLSnW0opawJrjIgVtrt4oIM+uOMYUvWttiGiBS/0nWpvEBa7N4Le03h9p2ZsIRqmYP
 ZdEL2MzM3wsYDUXUrsTIJE3hvupgnD8WzZZs1mS46Ew5gA/ySQtgOm9aoWEIo3iqcN9nGO/q
 0zhrzzCXzYmLdyQ0SPYzlaRr7qa9c/8cMdIfFGizdZqiUee7m8eEhsbUR28u/bRokyzWdh3L
 00S5zporKI3skesS7HVWhSivH+C+AYRR9dKCOA8wAaXw6HQ7kCSAW1sZjdNYd8hrMgrbSYn2
 l+Ag5XiAjkHmL+QRHSQ+beVhSm/NSgcMSkJYipsZREI/dT5u6kpgx7PR8olG6mw5vXxFSz2y
 DmMhDMjnLhVhskOv42//Fbak3evq4LPQwod+AraRCSm4xl/aYrjYJangXDf7PBdPMOCRUKAl
 GYLltLY7+0UC5yJ0iuXT40w8KqB/f2JNnjYxFVoBZRkrmzr8H+4docW6zZ7TKt0Dvs5lfbSS
 Be7kWtsCFV7ZRNGsYcfj1qNNvkX
IronPort-HdrOrdr: A9a23:lcLm5q9dRZXGcHg1blluk+ASI+orL9Y04lQ7vn2ZhyY4TiX+rb
 HLoB1173HJYVoqMk3I3OrwW5VoIkmskKKdg7NxAV7KZmCP01dAbrsSj7cKqAeOJ8SRzINg/J
 YlW7RiCdH2EFhxhdv37U2FCdo6qeP3l5xA/d2/815dCSd3dqpn8wB1TiyfEkFwWU16IKBRLu
 v72iKCzADQAUj+qa+AdwA4Y9Q=
X-Talos-CUID: 9a23:hCq0JGGUn9XPiQv+qmJipB8dIuR0KUb/wXfZL0C8I2Q3Uv6sHAo=
X-Talos-MUID: 9a23:CZbXwQgsKB+0yhVbI12VJMMpNuJP7oqJWBg2zLI6osmLLTUtBxOgpWHi
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,189,1774310400"; 
   d="scan'208";a="489827909"
Received: from rcdn-l-core-10.cisco.com ([173.37.255.147])
  by rcdn-iport-7.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 05 Jun 2026 23:47:08 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.102.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-10.cisco.com (Postfix) with ESMTPSA id 5DB7418000A5D;
	Fri,  5 Jun 2026 23:47:07 +0000 (GMT)
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
Subject: [PATCH v3 04/13] scsi: fnic: Advertise NVMe initiator service parameters
Date: Fri,  5 Jun 2026 16:45:29 -0700
Message-ID: <20260605234538.7950-5-kartilak@cisco.com>
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

