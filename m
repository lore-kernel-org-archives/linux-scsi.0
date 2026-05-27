Received: from rcdn-iport-7.cisco.com (rcdn-iport-7.cisco.com [173.37.86.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176B23B19B5;
	Wed, 27 May 2026 19:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779911520; cv=none; b=Ic8uomJjIwlkLoPqUOB2KfREbUHo+sA5+vkb68XC9jxlItL9agErkTJeyUClGlzE8q91wliFmBRmEAvwUT6uwiDlsicX264jDPF3I2gKdCX88Xq+i6EOLzbxzglyKa5sFI3Bi2vHcy16BgTyrw3Sp1mGR0PuJnKVrC1CEpaD+kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779911520; c=relaxed/simple;
	bh=MqfsJf+1OEMmO9q7T7+jnWt5YT9gOjSmP2N52PTvYXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M88BN3fUne+0DK14TAxefJJSrCJVYB/f84D4EFfegHMHgZmh0PuPUY/Pg1z5oySWJrbK/iFkvPQ/pzUGdjbZz3vhRlKF6/TFpkqWfqmxSjyMQ4g+IveHI3uF71X6aXW8VYz6s3wgjO3gp76u38X/6B6NZskOzfiw0s1lwcjEE5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=KLagbs/q; arc=none smtp.client-ip=173.37.86.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="KLagbs/q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2380; q=dns/txt;
  s=iport01; t=1779911519; x=1781121119;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7El7txWnVBYS0oAqoczxMxdcpNQB4t7ZrPZxLFg+7Q4=;
  b=KLagbs/qpUn7DmVMVInLc/VkLvxQTMhehDCiLwDAs/3Rv/u98xtDHZZo
   a2Qq79HyjMAOupgaIl6A6YqDd2P+xSviEbccs3RnqrrnU+7GCEW3EGdzK
   SEIW7aN0ZxcICSGBf+SP4kNSsOHTmRyZWnx7HGGqEi9ITyFFCROkm1IMn
   NoeEZCN6Omqq6h3QLyJVXRTGW8nHI6Zps4kGzlAJVAYZu4IOMTYBPh4YI
   wHnzseRzEy79ZaG6rJMu1L2e6Cw3l5QNn8J9OkdNIY3hJHK5+Iig7MsqF
   GPEhYqrT/iPzU5MPEGKOfN0mHL6qG85WGmJi5lWlhgTkPyrtUa92RMQhw
   A==;
X-CSE-ConnectionGUID: 8k6p7dJETfOSkJxOf4ROZQ==
X-CSE-MsgGUID: QGlGpNTCRXi2zlD1ecMblQ==
X-IPAS-Result: =?us-ascii?q?A0BCAgDGShdq/5P/Ja1aglmCV4FQQxkwlCqgP4F+DwEBA?=
 =?us-ascii?q?Q9RBAEBhQYCjTICJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBD?=
 =?us-ascii?q?hOGXIZbAgEDJwsBRhBRVhmDAoJ0A7RQgXkzgQHeQYFkAQsUAYE4jVx0hHsnF?=
 =?us-ascii?q?QaBSUSBFYNogVKDPoV3BIMuhhGJAEiBHgNZLAFVEw0KCwcFgWYDNRIqFW4yH?=
 =?us-ascii?q?YEjPheBCxsHBYFLdnJqgQWFGCMmA06BLYF/XQMLGA1IESw3FBsEPm4HinUaD?=
 =?us-ascii?q?4IxgQ+CPx2TRJItoQ6EJqFbGjOqa5kGo3CFUIFoPIFZMxoIGxWDIlMZD90jJ?=
 =?us-ascii?q?zI9AgcCBw4DC5NlAQE?=
IronPort-Data: A9a23:E2OU3K07U3bScHlRM/bD5SJwkn2cJEfYwER7XKvMYLTBsI5bpzUOm
 jYaDDyEPaqIY2HwLtp/adu2oUtQucXRzt4xHlE93Hw8FHgiRegpqji6wuYcGwvIc6UvmWo+t
 512huHodZ5yFjmH4E/xbtANlFEkvYmQXL3wFeXYDS54QA5gWU8JhAlq8wIDqtYAbeORXUXX5
 bsen+WFYAX7g2MubTpOg06+gEoHUMra6WtwUmMWPZinjHeG/1EJAZQWI72GLneQauF8Au6gS
 u/f+6qy92Xf8g1FIovNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ajs7XAMEhhXJ/0F1lqTzeJ
 OJl7vRcQS9xVkHFdX90vxNwS0mSNoUekFPLzOTWXcG7lyX7n3XQL/pGXEJoJdIU2MtLD0Z19
 t4IDz5RVDexvrfjqF67YrEEasULNsLnOsYb/3pn1zycVK5gSpHYSKKM7thdtNsyrpkRRrCFO
 IxDNGcpNUifC/FMEg9/5JYWn+6ymnj7ej5wo1OOrq1x6G/WpOB0+OS9boKPIIfVG625mG6hi
 Wbp50LFKSsqNYaNzRbc/3mJjOv2yHaTtIU6UefQGuRRqF2a3GE7CxAMU1a/5/6jhSaWWd9dI
 WQQ+ywzve4z/kntRd74NzW9qWSYvxhaQ9dMHvch5QelzbDd6AKUQGMDS1ZpYdAvt8guQiECz
 FKFn9r1QzdotdW9S3eQ8LqbrTKaIyUZLWYeIyQDSGMt+dT9rZsopgjCQtZqDOi+ididMTX83
 jaBpS4WnKgIgIgA0KDT1VTGhS+845vEVAg44i3JUW+/qAB0foioY8qv81ezxfJBKpuJC0KKp
 3kshceT9qYNAIuLmSjLR/8CdIxF/N6fOzHaxFoqFJ47+nH0oziofJtb53d1I0IB3ts4RAIFq
 XT74Wt5jKK/9lPzBUOrS+pd0/gX8JU=
IronPort-HdrOrdr: A9a23:zEdiAqxCANxzLlrAEuWoKrPw5r1zdoMgy1knxilNoNJuHvBw8P
 re+MjzuiWbtN98YhsdcJW7Scq9qBDnhPtICOsqXItKNTOO0ACVxcNZnOnfKlbbdBEWmNQx6Y
 5QN4BjFdz9CkV7h87m7AT9L8wt27C8gceVbJ/lr0tFfEVNd7xq6Rt/B0KwF017QxQDOL8Cfa
 DsgPauY1GbCAwqhgPRPAh9Y9T+
X-Talos-CUID: =?us-ascii?q?9a23=3A8lG8mGm/8WVw3YW7wHMqUaqjtIrXOS3ekm+PL22?=
 =?us-ascii?q?VNWhOc763WXiepJlDofM7zg=3D=3D?=
X-Talos-MUID: 9a23:p79D6gUFn3Ap833q/AbDgB56EvtD2ZSvUlIJvcwLsOyOMRUlbg==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,172,1774310400"; 
   d="scan'208";a="486022376"
Received: from rcdn-l-core-10.cisco.com ([173.37.255.147])
  by rcdn-iport-7.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 27 May 2026 19:51:58 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.14.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-10.cisco.com (Postfix) with ESMTPSA id 5FA0A18000276;
	Wed, 27 May 2026 19:51:56 +0000 (GMT)
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
Subject: [PATCH v2 04/13] scsi: fnic: Advertise NVMe initiator service parameters
Date: Wed, 27 May 2026 12:49:51 -0700
Message-ID: <20260527195000.8444-5-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260527195000.8444-1-kartilak@cisco.com>
References: <20260527195000.8444-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.14.55];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.14.55, [10.188.14.55]
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

