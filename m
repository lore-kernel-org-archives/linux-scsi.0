Received: from rcdn-iport-6.cisco.com (rcdn-iport-6.cisco.com [173.37.86.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD5E380;
	Wed, 11 Jun 2025 18:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749666818; cv=none; b=AE7hZHSk4CY3bbJAPeCUAJ3BNVmKGx1wP8BNaxU9yQb1+goQDiFOdyAkAG3pih2clP1FT/fjKpN11tTo81/RINQXwO4HjVq8SmylKBbK+kZ/NruqQLordqrCTapnHCrrJcZhlTtLrBvi38J5R4f6NC+XMHNKhpX1rD+/ZrPA5a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749666818; c=relaxed/simple;
	bh=W9TMtmNAQox4GJzmyGBKfQRvar8R3C9E12Rn9hMqO80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9ysmsWnEXBgnySLOpid7RJksaosotZBF5ZTCRdtVt9jcW8borQTMvB4R0mtyM4evxxKC/9aTHcrBiEZxqMmDxmJ1HpcyQorrFR0XVf7NPKJ01p7fWnDkvvZom+ZwYPE3SC849JtPULuAOCc1Yna+UAPQ3md+fqvV+BNmh1Kgkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=S21kekLs; arc=none smtp.client-ip=173.37.86.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="S21kekLs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=785; q=dns/txt;
  s=iport01; t=1749666816; x=1750876416;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vebaEpidSVTCWaBHFi0jPYyqh1hFt65CsSfk9PGHd6Y=;
  b=S21kekLsJMQQmQVdRDYd4XCIDqd19ELuDtThOM233ZZupA5YCrgmsMSn
   WlnqNwV/ECFJ91zaLA7vIJVFveqZB4+RYWXZ+4cHmfs7rHr8SNvaIs6ow
   xDGUEh2HGngXjKWbkWvhFPS4Cbg3J2Uie1C/bnDW8WNq6GN7Y6gPQ0jLM
   oWE/wnLvJVNtWfVzH6QoCvZkr+vl8gxh4QVNSwCFUIqSwo7Y0ce6yrfzU
   /ihEk6mPKw0+lpZNNAzoiySA3sOp5Zvw0PnooU/yEOfe2i+EzwweTlKrA
   2edV1nNYT2h0TA45iS3ApY2El98hBvSXhjp9qaHROk3fR8ffl7Tm5VT8N
   w==;
X-CSE-ConnectionGUID: IcWTMjmiTt6Boz6kLlXIrQ==
X-CSE-MsgGUID: bJkycYS0RuSt2/RuuRKzEg==
X-IPAS-Result: =?us-ascii?q?A0AEAABIy0lo/4sQJK1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBgX8FAQEBAQsBgkqBUkMZMIxwhzSgOoElA1cPAQEBD1EEAQGFB?=
 =?us-ascii?q?wKLZgImNAkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGC?=
 =?us-ascii?q?IZbAgEDMgFGEFFWGYMCgm8Dr3KCLIEB3jeBboFJAY1McIR3JxUGgUlEhH2BU?=
 =?us-ascii?q?oI4gQaFdwSCJIECFKEUSIEeA1ksAVUTDQoLBwWBYwM1DAsuFW4yHYINhRmCE?=
 =?us-ascii?q?osHhEkrT4UhhQUkcg8HPUADCxgNSBEsNxQbBj5uB5gEg3CBDoExgQ+mAKELh?=
 =?us-ascii?q?CWhUxozqmGZBKk4gWg8gVkzGggbFYMiUhkPyhgmMjwCBwsBAQMJkBeBfQEB?=
IronPort-Data: A9a23:cgRjfa2heyIA61YV8/bD5QNwkn2cJEfYwER7XKvMYLTBsI5bpzdRz
 TdMDGHXM6qLYGXzL99xYIvg9R8Eu5HUmNNhHQY63Hw8FHgiRegpqji6wuYcGwvIc6UvmWo+t
 512huHodZ5yFjmG4E70aNANlFEkvYmQXL3wFeXYDS54QA5gWU8JhAlq8wIDqtYAbeORXUXU5
 7sen+WFYAX4g2AtazpOg06+gEoHUMra6WtwUmMWPZinjHeG/1EJAZQWI72GLneQauF8Au6gS
 u/f+6qy92Xf8g1FIovNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ajs7XAMEhhXJ/0F1lqTzeJ
 OJl7vRcQS9xVkHFdX90vxNwS0mSNoUekFPLzOTWXcG7lyX7n3XQL/pGLUoJAaga/+dLHT9k8
 u5GKxQJXjGZvrfjqF67YrEEasULJc3vOsYb/3pn1zycVaxgSpHYSKKM7thdtNsyrpkRRrCFO
 YxAN3w2N0Wojx5nYj/7DLo9lf20h332cBVTqUmeouw85G27IAlZi+i8aICPJofTLSlTtky6p
 XPNzl+hOAwhKIbY8yeYyFG+q+CayEsXX6pXTtVU7MVCjFSVgGcaEgUbU0e2u9G9i0i3QdUZL
 FYbkgIsoKo43EiqSMTtGRyypTiPuRt0c99ZCfE77keVx7bZ+R2UAEADVDdKbNFgv8gzLRQo0
 1KPktzpBBR1vbGVQG7b/bCRxRuoNDYYN3QqfyIITQIZpdLkpekbihPJU8YmE6OviNDxMS//z
 irMryUkgbgXy8kR2M2T+VHBniLpvZPSTyYr6QjNGGGo9AV0YMiifYPA1LTAxf9EKIDcShyKu
 2IJ3pDEqusPFpqK0ieKRY3hAY2U2hpMCxWE6XYHInXr327FF6KLFWyI3AxDGQ==
IronPort-HdrOrdr: A9a23:UIEEFKgb1II/Pu3eB0X3c5TQO3BQXvUji2hC6mlwRA09TyVXra
 yTdZMgpHvJYVkqNk3I9errBEDEewK+yXcX2/h1AV7BZmjbUQKTRekI0WKh+UyDJ8SUzIFgPM
 lbHpRWOZnZEUV6gcHm4AOxDtoshOWc/LvAv5a4854Ud2FXg2UK1XYBNu5deXcGIjV7OQ==
X-Talos-CUID: 9a23:HoH4I235okWOMPvPLyoThLxfO8saTljfyXbsPxGSDnQ3S5mReX6KwfYx
X-Talos-MUID: 9a23:XpXraglFEd8jFEOtVKMDdnpoFsR56JWVUHoQqolc/POZKBZTKRqS2WE=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,228,1744070400"; 
   d="scan'208";a="389022431"
Received: from alln-l-core-02.cisco.com ([173.36.16.139])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 11 Jun 2025 18:32:24 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-02.cisco.com (Postfix) with ESMTPSA id D292818000151;
	Wed, 11 Jun 2025 18:32:22 +0000 (GMT)
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
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH 5/5] scsi: fnic: Increment driver version number
Date: Wed, 11 Jun 2025 11:30:33 -0700
Message-ID: <20250611183033.4205-5-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250611183033.4205-1-kartilak@cisco.com>
References: <20250611183033.4205-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.19.134, [10.188.19.134]
X-Outbound-Node: alln-l-core-02.cisco.com

Increment driver version number.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fnic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 6c5f6046b1f5..86e293ce530d 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -30,7 +30,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.8.0.0"
+#define DRV_VERSION		"1.8.0.1"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
-- 
2.47.1

