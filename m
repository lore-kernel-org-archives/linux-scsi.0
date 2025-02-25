Received: from alln-iport-3.cisco.com (alln-iport-3.cisco.com [173.37.142.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4436118DB2F;
	Tue, 25 Feb 2025 21:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740520293; cv=none; b=VHXGJ9PyCHrA7IqE/nWg6uxcDgxoyr9zYkCR78/1bpu52fchRaP+v5RVqbbEBypW6UFLh41kexNlajFlY9UrdCYGQYQsdoN+kmrfppDT2/XZ0j80l832yM1WcbuKckuNaUyMcDy6AGwVh9f24y8dTzlyR67NfMTYCZuSHjohV3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740520293; c=relaxed/simple;
	bh=7/xCv1/7Haop1b40vC/JDguGB7gj5YCCvcvYP6M2M7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ow1ICh/IaCKdlqcfSZPcZeZxcOLpizKAqJOy5oBJxZyzQItK3D6iIlF/+WfxJ08suuG0bqLAQDVgl3VIvunIz/b3IvcknJZ8pxMM6rjvOlzjM5nnnn8xKdNN/hORpzUVTGERtxczy1rpeZxCMFir7kqZMCTvA++hc5XPOVPQXyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=L4ecaHT+; arc=none smtp.client-ip=173.37.142.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="L4ecaHT+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=3274; q=dns/txt;
  s=iport01; t=1740520291; x=1741729891;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TNWF9S256sBAe2tm2aB8JzFaSq3gIXtgS5ymhM8fb8g=;
  b=L4ecaHT+88qO0oRZm8UdTmt/qKg6sdNWk1zWP8EFk6D9+eT/tmL2G62+
   iMlhBOQ5GRW1viWgi6U24eR+A/wu7puYte9Lw4DS2GYSxxn//XUZ35cBT
   uWV7p8pP8D6DtWnUtpQThkph9B+/qtjldpvctzroqfMTlyLuAzGdbZUdx
   C1q379F4NHxUPG4XcpWodsasVjfcemxx6bAnb7FFvRdQdFUT0O0Q58sNE
   63SKhk2TlR5zBFlraI0oIvsoL7bQ0qBG0T2Yuj2/6b4hCBZFZ/j617RLk
   Y+fEXC+evJQOxJriSlA1lpgzr06xjx2NFRRGaAjQAcMeFGCbYVqDXKa5D
   g==;
X-CSE-ConnectionGUID: hCzfemStR46H8SKw3x2UTQ==
X-CSE-MsgGUID: QnLfUzl3R9yyscJ8q1qcrA==
X-IPAS-Result: =?us-ascii?q?A0AnAAAsOr5n/5X/Ja1aHAEBAQEBAQcBARIBAQQEAQGBf?=
 =?us-ascii?q?wcBAQsBgkp2WUMZLwSMbocygiGeF4ElA1YPAQEBDzkLBAEBhQeLEwImNAkOA?=
 =?us-ascii?q?QIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOFew2GXSsLAUaBU?=
 =?us-ascii?q?IMCAYJkAxGvHYF5M4EB3jSBaAaBSAGNSoVnJxUGgUlEgRWBO4E+b4FSiTUEh?=
 =?us-ascii?q?BuDQI0cmk5IgSEDWSwBVRMNCgsHBYFxAzUMCy4VMoEUeoJFaUk6Ag0CNYIef?=
 =?us-ascii?q?IIrhFSEQ4RBhVKCEYs9hApAAwsYDUgRLDcUGwY+bgegKgE8hDwBLGEUGBeBZ?=
 =?us-ascii?q?hceCzqSb5IioQSEJYwYlTAaM6pUAZh9jgWbK4FnPIFZMxoIGxWDIhM/GQ+OL?=
 =?us-ascii?q?RaIa8ZTJTICATkCBwsBAQMJj2otgU4BAQ?=
IronPort-Data: A9a23:tBJb/ayoCudnuzRdxh56t+cPxyrEfRIJ4+MujC+fZmUNrF6WrkVWx
 2IeD22Ab6mJN2CkfI8iPIzl8E8PvpGAxoJnSAY5pFhgHilAwSbn6Xt1DatR0we6dJCroJdPt
 p1GAjX4BJlqCCea/lH1b+CJQUBUjcmgXqD7BPPPJhd/TAplTDZJoR94kobVuKYw6TSCK13L4
 IiaT/H3Ygf/hmYuaD9MscpvlTs21BjMkGJA1rABTagjUG/2zxE9EJ8ZLKetGHr0KqE8NvK6X
 evK0Iai9Wrf+Ro3Yvv9+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+vpT2M4nVKtio27hc+adZ
 zl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CCe5xWuTpfi/xlhJEEdL4MV/91rOz0Q1
 awjCy9Wfkq+u9vjldpXSsE07igiBNPgMIVavjRryivUSK98B5vCWK7No9Rf2V/chOgXQq2YP
 JVfM2cyKk2cMnWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZCxbYCFJ4PQFZU9ckCwn
 2Ti8VnrBkogZc2O0jGnomv1n+TVtHauMG4VPPjinhJwu3WXxXQ7CRsKWF/9qv684mayUtQZI
 EUO4icosaUo3EiqSNDnWFu/unHslhwRWdB4F+w89RHLy6DRpQ2eAwAsSzdbdN0g8tc7WTEwz
 VKPt9TzDDdrvfueTnf13rOVqy6ifCsYN2kPYQcaQgYfpdruuoc+ilTIVNkLOKq0iMDlXCr72
 DGisicznfMQgNQN2qH9+krI6w9AvbDTRQIzowGSVWW/40YgPsiuZpej7h7Q6vMowJulc2Rtd
 UMsw6C2hN3ix7nU/MBRaI3hxI2U2ss=
IronPort-HdrOrdr: A9a23:gV5OMKulbkiDGZMIeuSo8B6H7skDRdV00zEX/kB9WHVpmwKj+/
 xG+85rtyMc5wx+ZJhNo7q90cq7MBDhHPxOgLX5VI3KNGLbUQCTQ72Kg7GO/xTQXwXj6+9Q0r
 pheaBiBNC1MUJ3lq/BkWyF+q4boOVuNMuT9IDjJ7AHd3APV51d
X-Talos-CUID: 9a23:v8I/7m9kZ1LCQ+KuqP6Vv04/CM4od0bB9iuOAx+DKnkyWOeodWbFrQ==
X-Talos-MUID: =?us-ascii?q?9a23=3AzZgAsg7slQW2LXP5t8gZy9OlxoxR5YCgNVIJyq9?=
 =?us-ascii?q?XqtifPg4gIm6Ehy6eF9o=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.13,314,1732579200"; 
   d="scan'208";a="452857288"
Received: from rcdn-l-core-12.cisco.com ([173.37.255.149])
  by alln-iport-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 25 Feb 2025 21:50:22 +0000
Received: from fedora.cisco.com (unknown [10.188.0.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-12.cisco.com (Postfix) with ESMTPSA id B8725180001CE;
	Tue, 25 Feb 2025 21:50:20 +0000 (GMT)
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
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] scsi: fnic: Fix indentation and remove unnecessary parenthesis
Date: Tue, 25 Feb 2025 13:50:13 -0800
Message-ID: <20250225215013.4875-1-kartilak@cisco.com>
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
X-Outbound-Node: rcdn-l-core-12.cisco.com

Fix indentation in fdls_disc.c to fix kernel test robot warnings.
Remove unnecessary parentheses to fix checkpatch check.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202502141403.1PcpwyJp-lkp@intel.com/
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202502141403.1PcpwyJp-lkp@intel.com/
Fixes: a63e78eb2b0f ("scsi: fnic: Add support for fabric based solicited requests and responses")
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fdls_disc.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index d12caede8919..ff9ba7cafc01 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -318,8 +318,8 @@ void fdls_schedule_oxid_free_retry_work(struct work_struct *work)
 			"Schedule oxid free. oxid idx: %d\n", idx);
 
 		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-	reclaim_entry = (struct reclaim_entry_s *)
-	kzalloc(sizeof(struct reclaim_entry_s), GFP_KERNEL);
+		reclaim_entry = (struct reclaim_entry_s *)
+						kzalloc(sizeof(struct reclaim_entry_s), GFP_KERNEL);
 		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 
 		if (!reclaim_entry) {
@@ -338,7 +338,7 @@ void fdls_schedule_oxid_free_retry_work(struct work_struct *work)
 			/* unlikely scenario, free the allocated memory and continue */
 			kfree(reclaim_entry);
 		}
-}
+	}
 
 	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 }
@@ -1563,9 +1563,9 @@ void fdls_send_fabric_logo(struct fnic_iport_s *iport)
 
 	iport->fabric.flags &= ~FNIC_FDLS_FABRIC_ABORT_ISSUED;
 
-		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-		 "0x%x: FDLS send fabric LOGO with oxid: 0x%x",
-		 iport->fcid, oxid);
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+		     "0x%x: FDLS send fabric LOGO with oxid: 0x%x",
+		     iport->fcid, oxid);
 
 	fnic_send_fcoe_frame(iport, frame, frame_size);
 
@@ -4655,13 +4655,13 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 	d_id = ntoh24(fchdr->fh_d_id);
 
 	/* some common validation */
-		if (fdls_get_state(fabric) > FDLS_STATE_FABRIC_FLOGI) {
-			if ((iport->fcid != d_id) || (!FNIC_FC_FRAME_CS_CTL(fchdr))) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-							 "invalid frame received. Dropping frame");
-				return -1;
-			}
+	if (fdls_get_state(fabric) > FDLS_STATE_FABRIC_FLOGI) {
+		if (iport->fcid != d_id || (!FNIC_FC_FRAME_CS_CTL(fchdr))) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+				     "invalid frame received. Dropping frame");
+			return -1;
 		}
+	}
 
 	/*  BLS ABTS response */
 	if ((fchdr->fh_r_ctl == FC_RCTL_BA_ACC)
@@ -4678,7 +4678,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 					"Received unexpected ABTS RSP(oxid:0x%x) from 0x%x. Dropping frame",
 					oxid, s_id);
 				return -1;
-	}
+		}
 			return FNIC_FABRIC_BLS_ABTS_RSP;
 		} else if (fdls_is_oxid_fdmi_req(oxid)) {
 			return FNIC_FDMI_BLS_ABTS_RSP;
-- 
2.47.1

