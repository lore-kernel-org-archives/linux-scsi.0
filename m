Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21802295D85;
	Tue, 17 Jun 2025 09:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750154148; cv=none; b=LSlKEn75NXPlY+nCmA8bpNEv8sk7Ob+nJoeey8LLF4Nt1OC9LPwXIeW2zYsaMQAZpYUi3vmp4Y0QjUYcSZi/HPvHqT7v7gWQ2trAvXVjnJa+pGJl2k76lX/TH0Ty7EitVNswh4mvMVdIHs5IH4rtGqG/oiPnIDD6F7kEemvuJTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750154148; c=relaxed/simple;
	bh=+oZQx773tpJwPVGdXGiglLWOeItYJS7QI5pBwA/y+WA=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=Pl5A8GbhJGkpkIamYRn9ta1ssmTtTxojJ0n1uKcSh2bryUagd1i6bLuRoyIRqFUry1PDBG36ksFWiczcMJXuaQK7VAUcI+GS9P1C8FK5IrcRkUEM3W2DUM1pd9iwlJqc/wNzJNGpZT/6SNelXGRiOEpZfjawPvFbnHyZCuQ5+VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=mGXrpWbx; arc=none smtp.client-ip=43.163.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="mGXrpWbx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1750154140; bh=0LstCLd+ooxMwtRRuOVJqrkEDJBS38giqtvR0cA34zk=;
	h=From:To:Cc:Subject:Date;
	b=mGXrpWbxwPC1pYnqG2fFiwTjbm8jhInh/u1+YEmdd3SMh+fxbW1r/JNvFLKFalV16
	 ygppWofCPS2BiPWE8uIn8cG79myEZQGRyvlYCh2PtbaODm5dOvOIkS4Fav0aGgiJFO
	 9N5hUotrrHIu2m2mDJ/qrGiVN6Ril+f4/zCmvDTY=
Received: from VM-222-126-tencentos.localdomain ([14.116.239.37])
	by newxmesmtplogicsvrszgpua8-0.qq.com (NewEsmtp) with SMTP
	id DE6ABA5A; Tue, 17 Jun 2025 17:55:38 +0800
X-QQ-mid: xmsmtpt1750154138tcqpzx27z
Message-ID: <tencent_3C5078D216712F6F21FC8792FADED59A3D09@qq.com>
X-QQ-XMAILINFO: OSM/iTyfLV62kOpq2RHm9PS13nMDTXfAjDr+yxgtOdI8TVFB1Vf05irz/fhFjJ
	 nZFQ/miqJ2jpjwUpkDzVnGaYuCEPmzpFLNjnfOO0whtDL2dpGENapBbcAUA8fFj9RbmXlftuPTth
	 k2kA26pQvKktwlr4TDYijMcK38hE1rZCCiDGDbt1veuNg0MnWWQ01w7NOZbnimXdXO7qsRvWih0g
	 bRZN08PfcoHHTMMCcZsJtq4Kh5uGBe714Nw2ZOifav0XdzK9gUIBed0aXRM/mCAzKX2JsC13BZI6
	 rU/EOoCpZ2CDvffHSzeVqy0XKpVlAZIz0309JmxVddlfL0kJL4c2EAArPA4NXvF92pKpyW1qvYfs
	 6Bcf736YMd/NnPsLOh2ByuK39rQ8G4Y1hZsbZuliV+LkG907UgULWvQP8qa3uYsIaqY7rCZ5nm1Y
	 McTHLudRCBUWuqoQwI2AgbWnuubiTOS8UgYukR8o3wpjSHtixzjgFIzDfbeganaOF8LfhsRfekdK
	 7WJ6rZrJUinBWph3DYaPcGQiQrHDhSoLtt/ax1qKiQF/xiYT5VXET/tWKr6xWlP/3+Df4w7ItPlN
	 PXETPGFWKjtpODulRpuY/GIwVIM8CsBF1/KFXqGCtHsteq+9+t2DQ/J6YkZkodNf3S5J9UR69Frl
	 1K5fqvi42gdGJgvPWvkYNiZi1/6T294WuwMtaSh332AaSLqfO5ky30NlsnZtMl22p+5qzS8prz8U
	 8wrWSTNcwrpZLEGPFRK1PxdFDgn27yopESNyKmLsLAMFuuiUSyu7XzzU9psDc2bM1VrzAul1v1Fe
	 DhydBCFhtNfrKErgGDH/INjwYJmVKKylcKY+tD2iQAF5Z8uUT4+NeRkHUm5aeF97qStCVnC9/RAa
	 KXZD+LAiqE9DNsMeI6AH77/iLYJLE9JjH2k3X9pzf8YUQF8Vgg8XfLwxq8veMMkv2w90wAfS+dTM
	 OnE/wqlAi6xiLw3s8EYgdKc7fSCoxsV4TAAJ/o1ZVLEANkgXqijcFJ+4u+za2N
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
From: jackysliu <1972843537@qq.com>
To: skashyap@marvell.com
Cc: jhasan@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jackysliu <1972843537@qq.com>
Subject: [PATCH] scsi: qedf: Fix a possible memory leak in qedf_prepare_sb()
Date: Tue, 17 Jun 2025 17:55:31 +0800
X-OQ-MSGID: <20250617095531.850681-1-1972843537@qq.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A memory leak vulnerability found in
linux/drivers/scsi/qedf/qedf_main.c , qedf_prepare_sb Function Due to
Missing Resource Cleanup in Error Path.

The qedf_prepare_sb function allocates resources in a loop for
multiple queues. If an allocation fails mid-loop (e.g., kcalloc for
fp->sb_info or qedf_alloc_and_init_sb fails), the error path (goto
err) returns without freeing resources allocated in previous
iterations

Signed-off-by: jackysliu <1972843537@qq.com>
---
 drivers/scsi/qedf/qedf_main.c | 12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 6b1ebab36fa3..8767d9de819f 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2809,7 +2809,17 @@ static int qedf_prepare_sb(struct qedf_ctx *qedf)
 		    sizeof(struct fcoe_cqe);
 	}
 err:
-	return 0;
+for (int i = 0; i < id; i++) {
+	fp = &qedf->fp_array[i];
+if (fp->sb_info) {
+	qedf_free_sb(qedf, fp->sb_info);
+kfree(fp->sb_info);
+fp->sb_info = NULL;
+}
+}
+kfree(qedf->fp_array);
+qedf->fp_array = NULL;
+return -ENOMEM;
 }
 
 void qedf_process_cqe(struct qedf_ctx *qedf, struct fcoe_cqe *cqe)

