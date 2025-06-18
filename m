Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BE32F5319;
	Wed, 18 Jun 2025 00:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750206906; cv=none; b=EhmA/KcWu3JFJoOZML1RezCKP5fQy5X0YQM+M3YJNkHUYfUQx+1YOt8mKH24jsKdTub0Vq0gtDF6gEGUCsHpLhZmvEVq3Ok5c/HHelDkMwYwHNvW4dN5OAjsLodFxXu/VBf8/kKNLg6tRtA/7EvcgdZys/JrBK2HjYKboTIVpeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750206906; c=relaxed/simple;
	bh=zRFtJ/iao0Ech1UEoT6ezgdNxSGZ+XeOGviG4PJK89Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sq4JdqLeEE0uNNJh5Dc2o6HfrlbXGyGUfbntDtC99x7OCn0itT/wwm5FWQjAThf3UFFJBHb5VGovZ84NSea373SL2G7GqfkxzaryXdCItvy6ekthHLZraHQ584YPRzBlMgF5mWatSDdkelG7ob/YTTHPdlkXnEv9Zn7Th2BsfqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=G6FIr/Ee; arc=none smtp.client-ip=173.37.86.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="G6FIr/Ee"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2355; q=dns/txt;
  s=iport01; t=1750206904; x=1751416504;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7IsgDvvFymTOagzNvm3oHVT7O9uj4gRf7QPNS7LwD1M=;
  b=G6FIr/EexSA/YRqnvKmwSuYrNfALU+XgjS2fCwGVyAMxZQpzGZFfxdQv
   0WA9e7Sjulk+ShmI5s78YL1FZk9McVuwgm6mk/jDPTWgGhXcGe0uJHJXj
   SQm0z/HFeCybWsYEM958YEJ6ShlKtKGOYv9xmxwUizkQ8JvnPAw3JsWmj
   lb/ig6oOvbZ1V2tsEPKK91XYfdWso/JnapdZc+PoFekbYShVCsxDtafSr
   mqvDD899h1HXxpF/Et9D0ilzJ/AfIovZRfm2LhD9uB/ZlrGi1a4pGBVur
   SUD8yrFhbzmBAGzKPMAT7Y59rNkxbab20EN7mZh9NC1WZDLMEcw8+CJsK
   w==;
X-CSE-ConnectionGUID: JL9E1Ik4SrigdTvsTONciQ==
X-CSE-MsgGUID: yZGL27lCQNiRnXQ81z6JJw==
X-IPAS-Result: =?us-ascii?q?A0ANAACDCFJo/5AQJK1aGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAYF/BgEBAQsBgkqBUkMZMIxwhzSCIZ4ZgSUDVw8BAQEPUQQBAYUHAotmA?=
 =?us-ascii?q?iY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE4YIhlsCA?=
 =?us-ascii?q?QMnCwFGEFFWGYMCgm8DrwqBeTOBAd43gW6BSQGNTXCEdycVBoFJRIEVgnlvg?=
 =?us-ascii?q?VKDPoV3BIMmFJQ+dowUSIEeA1ksAVUTDQoLBwWBYwM1DAsuFW4yHYINhRmCE?=
 =?us-ascii?q?osFhEcrT4UhhQUkcQ8GgQtAAwsYDUgRLDcUGwY+bgeYMINygQ97NXgWASmlV?=
 =?us-ascii?q?6ELhCWhUxozqmGZBKk4gWg8gVkzGggbFYMiUhkPji0Wu1UmMjwCBwsBAQMJk?=
 =?us-ascii?q?gUBAQ?=
IronPort-Data: A9a23:SG+URqs8/MKNP00qnW6JXC/f2ufnVL5fMUV32f8akzHdYApBsoF/q
 tZmKWuPPfzeNmSneo9waYTgpElSucOBxtNhTgRrryk3F35AgMeUXt7xwmUckM+xwmwvaGo9s
 q3yv/GZdJhcokf0/0nrav676yAlj8lkf5KkYMbcICd9WAR4fykojBNnioYRj5Vh6TSDK1vlV
 eja/YuGZjdJ5xYuajhJs/za90s01BjPkGpwUmIWNKgjUGD2zxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0NS+7vw60c+VZk
 72hg3AfpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn3bEm51T4E8K0YIw2MImLDhv9
 qAjMjECYiydnN6R5rm6c7w57igjBJGD0II3s3Vky3TdSP0hW52GG/qM7t5D1zB2jcdLdRrcT
 5NGMnw0MlKZPVsWZgt/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9IYzSFJwExhbCz
 o7A13XLLTVAa9i08ByEyHScv7+Wj33Zep1HQdVU8dYv2jV/3Fc7BBQQE1Cyu+G0jFKzQfpbK
 kod4C1oqrI9nGSpQ9v3dxm5pmOU+B8WXpxbFOhSwASE0LbV5UCBC3QJVCVMbvQhrsY9QTFs3
 ViM9/vrADFpvbKVSFqH+7uUpC/0Mi8QRUcYaDEJVxAt+dTvoIgvyBnIS75LFK+zk82wGjzqx
 T2OhDYxiq9VjsMR0ai/u1fdjFqEopnPUx5w/Q7MX0q74Q5jIo2ofYql7R7c9/koBJ2FR1OFs
 VAalMWEquMDF5eAkGqKWuplIV2yz/+BNDuZhRtkGIMssmzyvXWiZotXpjp5IS+FL/o5RNMgW
 2eL0Ss52XOZFCbCgXNfC25pN/kX8A==
IronPort-HdrOrdr: A9a23:spjtBKgt6XaFrDZBzhWjg31ucHBQXvUji2hC6mlwRA09TyVXra
 yTdZMgpHvJYVkqNk3I9errBEDEewK+yXcX2/h1AV7BZmjbUQKTRekI0WKh+UyDJ8SUzIFgPM
 lbHpRWOZnZEUV6gcHm4AOxDtoshOWc/LvAv5a4854Ud2FXg2UK1XYBNu5deXcGIjV7OQ==
X-Talos-CUID: 9a23:nxX8FW4iY/VNpQ6eGtss1mpFN5kEcSHm1nbfL3OmElpObraUcArF
X-Talos-MUID: =?us-ascii?q?9a23=3AFRgpQw0pcMtXadsvtHyQPqJ8qjUj8paBLBpSlb4?=
 =?us-ascii?q?/nci+MxxJa26P0haVXdpy?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,244,1744070400"; 
   d="scan'208";a="380919082"
Received: from alln-l-core-07.cisco.com ([173.36.16.144])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 18 Jun 2025 00:35:03 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.123.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-07.cisco.com (Postfix) with ESMTPSA id BAEAA18000340;
	Wed, 18 Jun 2025 00:35:01 +0000 (GMT)
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
Subject: [PATCH v6 2/4] scsi: fnic: Turn off FDMI ACTIVE flags on link down
Date: Tue, 17 Jun 2025 17:34:29 -0700
Message-ID: <20250618003431.6314-2-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250618003431.6314-1-kartilak@cisco.com>
References: <20250618003431.6314-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.123.35, [10.188.123.35]
X-Outbound-Node: alln-l-core-07.cisco.com

When the link goes down and comes up, FDMI requests are not sent out
anymore.
Fix bug by turning off FNIC_FDMI_ACTIVE when the link goes down.

Fixes: 09c1e6ab4ab2 ("scsi: fnic: Add and integrate support for FDMI")
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
Changes between v5 and v6:
    - Incorporate review comments from John:
	- Rebase patches on 6.17/scsi-queue

Changes between v4 and v5:
    - Incorporate review comments from John:
	- Refactor patches
	- Increment driver version number

Changes between v3 and v4:
    - Incorporate review comments from Dan:
	- Remove comments from Cc tag

Changes between v2 and v3:
    - Incorporate review comments from Dan:
	- Add Cc to stable

Changes between v1 and v2:
    - Incorporate review comments from Dan:
	- Add Fixes tag
---
 drivers/scsi/fnic/fdls_disc.c | 9 ++++++---
 drivers/scsi/fnic/fnic.h      | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 36b498ad55b4..fa9cf0b37d72 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -5029,9 +5029,12 @@ void fnic_fdls_link_down(struct fnic_iport_s *iport)
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
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 86e293ce530d..c2fdc6553e62 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -30,7 +30,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.8.0.1"
+#define DRV_VERSION		"1.8.0.2"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
-- 
2.47.1

