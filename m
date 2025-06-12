Received: from rcdn-iport-6.cisco.com (rcdn-iport-6.cisco.com [173.37.86.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEE8522F;
	Thu, 12 Jun 2025 22:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749766795; cv=none; b=D7KoiDhZ2QLzoMM71BfgnFPKPcU9awnv+LcZ9noiqECqneiTnzJlSj5azJ8XuqDMa8SNoUtaXfngHdYXSjz5aHoI7ISRfEDJ60ClupbYOEwKrf1MuV+2ulhRZyQ8w8igvghpbiEEg9ofTVidNlkoEwR/RUfkDodf178SFgzhsT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749766795; c=relaxed/simple;
	bh=VF6dgA8PUluVs8ZETgx38AO4rpz46KSCJwyvC/T+z7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYky5Ug6v440yiDO9zIDuvaH3W8SOAKpcENFzJvL9eyHAHYuKrcNibC5WpA0Iisk5NsM+iDuAGCKPFyGSKxHK1lrL1yb7UERLl1QJ9Pv+LO0lHos5lD4h4+Nm7yFoKU1QpdSynu/cy+cdAwH7O6ckBtnrcYkjxy9HHwQ9w1p788=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=JvDcJYfy; arc=none smtp.client-ip=173.37.86.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="JvDcJYfy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1687; q=dns/txt;
  s=iport01; t=1749766794; x=1750976394;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uNiuCMRk8oRhq5D+rETvdReJllmt9JDTe094QIpWu9w=;
  b=JvDcJYfypMaxpAI9/0eX1FKoByuu5sdRv5elC0fH6afOWD4qiOA3Orsk
   ISr+oSIBDnw11e6yrnMgR9m6wDYuE/yW8t4H/232fXDRTyA2ntO9IYoHC
   1vMMPGMyYCsAsLk4XgcHQiU6B2Kre3jK8O4y2X4uPeh6kCp8ahqav7r4h
   OiybjhqAPUbe1tIdO9HYCC51MqUIIV3nyLzSPwlIVP+giWXChc5q08R2M
   Mz/IwhMhi7TyPglFPgYIXio02JVxozLKX7ddHQClNFVKb9r/FggPlCMzy
   fW2vM/iFZ4s2ybHZHpMYZBXo0A3h/LivgCgTM6cCUFtww/T+GY91sm+07
   A==;
X-CSE-ConnectionGUID: XDrJ7GfgRk6E9jsS/Ry2VQ==
X-CSE-MsgGUID: lmGaW74EQm24ptdCgkEirg==
X-IPAS-Result: =?us-ascii?q?A0ANAAAxUUto/5MQJK1aGwEBAgIBAQUBARQBAQMDAQGCA?=
 =?us-ascii?q?AYBAQwBgkqBUkMZMIxwhzSCIZ4ZgSUDVw8BAQEPUQQBAYUHAotmAiY0CQ4BA?=
 =?us-ascii?q?gQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE4YIhlsCAQMnCwFGE?=
 =?us-ascii?q?FFWGYMCgm8DsASBeTOBAd43gW6BSQGNTHCEdycVBoFJRIEVgnlvgVKDPoV3B?=
 =?us-ascii?q?IM6lTOLa0iBHgNZLAFVEw0KCwcFgWMDNQwLLhVuMh2CDYUZghKLCIRJK0+FI?=
 =?us-ascii?q?YUHJHIPBkdAAwsYDUgRLDcUGwY+bgeYCYNwgQ58gS0WASmlV6ELhCWhUxozq?=
 =?us-ascii?q?mGZBKk4gWg8gVkzGggbFYMiUhkPji0Wu1UmMjwCBwsBAQMJkXIBAQ?=
IronPort-Data: A9a23:p8IUAagNDNlQCbcq068o8WyDX161iBEKZh0ujC45NGQN5FlHY01je
 htvCGCBPKyCNmX0KtonaoqzpksP6MXSyodqSQFkrCwzECpjpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+FH1dOKn9CAmvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZSBULOZ82QsaD9MtfvZ8EkHUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqUo1vxVXk5A+
 sYbdh1cbAu4wNinmoyCH7wEasQLdKEHPasWvnVmiDWcBvE8TNWaG+PB5MRT23E7gcUm8fT2P
 pVCL2ExKk2eJUQTZT/7C7pm9Ausrnr2aSFZrFuWjaE2+GPUigd21dABNfKOK4TWGZgFzhvwS
 mTu+2HWCy5FaPGmzGDZ6m6greDMsCLhV9dHfFG/3rsw6LGJ/UQfARtQXlKhufS/lkOkc9ZeL
 UUO/Wwpt6da3E6mTNPVWxy+vW7CvxQZHdFXFoUS7QiX1qvSpR6UGmUeVTNHQNs8vcQySHoh0
 Vrht9HsCDpiv72UYWiQ+redsXW5Pi19BXUPeyIeViMf7tXjqZ11hRXKJv5nEaionpj2FCv2z
 jSisicznfMQgNQN2qH9+krI6xqop57UXksu7R7Wdnyq4xk/Z4O/YYGsr1/B4p5oN5qQRF2Ml
 GYLltLY7+0UC5yJ0iuXT40w8KqB7vKBNnjYxFVoBZRkrmzr8H+4docW6zZ7TKt0Dvs5lfbSS
 Be7kWtsCFV7ZhNGsYcfj1qNNvkX
IronPort-HdrOrdr: A9a23:tzQmlKChuvoykG/lHemD55DYdb4zR+YMi2TDGXocdfUzSL39qy
 nAppomPHPP4gr5HUtQ+uxoW5PwJE80l6QV3WB5B97LNzUO+lHYTr2KhrGM/9SPIUDD398Y/b
 t8cqR4Fd37BUV3gILH+gWieuxQp+VviJrJuQ8bpE0dND2DrMpbnmFENjo=
X-Talos-CUID: =?us-ascii?q?9a23=3Arcy3r2ucDB+wqEhK2VuZf/qn6IsVXmf/k1jeLHW?=
 =?us-ascii?q?7V0s4SqauDmWBop1dxp8=3D?=
X-Talos-MUID: 9a23:WxjzKQnJGLlFv5Ujr0vndnpmMehh3PvyJXkIy8kep8WvOi9dOi2S2WE=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,231,1744070400"; 
   d="scan'208";a="390445885"
Received: from alln-l-core-10.cisco.com ([173.36.16.147])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2025 22:19:47 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-10.cisco.com (Postfix) with ESMTPSA id B0AC81800015F;
	Thu, 12 Jun 2025 22:19:45 +0000 (GMT)
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
Subject: [PATCH v4 4/5] scsi: fnic: Turn off FDMI ACTIVE flags on link down
Date: Thu, 12 Jun 2025 15:18:04 -0700
Message-ID: <20250612221805.4066-4-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250612221805.4066-1-kartilak@cisco.com>
References: <20250612221805.4066-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.19.134, [10.188.19.134]
X-Outbound-Node: alln-l-core-10.cisco.com

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

