Received: from alln-iport-4.cisco.com (alln-iport-4.cisco.com [173.37.142.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD7220FA9B;
	Tue, 25 Feb 2025 21:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740520237; cv=none; b=taFn15Mx00+7dJ+CFy1gkkSxJDjb7/hYpuJHrlwBWRJnoBagfCzKNR/f5LpyGrfcpDxhdC0Ej7Lj0DyJrkQywBFIArYpkp9CHMY2KJgsb6cKoQAzoLMlIVaidXVhoC2zME0nft3NB1P1y7Bb/NmeKJzSCVPDpFZV6IF2UKohbsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740520237; c=relaxed/simple;
	bh=61eRLfzkeOT4cwIJywlG14ubKbKYoTuqOm41LBTPC6A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XuHJx9fB+X7lCrPJuVBmOYQpN9gMomMoRw/wqxd2eC1Lgh0WdBJ004ahu7Q0hftB/rezIR3kGOiGIjmokVAe9AHFA+cjbtuJ81lUOvZzjx+JiSuwb/ak3I0oHKGYVKXqohPZ7O+9/xd61nNryQtlDaY7yVImNK9dDTaArLBHc9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=kUXOiQmX; arc=none smtp.client-ip=173.37.142.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="kUXOiQmX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1393; q=dns/txt;
  s=iport01; t=1740520235; x=1741729835;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TJI27iPCQCtdchCr+f5UDcsFLCcsL5i//ZRP8RzItJs=;
  b=kUXOiQmXEl8VbOsNFR3oZ4oIhtjQej5dlRwu1ykRAmdED3EyyA7NZ7Ic
   SynZ8fp98DcunV4F7Himwx0vlamI0Exw0Cm6Eajp2AmJn/VuMe1TiZ1d+
   E0K3FeZ53cv/FhxsnnlI9Ru4GbrK7IzP+JJxauEyPUTrHi4wHhktOVEka
   zEq8hJfbp6+PDvOVpfYckRrsSHZacEweCzLsdTL9SNgv3qu/woSArqF/U
   +FBHx/CK3Sqk28zrvmEkiofgZya1U68hYUOD+njBUrBCCNpskcdmAOscm
   2UiXa0BSbXr9bE8UvzC4IFm22X4qRhFKrQSHge7QMcOQgFP90dXeTolBI
   w==;
X-CSE-ConnectionGUID: oNQN7ZJLR4ee+v2NgrQTnw==
X-CSE-MsgGUID: W1DmnZWmS/K8b8fOPdO+tQ==
X-IPAS-Result: =?us-ascii?q?A0AUAAAsOr5n/5H/Ja1aGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAYIABQEBAQsBgkqBT0MZL7RcgSUDVg8BAQEPRAQBAYUHixMCJjUIDgECB?=
 =?us-ascii?q?AEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThgiGXSsLAUaBUIMCg?=
 =?us-ascii?q?mUDry6BeTOBAd40gW6BSAGNSoVnJxUGgUlEhH2BUoM+hXcEgi+FLKdqSIEhA?=
 =?us-ascii?q?1ksAVUTDQoLBwWBcQM1DAsuFYFGeoJFaUk6Ag0CNYIefIIrhFSEQ4RBhVKCE?=
 =?us-ascii?q?Ys9hApAAwsYDUgRLDcUGwY+bgegKzyEPIEOgikXKTqSXpIzgTWfT4QloUgaM?=
 =?us-ascii?q?6pUAZh9qTCBaAE6gVkzGggbFYMiUhkPji0Wzz4lMjwCBwsBAQMJkWUBAQ?=
IronPort-Data: A9a23:sJInEqtW151Rwsk4g4/KStMpJOfnVH1fMUV32f8akzHdYApBsoF/q
 tZmKT3TOfyKN2KkfYp1YYq19hlS75fSy99hTQNqri5gQiJDgMeUXt7xwmUckM+xwmwvaGo9s
 q3yv/GZdJhcokf0/0nrav656yEhjclkf5KkYMbcICd9WAR4fykojBNnioYRj5Vh6TSDK1vlV
 eja/YuGYzdJ5xYuajhJs/jZ9Us11BjPkGpwUmIWNKgjUGD2zxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0NS+7vw60c+VZk
 72hg3AfpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn3bEm51T4E8K0YIw/cBOJz581
 9gidD0ALQ7Zoe2s+Y69Vbw57igjBJGD0II3oHpsy3TdSP0hW52GG/WM7t5D1zB2jcdLdRrcT
 5NGMnw0M1KaPkAJYwtKYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUoDRGJoLwh7I+
 Qoq+UzGWz0fMu6gzAHC0SKm1uHopS/cG54rQejQGvlCxQf7KnYoIBEfUx2wqOOhh0iiVsh3L
 00S8zAp668o+ySDTNT/VTW8oXiZrlgdUd8WGOo/gCmIw7DI4gDfHmUYQyRaZdoOs9U/Tjgnk
 FSOmrvBAT1pra3QSn+H8LqQhS29NDJTLmIYYyIACwwf7LHLpIA1kwKKVd14EYargdDvXzL92
 TaHqG45nbp7sCIQ/7+w8VaCh3enoYLEC1ZloA7WRWmiqAh+YeZJerCV1LQS1t4YRK7xc7VLl
 CFsdxS2hAzWMaywqQ==
IronPort-HdrOrdr: A9a23:Jei/NKxBQMERaw20hvQzKrPwH71zdoMgy1knxilNoNJuHvBw8P
 re/sjzuiWbtN98YhsdcLO7Scq9qBHnlKKdiLN5VdyftWLd11dAQrsO0aLShxX9Bizz8fNc36
 98f6U7NMf9FjFB/KPHCXGDc+rJBLK8gceVbSC09QYIcT1X
X-Talos-CUID: =?us-ascii?q?9a23=3AeUUc3Guvc85krjet6oEJRSy16IsiVET7k0XyB3X?=
 =?us-ascii?q?kBGsqVuezRkWpxKV7xp8=3D?=
X-Talos-MUID: 9a23:XSPcHgqMY+7reoFNw2gezw47GMJu0ZurMwcuwZ9Wte68OQszJw7I2Q==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.13,314,1732579200"; 
   d="scan'208";a="435764087"
Received: from rcdn-l-core-08.cisco.com ([173.37.255.145])
  by alln-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 25 Feb 2025 21:49:26 +0000
Received: from fedora.cisco.com (unknown [10.188.0.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-08.cisco.com (Postfix) with ESMTPSA id E5A8C180001E8;
	Tue, 25 Feb 2025 21:49:24 +0000 (GMT)
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
	Karan Tilak Kumar <kartilak@cisco.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] scsi: fnic: Remove unnecessary debug print
Date: Tue, 25 Feb 2025 13:49:09 -0800
Message-ID: <20250225214909.4853-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.0.187, [10.188.0.187]
X-Outbound-Node: rcdn-l-core-08.cisco.com

Remove unnecessary debug print from fdls_schedule_oxid_free_retry_work.
As suggested by Dan, this information is already present in
stack traces, and the kernel is not expected to fail small allocations.

Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: a63e78eb2b0f ("scsi: fnic: Add support for fabric based solicited requests and responses")
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fdls_disc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 11211c469583..d12caede8919 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -323,10 +323,6 @@ void fdls_schedule_oxid_free_retry_work(struct work_struct *work)
 		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 
 		if (!reclaim_entry) {
-			FNIC_FCS_DBG(KERN_WARNING, fnic->host, fnic->fnic_num,
-				"Failed to allocate memory for reclaim struct for oxid idx: 0x%x\n",
-				idx);
-
 			schedule_delayed_work(&oxid_pool->schedule_oxid_free_retry,
 				msecs_to_jiffies(SCHEDULE_OXID_FREE_RETRY_TIME));
 			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-- 
2.47.1

