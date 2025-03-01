Received: from alln-iport-4.cisco.com (alln-iport-4.cisco.com [173.37.142.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75C1182D7;
	Sat,  1 Mar 2025 01:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740793053; cv=none; b=CqIqTHTA7fMXIELZUhku51gj1Lccr9qMeA0NawSdxfkK0rQ+zcMJTmlCI9pVrwkyjGZQr/i6t9VTyoub2wxCarWYI3ExqMY5Vh4TAWQgJouOxWrRoCtwX0Rih9YwjylfwIxT677MXTRj13whpuN2CJoxpFxiFZCM/c0kA3Hq9G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740793053; c=relaxed/simple;
	bh=/mVb1cWmahOS0hdzk0lGF9RbsSLIIt2giyY6mwneQAw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O52CG54y05ePCh00i5tzkjCUmj6X/CzZ8jzIvWHXzp0KBXC6HoSetWTu5Veq813Umsdzx+x2mqj1V3RyIS/Sn9LlD/EcKgqBh7Mi7CgwesLKJrE1xeMSe64Jt7ftL6jPsjfTe99RmqTfdtdshCrv7Pgd+aht8VyoyPwWyuxMDG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=hJTPRl2T; arc=none smtp.client-ip=173.37.142.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="hJTPRl2T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2219; q=dns/txt;
  s=iport01; t=1740793051; x=1742002651;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3MonZo2jXloOtsIh/XS4/JCVgUFE8L/wLWsGXbbJe80=;
  b=hJTPRl2T0yS93PBlexISXZw0UA52s/2Rr/70fcn5E8cAgGXFy2GZivRm
   L4qWLw3hfvWEPL+4MefBfBo6h40XpWhf36rGc60+5uDzPjcVeH3cg1pmI
   nT5denCjfIGfap/HZzjTWejNMZuz63fsjrfP8J9GM3cMcVT5Ex40s0MVs
   GwieM5wt5ZjcFnj51teCjCfYPgXj112WgmoIg3Fn91ZQNGBTZbogKipq+
   5aOI4AR620PufuCqcaj5v/BXmlTSB6mWHou3lgWAMAAp7GzfqiPONwRbw
   BmcuVzhPi0Ny6FdgDCIbdjGmPCuxIKCC8e0jtNhNeOafOzpTOudWmdYlt
   A==;
X-CSE-ConnectionGUID: HQQu1CCeRtOrcrLvWmUdVA==
X-CSE-MsgGUID: Di+iL8DbTZC+tfWpAyJIpQ==
X-IPAS-Result: =?us-ascii?q?A0AFAAC3Y8Jn/4//Ja1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBgX8FAQEBAQsBgkqBT0MZL4xyp2qBJQNWDwEBAQ9EBAEBhQeLF?=
 =?us-ascii?q?gImNAkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGCIZdK?=
 =?us-ascii?q?wsBRoFQgwKCZQOvD4F5M4EB3jSBboFIAY1KcIR3JxUGgUlEhH2BUoM+hXcEh?=
 =?us-ascii?q?1aoYUiBIQNZLAFVEw0KCwcFgXEDNQwLLhWBRkM3gkVpSToCDQI1gh58giuEV?=
 =?us-ascii?q?IRDhECFUoIRizeFBkADCxgNSBEsNxQbBj5uB6B7PIQ9gQ4UgiwpOqUToQaEJ?=
 =?us-ascii?q?aFIGjOqVi6YT6kxgWc8gVkzGggbFYMiUhkPji0WzAolMjwCBwsBAQMJkWUBA?=
 =?us-ascii?q?Q?=
IronPort-Data: A9a23:d+fhyKgjvJVwGGoVshRJ5uKeX161SxEKZh0ujC45NGQN5FlHY01je
 htvW2DXOP2KYmv9etBxbNmw8xgPvp+Ex4BhTABqqC1kEXxjpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+FH1dOCn9SQkvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZSEULOZ82QsaD9MsPra8EoHUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqU4w99qWEpl+
 MYEDyoGdDSduOeLzIySH7wEasQLdKEHPasFsX1miDWcBvE8TNWbHePB5MRT23E7gcUm8fT2P
 pVCL2EwKk6dPlsWZgx/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9JofVH5wLwR/Jz
 o7A10j4QRA+ZPCV9QiusW6iuffmjAHaQLtHQdVU8dYv2jV/3Fc7BBQQE1Cyu+G0jFKzQfpbK
 kod4C1oqrI9nGSpQ9v3dxm5pmOU+B8WXpxbFOhSwASE0LbV5UCBC3QJVCVMbvQhrsY9QTFs3
 ViM9/vtBDpyoPiWRGib+7O8szy/I24WIHUEaCtCShEKi/HnoYcunlfURc1iOLC6g8ezGjzqx
 T2O6i8kiN0uYdUjza63+xXDxjmrvJWMFlBz7QTMVWXj5QR8DGK4W7GVBZHgxa4oBO6kopOp5
 RDoR+D2ADgyMKyw
IronPort-HdrOrdr: A9a23:cygtsqEdFPuAOGf6pLqE28eALOsnbusQ8zAXPo5KJSC9Ffbo9f
 xG88506faZslwssRIb6LO90cu7IE80nKQdieIs1NyZMzUO1lHEEKhSqaP/3jztHDD//OZB2a
 olT7JzE7TLfD1HZL7BgDVR170bsb66GGfCv5a780tQ
X-Talos-CUID: 9a23:oSrr826zahtUFhzzINss1HctB5kOWXDn0FDKKFWcF1lsdbGrYArF
X-Talos-MUID: 9a23:pGbF+ApELj0pgfTZz+Eezx1jd8ZMs4ikNHIm0okIhNGtJA5RIw7I2Q==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.13,324,1732579200"; 
   d="scan'208";a="437216719"
Received: from rcdn-l-core-06.cisco.com ([173.37.255.143])
  by alln-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 01 Mar 2025 01:37:24 +0000
Received: from fedora.cisco.com (unknown [10.188.102.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-06.cisco.com (Postfix) with ESMTPSA id 29DBA18000256;
	Sat,  1 Mar 2025 01:37:23 +0000 (GMT)
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
Subject: [PATCH v2 1/2] scsi: fnic: Replace fnic->lock_flags with local flags
Date: Fri, 28 Feb 2025 17:37:11 -0800
Message-ID: <20250301013712.3115-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.102.227, [10.188.102.227]
X-Outbound-Node: rcdn-l-core-06.cisco.com

Replace fnic->lock_flags with local variable for usage with spinlocks
in fdls_schedule_oxid_free_retry_work.

Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: a63e78eb2b0f ("scsi: fnic: Add support for fabric based solicited requests and responses")
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fdls_disc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 3a41e92d5fd6..8843d9486dbb 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -308,23 +308,24 @@ void fdls_schedule_oxid_free_retry_work(struct work_struct *work)
 	struct fnic *fnic = iport->fnic;
 	struct reclaim_entry_s *reclaim_entry;
 	unsigned long delay_j = msecs_to_jiffies(OXID_RECLAIM_TOV(iport));
+	unsigned long flags;
 	int idx;
 
-	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
 
 	for_each_set_bit(idx, oxid_pool->pending_schedule_free, FNIC_OXID_POOL_SZ) {
 
 		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			"Schedule oxid free. oxid idx: %d\n", idx);
 
-		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		reclaim_entry = kzalloc(sizeof(*reclaim_entry), GFP_KERNEL);
-		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+		spin_lock_irqsave(&fnic->fnic_lock, flags);
 
 		if (!reclaim_entry) {
 			schedule_delayed_work(&oxid_pool->schedule_oxid_free_retry,
 				msecs_to_jiffies(SCHEDULE_OXID_FREE_RETRY_TIME));
-			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 			return;
 		}
 
@@ -339,7 +340,7 @@ void fdls_schedule_oxid_free_retry_work(struct work_struct *work)
 		}
 	}
 
-	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 }
 
 static bool fdls_is_oxid_fabric_req(uint16_t oxid)
-- 
2.47.1

