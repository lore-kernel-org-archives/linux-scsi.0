Received: from rcdn-iport-5.cisco.com (rcdn-iport-5.cisco.com [173.37.86.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFDC2F531E;
	Wed, 18 Jun 2025 00:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750207003; cv=none; b=U1v//Q3iKOe4ZthqGlLO0bQwnqoAE00An37hw/FCw4NY61Ju1h24NaFmsy/4B0x0oNkrfB+fZLM3LACGgGF8CKkCWl6lTXdvBMlC+HvK8t73gMEXCbcqnMLfkURj/e/k3h9DYbViMWDbR/X24E5sMrIQJ62fvx16PDxhnqsGzl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750207003; c=relaxed/simple;
	bh=5BPzDXQtlINzJQyZYN1n3XYEDDr0DBFcFixTgAMjKMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmdZRc5CW44x5vvqL44KftDzyTIW0A/4TKMfg7CyGE2uGKq8rUdR0uv5ukznhjVu+4Gknt+pPhgDorzAUe8m/pPyQb8Yv+8MnUOPxaGZEV5ubnMMVBWud3DyUcdAd3WlsxNIkkNNdUyiiHF+R0uSd+P/bYgB7/YwL4vYBPwptkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=YgzpHLtK; arc=none smtp.client-ip=173.37.86.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="YgzpHLtK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1188; q=dns/txt;
  s=iport01; t=1750207001; x=1751416601;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Obd95QSroB3lWqCoq8Y1N/2bLgyv2RVWdsPuJdD9A5M=;
  b=YgzpHLtK93giDhkdti7UGnLNc1SP7qtuESpQ6/ePaNq5PcF5ndjaB/qY
   4H2YN9aflAQlbFab7dm983Hp4TmloD7GKhg+pkXcnGSsjumRkMSP+WSH7
   fuKehD3ACj2YvEQbT7CX+ZXRUgkJtjw6zXNcgI1G4fSTPc8gvz6tBSGtu
   YZ9VC+tb/FcuZi1Cfy0KF2OOxNNF+wooAai/BWoaRKJdIlBI/iP0KQUSc
   dAQSkYWBopOZCBQumX4x4IRKAMNUJLHPfN/CLre0M3Ph6gPKaUDsXSaoJ
   Nhpw+HIN+xvYfA2o1Do8VRZTmUoNHNwYj/PjmcHU153cbT0H9CFmzHS1j
   w==;
X-CSE-ConnectionGUID: Q8syrWiqTti7olyzxhVMNw==
X-CSE-MsgGUID: PDgCG/trTbmzuPhMwb8fFg==
X-IPAS-Result: =?us-ascii?q?A0ANAABpCVJo/5AQJK1aGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAYF/BgEBAQsBgkqBUkMZMIxwhzSgOoElA1cPAQEBD1EEAQGFBwKLZgImN?=
 =?us-ascii?q?AkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGCIZbAgEDJ?=
 =?us-ascii?q?wsBRhBRVhmDAoJvA68LgXkzgQHeN4FugUkBjU1whHcnFQaBSUSCUIE+b4FSg?=
 =?us-ascii?q?jiBBoV3BIMmFJQ+dowUSIEeA1ksAVUTDQoLBwWBYwM1DAsuFW4yHYINhRmCE?=
 =?us-ascii?q?oQphlyERytPhSGFBSRxDwaBC0ADCxgNSBEsNxQbBj5uB5gwg3KBDoECgT0Bp?=
 =?us-ascii?q?gChC4QloVMaM6phmQSpOIFoPIFZMxoIGxWDIlIZD44tFrtVJjI8AgcLAQEDC?=
 =?us-ascii?q?ZAIgX0BAQ?=
IronPort-Data: A9a23:35OlBqN+0TKM5HPvrR11lsFynXyQoLVcMsEvi/4bfWQNrUor32RWn
 TBMDWzSbKyDa2qhKI9yPYu1oxwDvMDUydNrTHM5pCpnJ55oRWUpJjg4wmPYZX76whjrFRo/h
 ykmQoCeaphyFDmF/03F3oHJ9RFUzbuPSqf3FNnKMyVwQR4MYCo6gHqPocZh6mJTqYb/Wl3lV
 e/a+ZWFZQf7gmEsaQr41orawP9RlKWq0N8nlgRWicBj5Df2i3QTBZQDEqC9R1OQapVUBOOzW
 9HYx7i/+G7Dlz91Yj9yuu+mGqGiaue60Tmm0hK6aYD76vRxjnBaPpIACRYpQRw/ZwNlMDxG4
 I4lWZSYEW/FN0BX8QgXe0Ew/ypWZcWq9FJbSJSymZT78qHIT5fj68w+F1AsAowBxvp2XmZK5
 O4IKA4oSA/W0opawJrjIgVtrs0nKM+uOMYUvWttiGmGS/0nWpvEBa7N4Le03h9p2ZsIRqiYP
 pRfMGYzBPjDS0Un1lM/C5skgOasj3rXeDxDo1XTrq0yi4TW5FcgjeSwYYeEJ7RmQ+1tskmzi
 SXa5VjzBwMHDNy61jDV/Fyj07qncSTTHdh6+KeD3vJjhhuYz3YLBRsKWEGTpfi/g1S5HdVFJ
 CQ8+Ccsp4A29Uq2Xp/8VRj+q3mB1jYZUsBMEut88AyRx7DP7gCxAXINRTpMLtchsaceRzkn0
 FKGn9LBHzFjsLSJD3ma89+8tz6sNDIOBXUPaS8NUU0O5NyLiIUyiA/fC9VuCqi4ivXrFjzqh
 TOHti4zg/MUl8Fj/6G6+03XximnvZnhUAE4/EPUU3ij4wc/Y5SqD7FE8nDS6fJGaYLcRV6bs
 T1cxI6V7fsFCteGkynlrPgxIYxFLs2taFX06WOD1bF9n9hx0xZPpbxt3Qw=
IronPort-HdrOrdr: A9a23:3wz5uat/oSQdXm/znAevcW2z7skDWdV00zEX/kB9WHVpmwKj+/
 xG+85rsSMc5wx+ZJhNo7q90ey7MBDhHP1OkOws1NWZPTUO0VHAROpfBMnZsl/d8kbFmdK1u5
 0MT4FOTPXtEFl3itv76gGkH9tl/MOK68mT9IDjJg9WLT2Dr8pbnn5E4sHxKDwReDV7
X-Talos-CUID: =?us-ascii?q?9a23=3A2vEUp2mMezyQbxq0wz+StUf4M4TXOUSN12bKHE6?=
 =?us-ascii?q?hNXpoF7qRWE2A+J1BtdU7zg=3D=3D?=
X-Talos-MUID: 9a23:j0NXggbmTcOdz+BTjxPjrx4lKN1U6aG8FXgNtIoM68eqOnkl
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,244,1744070400"; 
   d="scan'208";a="395459595"
Received: from alln-l-core-07.cisco.com ([173.36.16.144])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 18 Jun 2025 00:36:32 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.123.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-07.cisco.com (Postfix) with ESMTPSA id 593EE180001E1;
	Wed, 18 Jun 2025 00:36:31 +0000 (GMT)
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
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v6 4/4] scsi: fnic: Set appropriate logging level for log message
Date: Tue, 17 Jun 2025 17:34:31 -0700
Message-ID: <20250618003431.6314-4-kartilak@cisco.com>
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

Replace KERN_INFO with KERN_DEBUG for a log message.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
Changes between v5 and v6:
    - Incorporate review comments from John:
	- Rebase patches on 6.17/scsi-queue

Changes between v4 and v5:
    - Incorporate review comments from John:
	- Refactor patches
---
 drivers/scsi/fnic/fnic_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 7133b254cbe4..75b29a018d1f 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1046,7 +1046,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic, unsigned int cq_ind
 		if (icmnd_cmpl->scsi_status == SAM_STAT_TASK_SET_FULL)
 			atomic64_inc(&fnic_stats->misc_stats.queue_fulls);
 
-		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 				"xfer_len: %llu", xfer_len);
 		break;
 
-- 
2.47.1

