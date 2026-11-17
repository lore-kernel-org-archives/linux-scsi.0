Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794922978;
	b=K1orgAT0BJtJV2ncuetAoT94gkZGHr0fjqXdtrHD3t6bdGnJIdD0tIXKxAwXbe+WIP7J
	 GjjhEFr680P+HXXH7RiWRFaaHNpmVS6okECCMZer315YYWeOtQvww4U2aM2FLT5000imW
	 4C6sMzuNCXHIxH7SKZyfoOs/+vQiZ0xgNmMpSzkssE4yhQ+po7RFDDn6mnTNFXPTrTknC
	 00Z/e5fietjlfGVaCNe2hr5nPGYqxf5+LAr4G1xx3HEGqTqzuBnOItCpxgy7lUBOhXrpm
	 QBmQvpkJPlWo8U4b6hG2KYe8z/zPwFeigMOqBGd4OSK5ZQVhtxtPNlUyIXKvPOYfPnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794922978;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wu8+kFcsb4sAmE39UqIaqxXHcduGAo9od3bMzZjIHWY=;
	b=uJFsenKc77hVVTUjp5ZddC5lCq1sNchP0ocmS2LXfD2dyCYXFcAB2atOJ00D1j280nuj
	 +DrAu8z4dvL3x1T/ELEQ0HQdOipg0Y52STh7B8oylNzay9MbVtuxXnQ4wg/rFPa+WR7Q1
	 d3kZFrmp0dfcou/j/BpyNOjeF9lybBtXh4dcY2i7EX1lKGsNJAmn6a3iHAnztdgb5ls6O
	 LXKyEUPQgNfkFLBXH/VSPHrtuR+9zNFSc8guvWONgg2zr6+jAuhnXdGHz3RLuUeIueaWa
	 ZzUoOCWZxEm2fIWnWK7fky+/MT/5fulkEMqXZqHACVsD2ffj7d+ttl6nAdc4yfTPgcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=RE2+kfRo;
	arc=none smtp.remote-ip=209.85.210.169
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF18F606A88B
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 13:42:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF18F606A88B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=RE2+kfRo
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8b32bc605d9so2169685b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 05:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794922977; x=1795527777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wu8+kFcsb4sAmE39UqIaqxXHcduGAo9od3bMzZjIHWY=;
        b=RE2+kfRoVYnHaac858u71bMgFZKdGJ9vr/53YzIUJ1/PyR6rpplzGk1Z1wVdrfXjrz
         q1mTVuTswi7nEUWlP8JezhKeK8L4gRKwWhKI/hZMUMHg8vg7rYv6ns0JedK6fSPF8Buu
         qbNcg8gPl0gZFfqrOfrYlw40ELHxEkhClvvfs1tS7qFEWzBLZPmrleAkK0PfB0o6bqEm
         KUZEgTvVyRRU4n2O/9CvyMUMOpzKRsikii4KpyZYJ80p4SkpcJZNHmAqdHMO0qZus21b
         sL23PGXbZBYMqZTAOodCmKUf8K5QhJrrOsHzwLr6MXT4HeJqOhXLIw5SHfqltluAWyVa
         w5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794922977; x=1795527777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wu8+kFcsb4sAmE39UqIaqxXHcduGAo9od3bMzZjIHWY=;
        b=hRDbnkTUVGpBtnJk12Gz7BQc/cY/kSiWiFQNa1qzdGVxOIOA2gsmiNa/R5ES4b5xZ0
         p/kcg/cPA5isZKD02ZlmnXBDvgDiRChjNFKYtn4ylJOlSn08mgenjd6YB2Iu4HdqmKZq
         e7vn/w0zhFBdaEWdfwSEKU5YKWUdMKqqYQsvjUHCknBm+vaoXGS6WmJVh9z+fHUPm74r
         QVUHTcaiLT/GgC8Udu5meJyUNUmx2eroEpIIpMbx0bMZprMGUyBRecH1T07Iaby+4SQC
         NcPLqaWjDPGts2geZQLpW71uMRRjE6+JhvWPDXhVtrtDRxtngK/Jf9h8LzyoLWjHs0zQ
         X0mg==
X-Gm-Message-State: APuU4Z8piEEQFCykXZtCoY8/lPNCbcjXp8myJDU7RGdXcKfjOftbH6Ar
	k3v7z/7V9I1zKmYur8I9NqXtCLxzt3+vh2g+HrDNy/e34aZc8sQK12GrSnR+ZRmk/pM=
X-Gm-Gg: AYBFou0nl8zp4cNUMq9Ia3QhcmP80iccxTy3V5pt0ae84eX/bT3C+LlXNH2Iv/CSkwl
	7ZtwgfRDBTncVgZ4wuV0dcSj0kBSWDiT4Zg77OaYs+XRH2xOfGMm1f/T2mx6cSW2Yu1A2MEY21I
	/bxWKM477mf7oIO44uHG9ZIGJ5R/kjNEDjN4jq3jH1Ckro13+pKHVkSvenji3hWX6FMqtGeahW9
	ltKKtm+6gHo7izkUrkWFI5t3gHWaEKXAAOSAEz3mQiJN4Wa6SNxe9upiuPokzcA/tFhDjKN0dAl
	tkalQcvKcyz8rklgxrKoZxNfMK7OpnfA9OZD3QG4/MxQwBEavZF5Ai98k6gLcFrdxG6oGQwUcUa
	afFHZZ1l5swHV0oFcPXTLCtNzv3w7+StjSbdtbXgIzOWLoSVJCpVCQQyFI1ILfQaOrjoK42YFnC
	2wZmQWWeMZpERdj2YRM5L1bEE2CGpV7dndOAXBS9/PWzrAnqwaGTFc/r3pcuXvUp7f5npI32K9O
	DUi4vCfDH46xL2XH8uyC5W1dS70aVLcwXYmCjrWK9FNrqcNrWUcz119ntFbIKLiRdODT+C1FHcY
	TBKPSu1JZzDcpcTiF+Fa6tX7lZJqVscP/SstSWUnLiaNfvM1QWzKbnuESW0UbhqA8zYM5Ho/65q
	Y+pxhOkY2DF82dZ1Wg9Df4D0yU5CBQpM/e1GKfQ==
X-Received: by 2002:a05:6a00:94ed:b0:89e:43ee:654d with SMTP id d2e1a72fcca58-8beb2e7e0f8mr12824032b3a.5.1794922977062;
        Tue, 17 Nov 2026 05:42:57 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:73df:c7da:8e76:82c5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed12a8024sm5040714b3a.11.2026.11.17.05.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 05:42:56 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zilin@seu.edu.cn
Subject: [PATCH v3 3/3] scsi: mvumi: flush the event work before the host is freed
Date: Tue, 17 Nov 2026 22:42:27 +0900
Message-ID: <20261117134227.2077013-4-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117134227.2077013-1-yhlee@isslab.korea.ac.kr>
References: <20261117134227.2077013-1-yhlee@isslab.korea.ac.kr>
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

mvumi_launch_events() queues mvumi_scan_events() on the system workqueue
from the interrupt handler.  The work dereferences the mvumi_hba and can
wait up to 45 seconds for an internal command, but mvumi_detach_one()
frees the interrupt and calls scsi_host_put(), which frees the
mvumi_hba, without waiting for it.

Give the driver its own workqueue and destroy it in mvumi_detach_one()
after free_irq(), so the work has finished before the host is freed.
mvumi_probe_one() can fail in mvumi_io_attach() with the interrupt
already enabled, so flush the queue there as well after free_irq().
Also clear bus-mastering before mvumi_release_fw() on that path, because
pci_disable_device() runs further down and must not be called twice.

In a KUnit model where the event command is left unanswered and the host
is put during the wait, the work reads the freed host in 5 of 5 runs
without this patch and in none of 5 with it:

[  107.519931] BUG: KASAN: slab-use-after-free in mvumi_scan_events+0xc83/0xd10
[  107.519976] Read of size 8 at addr ffff88800a0d8908 by task kworker/0:0/10
[  107.520007]
[  107.520033] CPU: 0 UID: 0 PID: 10 Comm: kworker/0:0 Tainted: G    B            N  7.4.0-rc2-00716-g23c62304dde2-dirty #1 PREEMPT(lazy)
[  107.520086] Tainted: [B]=BAD_PAGE, [N]=TEST
[  107.520103] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  107.520128] Workqueue: events mvumi_scan_events
[  107.520173] Call Trace:
[  107.520200]  <TASK>
[  107.520220]  dump_stack_lvl+0x53/0x70
[  107.520290]  print_report+0xd0/0x630
[  107.520356]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[  107.520400]  ? mvumi_issue_blocked_cmd.isra.0+0x62b/0x940
[  107.520493]  ? mvumi_scan_events+0xc83/0xd10
[  107.520569]  kasan_report+0xe5/0x120
[  107.520650]  ? mvumi_scan_events+0xc83/0xd10
[  107.520730]  mvumi_scan_events+0xc83/0xd10
[  107.520800]  process_one_work+0x697/0x1060
[  107.520920]  ? __pfx___schedule+0x10/0x10
[  107.520976]  ? __pfx_process_one_work+0x10/0x10
[  107.521032]  ? _raw_spin_lock_irq+0x81/0xe0
[  107.521111]  ? __pfx_mvumi_scan_events+0x10/0x10
[  107.521159]  ? assign_work+0x11d/0x370
[  107.521222]  worker_thread+0x45b/0xd10
[  107.521304]  ? __pfx_worker_thread+0x10/0x10
[  107.521357]  kthread+0x2c8/0x3b0
[  107.521435]  ? recalc_sigpending+0x15c/0x1e0
[  107.521515]  ? __pfx_kthread+0x10/0x10
[  107.521564]  ret_from_fork+0x36e/0x5a0
[  107.521612]  ? __pfx_ret_from_fork+0x10/0x10
[  107.521672]  ? __switch_to+0xac3/0xdc0
[  107.521738]  ? __switch_to_asm+0x33/0x70
[  107.521793]  ? __pfx_kthread+0x10/0x10
[  107.521860]  ret_from_fork_asm+0x1a/0x30
[  107.521922]  </TASK>
[  107.521951]
[  107.521987] Allocated by task 84:
[  107.522047]  kasan_save_stack+0x33/0x60
[  107.522101]  kasan_save_track+0x14/0x30
[  107.522179]  __kasan_kmalloc+0x8f/0xa0
[  107.522259]  __kmalloc_noprof+0x193/0x450
[  107.522291]  scsi_host_alloc+0x29/0x1290
[  107.522374]  mvt_setup+0x14e/0xa50
[  107.522441]  mvt_event_work_after_put+0x93/0x3f0
[  107.522475]  kunit_try_run_case+0x1ad/0x490
[  107.522544]  kunit_generic_run_threadfn_adapter+0x7b/0xe0
[  107.522643]  kthread+0x2c8/0x3b0
[  107.522704]  ret_from_fork+0x36e/0x5a0
[  107.522787]  ret_from_fork_asm+0x1a/0x30
[  107.522855]
[  107.522880] Freed by task 84:
[  107.522898]  kasan_save_stack+0x33/0x60
[  107.522974]  kasan_save_track+0x14/0x30
[  107.523086]  kasan_save_free_info+0x3b/0x60
[  107.523140]  __kasan_slab_free+0x43/0x70
[  107.523198]  kfree+0x121/0x390
[  107.523275]  device_release+0xc8/0x240
[  107.523349]  kobject_put+0x14d/0x280
[  107.523383]  mvt_event_work_after_put+0x22f/0x3f0
[  107.523459]  kunit_try_run_case+0x1ad/0x490
[  107.523523]  kunit_generic_run_threadfn_adapter+0x7b/0xe0
[  107.523576]  kthread+0x2c8/0x3b0
[  107.523638]  ret_from_fork+0x36e/0x5a0
[  107.523724]  ret_from_fork_asm+0x1a/0x30
[  107.523762]
[  107.523803] The buggy address belongs to the object at ffff88800a0d8000
[  107.523803]  which belongs to the cache kmalloc-4k of size 4096
[  107.523833] The buggy address is located 2312 bytes inside of
[  107.523833]  freed 4096-byte region [ffff88800a0d8000, ffff88800a0d9000)
[  107.523880]
[  107.523929] The buggy address belongs to the physical page:
[  107.523978] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xa0d8
[  107.524037] head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[  107.524111] flags: 0x100000000000040(head|node=0|zone=1)
[  107.524155] page_type: f5(slab)
[  107.524248] raw: 0100000000000040 ffff888007042140 dead000000000122 0000000000000000
[  107.524319] raw: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
[  107.524422] head: 0100000000000040 ffff888007042140 dead000000000122 0000000000000000
[  107.524457] head: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
[  107.524543] head: 0100000000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
[  107.524592] head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[  107.524625] page dumped because: kasan: bad access detected
[  107.524660]
[  107.524681] Memory state around the buggy address:
[  107.524725]  ffff88800a0d8800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  107.524772]  ffff88800a0d8880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  107.524817] >ffff88800a0d8900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  107.524862]                       ^
[  107.524927]  ffff88800a0d8980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  107.525003]  ffff88800a0d8a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  107.525025] ==================================================================

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 15 ++++++++++++++-
 drivers/scsi/mvumi.h |  2 ++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index fe3f63a1088dc1..79086e2dd22e39 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1807,7 +1807,7 @@ static void mvumi_launch_events(struct mvumi_hba *mhba, u32 isr_status)
 			mu_ev->event = APICDB1_EVENT_GETEVENT;
 			isr_status &= ~(DRBL_EVENT_NOTIFY);
 			mu_ev->param = NULL;
-			schedule_work(&mu_ev->work_q);
+			queue_work(mhba->work_q, &mu_ev->work_q);
 		}
 	}
 }
@@ -2544,6 +2544,13 @@ static int mvumi_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -2570,9 +2577,14 @@ static int mvumi_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 fail_io_attach:
 	mhba->instancet->disable_intr(mhba);
 	free_irq(mhba->pdev->irq, mhba);
+	flush_workqueue(mhba->work_q);
 fail_init_irq:
+	/* mvumi_release_fw() frees buffers the controller was given */
+	pci_clear_master(pdev);
 	mvumi_release_fw(mhba);
 fail_init_fw:
+	destroy_workqueue(mhba->work_q);
+fail_alloc_workqueue:
 	scsi_host_put(host);
 
 fail_alloc_instance:
@@ -2600,6 +2612,7 @@ static void mvumi_detach_one(struct pci_dev *pdev)
 
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

