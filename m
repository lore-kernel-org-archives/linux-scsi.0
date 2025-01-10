Received: from alln-iport-6.cisco.com (alln-iport-6.cisco.com [173.37.142.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D16A20ADCF;
	Fri, 10 Jan 2025 09:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736500809; cv=none; b=FoIfzXqowwtRwlQm8kB8B1QF+zaUFYq4sVAuTxHf1y5GqDpXhdigFJOXrkB9KV7cy5zxCLT9pBb9LMzTDwBQgtuHOrZF/NGmOPIx6OvNJIrZXFX8icFMJs8rf7bnFrWn86FjdZ8r2/wqFmL+8fZ05d5Mk413z9S6vjMUR05guj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736500809; c=relaxed/simple;
	bh=bNa7YQeauaAsS/Lue2NDZ6h/nkc5tqYN1mD3eWYbk5k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QnMbG2z7i9EtevKUInu3UePFxnIURAKyPRqpNZshJol/csEq03vaLvoqKjqZGL/ONFZ0ihhpnYQHjOzvDSLi/bPGBrqZe06fY77D+TbRJaMCgJKfmg7QYKm/itmOqYOew/lAB+8YJGOZGWY3WtPDj9GFAvWPBjmDbkbXOpZDee8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=lz/ogmu6; arc=none smtp.client-ip=173.37.142.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="lz/ogmu6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1042; q=dns/txt; s=iport;
  t=1736500807; x=1737710407;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f/8f+tj2zX92XDvost4GnPugul88xhAEwbHZ/Y553R4=;
  b=lz/ogmu6T1oAOuOOwL3oPKJWnohbq8gUdi59/tmMrY3KvsPcVJpOWkrb
   iuoZHu0AS/PMpwIh/PG6ZF1odw1iRhucOuySTR1oG+Nti9ADLcL6aQ0kY
   b47NwdR45p5jz89ptkOe3HBoky1AsMyt+JeSOsA5pEYePnrX78uCb6R8b
   Y=;
X-CSE-ConnectionGUID: iqEWOrGCT82o2I57YO1krg==
X-CSE-MsgGUID: auXAOVj3Tn2RGnt01cdKBg==
X-IPAS-Result: =?us-ascii?q?A0ABAAA35YBnj4v/Ja1aGgEBAwMBAQMBARYBAQICAQGCA?=
 =?us-ascii?q?QUBAQ0BhBlDGS+vAYVdgSUDVg8BAQEPRAQBAYUHinYCJjQJDgECBAEBAQEDA?=
 =?us-ascii?q?gMBAQEBAQEBAQEBAQsBAQUBAQECAQcFFAEBAQEBATkFDjuGCIZdKwsBRjCBI?=
 =?us-ascii?q?IMBgmUDszaBeTOBAd4zgW2BSAGNSYVnJxUGgUlEhH2BUoI4gQaFdwSCM4F2g?=
 =?us-ascii?q?z+eSkiBIQNZLAFVEw0KCwcFgXMDOAwLMBU1gRp7gkZpSTcCDQI1gh58giuEX?=
 =?us-ascii?q?IRHhFaFZYIXhXhAAwsYDUgRLDcUGwY+bgebGzyDcHsTgkCTQJIwgTSfT4Qlo?=
 =?us-ascii?q?UYaM6pSAS6HZJBqqS2BZzqBWzMaCBsVgyJSGQ+OOrwfJTI8AgcLAQEDCY8hg?=
 =?us-ascii?q?X0BAQ?=
IronPort-Data: A9a23:1rzDL6pxB3KLIf2T4fnnTwJjK/5eBmL1ZRIvgKrLsJaIsI4StFCzt
 garIBmPaazbMGKmet0gaIux9hsH78KGmoAwQAVpryAwF3tBpePIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7zdOCn9T8kiPngqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYQXNNwJcaDpOtvra8Us35ZwehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86r5K255G7Q4yA2AdqjlLvhGmVSKlIFFVHT4pb+c/HKbilq/kTe4I5iXBYvQRs/ZwGyojxE4
 I4lWapc5useFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpfh660GMa04AWEX0uduLF5p7
 9MzFGBXaUqi2r2H5+u4UOY506zPLOGzVG8ekmtrwTecCbMtRorOBv2Qo9RZxzw3wMtJGJ4yZ
 eJANmEpN0uGOUASfA5MWfrSn8/w7pX7Wz5Rsk6UoaM0y2PS1wd2lrPqNbI5f/TWHJ0LxhfE9
 zmuE2LRCwwqHfuhy2G59CiWqenTxXrwVKE4G+jtnhJtqAbOnjNIUkJ+uUGAifWwjAi1UshHJ
 koI9zAGqak0/VasCN7nUHWQonOGtDYYWtxNA6s74gTLwa3Riy6cD3IYTzgHcNE6udUtSDoC0
 UWAlNfkQzdotdW9TXOb66fRrj6oPyURBXENaDVCTgYf5dTn5oYpgXrnStdlDb7wldbuGBnuz
 D2Q6isznbMeiYgMzarTwLzcqyinqp6MSks+4R/aGzr/qAh4f4WiIYev7DA38MqsMq6YV3S+m
 2IrsPTOtudULMzSpQvUQ/8CSeTBC+m+DBXQhltmHp8E/jur+mK+cY043N2YDBkyWirjUWGyC
 HI/qT9sCIlv0GxGhJKbgr5d6ex3lsAM9vy8Cpg4i+aihLAqK2drGwk1OiatM5jFyhRErE3GE
 c7znTyQJXgbE7976zG9Wv0Q17QmrghnmjiNGcykkkj7jeTODJJwdVvjGAbRBgzexP7VyDg5D
 /4FbaNmNj0GCrSnPHWHmWLtBQ9adSJgbXwJlyCnXrXeelU9Qj5J5w75yrI6cIsthLVOiurN5
 Tm8XEQeoGcTdlWZQThmnktLMeu1Nb4m9CpTFXV1YT6AhSN5Ca7xt/h3SnfCVeV8nACV5aIvF
 6FdEyhBa9wTIgn6F8M1NsCi9dQ6KEv13mpj/UONOVACQnKpfCSRkveMQ+cl3HJm4vaf3Sfmn
 4Cd6w==
IronPort-HdrOrdr: A9a23:0So6Ba4l4AMfAWDjdAPXwPvXdLJyesId70hD6qm+c3Bom6uj5q
 KTdZsguyMc5Ax6ZJhCo6HiBEDjexLhHPdOiOF7AV7IZmbbUQWTQb1K3M/L3yDgFyri9uRUyK
 tsN5RlBMaYNykesS+D2mmF+xJK+qjhzEhu7t2uq0tQcQ==
X-Talos-CUID: =?us-ascii?q?9a23=3A9NCu9mmSdENFxMqyv9gqqpX+TXzXOXzE4Uj3OWC?=
 =?us-ascii?q?TNTYzT+e0FACh3/pnicU7zg=3D=3D?=
X-Talos-MUID: 9a23:38GnsQmvEuZYz/I69zq0dnprKfdBxJqsU3wLy68pvdXcbCd8GB2S2WE=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.12,303,1728950400"; 
   d="scan'208";a="410609493"
Received: from rcdn-l-core-02.cisco.com ([173.37.255.139])
  by alln-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 10 Jan 2025 09:20:06 +0000
Received: from fedora.cisco.com (unknown [10.188.32.212])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-02.cisco.com (Postfix) with ESMTPSA id 358971800023D;
	Fri, 10 Jan 2025 09:20:05 +0000 (GMT)
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
	Dan Carpenter <dan.carpenter@linaro.org>,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH] scsi: fnic: Propagate scsi error code from fnic_scsi_drv_init
Date: Fri, 10 Jan 2025 01:19:56 -0800
Message-ID: <20250110091956.17749-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.32.212, [10.188.32.212]
X-Outbound-Node: rcdn-l-core-02.cisco.com

From: Arun Easi <aeasi@cisco.com>

Propagate scsi_add_host() error instead of returning -1.

Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Signed-off-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fnic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 6880b40507aa..2fc5e9688147 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -637,7 +637,7 @@ static int fnic_scsi_drv_init(struct fnic *fnic)
 	err = scsi_add_host(fnic->host, &pdev->dev);
 	if (err) {
 		dev_err(&fnic->pdev->dev, "fnic: scsi add host failed: aborting\n");
-		return -1;
+		return err;
 	}
 	fc_host_maxframe_size(fnic->host) = iport->max_payload_size;
 	fc_host_dev_loss_tmo(fnic->host) =
-- 
2.47.1

