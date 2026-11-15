Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794745335;
	b=hTlMadbDI+1FsP+7OpNzSVAoZCby6u9+5eEPQtf3Pv4t6DNsJAn2Ho611cHC1VEi2vjH
	 M29097nSOZDzLCEMw4PYkOIWoz4F0uElZJ0Paevy/9trzDr1ELZyfYi5TE5Ay4wxeHA7J
	 LSrk4k1vycFDvEPKrDputQzgFFLwWn0kPLiSd7kyo219tFDAzvdPUOXpqPU8gfTnvuqic
	 NOew/JmLFrYH38xX2jFFd4m1xlel5OnLJC1nTtXq0bpSN77N1RPgayK/LJvul7p2qphVW
	 /VFffm0wyuKn9wrvC7Rry/vrrNTn6kyQ68K82cdUzaOozERi02vlsvM/YOkxIGbvZ+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794745335;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=pec0ou9WUTALkQPa/wVdhz9fArgdzCN6xOPK5j8ug1o=;
	b=wwFYVO+7z61RZrQsQHh93euHLzFnAsfBP19iY3G21X54eHN3w81qjG+dQnyDiXTr5/Rn
	 TBq+pTDG2RehWuAK3q21AuDp8S1vuBfKecNjcYljcbJJCVZxHrljksT87pySx2sdR9PBB
	 jQMQAyB59E0jxOeEuO6+sIrwPY9q8qpcGq0K1p0U6+KXS/hE/AtXibKxcEUeoVm2u0Gcu
	 ZO5jIA5rYpFXgtuyYfNGOKA4e8+nCR9HyHSXxtRWhaSUA3TUBkxzKlMZQCzc96K7FnDgj
	 xNybmh+xlmm+4pssoE8/EGcdBKwcUA47IOaSmnopET+Ai7LTL3BhGZGK8PsJmZBzQrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="N/YWvHmG";
	arc=none smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38604606A32F
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 12:22:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38604606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=N/YWvHmG
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8b29b83fdf1so1280552b3a.2
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 04:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794745335; x=1795350135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pec0ou9WUTALkQPa/wVdhz9fArgdzCN6xOPK5j8ug1o=;
        b=N/YWvHmGTVax1qK93mhPlsPTMqx4Oxxvq/HBUrXpl8m2xH+QpRPCX8QIY/xwYAQcJR
         lGpI8NrAGB9fb9KwjmEL8gXCLLA/U5pXocurTeAU1nwfKq0/na2kULscRtCiveJr+mK0
         XoOVq+OBTLj9z5ZFlROJoVcmdBYRBWYZqQ5BHosg7bVcFwm/fZtUAvr92RrwZMjVMcoz
         K+Kq3PHlAOGh6ybb4uCk7wnSZUx4YgJ6CzydKV/HyMk+9QNrBrLsLjIXaSrFqYyZhYAb
         FlmzMSdH2hSLP/DlxUucJfw6oSRG3Aj/twqjo8zFPTIBpD6FMXeiYjIUrVAVprYnMpd+
         7xlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794745335; x=1795350135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pec0ou9WUTALkQPa/wVdhz9fArgdzCN6xOPK5j8ug1o=;
        b=sAFBVbC1eC7IwoMnRPaZ68bZGk0rFJO/191LlOSKwzl4spyh2wWImnTWq5+2NgxtE5
         R9I+g1urjL2gGDZILh/G8Jc1l3WMS/1kGmJfrO6jwr0B5Rn13hBkQl31/iMz9l/047xO
         c+q7bptkvseeKOUFir0dDptr3USuQjtSWjkxOir1WmrW7nKtQGQKRBMIn/uWN8HMWHwQ
         dBbGkbyzMbI1L8bbjiVrQYhszMqYezYEtQrVOUiHDwgvWrs8jvHDWSXCxmWCuKngt/cj
         JcbmRPU6KiSUrj10LXIJwCsncqBCfFUS/GxV1Vw9/zT0Itk6IwMPuAhmFdPcyrBdQEQD
         AkPw==
X-Gm-Message-State: APuU4Z9F0AYMNah+hMjBgcMGHG2HdfBEjpDcASXzoliMhlG41CT8Vzf+
	1+zLgpx2S0MCS+T5XyObTKmCw5t0yG5EkKwnDlp05/tc6vsaTtyHSe816JIAf6W7/Vw=
X-Gm-Gg: AYBFou0PozU2gjf6X41AZzLuBK2WRtbJWNudv7aZrFPRm/aNGjs0e112P36aJi/4duD
	hjIo8qJOTB0bVsvWEYl315V73l4Nlmzn2BD6HNiVbs8yRmQoXztlK5oZBirtWLRq9tZr95aEVFi
	akVHXwiJP9CeCllLexN75UjTDyRE1wsK/NmzPEIThzvrCWug7EdQRX7k8GJskP+BisSAQH/TNq6
	7BaKM+Upl0/B0IznYtsiMF7Kg3ZsB5VppgIEZqgi+sih65551vulVKLIp629ltXr3bwwCiJf7Iq
	SmJE2syUx0kG/NArWDrF2IpUXvFFfyv1Ky3BnbwDL0xk21rgTtZr7x45PXEST6PdeQR33Z7mCqq
	qepZKJO78qqkasvzo9jmrgzyl1BmeWpmfAY6FuDvvzZvcId7lX6tNbcPoVznbnw0HUJ0k2F8ket
	rzfd+VLUUJqnq4Aucj1hwBUXHz56vt0twsBQzJEBQ8uawgDFoyNoQMS0FpJx39jy4bhOcQFEs30
	Lt7VGF9ycTPdaao6YxlhBE1MLJG/Qj0s58JnhErvEr/RSLAER5d2I+pBYqnjQzZ7NQCEb8LrNqV
	mh+46Oq+UY2Hhdni8Oigp8RaV+zfQu2JR3M0sQ9FW335CXoYUeeLM+RUmuXQ+OU0v5+ezunFbNn
	T19S1I47i/M0i1uhNSJ59KogLXp+7xh60DQZApoQfLOvV+ZXmtBFo5/UwEeQ=
X-Received: by 2002:a05:6a20:d48e:b0:3e1:88d6:60e6 with SMTP id adf61e73a8af0-3f7a4cbff14mr6428821637.10.1794745334622;
        Sun, 15 Nov 2026 04:22:14 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:35d0:694a:1071:9bae])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdded58a9b9sm1220520a12.12.2026.11.15.04.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 04:22:14 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] scsi: mvumi: flush the event work before the host is freed
Date: Sun, 15 Nov 2026 21:21:53 +0900
Message-ID: <20261115122153.1446810-4-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115122153.1446810-1-yhlee@isslab.korea.ac.kr>
References: <20261115122153.1446810-1-yhlee@isslab.korea.ac.kr>
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

mvumi_launch_events() runs from the interrupt handler and hands a
DRBL_EVENT_NOTIFY off to mvumi_scan_events() on the system workqueue.
That work calls mvumi_get_event(), which dereferences the mvumi_hba it
was given, allocates an internal command from mhba->pdev and then waits
up to 45 seconds for the controller to answer it.

mvumi_detach_one() never waits for it.  It frees the interrupt, releases
the firmware resources and calls scsi_host_put(), which frees the
Scsi_Host the mvumi_hba lives in, while the work is still queued or
still parked in that 45 second wait.

Give the driver its own queue and destroy it in mvumi_detach_one() once
the interrupt is gone, so nothing can be queued after that point and
nothing is still running when the host is freed.  A work that was
already queued runs with the interrupt freed and its internal command
times out, which the preceding patch makes safe.  mvumi_probe_one()'s
error path needs the same order, because mvumi_io_attach() can fail with
the interrupt already enabled: flush the queue there once the interrupt
is freed, before mvumi_release_fw() takes away what the work uses.

In a KUnit model where the event command is left unanswered and the host
is put while the work sits in the wait, the work then reads the freed
host in 5 of 5 runs and in none of 5 with this patch:

[  111.616956] BUG: KASAN: slab-use-after-free in mvumi_scan_events+0xc83/0xd10
[  111.617010] Read of size 8 at addr ffff888009ff8908 by task kworker/1:1/30
[  111.617043]
[  111.617073] CPU: 1 UID: 0 PID: 30 Comm: kworker/1:1 Tainted: G    B            N  7.4.0-rc2-00716-g23c62304dde2-dirty #2 PREEMPT(lazy)
[  111.617126] Tainted: [B]=BAD_PAGE, [N]=TEST
[  111.617144] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  111.617173] Workqueue: events mvumi_scan_events
[  111.617258] Call Trace:
[  111.617304]  <TASK>
[  111.617354]  dump_stack_lvl+0x53/0x70
[  111.617438]  print_report+0xd0/0x630
[  111.617549]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[  111.617622]  ? mvumi_issue_blocked_cmd.isra.0+0x62b/0x940
[  111.617707]  ? mvumi_scan_events+0xc83/0xd10
[  111.617785]  kasan_report+0xe5/0x120
[  111.617871]  ? mvumi_scan_events+0xc83/0xd10
[  111.617950]  mvumi_scan_events+0xc83/0xd10
[  111.618052]  process_one_work+0x697/0x1060
[  111.618146]  ? __pfx___schedule+0x10/0x10
[  111.618207]  ? __pfx_process_one_work+0x10/0x10
[  111.618288]  ? _raw_spin_lock_irq+0x81/0xe0
[  111.618370]  ? __pfx_mvumi_scan_events+0x10/0x10
[  111.618466]  ? assign_work+0x11d/0x370
[  111.618578]  worker_thread+0x45b/0xd10
[  111.618688]  ? __pfx_worker_thread+0x10/0x10
[  111.618752]  ? __pfx_worker_thread+0x10/0x10
[  111.618840]  kthread+0x2c8/0x3b0
[  111.618910]  ? recalc_sigpending+0x15c/0x1e0
[  111.618968]  ? __pfx_kthread+0x10/0x10
[  111.619040]  ret_from_fork+0x36e/0x5a0
[  111.619127]  ? __pfx_ret_from_fork+0x10/0x10
[  111.619213]  ? __switch_to+0xac3/0xdc0
[  111.619254]  ? __switch_to_asm+0x33/0x70
[  111.619312]  ? __pfx_kthread+0x10/0x10
[  111.619399]  ret_from_fork_asm+0x1a/0x30
[  111.619484]  </TASK>
[  111.619542]
[  111.619596] Allocated by task 84:
[  111.619643]  kasan_save_stack+0x33/0x60
[  111.619703]  kasan_save_track+0x14/0x30
[  111.619754]  __kasan_kmalloc+0x8f/0xa0
[  111.619808]  __kmalloc_noprof+0x193/0x450
[  111.619860]  scsi_host_alloc+0x29/0x1290
[  111.619934]  mvt_setup+0x14e/0xa50
[  111.619997]  mvt_event_work_after_put+0x93/0x3f0
[  111.620063]  kunit_try_run_case+0x1ad/0x490
[  111.620096]  kunit_generic_run_threadfn_adapter+0x7b/0xe0
[  111.620153]  kthread+0x2c8/0x3b0
[  111.620212]  ret_from_fork+0x36e/0x5a0
[  111.620291]  ret_from_fork_asm+0x1a/0x30
[  111.620369]
[  111.620415] Freed by task 84:
[  111.620462]  kasan_save_stack+0x33/0x60
[  111.620509]  kasan_save_track+0x14/0x30
[  111.620542]  kasan_save_free_info+0x3b/0x60
[  111.620598]  __kasan_slab_free+0x43/0x70
[  111.620659]  kfree+0x121/0x390
[  111.620719]  device_release+0xc8/0x240
[  111.620790]  kobject_put+0x14d/0x280
[  111.620856]  mvt_event_work_after_put+0x22f/0x3f0
[  111.620907]  kunit_try_run_case+0x1ad/0x490
[  111.620961]  kunit_generic_run_threadfn_adapter+0x7b/0xe0
[  111.621035]  kthread+0x2c8/0x3b0
[  111.621083]  ret_from_fork+0x36e/0x5a0
[  111.621154]  ret_from_fork_asm+0x1a/0x30
[  111.621230]
[  111.621281] The buggy address belongs to the object at ffff888009ff8000
[  111.621281]  which belongs to the cache kmalloc-4k of size 4096
[  111.621321] The buggy address is located 2312 bytes inside of

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 13 ++++++++++++-
 drivers/scsi/mvumi.h |  2 ++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 48652640afc188..f58b29e55a3778 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1797,7 +1797,7 @@ static void mvumi_launch_events(struct mvumi_hba *mhba, u32 isr_status)
 			mu_ev->event = APICDB1_EVENT_GETEVENT;
 			isr_status &= ~(DRBL_EVENT_NOTIFY);
 			mu_ev->param = NULL;
-			schedule_work(&mu_ev->work_q);
+			queue_work(mhba->work_q, &mu_ev->work_q);
 		}
 	}
 }
@@ -2534,6 +2534,13 @@ static int mvumi_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	mhba->shost = host;
 	mhba->unique_id = pci_dev_id(pdev);
 
+	mhba->work_q = alloc_workqueue("mvumi_wq_%d", WQ_PERCPU, 0,
+				       host->host_no);
+	if (!mhba->work_q) {
+		ret = -ENOMEM;
+		goto fail_alloc_workqueue;
+	}
+
 	ret = mvumi_init_fw(mhba);
 	if (ret)
 		goto fail_init_fw;
@@ -2560,9 +2567,12 @@ static int mvumi_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 fail_io_attach:
 	mhba->instancet->disable_intr(mhba);
 	free_irq(mhba->pdev->irq, mhba);
+	flush_workqueue(mhba->work_q);
 fail_init_irq:
 	mvumi_release_fw(mhba);
 fail_init_fw:
+	destroy_workqueue(mhba->work_q);
+fail_alloc_workqueue:
 	scsi_host_put(host);
 
 fail_alloc_instance:
@@ -2590,6 +2600,7 @@ static void mvumi_detach_one(struct pci_dev *pdev)
 
 	mhba->instancet->disable_intr(mhba);
 	free_irq(mhba->pdev->irq, mhba);
+	destroy_workqueue(mhba->work_q);
 	pci_disable_device(pdev);
 	mvumi_release_fw(mhba);
 	scsi_host_put(host);
diff --git a/drivers/scsi/mvumi.h b/drivers/scsi/mvumi.h
index e248dfc1dd1bb7..04cd844851423e 100644
--- a/drivers/scsi/mvumi.h
+++ b/drivers/scsi/mvumi.h
@@ -493,6 +493,8 @@ struct mvumi_hba {
 	atomic_t fw_outstanding;
 	struct mvumi_instance_template *instancet;
 
+	struct workqueue_struct *work_q;
+
 	void *ib_list;
 	dma_addr_t ib_list_phys;
 
-- 
2.43.0

