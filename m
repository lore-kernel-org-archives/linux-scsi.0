Received: from rcdn-iport-9.cisco.com (rcdn-iport-9.cisco.com [173.37.86.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C734D14386D;
	Thu, 12 Dec 2024 02:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733969714; cv=none; b=TO1uybmg+JX5dVDsculAONhuBymj0ZK0UCj0Y1lsyhonylX1L/mCiWZNwocqDeeuNtKMx6xHDPnFFjACfwXoOrcmeYJDbtD9doICRw0mWjPpstQVLZFI8emMu3sYcfR4wI1B1WEHRb9dhHZQTDuCQKKnH7O3IDGDjpXrwz+C4TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733969714; c=relaxed/simple;
	bh=/Y/rXtRwP0/LwMzfyr2SZak4DufdILTgKYodER6v1B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfKE6PHYkyh2NtybGFuRzYTe9LuuXfifoelwrjxnFu/Pw+X5gYCie0Kqn17jT6gEREBxF2zT0L8IPCTK0NGCGSJvR16Wjq+QTpgNN/o7MjgPjp/IRakJa7QPxf12ZBu31QMz/ZkXsq2PyCpnjikITVtfjmsjt8pMRJNo2McqoI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=BUU8SAGq; arc=none smtp.client-ip=173.37.86.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="BUU8SAGq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=797; q=dns/txt; s=iport;
  t=1733969712; x=1735179312;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9gLWcc+XkmMHqQ8fEUowMy0jDPvBaTR0cJITXDCSmpI=;
  b=BUU8SAGqw4S1N9jRstpMiZ9nNr6zWaDd53gAIrqPkR5qe+j2iQ23sMTe
   p4AMUJj5osa74I2JRw3FaAuZbxYtjlRyoj18kW9BxkRDy8Cr3V7FHa5Ve
   SuhJslJwMVeKL8lqgIjasSK9mAzhgzIa7sI29rDNeS75sY0Rpd7aNvtlq
   g=;
X-CSE-ConnectionGUID: iFGjiLepTIi4AyuYtzYHeg==
X-CSE-MsgGUID: 3JiwTVaRTtiFGR5ggjg3ug==
X-IPAS-Result: =?us-ascii?q?A0BeAACHRlpn/5T/Ja1aHQEBAQEJARIBBQUBggAHAQsBg?=
 =?us-ascii?q?kqBT0MZL7RegSUDVg8BAQEPRAQBAYUHAoprAiY1CA4BAgQBAQEBAwIDAQEBA?=
 =?us-ascii?q?QEBAQEBAQELAQEFAQEBAgEHBYEOE4YIhlsCAQMyAUYQUVYZgwGCZQOvFIIsg?=
 =?us-ascii?q?QHeM4FtgUgBjUlwhHcnFQaBSUSEfYFSgjiBBoV3BIUjg3mdAEiBIQNZIREBV?=
 =?us-ascii?q?RMNCgsHBYF1AzkMCzEVg2BGPYJJaUk3Ag0CNoIkfIJNhRmEaWMvAwMDA4M5h?=
 =?us-ascii?q?iSCGYFfQAMLGA1IESw3FBsGPm4Hm0tGg2GBDoJApW2hAoQkoUQaM6pRmHukR?=
 =?us-ascii?q?IRmgWgBOoFZMxoIGxWDIlIZD9JSJTI8AgcLAQEDCY9SgX0BAQ?=
IronPort-Data: A9a23:qJChKqi0vDb8sm1QqVjd3hoGX161cREKZh0ujC45NGQN5FlHY01je
 htvWWrTM/2IZWX9etFxOt+/9k0Fu8KAz9NrSAM5pC83ESNjpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+FH1dOCn9SQkvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZSFULOZ82QsaD5Nsfva8E4HUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqUZ1Ml1AEVD7
 cA5KWwkfw2ym/CH4L+0H7wEasQLdKEHPasFsX1miDWcBvE8TNWaGuPB5MRT23E7gcUm8fT2P
 pVCL2EwKk6dPlsWZgd/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9II3WGpUKxhfFz
 o7A1z/bAw4mCtWl9SaE3F2W2+DAnyygRY1HQdVU8dYv2jV/3Fc7ChAUX3O/oP+kmgi/UdcZI
 EsRkgIrpLIu9UrtVtThUgejrXisuQQVUN5dVeY97WmlzqvS/hbcBWUeSDNFQMIpudVwRjEw0
 FKN2dTzClRHtLyTVGLY7byPrBusNiUPa2wPfykJSU0C+daLnW0opgjEQtAmFOu+icf4XGiph
 TuLtyM5wb4UiKbnypmGwLwOuBr0zrChc+L/zly/sr6Nhu+hWLOYWg==
IronPort-HdrOrdr: A9a23:Xi4WfK6BqWNsG0PJbgPXwOfXdLJyesId70hD6qm+c3Bom6uj5q
 STdZsguyMc5Ax6ZJhko6HiBEDiewK4yXcW2+gs1N6ZNWGMhILrFvAB0WKI+VLd8kPFm9J15O
 NJb7V+BNrsDVJzkMr2pDWjH81I+qjhzEnRv4fjJ7MHd3ASV0mmhD0JbDqmLg==
X-Talos-CUID: 9a23:a1319myHGH/HZ9wA1fX2BgUVNO8nc1nQ1EvxIhORGHtYVK+kaVKfrfY=
X-Talos-MUID: 9a23:+hqs/AZmoKCCdeBT7B3tmw1cPf1U/6WAJ3pQnpoEtJKZOnkl
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.12,227,1728950400"; 
   d="scan'208";a="294787095"
Received: from rcdn-l-core-11.cisco.com ([173.37.255.148])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Dec 2024 02:15:11 +0000
Received: from fedora.cisco.com (unknown [10.24.83.168])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-11.cisco.com (Postfix) with ESMTPSA id AB97518000259;
	Thu, 12 Dec 2024 02:15:10 +0000 (GMT)
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
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v7 15/15] scsi: fnic: Increment driver version
Date: Wed, 11 Dec 2024 18:03:12 -0800
Message-ID: <20241212020312.4786-16-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241212020312.4786-1-kartilak@cisco.com>
References: <20241212020312.4786-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.24.83.168, [10.24.83.168]
X-Outbound-Node: rcdn-l-core-11.cisco.com

Increment driver version to 1.8.0.0

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fnic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index b9b0a4f0b78c..0feea9557934 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -30,7 +30,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.7.0.0"
+#define DRV_VERSION		"1.8.0.0"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
-- 
2.47.0

