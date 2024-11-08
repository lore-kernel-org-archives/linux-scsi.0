Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074F1366;
	Fri,  8 Nov 2024 19:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731095501; cv=none; b=Ip0OZPQZJ1/B19kiQBML2GRC6LOe9gjAEyC62jhAnNafkNTKeZ65U7nyqRXuwyM33UZ87WSOvvkec9Lw1IjcEr89YM6ZaD3U+qIUZskZSmINaRef7wGXnEbq8zGHsHSwM/AdjHfm9uUSV7oXnQVN5NzHgmCNKfzL2G8CuLTTKAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731095501; c=relaxed/simple;
	bh=C2uRhxWzMs9XKyh+eTR8RPt2gx4Ki56mOsywA0U+3sc=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=JWFqQLkfO/fOIbHKaOYsI7UfGkCYe9lybXztxyU873bk8LAqVvo9DOGeYdlMtl4+HhIyR2Hah7fGhFlCem0AeRFlxNyrNGS5JLDbffNtHgAjfYftaWB5C9ft8jZp29mDTL7pN3j675WzjsO5pgRlLJmEcwvRf8K8E3B08NpA5To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=fF0/1VCH; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=u4JjM8Wo; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="fF0/1VCH";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="u4JjM8Wo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1731095498;
	bh=C2uRhxWzMs9XKyh+eTR8RPt2gx4Ki56mOsywA0U+3sc=;
	h=Message-ID:Subject:From:To:Date:From;
	b=fF0/1VCHdqIX1Wp3b3ZUqGX6c5EPKoMcYX0BsoTbwJP74ujnalOeJP8I7jHOpp/Yr
	 YnUY4yoA8BFrKh5EDUy9RuriyzxJ7caNQiem8gsFX7DMRY7rJ3iBr//WoYrh6KjhcC
	 V3FAmUmRW/jlgbxACoL14XmMvG8VnK8YLrOrz3N4=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 0A5621286B38;
	Fri, 08 Nov 2024 14:51:38 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id do3dBNPjUotf; Fri,  8 Nov 2024 14:51:37 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1731095497;
	bh=C2uRhxWzMs9XKyh+eTR8RPt2gx4Ki56mOsywA0U+3sc=;
	h=Message-ID:Subject:From:To:Date:From;
	b=u4JjM8Wo0cMJjROHPvjq3j81hzL/93v9likkW5wZ9HtTfFIfnMUH7P1hF/76lpsTp
	 +UrG7GTNpUcKbXD3tn11iwSp6rqKtQoo70xcvB6uAGnBzirrnrRbM02zh/uCWAQieI
	 /2wJo4/0lkdHvbPrSq4HtlqLJwgFVTEosUzH14Mk=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 79322128182B;
	Fri, 08 Nov 2024 14:51:37 -0500 (EST)
Message-ID: <d5a5c6467b9556633b8538f403202e800aeb3c82.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.12-rc6
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Fri, 08 Nov 2024 14:51:35 -0500
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Two small fixes, the drivers one in ufs simply delays running a work
queue and the generic one in zoned storage switches to a more correct
API that tries the standard buddy allocator first (for small
allocations); this fixes an problem with small allocations seen under
memory pressure.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (1):
      scsi: ufs: core: Start the RTC update work later

Johannes Thumshirn (1):
      scsi: sd_zbc: Use kvzalloc() to allocate REPORT ZONES buffer

And the diffstat:

 drivers/scsi/sd_zbc.c     |  3 +--
 drivers/ufs/core/ufshcd.c | 10 ++++++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index c8b9654d30f0..a4d17f3da25d 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -188,8 +188,7 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
 	bufsize = min_t(size_t, bufsize, queue_max_segments(q) << PAGE_SHIFT);
 
 	while (bufsize >= SECTOR_SIZE) {
-		buf = __vmalloc(bufsize,
-				GFP_KERNEL | __GFP_ZERO | __GFP_NORETRY);
+		buf = kvzalloc(bufsize, GFP_KERNEL | __GFP_NORETRY);
 		if (buf) {
 			*buflen = bufsize;
 			return buf;
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0e22bbb78239..3b32803b7a68 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8636,6 +8636,14 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 		ufshcd_init_clk_scaling_sysfs(hba);
 	}
 
+	/*
+	 * The RTC update code accesses the hba->ufs_device_wlun->sdev_gendev
+	 * pointer and hence must only be started after the WLUN pointer has
+	 * been initialized by ufshcd_scsi_add_wlus().
+	 */
+	schedule_delayed_work(&hba->ufs_rtc_update_work,
+			      msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
+
 	ufs_bsg_probe(hba);
 	scsi_scan_host(hba->host);
 
@@ -8795,8 +8803,6 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
 	ufshcd_force_reset_auto_bkops(hba);
 
 	ufshcd_set_timestamp_attr(hba);
-	schedule_delayed_work(&hba->ufs_rtc_update_work,
-			      msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
 
 	/* Gear up to HS gear if supported */
 	if (hba->max_pwr_info.is_valid) {

