Received: from alln-iport-2.cisco.com (alln-iport-2.cisco.com [173.37.142.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20997245019;
	Fri, 24 Jul 2026 17:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784915751; cv=none; b=PpXs324JcBZxT6E8KicdjIIs71eVfytGirAEbQ81AmMc8si1YX1+8/1ISgaL8qd7ma+SSEcaWrJDkkTyiSwC0CEDT/9nRVyzik4o5niiMOjpaTHpuKwnk5FbmMXmABR2Ch6zFxfyW36Y9OtjwR9ykrxGUAekn27ZrlMFPVEYjMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784915751; c=relaxed/simple;
	bh=Arog+kvfMh8RyGwtKU7kx+RmmSzW4py/JBIggpynoqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2E1iN2mic4yJnhiMvdlLrsywTa6BUv7b42W8vOVMxU59G/wRIN5lLLJbBVbW58x+bcFAHBUIvNxvac4/RfU8+ODHLHO0jat86yXcL/MmQc4XK4MCD3iUBy4P1p953tC8OuT2IpSMVGApzGiUp+Sfa0qPeFgxdN06ymXRvwbyPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=jhU3nPye; arc=none smtp.client-ip=173.37.142.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="jhU3nPye"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=982; q=dns/txt;
  s=iport01; t=1784915750; x=1786125350;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mt6uMRIRiHCo3vDpzJgcvMQMx3xcfQiJ4o7/occv6wk=;
  b=jhU3nPyeN9IYBbeDgirURECAJwPpD1ZAIgPbSBmEX8Z/WaU/ZpThfGKG
   pgpkVubUAMJNWgCJOLEbDkhQjw5igOkYjnKQwzlW0qjtCGlyDwYLe9Wfn
   5gZtO2S2Ur7pTdrh0gGw2a+QGuOqDtqaoHrqIJo2uxHjlAwK0ER06Q2f5
   mK6MIeRLFQEn1Bv9H8dhXpKCKFk6boBNtKtCCC2jRKjBuyrr/4U2uH76D
   myudRpyAZIMnWPf6CZoggVGDwkmF6WK9dAyOJd2PLLMN1ey1Mbmk2ZrYR
   QUcoTwR9oO/+xNrSI9WSp3Mx4al1tmanQ/Es13LMSJkBu/6tftpMANqFO
   w==;
X-CSE-ConnectionGUID: wEuTlHSpQZe4yW9zr3MLnw==
X-CSE-MsgGUID: 9CJDzDcNT/CATWgtFBTK0A==
X-IPAS-Result: =?us-ascii?q?A0BCAgDcpWNq/5AQJK1aglmCV4FSQxkwlCmgP4F+DwEBA?=
 =?us-ascii?q?Q9RBAEBhQUCjWACJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBD?=
 =?us-ascii?q?hOGXIZbAgEDMgFGEFFWGYMCgnUDwjCCLIEB3kWBZgELFAGBOI1fdYR8JxUGg?=
 =?us-ascii?q?UlEhH6BUoI4gQaFeASDHBKSQEiBHgNZLAFVEw0KCwcFgWYDNRIqFW4yHYEjP?=
 =?us-ascii?q?heBDBsHBYEdgSx5hFgjHwM5f4EvdUp3LWkBEheBJoNLAoFPAwsYDUgRLDcUG?=
 =?us-ascii?q?QQ+bgeNdyOCQIEOgTGBD6YOoQ+EJ6FbGjOqbJkIqUOBaDyBWTMaCBsVgyJTG?=
 =?us-ascii?q?Q/gfScyPQEBBwIHDgMLgWiQAIF+AQE?=
IronPort-Data: A9a23:f5hdgq3a+G3zWVE/tPbD5SVwkn2cJEfYwER7XKvMYLTBsI5bpz1Sz
 TMZWTvQb/bfZGCmetAiO4+3pkoB6sLSzdMxQFQ43Hw8FHgiRegpqji6wuYcGwvIc6UvmWo+t
 512huHodZ5yFjmH4E/xbtANlFEkvYmQXL3wFeXYDS54QA5gWU8JhAlq8wIDqtYAbeORXUXX5
 Lsen+WFYAX7g2EubjtNg06+gEoHUMra6WtwUmMWPZinjHeG/1EJAZQWI72GLneQauF8Au6gS
 u/f+6qy92Xf8g1FIovNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ajs7XAMEhhXJ/0F1lqTzeJ
 OJl7vRcQS9xVkHFdX90vxNwS0mSNoUekFPLzOTWXcG7lyX7n3XQL/pGE2wrAYk4wf5OM2wS5
 MNJOipWSzSFmLfjqF67YrEEasULJc3vOsYb/3pn1zycValgSpHYSKKM7thdtNsyrpkRRrCFO
 YxAN3w2MEiojx5nYj/7DLo9lf20h332cBVTqUmeouw85G27IAlZj+ixbIWLJI3TLSlTthezh
 E7U02/fPlYxHeCgxiar2E6P3saayEsXX6pXTtVU7MVCgFSJy0QQBQcQWF/9puO24ma8VtBVA
 0gV/Dc+66k48QqgSdyVdxixumKFuFgEVsZdCfY37imK0KPf5wvfDW8BJhZIZNUls9cxWBQw2
 1OJls+vDjtq2JWXTH+b+7iUrBuoNCQVJHNEbigBJSMf7sfuupoblB/DTt9/VqWyi7XdHT3tx
 TuDqgAlmq4ey8UM0s2T+VHBniLppZXTSAMxzhvYU3jj7Q5jYoOhIYuy5jDz6fdGMZbcVVKav
 VAalMWEquMDF5eAkGqKWuplIV2yz/+BNDuZhRtkGIMssmzyvXWiZotXpjp5IS+FL/o5RNMgW
 2eL0Ss52XOZFCLCgXNfC25pN/kX8A==
IronPort-HdrOrdr: A9a23:J8aXO6O+fWAj3MBcTgujsMiBIKoaSvp037Dk7SxMoHtuA6ilfq
 +V8sjzuSWftN9VYgBCpTniAtjkfZq/z/9ICOAqVN/IYOClghrLEGgI1+TfKlPbdhHWx6p0yb
 pgf69iCNf5EFR2yfrh7BLQKadG/DD+ysCVrNab6WtxRgd3bKwlxQJ4BgGHVnBSfmB9dPwE/F
 723Ls+m9JmEk5nF/iGOg==
X-Talos-CUID: 9a23:KeEyVmwgiMhK3GcA9NVbBgULN90Zdl3m1E7iLhOpNjd7UuawbVmPrfY=
X-Talos-MUID: 9a23:Q8/tDApgt3zB3hhjn8Mez2BJFut6z6+INAcmuKk5tNWqHxBTYx7I2Q==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,183,1779148800"; 
   d="scan'208";a="784476691"
Received: from alln-l-core-07.cisco.com ([173.36.16.144])
  by alln-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jul 2026 17:55:49 +0000
Received: from fedora.cisco.com (unknown [10.189.189.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-07.cisco.com (Postfix) with ESMTPSA id 7604A180001C6;
	Fri, 24 Jul 2026 17:55:43 +0000 (GMT)
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
Subject: [PATCH v6 13/13] scsi: fnic: Bump up version number
Date: Fri, 24 Jul 2026 10:48:11 -0700
Message-ID: <20260724174811.5118-14-kartilak@cisco.com>
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

Bump up version number to 1.9.0.0.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/fnic/fnic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 507c22d21882..c576a7f5083e 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -31,7 +31,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.8.0.3"
+#define DRV_VERSION		"1.9.0.0"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
-- 
2.47.1

