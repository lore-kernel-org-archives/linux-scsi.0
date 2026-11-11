Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794387791;
	b=xvHYPIlr3SbaZHn+xgsK3pgwX+gmAbgP/JsvLnfVbXCrAWfdGDLQpAzN/ndem2/arF9o
	 BhTdJa0srXON4Lo93AIe9/vBJSwHwbacxBXCBdqhEaWLEuI7FiUbelrXY9NMs/rCO/ehd
	 6Ejs4XEqh/HDKaiLnfPUmWzL2k3a1iK9S/OF3VJdM1dTrej8T4LGDdeE5INPPOscvrnkU
	 TXQjzxo5xibEkPXy6Mkiposc4MsTaOpVrsIA9usegla8EGT9WTuzwzbcIBVUICmSevZgK
	 1W0L3I5HFF5pqpP+P0Ndj6W6i+LMeuVhtzebOkQhd1RJsvVsjRSbraCd6+2v/KAfBZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794387791;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:X-Hop-Count:
	 X-CMS-RootMailID:References;
	bh=kTYY8x+hTdAdQLqwG3no5Cq26knGsOfbqx8bpZjUYog=;
	b=VHCyorW1AaX3ElLh6jp4rxJb3QiJWy6AqZnBKhfanTUSX2Xz1o9x5r36Mrw0dhVHkF1Y
	 z9Q76C/3Dr4tQJkHjRofJm5L3hwQHMuuJ5BRHqs3tOXYt0WJYYWiPZNom3SFRc+EIO+nE
	 GB0DRIMgaCMNm5laQy89FeWmIvbcF/6zajn4Lkm0r6dDPgBtUQwq8W8t7Ba0HQab5wRTv
	 Y3iLynA1yyvRBDVzxoBcWs3xjCsBUG8lCx5RM9fCqrwg7DOINzvMLMGxc2x111Bdz96A+
	 YuEhZpfhGoOPn5JDoFbcz6ftEoQCHQcsE5G6rmpdz3bE/e90R2ytoA3HXmaXPQx0AQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Gv+z99ak;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF81606A32A
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 09:03:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1EF81606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Gv+z99ak
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261111090308epoutp033d64c6897168d85c37e8dde34d46b06b~m8i_yIjOz0374303743epoutp03b
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 09:03:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261111090308epoutp033d64c6897168d85c37e8dde34d46b06b~m8i_yIjOz0374303743epoutp03b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794387788;
	bh=kTYY8x+hTdAdQLqwG3no5Cq26knGsOfbqx8bpZjUYog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gv+z99akpuq5lr5xeji1Mj4C6TtmfJ1Gcar66ayHMs+/myptRu8CdiQrqh2EvOMbC
	 EAQEFvC5PdvJ2zNf4qSmpTn3CpGonqfD2R8pbvXBt9Dpc1tNhf8XVOe/t7TLld/vbt
	 AcMZyozW8xUUO8qUR1Rt/EoYKeoNzbgCwMSYmRFE=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261111090307epcas2p11c8c8ab701dca152853830fd5ee2fb92~m8i_grtFN3213232132epcas2p1G;
	Wed, 11 Nov 2026 09:03:07 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jPcxR6Hn7z6B9mF; Wed, 11 Nov
	2026 09:03:07 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20261111082306epcas2p21456a0a7d81ed5328ec01f022b87ee32~m8ACAi9to1539115391epcas2p28;
	Wed, 11 Nov 2026 08:23:06 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261111082306epsmtip2a6c844e271c821f53d371dab5d9466a4~m8AB7GGJy1507515075epsmtip2k;
	Wed, 11 Nov 2026 08:23:06 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, peter.wang@mediatek.com, alim.akhtar@samsung.com,
	kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgsproxy1@samsung.com,
	h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v10 3/4] scsi: ufs: core: Make ufshcd_wl_poweroff() behave
 like ufshcd_wl_suspend()
Date: Wed, 11 Nov 2026 17:18:33 +0900
Message-Id: <603443293.161794387787869.JavaMail.epsvc@epcpadp2new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1794384665.git.hy50.seo@samsung.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261111082306epcas2p21456a0a7d81ed5328ec01f022b87ee32
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Hop-Count: 3
X-CMS-RootMailID: 20261111082306epcas2p21456a0a7d81ed5328ec01f022b87ee32
References: <cover.1794384665.git.hy50.seo@samsung.com>
	<CGME20261111082306epcas2p21456a0a7d81ed5328ec01f022b87ee32@epcas2p2.samsung.com>

ufshcd_wl_poweroff(), the hibernation poweroff callback, calls
__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM) directly and ignores the
result. Unlike ufshcd_wl_suspend() it:

 - does not take hba->host_sem. An error handler that runs in the
   meantime can reset the link concurrently with __ufshcd_wl_suspend().
   It also leaves host_sem unbalanced: if hibernation is aborted after
   ufshcd_wl_poweroff() has been called, ufshcd_wl_resume() is called as
   the .restore callback and releases host_sem, which was not acquired;
 - does not check pm_runtime_suspended(dev). __ufshcd_suspend_prepare()
   leaves the WLUN runtime suspended if ufshcd_rpm_ok_for_spm() is true,
   which is the case if rpm_lvl and spm_lvl are equal. Then
   __ufshcd_wl_suspend() triggers error recovery and returns -EBUSY;
 - does not set hba->is_sys_suspended, so ufshcd_err_handling_prepare()
   does not restore the clocks and regulators if the .restore callback
   fails;
 - ignores errors.

Call ufshcd_wl_system_suspend() with UFS_SHUTDOWN_PM from
ufshcd_wl_poweroff() to fix all of these, as suggested by Bart Van
Assche. host_sem is held until ufshcd_wl_resume() releases it if
hibernation is aborted, and released if the suspend fails. For
UFS_SHUTDOWN_PM, __ufshcd_wl_suspend() does not convert failures into
-EBUSY, so a positive SCSI or UIC status can be returned. A dev_pm_ops
callback has to return a negative error code, so convert it.

This changes the behavior of ufshcd_wl_poweroff(): an error is now
returned from the .poweroff callback, which aborts hibernation, instead
of being ignored, and a runtime suspended WLUN is left as it is like in
ufshcd_wl_suspend().

Do not use hba->shutting_down to stop the error handler: it makes
ufs_mtk_system_suspend(), which is also the .poweroff callback of the
MediaTek host controller, fail with -EBUSY, and nothing clears it when
hibernation is aborted.

Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4825349e87fd..8aea99f5c364 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10729,6 +10729,9 @@ static int ufshcd_wl_system_suspend(struct device *dev, enum ufs_pm_op pm_op)
 	if (ret) {
 		dev_err(&sdev->sdev_gendev, "%s failed: %d\n", __func__,  ret);
 		up(&hba->host_sem);
+		/* __ufshcd_wl_suspend() can return a positive status for UFS_SHUTDOWN_PM. */
+		if (ret > 0)
+			ret = -EBUSY;
 	}
 
 out:
@@ -11576,11 +11579,7 @@ EXPORT_SYMBOL_GPL(ufshcd_suspend_prepare);
 #ifdef CONFIG_PM_SLEEP
 static int ufshcd_wl_poweroff(struct device *dev)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
-	struct ufs_hba *hba = shost_priv(sdev->host);
-
-	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
-	return 0;
+	return ufshcd_wl_system_suspend(dev, UFS_SHUTDOWN_PM);
 }
 #endif
 
-- 
2.34.1


