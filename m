Received: from rcdn-iport-6.cisco.com (rcdn-iport-6.cisco.com [173.37.86.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332223B895D;
	Mon, 10 Aug 2026 11:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786360020; cv=none; b=p0LCwNLS4R3AdVdtCuZBO6blfC1DGuw6OVCQG0INHZ9z1ix0fSejfYwUAOUCB5LW/D1DqJnOOxf5m6DjbJY1YdILKZfhzKEAOk8Jjh7U0rXd6yaEawiqbji9TUsi+kxuVbOCMKa2p/fxnouHHYO/vMvZHwnTCSSi/UslBrrbr4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786360020; c=relaxed/simple;
	bh=GV4IuH6dMrXz0tbvrq32Kt5q89sSlgcInjt+3wuCwVM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YSOqJ129hMXTkMTSgCFkrb6eZN6VjAsJlbau0v77HxvUt6bKfk8loD6kirlXSB2EWHnHqZmrpqHNC+nVz6XRDK2E4yOTeuupti8r2ZKFDwsoz0Dyk16mEhDLn2rz0KuWBRo7uHnW6WgiHVhGVF2KX4XlrCx8P5EzQahaOdIxG/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=XYB4LEtA; arc=none smtp.client-ip=173.37.86.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="XYB4LEtA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2031; q=dns/txt;
  s=iport01; t=1786360019; x=1787569619;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=z5IQ2G1Nw+suY6yEwO2v6JUwi37yMsaZOTeab+pS14g=;
  b=XYB4LEtAjaDOuUhMSV5YAAilbegQMVeM8dlyvEjAHEFYRwCqJXKXJCE4
   muZC6qmXkVTlB0alvg6+zG1zS4JuIunxDHbyGqfEJdmj/wX9yeKFxkD35
   3k04DQHKO1xOrdSTpfBVhtu6KHU7atPbgr/rOMdYSK88IrUKhHs25gW8D
   XXBEbrNBoi3wCogvybER9hmeAqtTEQv7SXNuZmYLOss+3NyGxL3uIb0Gt
   X0mq14mDDKtYnwLbQZ8cO7PlLPcuJVxUuL8NqFVnKnOqYezg/bNyHPIfz
   OETKNDqHo2aZlOzbuWqkzgkt1mxE/4Yt/9Y2ZneotM0QCcYROaTAqoqaM
   A==;
X-CSE-ConnectionGUID: H8soe6MxRXaSwAzz93IKmQ==
X-CSE-MsgGUID: ezROvmIZRQyIVztSmWlX+Q==
X-IPAS-Result: =?us-ascii?q?A0BAAgBFsHlq/5T/Ja1aglmCV3ReQxkwBJQloD+Bfg8BA?=
 =?us-ascii?q?QEPRA0EAQGFBY1oAiY0CQ4BAgQDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFg?=
 =?us-ascii?q?Q4Thk8Nhl02AUaBUIMCAYJ0AxHFOYIsgQHeRoFmAQUGFAGBOI1ghXInFQaBS?=
 =?us-ascii?q?USEfoFSgz6FeASCIoEMkmNIgR4DWSwBVRMNCgsHBYFmAzUSKhVuMh2BIz4Xg?=
 =?us-ascii?q?Q0bBgWBHYEohGcjGTZ8gQlegSsqZAESF4EJgjQCgnaBLRULGA1IESw3FBkEP?=
 =?us-ascii?q?m4HjXQggkZaNStQgUSmDqEPhCiMIZU6GjOqawGZCI4KmzmBaDyBWTMaCBsVg?=
 =?us-ascii?q?yITQBkPji0WiHPHJicyAgE6AgcCBw4DC5NmAQE?=
IronPort-Data: A9a23:IyFmSaODZqEVNqbvrR1+lsFynXyQoLVcMsEvi/4bfWQNrUp20D0Dy
 zAXXWmHOv+OajDxKNlxO9jg/E0C6MXSndU3HnM5pCpnJ55oRWUpJjg4wmPYZX76whjrFRo/h
 ykmQoCeaphyFTmE+kvF3oHJ9RFUzbuPSqf3FNnKMyVwQR4MYCo6gHqPocZh6mJTqYb/WV7lV
 e/a+ZWFZgf1gmYsaQr41orawP9RlKWq0N8nlgRWicBj5Df2i3QTBZQDEqC9R1OQapVUBOOzW
 9HYx7i/+G7Dlz91Yj9yuu+mGqGiaue60Tmm0hK6aYD76vRxjnBaPpIACRYpQRw/ZwNlMDxG4
 I4lWZSYEW/FN0BX8QgXe0Ew/ypWZcWq9FJbSJSymZT78qHIT5fj69U+F0Y7Y6gIwNZ+On5n5
 +5JcxEuaynW0opawJrjIgVtrt4oIM+uOMYUvWttiGiAS/0nWpvEBa7N4Le03h9p2ZsIRqmYP
 ZdEL2MzPHwsYDUXUrsTIJE3hvupgnD8WzZZs1mS46Ew5gA/ySQsieizbYeFJITiqcN9k1Sig
 XzD3lbDOwA7Cs6D8j+69kLvv7qa9c/8cMdIfFGizdZug0W7x2oPBRlQXly+ydG8g1SiWtQZM
 0EI9zA1oK4a81aiRd3wGRa/pRastxIVWN1IFPAS8gyByqPIpQ2eAwAsTDtMbtEptM4eXzEm1
 laV2djuAFRHqrCLRGiG3q2ZoTO7JW4eKmpqTSsIUA0O6t/Lu5wog1TESdMLOKq0iMDlXDL92
 TaHqAAgiLgJy80GzaO2+RbAmT3EjpzISBMlox7cRWON8Ax0fsimapau5Fyd6uxPRLt1VXGbt
 3QC3szb5+cUANTUzWqGQf4GG/ei4PPt3CDgvGOD1qIJr1yFk0NPt6gKiN2iDC+F6vo5RAI=
IronPort-HdrOrdr: A9a23:vEWRMKoz1NuO9ll7zYKgbPIaV5r1eYIsimQD101hICG9vPb1qy
 nIpoV46faaslgssR0b8+xoW5PwIk80l6QV3WB5B97LNzUO01HGEGgN1+bf6gylMzHi9+JbyK
 dre7VzBZnNF1Rg5PyKhTVQa+xB/PC3tIa1mOzZ03BhCStua61m8kNFLzzzKDwTeOGDbqBJcq
 Z1IaF81l2dRUg=
X-Talos-CUID: =?us-ascii?q?9a23=3ADUN/zGuYxOWO2d5uKE1X7I4w6IsFImbawSn1M3W?=
 =?us-ascii?q?IAF12Ya+HGASx26Zdxp8=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3ArRK3NQ5j6WFhKBNJu7IxY6YCxoxl8Z6JFkUso68?=
 =?us-ascii?q?/qui6JzBLPgiZvHeOF9o=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,215,1779148800"; 
   d="scan'208";a="518655860"
Received: from rcdn-l-core-11.cisco.com ([173.37.255.148])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 10 Aug 2026 11:06:51 +0000
Received: from fedora.cisco.com (unknown [10.189.135.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-11.cisco.com (Postfix) with ESMTPSA id 15E6018000255;
	Mon, 10 Aug 2026 11:06:45 +0000 (GMT)
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	aeasi@cisco.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmeneghi@redhat.com,
	revers@redhat.com,
	adakopou@redhat.com,
	lduncan@suse.com,
	Karan Tilak Kumar <kartilak@cisco.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] scsi: fnic: Fix built-in NVMe/FC build
Date: Mon, 10 Aug 2026 04:06:27 -0700
Message-ID: <20260810110627.4521-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.189.135.132];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.189.135.132, [10.189.135.132]
X-Outbound-Node: rcdn-l-core-11.cisco.com

The fnic NVMe/FC code is guarded with IS_ENABLED(CONFIG_NVME_FC).
That also evaluates true when NVME_FC is built as a module.

When fnic is built into vmlinux and NVME_FC=m, fnic_nvme.o still
references the NVMe/FC transport helpers even though those helpers are
not reachable from built-in code. The final vmlinux link then fails with
undefined nvme_fc_* symbols.

Use IS_REACHABLE(CONFIG_NVME_FC) for the fnic NVMe/FC implementation and
prototypes so built-in fnic uses the disabled stubs unless the NVMe/FC
transport is reachable.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202608092246.XZe7Hlrt-lkp@intel.com/
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fnic_nvme.c | 2 +-
 drivers/scsi/fnic/fnic_nvme.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
index 8794360f2adf..b237948dcafd 100644
--- a/drivers/scsi/fnic/fnic_nvme.c
+++ b/drivers/scsi/fnic/fnic_nvme.c
@@ -22,7 +22,7 @@
 #include "fnic_trace.h"
 #include "fdls_fc.h"
 
-#if IS_ENABLED(CONFIG_NVME_FC)
+#if IS_REACHABLE(CONFIG_NVME_FC)
 
 static bool nvfnic_ls_req_cleanup(struct fnic_iport_s *iport,
 				  struct nvmefc_ls_req *lsreq,
diff --git a/drivers/scsi/fnic/fnic_nvme.h b/drivers/scsi/fnic/fnic_nvme.h
index 5e897908337c..c05908b68e36 100644
--- a/drivers/scsi/fnic/fnic_nvme.h
+++ b/drivers/scsi/fnic/fnic_nvme.h
@@ -61,7 +61,7 @@ struct nvfnic_ls_req {
 	unsigned int flags;
 };
 
-#if IS_ENABLED(CONFIG_NVME_FC)
+#if IS_REACHABLE(CONFIG_NVME_FC)
 int nvfnic_nvme_io_done_handler(void *arg);
 struct fnic_io_req *nvfnic_find_io_req_by_tag(struct fnic *fnic, uint16_t tag);
 void nvfnic_reset_fcpio_tag_pool(struct fnic_iport_s *iport);
-- 
2.47.1

