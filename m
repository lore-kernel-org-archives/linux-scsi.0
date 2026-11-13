Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794567647;
	b=GV3xsEsN9r2MqnHz+VO9a2a547mo74GMn6jeNy2tIkUoCejgbdm8LffUev1ZXqUIcGYF
	 YdwTCBcpOS5VeQBjhjr+j1Kb7ezk5WzFPsU+iBr548YHbREHMF2ZUq4QHUpuX8nZqZheE
	 4AuAvkCa9sXL1G6J8wDcfccvutyK5F9wUO+3ONkRyqVQMarydiybyArdAsnDU8Ink1NGJ
	 RD89NB9WU5Ks6Lz/BN7xUMhS8+hWRKbsNLoz/G6+hxymKkMDQNTvvp8ZBL8bAeXSMz9eB
	 biZ2IW0sv+lGzOuRw4ace/0n+bdp+JJHZ/iM/tD8xWvkENtEiQknikFCmTYClCp4LXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794567647;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=E0Spw+Wz+o3GYXN/Tq9YXE4Yt9eck1f5/t1doKsqquU=;
	b=pf5TkdZ5N6kdUNnPLatvq01Y+a/2R6dMFAUdwLKI6qMCAlQJTo8iA1g8ssFiUmEd9e2z
	 eeImBvYX2kwLTeb0y1kXM7Ukla8ehhAY8JyrRXHvtj5HqjoQMAT/hCzwHvO3kC/WwHc0a
	 dh2L23cU4EazTJ2HdTzKvgf22qjdgH4Me5vQQE+9aafqF4adBmwnsdTt4X1fGQQvvGfOo
	 rZqPw2bvXBei5hQAvbG8hA7kwBLlE/6sBvWSMYCjiQ+0J+SgZL1+JS0gTvXOhdz2gRkKT
	 nz3eg9bmNrDj2gmjSOYaTXrVUTBBWmIgwMsnPuGZB/QizDQF93KD2plz1QEQ2KZx1Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=IOhWIIOB;
	arc=none smtp.remote-ip=209.85.210.178
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6531606BDA8
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 11:00:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6531606BDA8
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=IOhWIIOB
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8a06e79e152so345686b3a.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 03:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794567646; x=1795172446; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=E0Spw+Wz+o3GYXN/Tq9YXE4Yt9eck1f5/t1doKsqquU=;
        b=IOhWIIOBXi9j/kk02rDsO6zNJ3cl7siqpWtb/Sj3TCpjHuCCw3yNel0d2DJ6FxfkT9
         TqyUISsm20FuA+0YFJuOApZYIEtui30MUBE/mGKK4spCG6HpYMaFOZ7h67CI8YJm5tCL
         5X2kd7djjo5wbnCsH+wJOC7nWwV1Rb8f5jH6Lnco8yieYaBV4vPrabyljUHnfQXZKt4s
         W+rpU6CCwNfMTpeBDZkgf1T92ZQXb8KxDb4q3rTd50F+c1cjfN6AL7b8vesSu7CFvPuW
         T9Z4N1TSB8vDQX5OtZ5NpWOSDHNFOM11I9IGp8yftqOOXaL6gTb0415Jx61Aa6+LxxjN
         O4bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794567646; x=1795172446;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E0Spw+Wz+o3GYXN/Tq9YXE4Yt9eck1f5/t1doKsqquU=;
        b=I0SrCOAFztXbtxMiU73Mqif13I0/OHp1qrNiY/0n/ID1QCp1IK63ubo0KvsJcAgk+d
         YPcZ4+Nhm5hp34AgJ1rFohc7/k+l2GFuj5UixvOSwVQcKDsdUUNTDgulNcezY0YDjX4+
         1lpMMgiseJAuV/KnVFWjlQL2/VQbqGRvmKS+PBDo80FNGXNqhoiHM5sxWmUWNJMW+d8+
         pzeGhCRxnvoM28ZtNOMrFFAzp347y4+YYSoCqWP3XZ0SSZ0OWrc1lKKUUUdGUuB72TdH
         FyY3IxAmWmljWpIaNs1tapwiWBtQzY2oMM4i0TXIsXrWoplDhmkwnGUYb7p+rVwXXMbV
         eehQ==
X-Forwarded-Encrypted: i=1; AL+hErG3FF0Cs2Y1y/IOFz6hHRi0nmN9KTZb3PXw7EAAO5c33mubhvCJwReiP7hgWW242nbvyZixlRPL7c2a@vger.kernel.org
X-Gm-Message-State: APuU4Z+2pzFhIy47RhY+URTcXd0nj6N/yYOH8RHsWXEN8XEYRUedvFgv
	tcGDHjgxHnct/Bmg10iEhtEmSmybA0wXFaIrW3SAS0n551Fbvz+H2U2dqvtQRssHzjc=
X-Gm-Gg: AYBFou1L8QVJtgdv0ktzWmI1LaN5LwzZfAYwmHM8CNKB/oKGEINnWOH6cJy7rHrZFvj
	/BEjAAiiXpUNMrGyoTlI0o0CT1bZ3QqgcTRADo4Z9l0O/1xr/w9/Z8Ca2xWo+SSqNTp3pjLLUep
	lr/c+X9uJwmDtM/0torhPLn2Blclxo4dueeX1mHSAYLYE15DkrR4EiCFSVUILxOhKOAAdfOdnQX
	u/7lT7KgY+QfSeQQjTTsuWW9Xrz/27IG3f4B7nXn8hhSjJ401aa5huuGbdylBXomv/ubrFL6Hg+
	RxlNGqJwKp+C0q0XfWig1URBWndfxqtfMN5Clg7G6QraeMEBbL3K7uvBn6RNQjugmEH4Fddh2ej
	uQUVYlbiNBRDvnfaBxs/UCVCfjcMKR4XxBBvboEOnFnHVhhPhYTG0lHSF0behnPNg02sYce2s++
	OyJpn76Wj8xWESzSBQipm+rAiKCndhO21huo6WRi5qSaruoUgEC9sOyVERoj9XepHlvyKfy3Swx
	FBUwF9b+2eQoxrSywjTFft63vSazYLqAm5eSpxm2cYRMmVV8YpKy1Z/NA1pzAXyx5JzlAiFTQgU
	Fm6AYbFNTnrPI0gyRDoQkCe+7kUaYFKt0ng140vsZCAVlMNQJR+ZU/oWXgN4Al2HvB9zRbxZCMt
	y2zIvT+QZmD0tLMVi+veYiafFn6jOQs/cEQtdJQ==
X-Received: by 2002:a05:6a00:2d0c:b0:8b1:d612:e945 with SMTP id d2e1a72fcca58-8beb753a01fmr2253520b3a.52.1794567645735;
        Fri, 13 Nov 2026 03:00:45 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:7e8c:590a:782b:a57b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bececce013sm945262b3a.6.2026.11.13.03.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 03:00:45 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: jgross@suse.com
Cc: sstabellini@kernel.org,
	oleksandr_tyshchenko@epam.com,
	xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	martin.petersen@oracle.com,
	stable@vger.kernel.org
Subject: [PATCH v2] xen/scsiback: disable the IRQ before draining in-flight requests
Date: Fri, 13 Nov 2026 20:00:36 +0900
Message-ID: <20261113110036.146860-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
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

scsiback_disconnect() drains the in-flight count before stopping the only
thing that can raise it.  scsiback_cmd_exec() (xen-scsiback.c:426) runs in
the backend's threaded IRQ handler, so a request can be admitted just after
wait_event() has seen zero, and its response is written later from target
core context by scsiback_send_response() (:347) - after the ring has been
unmapped, and on the scsiback_remove() path (:1268-1280) after kfree(info).

xen-blkback and xen-netback stop their request processing first:
kthread_stop() before reading ring->inflight
(xen-blkback/xenbus.c:290-304), and the kthreads and napi before
unbinding and unmapping (xen-netback/interface.c:673-700).

Call disable_irq() before the drain: it waits for a running handler, so
nothing is admitted afterwards, while info->irq and its event channel stay
valid for the responses written during the drain.  Unbind only once the
drain is done, with the ring still mapped until then.

Reproduced in a nested-Xen lab with KASAN.  Reaching the window needed two
test-only usleep_range() delays, one after wait_event() returns and one at
the top of scsiback_do_resp_with_sense() once the teardown has started.
With both off nothing was produced (4 rounds unpatched, 2 patched); with
both on the unpatched driver crashed in 6 of 6 valid cells, the patched in
0 of 5:

[  168.546709] BUG: KASAN: vmalloc-out-of-bounds in scsiback_send_response+0x516/0x5d0
[  168.551012] Write of size 4 at addr ffffc900000230a4 by task kworker/0:1/11
[  168.554757]
[  168.555908] CPU: 0 UID: 0 PID: 11 Comm: kworker/0:1 Not tainted 7.3.0-kCTLblk2-15482-g21a7f44fd076-dirty #10 PREEMPT(full)
[  168.555914] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  168.555918] Workqueue: target_completion target_complete_ok_work
[  168.555939] Call Trace:
[  168.555946]  <TASK>
[  168.555949]  dump_stack_lvl+0x64/0x80
[  168.555958]  print_report+0xd0/0x630
[  168.555966]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[  168.555978]  ? scsiback_send_response+0x516/0x5d0
[  168.555983]  kasan_report+0xce/0x100
[  168.555988]  ? scsiback_send_response+0x516/0x5d0
[  168.555992]  scsiback_send_response+0x516/0x5d0
[  168.555997]  ? __pfx_scsiback_send_response+0x10/0x10
[  168.556001]  scsiback_do_resp_with_sense+0x87/0x230
[  168.556007]  scsiback_cmd_done+0xc0/0x290
[  168.556011]  ? update_cfs_rq_load_avg+0x5a/0x560
[  168.556023]  scsiback_queue_status+0xd3/0x100
[  168.556028]  target_complete_ok_work+0x467/0xc30
[  168.556032]  ? __pfx_target_complete_ok_work+0x10/0x10
[  168.556036]  ? put_prev_task_fair+0x44d/0xa30
[  168.556039]  ? finish_task_switch.isra.0+0x1d9/0xa70
[  168.556047]  process_one_work+0x697/0x1060
[  168.556052]  ? __pfx___schedule+0x10/0x10
[  168.556058]  ? __pfx_process_one_work+0x10/0x10
[  168.556061]  ? _raw_spin_lock_irq+0x86/0xe0
[  168.556065]  ? __pfx_target_complete_ok_work+0x10/0x10
[  168.556069]  ? assign_work+0x11d/0x370
[  168.556074]  worker_thread+0x45b/0xd10
[  168.556078]  ? __pfx_worker_thread+0x10/0x10
[  168.556081]  ? __pfx_worker_thread+0x10/0x10
[  168.556083]  kthread+0x2c8/0x3b0
[  168.556090]  ? recalc_sigpending+0x15c/0x1e0
[  168.556094]  ? __pfx_kthread+0x10/0x10
[  168.556098]  ret_from_fork+0x373/0x5b0
[  168.556104]  ? __pfx_ret_from_fork+0x10/0x10
[  168.556107]  ? __switch_to+0x3c4/0xb40
[  168.556115]  ? __pfx_kthread+0x10/0x10
[  168.556120]  ret_from_fork_asm+0x1a/0x30
[  168.556127]  </TASK>
[  168.556129]
[  168.639704] The buggy address belongs to a vmalloc virtual mapping
[  168.642324] Memory state around the buggy address:
[  168.644439]  ffffc90000022f80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
[  168.647698]  ffffc90000023000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
[  168.650951] >ffffc90000023080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
[  168.669199]                                ^
[  168.671056]  ffffc90000023100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
[  168.674050]  ffffc90000023180: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
[  168.676974] ==================================================================

[  168.682117] BUG: unable to handle page fault for address: ffffc900000230a4
[  168.684784] #PF: supervisor write access in kernel mode
[  168.686797] #PF: error_code(0x0002) - not-present page
[  168.688797] PGD 100000067 P4D 100000067 PUD 10019c067 PMD 1001a1067 PTE 0
[  168.691319] Oops: Oops: 0002 [#1] SMP KASAN NOPTI
[  168.693246] CPU: 0 UID: 0 PID: 11 Comm: kworker/0:1 Tainted: G    B                7.3.0-kCTLblk2-15482-g21a7f44fd076-dirty #10 PREEMPT(full)
[  168.699142] Tainted: [B]=BAD_PAGE
[  168.700896] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  168.705056] Workqueue: target_completion target_complete_ok_work
[  168.707701] RIP: 0010:scsiback_send_response+0x1b6/0x5d0
[  168.710147] Code: 48 89 f8 83 e0 07 83 c0 03 40 38 f0 7c 09 40 84 f6 0f 85 60 03 00 00 48 89 d8 48 c1 e0 06 48 29 d8 48 c1 e0 02 48 8d 7c 01 40 <89> 94 01 a4 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1
[  168.718883] RSP: 0018:ffffc900000bfaa0 EFLAGS: 00010046
[  168.721447] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffc90000023000
[  168.724785] RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffc90000023040
[  168.727913] RBP: ffff88810a4a7238 R08: 0000000000000246 R09: fffffbfff0de2638
[  168.730938] R10: ffffffff86f131c7 R11: ffff888100077320 R12: 1ffff92000017f59
[  168.733902] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88810a6de200
[  168.736874] FS:  0000000000000000(0000) GS:ffff8881b034d000(0000) knlGS:0000000000000000
[  168.740171] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  168.742490] CR2: ffffc900000230a4 CR3: 0000000103271005 CR4: 0000000000770ef0
[  168.745350] PKRU: 55555554
[  168.746577] Call Trace:
[  168.747772]  <TASK>
[  168.748872]  ? __pfx_scsiback_send_response+0x10/0x10
[  168.751022]  scsiback_do_resp_with_sense+0x87/0x230
[  168.753109]  scsiback_cmd_done+0xc0/0x290
[  168.754847]  ? update_cfs_rq_load_avg+0x5a/0x560
[  168.756782]  scsiback_queue_status+0xd3/0x100
[  168.758630]  target_complete_ok_work+0x467/0xc30
[  168.760556]  ? __pfx_target_complete_ok_work+0x10/0x10
[  168.762644]  ? put_prev_task_fair+0x44d/0xa30
[  168.764512]  ? finish_task_switch.isra.0+0x1d9/0xa70
[  168.766584]  process_one_work+0x697/0x1060
[  168.768282]  ? __pfx___schedule+0x10/0x10
[  168.769973]  ? __pfx_process_one_work+0x10/0x10
[  168.771880]  ? _raw_spin_lock_irq+0x86/0xe0
[  168.773599]  ? __pfx_target_complete_ok_work+0x10/0x10
[  168.775721]  ? assign_work+0x11d/0x370
[  168.777324]  worker_thread+0x45b/0xd10
[  168.778899]  ? __pfx_worker_thread+0x10/0x10
[  168.780648]  ? __pfx_worker_thread+0x10/0x10
[  168.782415]  kthread+0x2c8/0x3b0
[  168.783877]  ? recalc_sigpending+0x15c/0x1e0
[  168.785697]  ? __pfx_kthread+0x10/0x10
[  168.787218]  ret_from_fork+0x373/0x5b0
[  168.788752]  ? __pfx_ret_from_fork+0x10/0x10
[  168.790500]  ? __switch_to+0x3c4/0xb40
[  168.792029]  ? __pfx_kthread+0x10/0x10
[  168.793555]  ret_from_fork_asm+0x1a/0x30
[  168.795180]  </TASK>
[  168.796205] Modules linked in:
[  168.797596] CR2: ffffc900000230a4
[  168.799084] ---[ end trace 0000000000000000 ]---

Fixes: d9d660f6e562 ("xen-scsiback: Add Xen PV SCSI backend driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v2:
- disable the IRQ before the drain and unbind it after the drain, instead
  of unbinding first, so info->irq stays valid for responses sent during
  the drain (Sashiko)
- dropped Juergen's Reviewed-by since the code changed
  v1: https://lore.kernel.org/all/20261109122654.30859-1-yhlee@isslab.korea.ac.kr/

Reported to the Xen security team first; xen-scsiback is not security supported, so posting here as suggested.

 drivers/xen/xen-scsiback.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index c7036e0e41bda1..4204b555c908c7 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -603,6 +603,9 @@ static int scsiback_gnttab_data_map(struct vscsiif_request *ring_req,
 
 static void scsiback_disconnect(struct vscsibk_info *info)
 {
+	/* Stop admitting requests before draining the in-flight ones. */
+	disable_irq(info->irq);
+
 	wait_event(info->waiting_to_free,
 		atomic_read(&info->nr_unreplied_reqs) == 0);
 

base-commit: 067c5c24cef23d913b67eaaf71ae67e7169a6620
-- 
2.43.0

