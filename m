Received: from alln-iport-4.cisco.com (alln-iport-4.cisco.com [173.37.142.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9A61E0DB0;
	Mon,  6 Jan 2025 22:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736203532; cv=none; b=pEXcyFpSK9Dlzzjagk/3+otzfxPuPYvZz5fov+MV4AgwYfbupO5VRtIw0qFyopecPzIJO3IK9D4qjZoaBZe2xCwpenI7qSqXHl2iVdmYQp4xS7HOzvKMUMdCkRUTug02+S+47zBDcHogkGahehjFouTUjd2WWYkLA9n9W3K7UUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736203532; c=relaxed/simple;
	bh=wmOknkTwJxOtqnsV1XMil+6bbgDzsn0IgQkxEtPtIdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlRGoFGaJzAOwwA2FAghhl5MW6ieTQZHgLygFqB1fl80PkHZf/gwuVXA7vvIqrPXbOZ1QPHGdFhv5NQUpFglsaEiHcIuiSJK3TA2LgIfShGGtorISVCYIKaGELwgI+5EyrF3o/fpB3KtP7VX/3aRE6HxL+zkD1sYGu2JiYyibJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=BnHy90r6; arc=none smtp.client-ip=173.37.142.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="BnHy90r6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1794; q=dns/txt; s=iport;
  t=1736203530; x=1737413130;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gx+Pb4z/q0lNaAccmsZd68iqZP2DGrLoqmDZ9ds2gJ8=;
  b=BnHy90r6zvZ8RwN3GKSBE1RMyqe6THJkPJBvMEGMM3SwNj+89V728Ybp
   TGzB3+YTm8MdkO5KCZ59PCCT/0G4b9znRImN2TcIPXDaO3oTXbnOg9hoa
   Yab/mp/Hua/4aiG5R8M2KCn4iFP3NQe9GMhjZCuGWlOnY6QNxB30f33yV
   I=;
X-CSE-ConnectionGUID: 6mufl0+PRpqrA0IKNhl8Wg==
X-CSE-MsgGUID: OG22L9ihTYORmhg9tpP2Ag==
X-IPAS-Result: =?us-ascii?q?A0AeAAAIXHxnj4r/Ja1aHAEBAQEBAQcBARIBAQQEAQGCA?=
 =?us-ascii?q?QUBAQsBhBlDGS+0XoElA1YPAQEBD0QEAQGFBwKKdAImNgcOAQIEAQEBAQMCA?=
 =?us-ascii?q?wEBAQEBAQEBAQEBCwEBBQEBAQIBBwUUAQEBAQEBOQVJhgiGWwIBAzIBRhBRV?=
 =?us-ascii?q?hmDAYJlA7BHgiyBAd4zgW2BSAGNSXCEdycVBoFJRIJQgT5vgVKDPoVVIgSHb?=
 =?us-ascii?q?J1wSIEhA1ksAVUTDQoLBwWBcwM4DAswFYFbRDmCRmlJNwINAjWCHnyCK4Rch?=
 =?us-ascii?q?EeEVoVmgheFAEADCxgNSBEsNxQbBj5uB5pkPINugQ+CKBYBpXChA4QloUYaM?=
 =?us-ascii?q?6pTmHykR4RmgW0BM4FbMxoIGxWDIlIZD44tDQm3UyUyPAIHCwEBAwmRdAEB?=
IronPort-Data: A9a23:GuWqhaj62czDbf3HtkfPMmrJX161qxAKZh0ujC45NGQN5FlHY01je
 htvUW2AbP2MZTGme4p0YYjkp0kO75eGyIJhSgI9qyoxFy5jpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+FH1dOCn9SQkvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZSFULOZ82QsaD9Msvrd8EkHUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqVG//t5BTkNz
 cYAMSokNjGgoeKykI20H7wEasQLdKEHPasFsX1miDWcBvE8TNWbGuPB5MRT23E7gcUm8fT2P
 pVCL2EwKk6dPlsWYQd/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9JoTaFJkLxBfCz
 o7A10PWWEs+Zd2f9QuiyHesib7ThRuhcY1HQdVU8dYx3QXMnTZMYPEMbnO5rPuzokq/Xc9Pb
 U0e/2wlqq1a3EmiVMX8WVugrWKJpAURXfJXCeQx7AzLwa3Riy6dB24ZXntCZcYgucseWzMnz
 BmKksnvCDgpt6eaIVqZ97GJvXapMjMUBXENaDVCTgYf5dTn5oYpgXryos1LCqW5iJjxXDr32
 T3P9HF4jLQIhslN3KK+lbzav96yjsbMUwAxvkbvZHq89CohRa2DZ4j41leOuJ6sM72lZlWGu
 XEFne2X4+YPEYyBmUSxrAMlQunBCxGtbmG0vLJ/I6TN4QhB7JJKQGyx3N2cDBo0WirnUWa1C
 KM2he+3zMQJVJdNRfQoC79d8+xwkcDd+S3ND5g4lOZmbJlrbxOg9ypzf0OW1G2FuBFzyv9mY
 c7KLZz3Uyly5UFbINyeGr11PVgDm3FW+I8vbcqgp/ha+ePEPSfLFedt3KWmMbBhsPnsTPrpH
 yZ3bJbSlE4FD4USkwHc8JUYKhgRPGMnCJXt481RfajrH+aVMD9JNhMl+pt4I9YNt/0Mzo/gp
 yjtMmcGkwCXrSOcdm23hoVLNOiHsWBX8SljZXRE0JfB8yRLXLtDG49GK8JoIuF8q7Q6pRO2J
 tFcE/i97j10Ymyv01wggVPV9eSOqDzDadqyAheY
IronPort-HdrOrdr: A9a23:LrQ18KAfoK0r2xPlHemD55DYdb4zR+YMi2TDGXocdfUzSL39qy
 nAppomPHPP4gr5HUtQ+uxoW5PwJE80l6QV3WB5B97LNzUO+lHYTr2KhrGM/9SPIUDD398Y/b
 t8cqR4Fd37BUV3gILH+gWieuxQp+VviJrJuQ8bpE0dND2DrMpbnmFENjo=
X-Talos-CUID: =?us-ascii?q?9a23=3Ae1EWlmnR31LcuySxn9t0iPF18EHXOSPY0XnUewy?=
 =?us-ascii?q?AM35wUpTNaHy2+Kc0rMU7zg=3D=3D?=
X-Talos-MUID: 9a23:BA3e7AR/OpzmoAk+RXTLq2s4EJZp45ifL3oIkZpXp9G8bwV/bmI=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.12,293,1728950400"; 
   d="scan'208";a="408946292"
Received: from rcdn-l-core-01.cisco.com ([173.37.255.138])
  by alln-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 06 Jan 2025 22:45:22 +0000
Received: from fedora.cisco.com (unknown [10.188.112.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-01.cisco.com (Postfix) with ESMTPSA id 7519518000299;
	Mon,  6 Jan 2025 22:45:21 +0000 (GMT)
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
Subject: [PATCH 2/3] scsi: fnic: Remove extern definition from .c files
Date: Mon,  6 Jan 2025 14:44:50 -0800
Message-ID: <20250106224451.3597-2-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106224451.3597-1-kartilak@cisco.com>
References: <20250106224451.3597-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.112.101, [10.188.112.101]
X-Outbound-Node: rcdn-l-core-01.cisco.com

Implement review comments from Martin:
    Remove extern definition of fnic_fip_queue from .c files

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fip.c      | 2 --
 drivers/scsi/fnic/fip.h      | 2 ++
 drivers/scsi/fnic/fnic_fcs.c | 1 -
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fip.c b/drivers/scsi/fnic/fip.c
index 161075e3bb95..aaf5f768a9bd 100644
--- a/drivers/scsi/fnic/fip.c
+++ b/drivers/scsi/fnic/fip.c
@@ -7,8 +7,6 @@
 #include "fip.h"
 #include <linux/etherdevice.h>
 
-extern struct workqueue_struct *fnic_fip_queue;
-
 #define FIP_FNIC_RESET_WAIT_COUNT 15
 
 /**
diff --git a/drivers/scsi/fnic/fip.h b/drivers/scsi/fnic/fip.h
index c62993c76dc7..79fee7628870 100644
--- a/drivers/scsi/fnic/fip.h
+++ b/drivers/scsi/fnic/fip.h
@@ -131,6 +131,8 @@ void fnic_fcoe_start_flogi(struct fnic *fnic);
 void fnic_fcoe_process_cvl(struct fnic *fnic, struct fip_header *fiph);
 void fnic_vlan_discovery_timeout(struct fnic *fnic);
 
+extern struct workqueue_struct *fnic_fip_queue;
+
 #ifdef FNIC_DEBUG
 static inline void
 fnic_debug_dump_fip_frame(struct fnic *fnic, struct ethhdr *eth,
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 471d4a7553bf..1e8cd64f9a5c 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -27,7 +27,6 @@
 
 #define MAX_RESET_WAIT_COUNT    64
 
-extern struct workqueue_struct *fnic_fip_queue;
 struct workqueue_struct *fnic_event_queue;
 
 static uint8_t FCOE_ALL_FCF_MAC[6] = FC_FCOE_FLOGI_MAC;
-- 
2.47.1

