Received: from rcdn-iport-4.cisco.com (rcdn-iport-4.cisco.com [173.37.86.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C71C301471;
	Wed, 24 Jun 2026 04:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782276696; cv=none; b=PsKF+kR+nsGn7YjBPMGLXKlwmd7/q6VVRpmYv5jr2SX4CxIGs6hngbdmHfn3obK6v2hZlO3qoiqsag0L2Jtr9irY80RxBMTOypjZLcn9luqpF8zuSLuQ8U3HS4l302v+IVvGcBOAAtrBKhOwORogL8k8DnXe+cKOWsU+fosZYec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782276696; c=relaxed/simple;
	bh=Arog+kvfMh8RyGwtKU7kx+RmmSzW4py/JBIggpynoqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFdvr+D8Pe1RrOg23f52cEFokTwDJ1ybuhG1y8HHLsrGqLGhzw9sgYH+wxTM6NqQwau9NxKVFxP9z+lk+/SFHXOKFbvrogND/Fh5m6EZPyGwa0bP2upJ12ZhpHClHGtSlv35LsupIUULEc4HqvB6Xz7N0m8SNrbmW/ugTIj9cJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=XBAZk7jV; arc=none smtp.client-ip=173.37.86.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="XBAZk7jV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=982; q=dns/txt;
  s=iport01; t=1782276695; x=1783486295;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mt6uMRIRiHCo3vDpzJgcvMQMx3xcfQiJ4o7/occv6wk=;
  b=XBAZk7jVkG5fsefc2clg0K8jCDC+wPrqTcUod5oZaUF0uGZ92kOoUrVd
   3+VSSrV9H+jqRAmNNr/sDc2tZo8aNCGIx17Pejq5OvFmKJFIFMvQTaEKB
   s0c7BKfdXHzdpOWeZmA/hA183BFXQCd3IABXPICkeYbEJ1KcdMxC8Nigy
   iEasBT/V3r8XZvzNk7yngIonQKorcDJr7BiVK1ohvu+FUApMfusaF/x9T
   5mMg2KgJGtR0uWaoUBVOZ/rGEOeIEq/6nLgWuufuzMf9e/nmeje+wnUpT
   R1FsDcw9PImNHjOjEdUQvGJth/j3hY3qv1fyXb/AHdvLIgEVqPrmOtbmJ
   w==;
X-CSE-ConnectionGUID: HZGYTWvoTb+oQUL2s0ZM8w==
X-CSE-MsgGUID: MrHPZXNBQ6aqjMLotGcYyQ==
X-IPAS-Result: =?us-ascii?q?A0BBAgCzYTtq/4//Ja1aHgEBCxIMggULgleBUkMZMJQqo?=
 =?us-ascii?q?D+Bfg8BAQEPUQQBAYUGAo1KAiY0CQ4BAgQDAgMBAQEBAQEBAQEBAQsBAQUBA?=
 =?us-ascii?q?QECAQcFgQ4ThlyGWwIBAzIBRhBRVhmDAoJ0A7IvgiyBAd5DgWYBCxQBgTiNX?=
 =?us-ascii?q?nSEfCcVBoFJRIR+gVKCOIEGhXgEgxwSkQJIgR4DWSwBVRMNCgsHBYFmAzUSK?=
 =?us-ascii?q?hVuMh2BIz4XgQwbBwWBHYFugQSFAiMfAzl/gT+BJGRmFTA1gQEBER8KgTUDC?=
 =?us-ascii?q?xgNSBEsNxQbBD5uB4xdFw+CPYEOgTGBD6YOoQ+EJ6FbGjOqbJkIqUKBaDyBW?=
 =?us-ascii?q?TMaCBsVgyJTGQ/gfScyPQIHAgcOAwuRaIF9AQE?=
IronPort-Data: A9a23:AiGSpKmuJ9fwmhyjBNTd+ELo5gxwJ0RdPkR7XQ2eYbSJt1+Wr1Gzt
 xJLXGuBP/eJNDH1ft8kb9u2/EIF75/Xzt9gSQA6+CgzRFtH+JHPbTi7wugcHM8zwunrFh8PA
 xA2M4GYRCwMZiaC4E/raf658SUUOZigHtLUEPTDNj16WThqQSIgjQMLs+Mii+aEu/Dha++2k
 Y20+ZG31GONgWYubDpKsfnb8nuDgdyr0N8mlg1mDRx0lAe2e0k9VPo3Oay3Jn3kdYhYdsbSb
 /rD1ryw4lTC9B4rDN6/+p6jGqHdauePVeQmoiM+t5mK2nCulARrukoIHKZ0hXNsttm8t4sZJ
 OOhGnCHYVxB0qXkwIzxWvTDes10FfUuFLTveRBTvSEPpqHLWyOE/hlgMK05Fa0q1ddLPn9Jy
 fZbLwkwSkqY39CTkK3uH4GAhux7RCXqFJkUtnclyXTSCuwrBMidBa7L/tRfmjw3g6iiH96HO
 JFfMmUpNkmdJUQTYT/7C7pm9Ausrnr2aSFZrFuWjaE2+GPUigd21dABNfKJK43RHpsEwRrwS
 mTu2n7ZOiMqEvamlzOc8FeIgfPglhLqYddHfFG/3rsw6LGJ/UQTAQcbfVi2u/+0jgi5Qd03A
 04Z+CAGqak06VztT9P4GRa/pRasuxcGR9tWVfU39AyX0afSywGDD2MAQ3hKb9lOnMY6TD8tz
 liUt8nkCTxmrPueTnf13rWRoDW/NigUBXUPaS8NUU0O5NyLiJs+kB/VVf55HaK1h8GzEjb1q
 xiOoDU4jLwVpdUWzKj99lfC6xqop57UXks26x/RU2aN8Ax0fsimapau5Fyd6uxPRK6dT1+cr
 D0fkNOfxP4BAIvLlyGXRugJWraz6J643Cb0m1VjGdwlsj+q4XPmJd4W6zBlL0AvOcEBEdP0X
 HLuVcpqzMc7FBOXgWVfOupd1+xCIXDcKOnY
IronPort-HdrOrdr: A9a23:ELOdFKE3QuTA/SkFpLqEIseALOsnbusQ8zAXPo5KJSC9Ffbo8/
 xG88506faZslwssTQb6LO90cq7MBbhHPxOgLX5VI3KNGLbUSmTXeNfBODZrAEIdReSysdtkY
 99bqlzD8DxB1Bmgcu/3BO1CL8bsb66GdiT5dv2/jNKURxgbb1m4kNSDwaWFVAzeSx9bKBJcq
 Z1IqF81kKdkbN9VLXDOkU4
X-Talos-CUID: =?us-ascii?q?9a23=3AVA5quWpk1ZSrelzK8fRxjPXmUeAXXUzh82nXH0X?=
 =?us-ascii?q?7Dl9UbOeOEW21qLwxxg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AoRwWfg4zhp+ltqK/kM3kNOCsxoxN+YSWOnAru6x?=
 =?us-ascii?q?YstCGEAh3JxiWvSWOF9o=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,221,1774310400"; 
   d="scan'208";a="499336974"
Received: from rcdn-l-core-06.cisco.com ([173.37.255.143])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jun 2026 04:51:32 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.122.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-06.cisco.com (Postfix) with ESMTPSA id 3F8AB18000277;
	Wed, 24 Jun 2026 04:51:31 +0000 (GMT)
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
Subject: [PATCH v5 13/13] scsi: fnic: Bump up version number
Date: Tue, 23 Jun 2026 21:43:34 -0700
Message-ID: <20260624044334.3079-14-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260624044334.3079-1-kartilak@cisco.com>
References: <20260624044334.3079-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.122.232];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.122.232, [10.188.122.232]
X-Outbound-Node: rcdn-l-core-06.cisco.com

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

