Received: from alln-iport-8.cisco.com (alln-iport-8.cisco.com [173.37.142.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054942066FF;
	Fri, 10 Jan 2025 09:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736500740; cv=none; b=RThyP3+TfbWbr/g9ygL7QcwmrIeV+ofn2MRSZNdnArYVFA/yUeeknEcIn9861eRE/fWtM0vwFBMikacUd6MXDeXORQxPfDAsXvplUduirRZiyOT2rgcETIgoTPBt2lBDssdvp4r6M+YiWtlxSTMbTT9ZELuPanucxpRNs6/u9l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736500740; c=relaxed/simple;
	bh=nxROwyL3xxhy9gLWuxQZ4KR+ROD93uU0C1H3OxvgL9I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lN3zDW+3yBvruSHF8uwOLXz+VD/SXOa8q09wZL8e9KYWN05uW9Lryw88FhCB/1IOVlPiF4+1md9t3uO0FRqXUiI5QBAJr7NyHLsBfo5otkNo6tfgp0y9JTKelqfl5nmzqyFz8bOrLnkK/lBHNkyXSVTs5r8URTGlB5m1POR81aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=NvVxd3bw; arc=none smtp.client-ip=173.37.142.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="NvVxd3bw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1038; q=dns/txt; s=iport;
  t=1736500739; x=1737710339;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=o8iT1qMyFuPIhI3wSoaYBNFkFPT90GmHqVw4AahnhIU=;
  b=NvVxd3bw2vXybNHWaSfsMhQ7sKreD4JO+VjRI1uZwRTTpFyB4pMp6L1+
   2fY0WKI8OLLNb2c6CXfzhoLF2iN5YxJFDnNHdLi4IBWZtWeD6vWxRFALa
   4nrqK9ia9s8HX7l28VSSmcds3QguYfVLsY5i9j13BY+lWBWKFgxr0PYfb
   I=;
X-CSE-ConnectionGUID: mFKoP92jReSkPzify5GhyA==
X-CSE-MsgGUID: mxZ/MZ88RXuqMaglJxC5Sg==
X-IPAS-Result: =?us-ascii?q?A0AQAAA35YBnj4v/Ja1aHAMDBxYEBIIBBw0BhBlDGS+WQ?=
 =?us-ascii?q?54bgSUDVg8BAQEPRAQBAYUHinYCJjQJDgECBAEBAQEDAgMBAQEBAQEBAQEBA?=
 =?us-ascii?q?QsBAQUBAQECAQcFFAEBAQEBATkFDjuGCIZdKwsBRoFQgwGCZQOzNoF5M4EB3?=
 =?us-ascii?q?jOBbYFIAY1JhWcnFQaBSUSCUIE+b4FSgjiBBoV3BIdonkpIgSEDWSwBVRMNC?=
 =?us-ascii?q?gsHBYFzAzgMCzAVNYEae4JGaUk3Ag0CNYIefIIrhFyER4RWhWWCF4V4QAMLG?=
 =?us-ascii?q?A1IESw3FBsGPm4Hmxs8g3B7CQqCQKVwoQOEJaFGGjOqUgGYfKktgWc6gVszG?=
 =?us-ascii?q?ggbFYMiUhkPjjq8HyUyPAIHCwEBAwmPIYF9AQE?=
IronPort-Data: A9a23:pN+oiaDkooEESxVW/8Tjw5YqxClBgxIJ4kV8jS/XYbTApDsrhDIOy
 2QYXDqBbq7YN2GmfIgnYdix8ElXscLcyt5iOVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4eGdIZsCCeB/n9BC5C5xVFkz6aEW7HgP+DNPyF1VGdMRTwo4f5Zs7ZRbrVA357gWWthh
 fuo+5eCYAb8g2YtWo4pw/vrRC1H7ayaVAww5jTSVdgT1HfCmn8cCo4oJK3ZBxPQXolOE+emc
 P3Ixbe/83mx109F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq+kTe5p0G2M80Mi+7vdkmc+dZk
 72hvbToIesg0zaldO41C3G0GAkmVUFKFSOuzXWX6aSuI0P6n3TExttNC3lnZ48i9910OXNP+
 +1FBzAcR0XW7w626OrTpuhEnM8vKozveYgYoHwllWufBvc9SpeFSKLPjTNa9G5v3YYVQrCEO
 pdfMGE+BPjDS0Un1lM/C5skgOasj3rXeDxDo1XTrq0yi4TW5FAoiei0bYWIIrRmQ+1QjnTfg
 1CWr17JHwg/PdOb6yqur0mj07qncSTTA99KS+biqZaGmma7ymUVThYfT0O2p+W0kGa6WtRWM
 UtS/TAhxYAw+U6hZt38WQCo5n+Ou1gXXN84O+gz8h2MzOzM7hqUHHMJSBZGctUtsMJwTjsvv
 neNntX0FXlsvaeTRHa16LiZt3WxNDITIGtEYjULJSMB4t/+sMQohQnOZshsHbTzjdDvHzz0h
 TeQo0ADa647l8UH0eC/uFvAmT/p/sKPRQ8u7QKRVWWghu9kWGK7T4mGyl/jvKxCFouiTWGTv
 XYVxuee/clbWPlhixexaOkKGbio4dOMPzvdnUNjEvEdG9KFpSXLkWd4vmoWGat5DvvobwMFd
 6M6hO+w2HOxFCbxBUOUS9vtYyjP8UQGPY+6PhwzRoERCqWdjCfdoElTibe4hggBanQEn6AlI
 ou8es2xF3scAqkP5GPpHLlBjeB2mnximzO7qXXHI/KPjOX2iJm9FOZtDbdyRrpjhE95iFyPq
 o8Ba5viJ+t3D72mOHK/HXEvwaAidiVjWsus9KS7h8aIIxFtHyk6GuTNzLY6M41jlOI9qws71
 i/VZ6Os83Km3SevAVzTMhhLMeqzNb4h9ihTFXJ3Yj6VN40LPd3HAFE3K8BvJeFPGS0K5aIcc
 sTpjO3bW6sWEmybpGpGBXQ/xaQ7HCmWacu1F3LNSFACk1RIHWQlJveMktPTyRQz
IronPort-HdrOrdr: A9a23:b9ueq6p5FlUs+GpRvEKWo5waV5oYeYIsimQD101hICG9vPb1qy
 nIpoV46faaslgssR0b8+xoW5PwIk80l6QV3WB5B97LNzUO01HGEGgN1+bf6gylMzHi9+JbyK
 dre7VzBZnNF1Rg5PyKhTVQa+xB/DFCm5rY4ts3CBxWPGVXV50=
X-Talos-CUID: =?us-ascii?q?9a23=3Ayqf7OGoQhFgcsne6sDMjuPXmUcULUXrlnS3SGUK?=
 =?us-ascii?q?DCl57SbOEFHCQ6Yoxxg=3D=3D?=
X-Talos-MUID: 9a23:yrUXgQUlZHMjYwHq/Dr8tnZHBpc42ZSzEWUEnpEkq+LZDiMlbg==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.12,303,1728950400"; 
   d="scan'208";a="411815750"
Received: from rcdn-l-core-02.cisco.com ([173.37.255.139])
  by alln-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 10 Jan 2025 09:18:52 +0000
Received: from fedora.cisco.com (unknown [10.188.32.212])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-02.cisco.com (Postfix) with ESMTPSA id DD65518000233;
	Fri, 10 Jan 2025 09:18:50 +0000 (GMT)
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
Subject: [PATCH] scsi: fnic: Return appropriate error code from failure of scsi drv init
Date: Fri, 10 Jan 2025 01:18:42 -0800
Message-ID: <20250110091842.17711-1-kartilak@cisco.com>
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

Return appropriate error code from fnic_probe caused by failure of
fnic_scsi_drv_init. Fix bug report.

Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fnic_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index d366cbca04d5..6eb551112170 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -1039,7 +1039,8 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	fnic_fdls_init(fnic, (fnic->config.flags & VFCF_FIP_CAPABLE));
 
-	if (fnic_scsi_drv_init(fnic))
+	err = fnic_scsi_drv_init(fnic);
+	if (err)
 		goto err_out_scsi_drv_init;
 
 	err = fnic_stats_debugfs_init(fnic);
-- 
2.47.1

