Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794460570;
	b=40oa71aSMI2M9YA1n4KJ8COuN+bH/t4/Zp9fdHxuhCLrhuhD7SEdpF/qiEILGQ2EzOso
	 I5ir+gN09IESmMuthzfHaVq2eFBDhtZpnKrlMnTX/QhPeSRhrYDLVsIInLKFbjEQ+gT03
	 PdUroThquJ8f5bzAohflL6T6ZdGanZ1ZFP+N19mqJmDlhFY7/GEreZgS/tZYAw+MQZJpd
	 hNGc+7UpeDIvB41kvx2x/N7o248EOXQT/Iw+TfvqmP24mFEg4rgAnUHN7BFKhLwTj7bfi
	 vFYeDqRCv8U+/7kuhP0LtRsSHGlahuhqouhG+uEhiMJLzkL78YNeklkc45qloSFgxUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794460570;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=dZZYA4aJZW24rfHpvdxAeVS1QTPuYpP8ld4MwD2MKno=;
	b=lsRjSYkQm/R1e1CZyzNEKBDAutUU+mGAbyRRiGZZg+Yl17SU94Whajq+ygvu+BA1YZ/f
	 kmksi2ha8Ts/aA8m/i90M9Y/6h06cUpG7Zio1Jpqx3q8JI2fK7sEiJJvB1oe5W9NLcZSj
	 XyurK4lVM5ZYMHAOVdiVx3Fm22+7u5osIHLyju1PPsrRQlswisYilLX3GAVfpIn/l05AI
	 iLD8kVA4ViwEN9pAvOU+HIgnJ+fWzwnVskW2LNywJJ5xL+sGZY3bDrjd//jQMCfGS60Qf
	 T4G/9JE/MO3/3fr24TN0GP/+mtSYpUdv1pv0sQYX6WeYu2sIudnjI2XdbZlGFgyM5Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YGZlFE86;
	arc=none smtp.remote-ip=209.85.210.199
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F118F60A3824
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 05:16:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F118F60A3824
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YGZlFE86
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-89f84753b43so3088910b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 21:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794460569; x=1795065369; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dZZYA4aJZW24rfHpvdxAeVS1QTPuYpP8ld4MwD2MKno=;
        b=YGZlFE86oCC8gTSIurY4Bbc+mlwEbzfIBeVYT/JpedYaLTMsHLiUZDUSa6GVE8w8dV
         0B0dW2Lp0x7o5s1LRP2jkD0hyTVMikf8S/iVC1SU60/7WR5wA1jwHMwSKGyls4p9mrhd
         92h1tKySJMJ5i4U5mOrroXghsTnyhsKr55PTMwKNXkI8PtaWIwIXHD+9Np5F97Jpyz+a
         NvLEZc+LszDp/F8BWxtFx08mZO5aHCJrNS24BCJHoBQfzw/W8KgZAr1LvUqKEXflpgH7
         p1TtSTcV8nJGpdGN+i8Q6MfuEy/md8tvGKWJqcdUtmUNOVRti5//CToz/xemrMncfh2C
         GiUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794460569; x=1795065369;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dZZYA4aJZW24rfHpvdxAeVS1QTPuYpP8ld4MwD2MKno=;
        b=k32d2B1Id6j2/QzdpHvAwy6XciBA/tD0kT1EfK/s8SmCd/lFr2dN60Cy774+DxSybT
         Jv/N79WISRLCMa+whmjV3TKwXCMzNJqT/q8PrEsLKUwsOcYeKJ1nS4t7SBx9Aqft207y
         kfa72huAmn51wBOtKDfVeSPF+1G4vdygnWoS/k+TizfdK7VMpjn5BT0CV8K4z4Xwp5yX
         o/knPamVt2sLSkHtJRlvVG01ZHG/MXSUM1jplnf45D1tOcL1mfH9uGU8JP9RZDhS2bzf
         Qip6iVnixmo/g8DHoX6GgDYqKOD23QtbYzff/PuJZ8O52aFmjIpn3rciKeSXtkAtAbCY
         6e+w==
X-Gm-Message-State: APuU4Z9484dualgK1y29KxVwhJvxfFGR/CBb1X3OX/HKrQI08a6ytKzE
	XfvPoWoORnQ5Vc1y3tYNo4I1/mI7PL1lIsBDF/tNj/lrtP8rA1sm0dlJK3NRmzF8LH5xnHAohlo
	v/eSSNAIsRcf3U5VXzXI8Fqt3tTAsZdQBAiljrUCyYAqk0Fa/FKRVpO2a+p1KJqXjJ7vD6VgArC
	cOSO+i7ulcE3CdhVKrmA3Fh6g/kRWhFZEUXeazbAd2vWlXEsIRlRQhrF2JBt2HgmE=
X-Received: from pfbci8.prod.google.com ([2002:a05:6a00:28c8:b0:88f:dade:52e])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:428f:b0:886:73c9:89d7 with SMTP id d2e1a72fcca58-8bc1c499e3fmr4256425b3a.11.1794460568903;
 Wed, 11 Nov 2026 21:16:08 -0800 (PST)
Date: Thu, 12 Nov 2026 13:15:42 +0800
In-Reply-To: <20261112051542.1539779-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261112051542.1539779-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.567.gdb80ae8cd5-goog
Message-ID: <20261112051542.1539779-10-stanleyjhu@google.com>
Subject: [PATCH 9/9] scsi: ufs: core: Do not recover the link concurrently
 with a PM callback
From: Stanley Jhu <stanleyjhu@google.com>
To: linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>, 
	Peter Wang <peter.wang@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>, 
	Can Guo <quic_cang@quicinc.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	Asutosh Das <quic_asutoshd@quicinc.com>, Hongjie Fang <hongjiefang@asrmicro.com>, 
	Praveen Talari <praveen.talari@oss.qualcomm.com>, HOYOUNG SEO <hy50.seo@samsung.com>, 
	Brian Kao <powenkao@google.com>, Jens Axboe <axboe@kernel.dk>, 
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Brian Kao <powenkao@google.com>

Commit f966e02ae521 ("scsi: ufs: core: Fix runtime suspend error
deadlock") made ufshcd_err_handler() call ufshcd_link_recovery() and
return early if hba->pm_op_in_progress is set. Commit e23ef4f22db3
("scsi: ufs: core: Fix error handler host_sem issue") moved that check
ahead of down(&hba->host_sem). The patch "scsi: ufs: core: Limit early
link recovery in the error handler to runtime PM" restricts that early
path to ufshcd_in_wl_rpm_callback() and notes in its cover
letter that during runtime resume it can still run concurrently with
__ufshcd_wl_resume(), and removing it there needs a closer look at the
deadlock that it avoids.

With this shortcut, when a fatal UIC error arrives while
__ufshcd_wl_resume() is in ufshcd_bkops_ctrl(), ufshcd_err_handler()
calls ufshcd_link_recovery() -> ufshcd_host_reset_and_restore() without
holding host_sem or waiting for the PM callback, putting the host
controller into a reset (non-working) state while ufshcd_issue_dev_cmd()
on the resume thread is still sending query requests and accessing the
controller:

  Process A (PM callback, e.g. runtime resume):
  __ufshcd_wl_resume()
    -> ufshcd_bkops_ctrl()
      -> ufshcd_query_attr_retry()
        -> ufshcd_exec_dev_cmd()
          -> ufshcd_issue_dev_cmd()
            (accesses controller while in reset state)

  Process B (UFS error handler, triggered by UIC error):
  ufshcd_err_handler()
    -> if (ufshcd_in_wl_rpm_callback(hba))
      -> ufshcd_link_recovery()
        -> ufshcd_host_reset_and_restore()
          (puts controller into reset state)

Remove the early link recovery shortcut and
ufshcd_in_wl_rpm_callback() from ufshcd_err_handler() so that
error handling waits in ufshcd_err_handling_prepare() for a runtime PM
callback and on hba->host_sem for a system PM callback to finish before
resetting the controller. This does not reintroduce the runtime suspend
deadlock because:
- If the state is UFSHCD_STATE_EH_SCHEDULED_FATAL, ufshcd_queuecommand()
  fails SCSI commands such as START STOP UNIT sent from a PM callback
  immediately with DID_BAD_TARGET, and ufshcd_issue_dev_cmd() fails
  reserved device management commands immediately with -EIO, while any
  already in-flight PM command timeout is completed by
  ufshcd_eh_timed_out().
- If the state is UFSHCD_STATE_EH_SCHEDULED_NON_FATAL,
  ufshcd_queuecommand() still dispatches START STOP UNIT because
  eh_in_progress is not set yet.
- If a dispatched START STOP UNIT times out without a pending fatal
  error, ufshcd_eh_timed_out() recovers the link directly and returns
  SCSI_EH_DONE without waiting on eh_work.
- Runtime suspend errors call ufshcd_force_error_recovery() and return
  -EBUSY.
- Runtime resume (__ufshcd_wl_resume()) does not wait on eh_work or
  host_sem. A hibern8 exit failure recovers on the PM thread, a START
  STOP UNIT failure returns an error, and query errors are ignored.

Removing the shortcut relies on the companion patches in this series,
which complete PM command timeouts in ufshcd_eh_timed_out() before
reaching SCSI error handling and disable W-LUN runtime PM in
ufshcd_err_handling_prepare().

Fixes: f966e02ae521 ("scsi: ufs: core: Fix runtime suspend error deadlock")
Fixes: e23ef4f22db3 ("scsi: ufs: core: Fix error handler host_sem issue")
Cc: stable@vger.kernel.org # 7.3.x
Signed-off-by: Brian Kao <powenkao@google.com>
[stanleyjhu: rebased onto "scsi: ufs: core: Limit early link recovery
 in the error handler to runtime PM", clarified the reserved command
 path in the commit message, and limited Cc: stable to 7.3.x]
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 39 ---------------------------------------
 1 file changed, 39 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 87d475e323b1..1aecf55c0646 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7120,23 +7120,6 @@ static bool ufshcd_abort_all(struct ufs_hba *hba)
 	return ret != 0;
 }
 
-/*
- * Whether a runtime PM callback of the WLUN runs __ufshcd_wl_suspend() or
- * __ufshcd_wl_resume().
- */
-static bool ufshcd_in_wl_rpm_callback(struct ufs_hba *hba)
-{
-#ifdef CONFIG_PM
-	enum rpm_status status =
-		READ_ONCE(hba->ufs_device_wlun->sdev_gendev.power.runtime_status);
-
-	return READ_ONCE(hba->pm_op_in_progress) &&
-	       (status == RPM_SUSPENDING || status == RPM_RESUMING);
-#else
-	return false;
-#endif
-}
-
 /**
  * ufshcd_err_handler - handle UFS errors that require s/w attention
  * @work: pointer to work structure
@@ -7163,28 +7146,6 @@ static void ufshcd_err_handler(struct work_struct *work)
 		 hba->saved_uic_err, hba->force_reset,
 		 ufshcd_is_link_broken(hba) ? "; link is broken" : "");
 
-	if (hba->ufs_device_wlun) {
-		/*
-		 * Use ufshcd_rpm_get_noresume() here to safely perform link
-		 * recovery even if an error occurs during runtime suspend or
-		 * runtime resume. This avoids potential deadlocks that could
-		 * happen if we tried to resume the device while a PM operation
-		 * is already in progress.
-		 *
-		 * Do this only while the PM callbacks run for a runtime PM
-		 * operation. The system PM and poweroff callbacks hold
-		 * host_sem, and shutting_down makes the regular path below
-		 * stop, so it does not reset the link concurrently with them.
-		 */
-		ufshcd_rpm_get_noresume(hba);
-		if (ufshcd_in_wl_rpm_callback(hba)) {
-			ufshcd_link_recovery(hba);
-			ufshcd_rpm_put(hba);
-			return;
-		}
-		ufshcd_rpm_put(hba);
-	}
-
 	down(&hba->host_sem);
 	spin_lock_irqsave(&hba->host->host_lock, flags);
 	if (ufshcd_err_handling_should_stop(hba)) {
-- 
2.56.0.567.gdb80ae8cd5-goog

