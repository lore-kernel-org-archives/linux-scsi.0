Received: from rcdn-iport-7.cisco.com (rcdn-iport-7.cisco.com [173.37.86.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CDB44C77;
	Thu, 12 Jun 2025 00:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749689151; cv=none; b=HNb1nyVYjJ1p4NydiUTQCxCL5WoSMhG1NLL3UIilEpPraaC/6J0vXoaxijNMeecWzlQ2NwaO21tQMQHfyrPYRGpA820KQFNeHWg9gCq7+vJ+1D/HC7B1qtELI+W/YfAXTb0EYJUzQfA/9AC5yPy8wXKKZ9OVsDAdoR5BuMgAPqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749689151; c=relaxed/simple;
	bh=bKDZExpTVr2pGtwZnZLCuVNx9sxw+4CpIbC6hw/Xx/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqMnXmyw+HmtDTGbUyFntsDhzXl1ubzzZJmTKNQDAS84xgUQ0vtQ3KCx8wMRGIDMoN4ZZNy0Tu4ZSmYYx/FGxMd7Pv63gotyJlJ5YuxwD9n2PJhaYv2cOp8zY3ILH4ewMvtGSC7Rr3DqX50nykvu7TwpV11JrBQ0YOA+EjttBo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=DsCKPGCo; arc=none smtp.client-ip=173.37.86.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="DsCKPGCo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1435; q=dns/txt;
  s=iport01; t=1749689150; x=1750898750;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yE83WXXy7htpJHWda3RTgdsS+5aW/fHR3g7XMaHM/fc=;
  b=DsCKPGCodiuSl2E4vvKQFa/JqRL5aQuKJm3ghPDylYV6veog8qcE8V5B
   /Y+kxMB29xB7AkKnwWptPpX6E13DQHXBEteoGKgtv3Ggyhf98ynYWyi2q
   mC+8vmA8/4/dx6fKe2fuRd9W1dVLkkK+fNzxZMjwS0lYvUQpVd3YIkOfo
   fARtyfeMFHTP6NxgAFGc0uZbk5eJO3qP9Ij225vCwz6171gaNrNKsudop
   curWoglgO5hz8DRjHFvUbUHY5cKnCe6q9CCInBWb1umu8yXGjc+UOJrNC
   aONyRtcEG2rRm9fuIydPn0/ZUCepqKrI9pxEFTL3rQRmBWA1n2Nxx4AWn
   g==;
X-CSE-ConnectionGUID: DOrEmQ+XSsCivpxNuCGB1w==
X-CSE-MsgGUID: OZB2mSG0Rn2RGKx9+mmsJA==
X-IPAS-Result: =?us-ascii?q?A0ANAACCIkpo/5IQJK1aGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAYF/BgEBAQsBgkqBUkMZMIxwhzSgOoElA1cPAQEBD1EEAQGFBwKLZgImN?=
 =?us-ascii?q?AkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGCIZbAgEDJ?=
 =?us-ascii?q?wsBRhBRVhmDAoJvA7AIgXkzgQHeN4FugUkBjUxwhHcnFQaBSUSBFYJ5b4FSg?=
 =?us-ascii?q?z6FdwSDOqEeSIEeA1ksAVUTDQoLBwWBYwM1DAsuFW4yHYINhRmCEosHhEkrT?=
 =?us-ascii?q?4UhhQUkcg8HSkADCxgNSBEsNxQbBj5uB5gLg3CBDnyBRCmlV6ELhCWhUxozh?=
 =?us-ascii?q?ASNDZlQmQSpOIFoPIFZMxoIGxWDIlIZD44tFrtVJjI8AgcLAQEDCZIUAQE?=
IronPort-Data: A9a23:gYKs/q3PsmTXZ4z4s/bD5Ttwkn2cJEfYwER7XKvMYLTBsI5bpzwPy
 GYXWzqBP/iMYGr1Kotzb4rl/UIP65LSndZnSgpq3Hw8FHgiRegpqji6wuYcGwvIc6UvmWo+t
 512huHodZ5yFjmG4E70aNANlFEkvYmQXL3wFeXYDS54QA5gWU8JhAlq8wIDqtYAbeORXUXU5
 7sen+WFYAX4g2AtazpPg06+gEoHUMra6WtwUmMWPZinjHeG/1EJAZQWI72GLneQauF8Au6gS
 u/f+6qy92Xf8g1FIovNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ajs7XAMEhhXJ/0F1lqTzeJ
 OJl7vRcQS9xVkHFdX90vxNwS0mSNoUekFPLzOTWXcG7lyX7n3XQL/pGIGYsEIghudZMGkpP6
 +QIDi0mQTramLfjqF67YrEEasULJc3vOsYb/3pn1zycVadgSpHYSKKM7thdtNsyrpkRRrCFO
 YxAN3w2MEqojx5nYj/7DLo9lf20h332cBVTqUmeouw85G27IAlZi+i9YISPJI3SLSlTtmGqj
 DjDxEuhOBdADvO82WvG93e3pMaayEsXX6pXTtVU7MVCjFSVgGcaEgUbU0e2u9G9i0i3QdUZL
 FYbkgIsoKo43EiqSMTtGRyypTiPuRt0c99ZCfE77keVx7bZ+R2UAEADVDdKbNFgv8gzLRQo0
 1KPktzpBBR1vbGVQG7b/bCRxRuoNDYYN3QqfyIITQIZpdLkpekbihPJU8YmE6OviNDxMS//z
 irMryUkgbgXy8kR2M2T+VHBniLpvZPSTyYr6QjNGGGo9AV0YMiifYPAwUPH5PxEIa6HQVSb+
 nsJgc6T6KYJF57lqcCWaOwJGLfs47OONyfRxAY+WZIg7D+qvXWkeOi8/Q1DGaugCe5cEReBX
 aMZkVk5CEN7VJdyUZJKXg==
IronPort-HdrOrdr: A9a23:vDTsE65Ze4jr9VJZDgPXwOfXdLJyesId70hD6qm+c3Bom6uj5q
 STdZsguyMc5Ax6ZJhko6HiBEDiewK4yXcW2+gs1N6ZNWGMhILrFvAB0WKI+VLd8kPFm9J15O
 NJb7V+BNrsDVJzkMr2pDWjH81I+qjhzEnRv4fjJ7MHd3ASV0mmhD0JbDqmLg==
X-Talos-CUID: =?us-ascii?q?9a23=3AQmv89mplRI4ab5gAEECyEyTmUewCaFDY9TTgGFS?=
 =?us-ascii?q?TCHhxWJuIYnC6obwxxg=3D=3D?=
X-Talos-MUID: 9a23:6sGIfQkJ2s7k2A/onw+HdnpFBu0y5p+BUHoLy68pmNnVdil1IBW02WE=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,229,1744070400"; 
   d="scan'208";a="388862690"
Received: from alln-l-core-09.cisco.com ([173.36.16.146])
  by rcdn-iport-7.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2025 00:45:48 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-09.cisco.com (Postfix) with ESMTPSA id EF99C18000443;
	Thu, 12 Jun 2025 00:45:46 +0000 (GMT)
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
	Karan Tilak Kumar <kartilak@cisco.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 4/5] scsi: fnic: Turn off FDMI ACTIVE flags on link down
Date: Wed, 11 Jun 2025 17:44:25 -0700
Message-ID: <20250612004426.4661-4-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250612004426.4661-1-kartilak@cisco.com>
References: <20250612004426.4661-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.19.134, [10.188.19.134]
X-Outbound-Node: alln-l-core-09.cisco.com

When the link goes down and comes up, FDMI requests are not sent out
anymore.
Fix bug by turning off FNIC_FDMI_ACTIVE when the link goes down.

Fixes: 09c1e6ab4ab2 ("scsi: fnic: Add and integrate support for FDMI")
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Cc: <stable@vger.kernel.org> # 6.14.x Please see patch description
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fdls_disc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 9e9939d41fa8..14691db4d5f9 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -5078,9 +5078,12 @@ void fnic_fdls_link_down(struct fnic_iport_s *iport)
 		fdls_delete_tport(iport, tport);
 	}
 
-	if ((fnic_fdmi_support == 1) && (iport->fabric.fdmi_pending > 0)) {
-		timer_delete_sync(&iport->fabric.fdmi_timer);
-		iport->fabric.fdmi_pending = 0;
+	if (fnic_fdmi_support == 1) {
+		if (iport->fabric.fdmi_pending > 0) {
+			timer_delete_sync(&iport->fabric.fdmi_timer);
+			iport->fabric.fdmi_pending = 0;
+		}
+		iport->flags &= ~FNIC_FDMI_ACTIVE;
 	}
 
 	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-- 
2.47.1

