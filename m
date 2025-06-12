Received: from rcdn-iport-9.cisco.com (rcdn-iport-9.cisco.com [173.37.86.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7516BA34;
	Thu, 12 Jun 2025 00:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749687840; cv=none; b=K/Kn68bP1c2w9IJy0/yjCzCWHbrHAxHdIvCqTyPCnbYScb3sqMyqoiOJwUA15OgNP01Q9F45cVOQLSjjs6OZzncQ23nCgq1mCVmfVnDc528ShqEdzMc/CU9C5CznJusd1bQt7ijeVzGvl8xnbW4oLXzIR/g4NVvtxCCrRO280t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749687840; c=relaxed/simple;
	bh=HJNEdZGMyAB+jvPWThGDKzErCxKPoTotS0aGlSIzRWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIrlQsScALPFx76YpQHOS5a3KHei+pIg6gUVKg0Ap/FZYwVLNPPRuiJIhp0dbyHXjT/gve4o3IgmF1uBHm/2kJgDLbnfGfwhZJ6Gc8JyHWUjTGi/nZp6jauTPH1+MLcIa9fw724XjLEO4Smy5kKy5mbuYQ/uolVop+2pk+Bfo38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=df8Xc2Zy; arc=none smtp.client-ip=173.37.86.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="df8Xc2Zy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1367; q=dns/txt;
  s=iport01; t=1749687838; x=1750897438;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4Fp/Xv35+vz9iU9LyAJK+CcZDXYVsSMGlKnoyXRKYiw=;
  b=df8Xc2ZyPThIQmppBRo5fjU2zioHopOF+md4iBUxVvx5HTQRb0diLVu5
   A+qsSQaijaZm0AkKY/ckb8VMJB3Rha7Vx43WeTJs26awOAV73kd66eura
   Pt7+CIqu8Bj0h+vxDLsRnMpFC9qZOOAa8xeVH1rEzjzMuqtyei07PjK9Z
   mLJfKMh6DWmiac6Uo0irDABqfZOq/7X4llPgltacdE4XeKwZkyRAqXrfC
   DdKecUPmH9eJG1x6IcoOyIrUREkj9Ohp/MEaSLgx3uVE5SWH2dnE8/2CB
   MyvK0o5CQVvFouQzjWq3CG3M/J6Bk4ocigumSJEGwdIQq4CrK7WESX8Lu
   w==;
X-CSE-ConnectionGUID: NRA5Z6eWRn+diPAjR6q9pQ==
X-CSE-MsgGUID: 4eYbmi+AStioACR7PysDqQ==
X-IPAS-Result: =?us-ascii?q?A0ANAACTHUpo/5IQJK1aGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAYF/BgEBAQsBgkqBUkMZMIxwhzSgOoElA1cPAQEBD1EEAQGFBwKLZgImN?=
 =?us-ascii?q?AkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGCIZbAgEDJ?=
 =?us-ascii?q?wsBRhBRVhmDAoJvA7ATgXkzgQHeN4FugUkBjUxwhHcnFQaBSUSBFYJ5b4FSg?=
 =?us-ascii?q?z6FdwSDOqEeSIEeA1ksAVUTDQoLBwWBYwM1DAsuFW4yHYINhRmCEosHhEkrT?=
 =?us-ascii?q?4UhhQUkcg8HSkADCxgNSBEsNxQbBj5uB5gLg3CBDnyBRCmlV6ELhCWhUxozq?=
 =?us-ascii?q?mGZBKk4gWg8gVkzGggbFYMiUhkPji0Wu1UmMjwCBwsBAQMJkhQBAQ?=
IronPort-Data: A9a23:m9voDaAQkxvayRVW/8Piw5YqxClBgxIJ4kV8jS/XYbTApDol0WMCz
 mJMXGHTbqyOMGT8Ld5yOoy/8hsCvJKEy9BnOVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4eGdIZuCCaF/H9BC5C5xVFkz6aEW7HgP+DNPyF1VGdMRTwo4f5Zs7ZRbrVA357gXWthh
 fuo+5eCYAH8gmYvWo4pw/vrRC1H7ayaVAww5jTSVdgT1HfCmn8cCo4oJK3ZBxPQXolOE+emc
 P3Ixbe/83mx109F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq+kTe5p0G2M80Mi+7vdkmc+dZk
 72hvbToIesg0zaldO41C3G0GAkmVUFKFSOuzXWX6aSuI0P6n3TE5c9HUXNoMLIi/KV7AFln9
 8ZGMWEVV0XW7w626OrTpuhEj8AnKozveYgYoHwllWCfBvc9SpeFSKLPjTNa9G5v3YYVQ7CHO
 YxANWQHgBfoO3WjPn8UAYgineOhhVH0ciZTrxSeoq9fD237l1whjuSxYYGOEjCMbZlYr0ydp
 yHvxHj4BTgxDoOn2CGp60v504cjmgu+Aur+DoaQ+vdsxlaa3HQeDgEbT3O/oP+wkEn4XMhQQ
 2QW9ygkhawz8lG7CNj3Wluzp3vslhsVQcZRFasi5R2A0LHZ5S6eHGEPSjMHY9sj3Oc0QDEs2
 1CJnvvzCDBvuaHTQnWYnp+OoC2/IzM9N2IOZSYYCwAC5rHLpIA1kwKKTdt5FqOxpsP6FCu2w
 D2QqiU6wbIJgqYj06S94ECCmDm3p7DXQQMvoAbaRGSo6kV+foHNT5e04FLf4N5eI4uDCFqMp
 n4Jn46Z9u9mMH2WvCWJRONIGPSi4OyIdWWNx1VuBJImsT+q/hZPYLxt3d23H28xWu5sRNMjS
 BWM4mu9OLc70KOWUJJK
IronPort-HdrOrdr: A9a23:5yP1lKy5Uuq9owLjgbTrKrPwA71zdoMgy1knxilNoNJuHvBw8P
 re+MjzuiWbtN98YhsdcJW7Scq9qBDnhPtICOsqXItKNTOO0ACVxcNZnOnfKlbbdBEWmNQx6Y
 5QN4BjFdz9CkV7h87m7AT9L8wt27C8gceVbJ/lr0uEiWpRGthdB8ATMHf8LnFL
X-Talos-CUID: 9a23:Lafy127ReqjV6MzJg9ss0nQ9R/J7f0LnyjTcIneRC1w3UeyNcArF
X-Talos-MUID: 9a23:Z4osIwgJHcqs9l36WKMvUMMpaMpZ6aGvS2k2jZQBkuK+ahRhIBuEtWHi
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,229,1744070400"; 
   d="scan'208";a="388644933"
Received: from alln-l-core-09.cisco.com ([173.36.16.146])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2025 00:23:44 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-09.cisco.com (Postfix) with ESMTPSA id 7491C1800023E;
	Thu, 12 Jun 2025 00:23:42 +0000 (GMT)
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
	stable@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v2 4/5] scsi: fnic: Turn off FDMI ACTIVE flags on link down
Date: Wed, 11 Jun 2025 17:22:11 -0700
Message-ID: <20250612002212.4144-4-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250612002212.4144-1-kartilak@cisco.com>
References: <20250612002212.4144-1-kartilak@cisco.com>
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

