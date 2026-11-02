Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793579788;
	b=wqcKIvE2ZHYq5WI/q/MQ3jCSdp/F4NvRrVpk2v4D7+KnBSoGVOXEMnMISgLMdx30D291
	 6Aaa592N/IX2ehrOgbdiWbDpyvVCppAG1ubSiHgHDeuUl4jfigJbYQJfZsFlx1+ty5M3O
	 smpkUBOdtHug80hvSm3+8KhTWdzcwZ+D/be7539J105A8oHrC608iQVkpG3u+0xSyGJ6+
	 sXiyQiSYEp+rf9whmh6w6ZrhvhX3SME4o34kvahhX5daa/cbgBOKt5pSPQhtKdsYUKmBP
	 D6Jlu5O/pyH/jyhpH9bFdOhpa/I4HKjcHbzOLs0F+VNaJ6frkVFhtJITkLKeeqI5OBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793579788;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=d5I/3o3ZMDmTHhqki/RL15OKEhwf2lx/PeEsYN29HFM=;
	b=0QLzAF3wal/jlKdY2L2WtlmtRagrU3IuGXyLfsS3cHzPlfKQEJQvHNeV4MQRR5yF6N4n
	 19wgpHGQXuUpbb3khO7G61+/NMBettV85u3LcCx9DxtxgBSxyAhdrilJGz0tsdE9TXIK+
	 M2jMRwMR4b36uYLE8MU2lmER8xCm8bmoLGCGtFmGVmqHTEyhcqYLibX/F71WQq/FRfyl6
	 IGk2lHbRoBoqjMoDKxwvzei4QSYuaf644jkIl2LQBuTZQt04t2xkp0HlkmPKud6Y3x18E
	 HmOWMB9Ye9nfENvo8pSka9Y4OfdulDOpZ41C5nlPxyarh7s0LbGva5MQIkGG7QhPYFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mCsT9VkB;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC43606A324
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 00:36:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8AC43606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mCsT9VkB
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a4dc547987so12190305e9.0
        for <linux-scsi@vger.kernel.org>; Sun, 01 Nov 2026 16:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793579786; x=1794184586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=d5I/3o3ZMDmTHhqki/RL15OKEhwf2lx/PeEsYN29HFM=;
        b=mCsT9VkBi31Q/07PhFPnoQyS8sTl+vy7CHR/3/MgntufJMCCERNwr2dA08BepuRIJn
         Jo8Iqd/a8TGougUUFsKMEXkjZXNUEVi/67EPw6/9OitQWRIkM8c4c+IC4ahoWroHNc9J
         kf7vSNvWX2ZCdoFGTDKRswi8fLboxdbzWtm4vNggw0JoaVP/oI8i3v0tKBe5ddxFz6Y4
         zGwOujyrTbdDJKwGbNhALIzvSyn6sKOcqLrxA27A+zTZqNC/IL0BCTEQfegmqrrdy9u3
         Oa107eopoqYAhcQ+o1zziZOFkdqknyP9K5/3WeBmMdvC0yq0PdDLlc3JXuKPHOoiQ9eq
         H1vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793579786; x=1794184586;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d5I/3o3ZMDmTHhqki/RL15OKEhwf2lx/PeEsYN29HFM=;
        b=Cky5oDZbcGq7cLFMVA8ckoZM3CdOrob4RGJRxfFQX7cZxugRsVg/c72vYS6hwXzw8s
         Tx5iZDVXrjaU2rsvhGnp8lso/o9h14PPD6zRmc6LVse4pP48mAvMxmNOw2YHDKGuJGxM
         q4dqMpWM/UBuWHS7IJiqia5K0aiHFua73AhHFIo/pfBgWLatQCH5O6YuFmPNIrPMbvUu
         JKwh4awKvjYU+jBLhwMJeCGDcWYwlRMozO0KujC1pyPKb3EguMFLRu3POe6derHY0qD4
         gLFDoN1psce6MLtioIHlEgnp+ibT7wpPnlXQfbfIJtFzorG+iXAhJtoHYZ49hmNeVVMt
         6mbw==
X-Forwarded-Encrypted: i=1; AKwUvBwPPh1dB0M40NuEK9DkZidgp7ZRKaIK/KoXqlaum+PNKZqAAEpLDSdsAAPCALYrpTpM0YCx8sudUDZg@vger.kernel.org
X-Gm-Message-State: AFq9FYKAVEFM30s9Al9JF8wLjKTseEWGKrAj5Kg0n4qusNG/RhWgJmDa
	qjMZvAD4bp3ZSWsZaHBBvy0QrNX3xs7GG7rMhJ+M3uG9rGXucI3oLgM=
X-Gm-Gg: AYBFou2hr/m1CL2u7phwol2+Ik/c0AzsqmghYQSpKI9v9TX3559dVVEAh8pkbr0NTnS
	P+YWqyKa0O+jsTxxARcFoxVdarlvSDtfJpTcY0UzXywI+RkDfvnS4zWVM4OCP4vxFbxyvQDxfZm
	LCwLufaPOxdycawhrok9zWxNv38I4Dt3JmQgTFBt3NW0/ZOYBUUBi4tOIKXuC7vMp4MsoVn6s4I
	RR9ofYucH5vEOncoXj9KQl1IViW4WPM4Fbl1zOXcl946Gsm1ywfk9jPpF9HoTdsUxYn1jJufqUL
	sw+EmY8yVvi9BDXYQck8k0KJSZLOcdZ/YCrQ14HDZG6KgdAIgTeLFyp5CEg7DqItSTAxMeKHCqD
	s7SU3DUJAV9q6bEjBDM/QWT/kgLjJneshChm5OgH6oYoaJjNLBvuDfJr0ky31/u+m9dNqbpUu+u
	EVIn2f9jj/z1ETvFynZXf4US9BhTn6I4ZCJdkDeUvsOKfVLZU/3/1ue8Y1ZovEX2YgI72USwTzQ
	BxmiSFPyUivFvV/RWUshz4/6QYVhrhi+t+Rj1Pd0uP3cg4EJEGN5uad8lLgUQgkE/fKy4lNrUnF
	fgkyvcLJwENEWcSIiJpphCgzGSQB+zfBMsOe
X-Received: by 2002:a05:600c:5397:b0:4a4:4d57:8462 with SMTP id 5b1f17b1804b1-4ac18b7e65bmr197850895e9.24.1793579785959;
        Sun, 01 Nov 2026 16:36:25 -0800 (PST)
Received: from sasha-User.lan ([185.159.163.49])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa813d2950sm302007805e9.8.2026.11.01.16.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 16:36:25 -0800 (PST)
From: Asdlerto Korry <korryasdlerto@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Asdlerto Korry <korryasdlerto@gmail.com>
Subject: [RFC PATCH] scsi: ufs: core: Allow error recovery before the device W-LUN exists
Date: Mon,  2 Nov 2026 02:36:07 +0200
Message-Id: <20261102003607.341651-1-korryasdlerto@gmail.com>
X-Mailer: git-send-email 2.25.1
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

ufshcd_err_handling_should_stop() returns true while hba->ufs_device_wlun
is NULL, i.e. until the first probe has added the device W-LUN. If the
link fails during that first probe (for example NOP OUT failing after
link startup), the error handler therefore never resets the host or the
link: it only marks the state operational and returns, and the probe
keeps failing until it gives up.

On a Samsung Galaxy M52 5G (SM7325) the first link startup regularly
ends in PA errors (LINERESET). With the W-LUN check removed, the error
handler performs a real host reset and restore and the device comes up;
without it, it never does.

Removing the check exposes three places that dereference
hba->ufs_device_wlun unconditionally on this path:
ufshcd_rpm_get_sync()/ufshcd_rpm_put(), ufshcd_err_handling_prepare()
and ufshcd_recover_pm_error(). Skip the W-LUN runtime PM handling there
when the W-LUN does not exist yet; there is nothing to resume and no
regular SCSI I/O before it is added.

Note: the error handler then calls ufshcd_verify_dev_init() through
ufshcd_reset_and_restore() while the tag set is quiesced. This needs the
pseudo SCSI device queue to be unquiesced in ufshcd_err_handling_prepare()
(as done upstream), otherwise blk_execute_rq() waits forever.

Signed-off-by: Asdlerto Korry <korryasdlerto@gmail.com>
---
 drivers/ufs/core/ufshcd-priv.h |  4 ++++
 drivers/ufs/core/ufshcd.c      | 13 +++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index e55c2a02c1f5..2cb0d542d114 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -385,6 +385,8 @@ static inline int ufshcd_update_ee_usr_mask(struct ufs_hba *hba,
 
 static inline int ufshcd_rpm_get_sync(struct ufs_hba *hba)
 {
+	if (!hba->ufs_device_wlun)
+		return 0;
 	return pm_runtime_get_sync(&hba->ufs_device_wlun->sdev_gendev);
 }
 
@@ -410,6 +412,8 @@ static inline int ufshcd_rpm_resume(struct ufs_hba *hba)
 
 static inline void ufshcd_rpm_put(struct ufs_hba *hba)
 {
+	if (!hba->ufs_device_wlun)
+		return;
 	pm_runtime_put(&hba->ufs_device_wlun->sdev_gendev);
 }
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fd52deb72d21..9767fbc7b870 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6876,8 +6876,9 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 	 */
 	pm_runtime_get_sync(hba->dev);
 	ufshcd_rpm_get_sync(hba);
-	if (pm_runtime_status_suspended(&hba->ufs_device_wlun->sdev_gendev) ||
-	    hba->is_sys_suspended) {
+	if (hba->ufs_device_wlun &&
+	    (pm_runtime_status_suspended(&hba->ufs_device_wlun->sdev_gendev) ||
+	     hba->is_sys_suspended)) {
 		enum ufs_pm_op pm_op;
 
 		/*
@@ -6926,7 +6927,6 @@ static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
 {
 	return (!hba->is_powered || hba->shutting_down ||
-		!hba->ufs_device_wlun ||
 		hba->ufshcd_state == UFSHCD_STATE_ERROR ||
 		(!(hba->saved_err || hba->saved_uic_err || hba->force_reset ||
 		   ufshcd_is_link_broken(hba))));
@@ -6935,12 +6935,17 @@ static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
 #ifdef CONFIG_PM
 static void ufshcd_recover_pm_error(struct ufs_hba *hba)
 {
-	struct scsi_target *starget = hba->ufs_device_wlun->sdev_target;
+	struct scsi_target *starget;
 	struct Scsi_Host *shost = hba->host;
 	struct scsi_device *sdev;
 	struct request_queue *q;
 	bool resume_sdev_queues = false;
 
+	/* Nothing to recover before the device W-LUN has been added */
+	if (!hba->ufs_device_wlun)
+		return;
+	starget = hba->ufs_device_wlun->sdev_target;
+
 	hba->is_sys_suspended = false;
 
 	/*
-- 
2.25.1

