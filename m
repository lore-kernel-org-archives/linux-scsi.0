Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B702874ED;
	Mon, 16 Jun 2025 16:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750091232; cv=none; b=ivAlw5XsiUAYEYmoXxkZP49sGBtJZr+mhm5SDUDUPStDcDT9QRY7xitp+81iN5OaNEBot8og3JcWSxsXF85P43WyUq89TvJ4dhTeufwdRlh2egxIEXtIym72d5lCP/yUy6rCtKlujl3rf6sS14p+LXme64wydwoLhd0jZXMnB/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750091232; c=relaxed/simple;
	bh=DW0+h0UWS/Irhb2EAVUKA+dO+EBEWw8yU6Ds0ZFz+nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKH6g/VlBpwUGldMchkPTe8Jaj0iVyt6Ow2Ei/VfSGAvV7t1sZaVIwthGK7mkwMu9ngQkFwXH4/2VczCE4WNktNsEaDm6pUpqGltQDbPSNbUckAt/r8x51uAtLs21QX1tT+zs9QT8DPXnBnZgiQhq7n4JBZEbJbMVztLAOwWDbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=f0iy+wUh; arc=none smtp.client-ip=173.37.86.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="f0iy+wUh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2244; q=dns/txt;
  s=iport01; t=1750091230; x=1751300830;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YqODL3LXmwxnxActdJgMhQ4PbbcDeFUHmaJJHfZ370E=;
  b=f0iy+wUh/aI9iyhEisC3cDyWSCskqkC/FPrTKH3oo3DdUCwYugPf7rgD
   X9GUrii7xUKMYvaj+26OjWnOiRSO9GgOkYwh5n0Cin66fo3poZogEgEpb
   hwiReEKRby0Fa10NSiEXiz3+uRszLARWY2mevy+2nzuej0VgkMd2uhDep
   blAmM11kEyqDMgPATOrqcIanMHGF1QVFqp90AKFvON6CyFWJlkrAJeKPU
   cVqqFXPrTFSDwGYYWYDZfvD4q0DbOlPJSycogp47n5iX/krnC/XhwaQdm
   W94Ypo1PTBGI75b6h3Q9yP7GQ9FNT5uqzRFtgveJtDzaWgGtGemZnwqBQ
   g==;
X-CSE-ConnectionGUID: duDHG0QXRMeepINyvnsMCw==
X-CSE-MsgGUID: R3gFHtHWTmqHOcJMkrJwHA==
X-IPAS-Result: =?us-ascii?q?A0ANAAAYRVBo/5QQJK1aGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAYF/BgEBAQsBgkqBUkMZMIxwhzSCIZ4ZgSUDVw8BAQEPUQQBAYUHAotmA?=
 =?us-ascii?q?iY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE4YIhlsCA?=
 =?us-ascii?q?QMnCwFGEFFWGYMCgm8Dr3WBeTOBAd43gW6BSQGNTXCEdycVBoFJRIEVgnlvg?=
 =?us-ascii?q?VKDPoV3BIMmFJUzi3BIgR4DWSwBVRMNCgsHBYFjAzUMCy4VbjIdgg2FGYISi?=
 =?us-ascii?q?wiESStPhSGFBSRxDwZPQAMLGA1IESw3FBsGPm4HmAuDcoEPezV4FgEppVehC?=
 =?us-ascii?q?4QloVMaM6phmQSpOIFoPIFZMxoIGxWDIlIZD44tFrtTJjI8AgcLAQEDCZF8A?=
 =?us-ascii?q?QE?=
IronPort-Data: A9a23:g2ACvaCjrx5JfxVW/8Hiw5YqxClBgxIJ4kV8jS/XYbTApD4m0WAPm
 2YWUTvQbKmNNGf1fo0nPdzn8U8H7JfRmNBqOVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4eGdIZuCCaF/H9BC5C5xVFkz6aEW7HgP+DNPyF1VGdMRTwo4f5Zs7ZRbrVA357gXWthh
 fuo+5eCYAH8hWYuWo4pw/vrRC1H7ayaVAww5jTSVdgT1HfCmn8cCo4oJK3ZBxPQXolOE+emc
 P3Ixbe/83mx109F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq+kTe5p0G2M80Mi+7vdkmc+dZk
 72hvbToIesg0zaldO41C3G0GAkmVUFKFSOuzXWX6aSuI0P6n3TEz+hCLG5uBL0i3+t6GUBo5
 OIeMxUmcUXW7w626OrTpuhEj8AnKozveYgYoHwllGifBvc9SpeFSKLPjTNa9G5v3YYVQ7CHO
 YxANWoHgBfoO3WjPn8UAYgineOhhVH0ciZTrxSeoq9fD237l1Mgiee3bISOEjCMbf8OkWi4u
 kL5w2HgIjYRFvmc0xia0lv504cjmgu+Aur+DoaQ+vdsxlaa3HQeDgEbT3O/oP+wkEn4XMhQQ
 2QW9ygkhawz8lG7CNj3Wluzp3vslhsVQcZRFasi5R2A0LHZ5S6eHGEPSjMHY9sj3Oc0QDEs2
 1CJnvvzCDBvuaHTQnWYnp+OoC2/IzM9N2IOZSYYCwAC5rHLpIA1kwKKTdt5FqOxpsP6FCu2w
 D2QqiU6wbIJgqYj06S94ECCmDm3p7DXQQMvoAbaRGSo6kV+foHNT5e04FLf4N5eI4uDCFqMp
 n4Jn46Z9u9mMH2WvCWJRONIGPSi4OyIdWSFx1VuBJImsT+q/hZPYLxt3d23H28xWu5sRNMjS
 Ba7Vd95jHOLAEaXUA==
IronPort-HdrOrdr: A9a23:Xs8XMa4kwtcixeqh6APXwOfXdLJyesId70hD6qm+c3Bom6uj5q
 STdZsguyMc5Ax6ZJhko6HiBEDiewK4yXcW2+gs1N6ZNWGMhILrFvAB0WKI+VLd8kPFm9J15O
 NJb7V+BNrsDVJzkMr2pDWjH81I+qjhzEnRv4fjJ7MHd3ASV0mmhD0JbDqmLg==
X-Talos-CUID: 9a23:PudVXGCJuqOs7Gj6EyV62G47QvkVSFjQwW/xBV6mD31MY6LAHA==
X-Talos-MUID: 9a23:xN3E4QbhOMHti+BTjWTjqhF+FPhU5r2OL0svtJYcmdakHHkl
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,241,1744070400"; 
   d="scan'208";a="379172463"
Received: from alln-l-core-11.cisco.com ([173.36.16.148])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 16 Jun 2025 16:27:03 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-11.cisco.com (Postfix) with ESMTPSA id DFF9E180001E7;
	Mon, 16 Jun 2025 16:27:01 +0000 (GMT)
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
Subject: [PATCH v5 2/4] scsi: fnic: Turn off FDMI ACTIVE flags on link down
Date: Mon, 16 Jun 2025 09:26:30 -0700
Message-ID: <20250616162632.4835-2-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250616162632.4835-1-kartilak@cisco.com>
References: <20250616162632.4835-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.19.134, [10.188.19.134]
X-Outbound-Node: alln-l-core-11.cisco.com

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
index 0ee1b74967b9..146744ca97c2 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -5027,9 +5027,12 @@ void fnic_fdls_link_down(struct fnic_iport_s *iport)
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

