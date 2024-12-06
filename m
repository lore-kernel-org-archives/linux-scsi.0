Received: from rcdn-iport-9.cisco.com (rcdn-iport-9.cisco.com [173.37.86.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A16204575;
	Fri,  6 Dec 2024 21:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733519998; cv=none; b=MQDwdBKM8I2b2yJy3eX8JIHEw7eQS6gcItaMQuNprZHHUsH/xeHFwgQRlDTy0yF7pzw7Zt3yw158D05XDiQgoCmsvLAv9G4OXPCe316mSoEVL6xTdfUsldWJW+qbeUUnGgoc4cK0ganQn2N+WZX1mJe0TfhSa9BZi3BiS5Y1PZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733519998; c=relaxed/simple;
	bh=/Y/rXtRwP0/LwMzfyr2SZak4DufdILTgKYodER6v1B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEhoWfglCOtCVxmo9VKRzJZy3zRUg5xucRL5jvmIA+/PyPkb4pdSGiuKYTNn7uEsNreOUIj+gk3Z5m+qgWc3GQbVtcZEklvG87RV0W4lVLE/bGDImcp2L4UK1YwiD+UczhBzcHgI9hqQWXx1Cga4ECUkd2vXwCdIX61P2cma9ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=WshI+dmD; arc=none smtp.client-ip=173.37.86.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="WshI+dmD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=797; q=dns/txt; s=iport;
  t=1733519996; x=1734729596;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9gLWcc+XkmMHqQ8fEUowMy0jDPvBaTR0cJITXDCSmpI=;
  b=WshI+dmDuA1dv/rherX3aaxRT5Vy6XIt4tsPBXi9DP8HG2Dlo36EpJ7z
   4GeVqlFjDvTIy4r+/6T3Bm9sG0f2A+a70ZP8N2V6llb5rhKYnxoxCzfC0
   hD0BB6VzwLt5xG9hllcKb1jbC/mk8U/ONMcwEyynJeLDJ1VBG9QgH6wEL
   g=;
X-CSE-ConnectionGUID: sq1HKQaITj+2wgj+zs7hrQ==
X-CSE-MsgGUID: hnxIaVW3RFGVPsktCwQYjw==
X-IPAS-Result: =?us-ascii?q?A0A5AADYaVNn/4//Ja1aHQEBAQEJARIBBQUBgX8IAQsBg?=
 =?us-ascii?q?kqBT0MZL4xyp2yBJQNWDwEBAQ9EBAEBhQcCimgCJjQJDgECBAEBAQEDAgMBA?=
 =?us-ascii?q?QEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThgiGWwIBAzIBRhBRVhmDAYJlA7F7g?=
 =?us-ascii?q?iyBAd4zgW2BSAGNSXCEdycVBoFJRIR9gVKCOIEGhXcEh04lhQaDep0dSIEhA?=
 =?us-ascii?q?1khEQFVEw0KCwcFgXYDgk16K4ELgRc6gX6BE0qFDEY9gkppSzcCDQI2giR9g?=
 =?us-ascii?q?k2FGYRpYy8DAwMDgzyGJYI0QAMLGA1IESw3FBsGPm4HoUZGg1mBDoJApWyhA?=
 =?us-ascii?q?YQkoUQaM6pRmHukRIRmgWc8gVkzGggbFYMiUhkP0GglMjwCBwsBAQMJkzyBf?=
 =?us-ascii?q?QEB?=
IronPort-Data: A9a23:tUlLAqlv0Tg0yhRap3B71zfo5gyQJ0RdPkR7XQ2eYbSJt1+Wr1Gzt
 xJNWWqHO/6PMWugc9hwYdjipBwC6pPVm9NiTQZk/Hg8E1tH+JHPbTi7wugcHM8zwunrFh8PA
 xA2M4GYRCwMZiaC4E/rav658CEUOZigHtLUEPTDNj16WThqQSIgjQMLs+Mii+aEu/Dha++2k
 Y20+pe31GONgWYubjtOs/zb83uDgdyr0N8mlg1mDRx0lAe2e0k9VPo3Oay3Jn3kdYhYdsbSb
 /rD1ryw4lTC9B4rDN6/+p6jGqHdauePVeQmoiM+t5mK2nCulARrukoIHKZ0hXNsttm8t4sZJ
 OOhGnCHYVxB0qXkwIzxWvTDes10FfUuFLTveRBTvSEPpqHLWyOE/hlgMK05FZYBo8ZUOGhvy
 f5bci8CbFORnL222ovuH4GAhux7RCXqFJkUtnclyXTSCuwrBMidBa7L/tRfmjw3g6iiH96HO
 JFfMmUpNkmdJUQTYT/7C7pm9Ausrnr2aSFZrFuWjaE2+GPUigd21dABNfKPK4baHJQMxRrwS
 mTu/2LpIxgkC4el5xW7ymmvmsTQpBL5R9dHfFG/3rsw6LGJ/UQRBR8cfV+6p+SpzE+0XpRUL
 El80i8nt7Qz8gqzQ8XwRQa1plaDpBcXX9cWGOo/gCmJy6zJ80OaC3ICQzppdtMrrok1SCYs2
 1vPmMnmbRRrsbuIWTeG/ayVhS29NDJTLmIYYyIACwwf7LHeTJoblBnDSJNnVaWylNCwQW+2y
 DGRpy94jLIW5SIW65iGEZn8q2rEjvD0osQdvG07gkrNAttFWbOY
IronPort-HdrOrdr: A9a23:Oc5acakNh9x/dpb7D2VLRm/A90HpDfID3DAbv31ZSRFFG/FwWf
 rDoB19726RtN9/Yh8dcLy7UpVoBEmslqKdgrNhWItKPjOGhILAFugLhrcKgQeQeREWndQz6U
 4PScVDIey1JURmjMr8/QmzG8stzZ266qyy7N2uqEuFNTsLV0mlhD0Jczpy1SZNNW97OaY=
X-Talos-CUID: =?us-ascii?q?9a23=3AHX+pe2iRku/04HY8pO0NSfbPNDJuaWSE7FTpKm6?=
 =?us-ascii?q?ECyUzV7KXCk2Lp6N+qp87?=
X-Talos-MUID: 9a23:Bxmc2AbfRUUQnOBTtzn8pThcC5xSzYuQMFsOjb4ZgviGKnkl
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.12,214,1728950400"; 
   d="scan'208";a="292819134"
Received: from rcdn-l-core-06.cisco.com ([173.37.255.143])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 06 Dec 2024 21:19:55 +0000
Received: from fedora.cisco.com (unknown [10.24.83.168])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-06.cisco.com (Postfix) with ESMTPSA id 6507618000264;
	Fri,  6 Dec 2024 21:19:54 +0000 (GMT)
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
Subject: [PATCH v6 15/15] scsi: fnic: Increment driver version
Date: Fri,  6 Dec 2024 13:08:52 -0800
Message-ID: <20241206210852.3251-16-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241206210852.3251-1-kartilak@cisco.com>
References: <20241206210852.3251-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.24.83.168, [10.24.83.168]
X-Outbound-Node: rcdn-l-core-06.cisco.com

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

