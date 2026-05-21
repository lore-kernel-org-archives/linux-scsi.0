Received: from rcdn-iport-1.cisco.com (rcdn-iport-1.cisco.com [173.37.86.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02C6381AEB;
	Thu, 21 May 2026 18:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779387205; cv=none; b=ow4iDUkFBxDBdMeZKvrw3V5Cg7k4KVSyA+nLPmT9i2waMFUPbW/zbEGyl9GEPOABhgcm2OawyZNjIirzKRNmMP85ha2GATkLGgg/MGtL6Tg+k+fmjpvzVwlRMcKVF7NpRWM/8D7y4uZR032DpHXnGXiR1LC3oFhkNDSFRJYcfzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779387205; c=relaxed/simple;
	bh=WHaVe4lxP3vzySB73pwv+/q2GF2UEAHCOQH6XlTNEPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXrVsdVMwLXteeuZs1m2pEvlr5DpWqCdjxCL2Vm0+Uz41oYuOlB+/LgJlUl+geplvASHaArf1GLiKsY5mrzfuWY47kjregqoaqRNKka5ijnAIHOZQqUp+NTX10l/K90VAjgymxODwI6znG51MY/zHx34cCMWWUNwOvfQuBZiTG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=HVvpXbxT; arc=none smtp.client-ip=173.37.86.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="HVvpXbxT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=982; q=dns/txt;
  s=iport01; t=1779387204; x=1780596804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ih4/4CQtXsRllMF+cu0QXC1vYWo60kbbCDWls6M2bSg=;
  b=HVvpXbxTE+h5cyR40Cdrh1lwbN3lA/SNhEX40r88wghQgIWNtlh6Bf1X
   pW03iXqwdrYwOO7VIE7Iyyq3uxdzVTpIxmVNkLa7JDROZjZpd+06Ch6vQ
   8ZnvzKkUdfTV0QozL+CJ8Ulf72M0mdpDsTWp6Y29u4GqXTL7yS0FFKEdA
   dLFwAnSKJmLtgYQNNN4vbOctBBHdZtZVurvucS169dyzwQb0ny8upeAT+
   NNvOrOeqI9fv+2pkZg2QNhzs7W0bxoQZdWhfU10kRorEuKyBhCDVGzZvv
   FZjPUiFvHho9IBMQxu2fhGkdIoUYHqsfCaxsKO11YjuCZSBUUC9i8swfm
   Q==;
X-CSE-ConnectionGUID: s4I28M3/Q7uLtMuDDxd0iw==
X-CSE-MsgGUID: +zDEyyfVRyq0tBSy/FrDhw==
X-IPAS-Result: =?us-ascii?q?A0BBAgDGSQ9q/5L/Ja1aHgEBCxIMggULgleBUEMZMJQqo?=
 =?us-ascii?q?D+Bfw8BAQEPUQQBAYUGAo0yAiY0CQ4BAgQDAgMBAQEBAQEBAQEBAQsBAQUBA?=
 =?us-ascii?q?QECAQcFgQ4ThlyGWwIBAzIBRhBRVhmDAoJ0A7QbgiyBAd5BgWQBCxQBgTiNX?=
 =?us-ascii?q?HSEeycVBoFJRIR9gVKCOIEGhXcEgxwSjxxIgR4DWSwBVRMNCgsHBYFmAzUSK?=
 =?us-ascii?q?hVuMh2BIz4XgQsbBwWBS4IpaoEEhFd4IywDToEtgWsDCxgNSBEsNxQbBD5uB?=
 =?us-ascii?q?4p5HA+CMYEOgTGBD6YOoQ6EJqFYGjOqapkFqUCBaDyBWTMaCBsVgyJTGQ/ZY?=
 =?us-ascii?q?ScyPQIHAgcOAwuRaIF9AQE?=
IronPort-Data: A9a23:uoaXLKvJjEyH8Caa4+jYeoHzvefnVN1fMUV32f8akzHdYApBsoF/q
 tZmKW6BOvrbZ2unf9onPdmz9RlQ7Z7VmtYxHQRs+Hg8Q3gQgMeUXt7xwmUckM+xwmwvaGo9s
 q3yv/GZdJhcokf0/0nrav666yEgiclkf5KkYMbcICd9WAR4fykojBNnioYRj5Vh6TSDK1vlV
 eja/YuFZDdJ5xYuajhKs//Z8Usz1BjPkGpwUmIWNKgjUGD2zxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0NS+7vw60c+VZk
 72hg3AfpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn3bEm51T4E8K0YIw4bpWWzFrr
 rshdy0pcjWeq86mzOq6Vbw57igjBJGD0II3oHpsy3TdSP0hW52GG/SM7t5D1zB2jcdLdRrcT
 5NGMnw0M1KaPkAJYwtJYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUoDaGZwKxBfE/
 goq+Uy6ED03Jc2R9wCU6yqwrNTe2g3hdIINQejQGvlCxQf7KnYoIB0fT1aTovSjjEO6HdVFJ
 CQ89iMo66M77lSmSMXwRTW8oXiNpBlaXMBfe8U45QOH4q7V5RuJQGkOS3hKb9lOnMo/XyAr0
 BmRks/kHyditpWSU3uW8rrSpjS3UQAcIWYBYjcDUCMf7tXjqZ11hRXKJv5hFaOzg9L1GBnqz
 jyKpTR4jLIW5eYR2ru250vvmT+gppHVCAUy423/Wm646AhwYqa+epelr1Pc6J5oKIefU0nEv
 3UencWaxP4BAIvLlyGXRugJWraz6J6tNDzanE4qBJI69hyz9HO5O4Nd+jdzIAFuKMlsRNPyS
 FXYtQUU4NpYO2GnKPcmJYmwEM8ti6PnELwJS8zpUzaHWbApHCfvwc2kTRf4M7zF+KT0rZwCB
 A==
IronPort-HdrOrdr: A9a23:vapHQ6ol6UTZ0wzobxM+gcsaV5rheYIsimQD101hICG9vPb1qy
 nIpoV+6faaslgssR0b8+xofZPwIk80lqQFhLX5X43CYOCOggLBR72Kr7GSoQEIcBeQygcy78
 pdWpk7IMHsDFR8kMbx6BS1HpId2tWdmZrY4ts2t00McShaL4d98gx+FgGXVmdyRAVAGN4FMa
 D03Lsgm9JlEk5nFvhSwRI+LpH+m+E=
X-Talos-CUID: =?us-ascii?q?9a23=3Ai7VogmiePn+ki0FWDxqseMfokzJuaSH8lif1eAi?=
 =?us-ascii?q?BVntNVJiIZXOA9PtljJ87?=
X-Talos-MUID: 9a23:UrIPnQb2AJOwBOBT9C3AqSBzOvlS8r32FGo2gNIooeWEKnkl
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,160,1774310400"; 
   d="scan'208";a="484172940"
Received: from rcdn-l-core-09.cisco.com ([173.37.255.146])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 21 May 2026 18:13:23 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.18.181])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-09.cisco.com (Postfix) with ESMTPSA id 9726C18000496;
	Thu, 21 May 2026 18:13:21 +0000 (GMT)
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
Subject: [PATCH 13/13] scsi: fnic: Bump up version number
Date: Thu, 21 May 2026 11:04:58 -0700
Message-ID: <20260521180458.5448-14-kartilak@cisco.com>
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
index 951549aff521..7a46b3ce0cb3 100644
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

