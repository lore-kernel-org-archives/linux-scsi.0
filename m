Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794227224;
	b=rsiI/OBz2LsR5KPw3ntsx4EY4NlveBt28NLWjXf1FnnafEMfsCm+pT95ELuOI2cbmp1F
	 +PiqjQ1StcUNocbNBKzthzcjIAHba+1bUBA3P2iKdXfY3SR2brGrG2GG+O5Ixu6M5CXGM
	 R4RPTb0vK/eAsPdRKBRqItgGwpmn/vWq7yhVMFFYFT+OXZtuVdU5YuDST1ae74EgWR7Bg
	 gfefBThu/AbfjbfaRhWMy+cZQNJ6fKiys85M52sAWE3q9H8wGIJRUFdSqgS+YPd5Az1tJ
	 7AZWkTxtxtSl3qw2tWbFI1xtph3Y8lhD+JN9a4tG1pDhizgTVkc7I6JVuyrI8mA99Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794227224;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=auUowkHUVqWY9moHr++cNLc5S5EI9m+OJlbauxvV4NY=;
	b=eraDW6qoFz49GfL/Hq5GvuBO63Mj0WABNHvCDDU4logQn8JmvqnpCQUeQ/dKBkkuPyk9
	 uZq0bp8g22Zhnflftk9XzMhvA2XjPQEX+WO+QHKeJZBBZ7r5gn05vqpL2Ke8EJfCIr+Gi
	 N99x+487/h9VQt1cP4lIVYqxENn2rn1suWMVj+rXW3ErLFotVt43aGeD+inJ6XPj4rzp2
	 D464N7PRPldYeUdyFky5DGCU5oFYlH0M8ccrY6yL/PAhYClVaJWZUbgDCNXmIObt9kDId
	 FOlVjud/WT+kGahxv3jC8UYcyhELpXhTlVS4AGPBBw8+RB0GuVKO8mGhje7vHGYiCrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="hF9v/iM+";
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C506606A323
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 12:27:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C506606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=hF9v/iM+
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ea7987517aso4147675ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2026 04:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794227222; x=1794832022; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=auUowkHUVqWY9moHr++cNLc5S5EI9m+OJlbauxvV4NY=;
        b=hF9v/iM+iAvg7OK8eDWvCBJ50ibWpYv/0iDi6SeUp2pCDSNpw8yai7Ixk2dEbhTqA6
         U0fIR4BaR4BEGwPWzbz2HVd5g3z21+9wVpzdu4+SqK20i1ZFUmLkXQmO1NqpOvV0tBh1
         uODC96F9nH1fk0mlnV23kGIulphdQ1wTmKISYxWeLbsyAupC69VIs/KaGEn76Yx8+G8j
         mIMLJ2zSn37orQ3TI1/Xhzp65heshCB5/RTl8MHeXsLfbQQFTytbaC2iS+o9xD5K2fbf
         emx5gGPHzXbdUpGgqqX338/zqzQa1dfTtKvrLISNFC6Q6PJS3pPLBydwdjOTjn6DwxOX
         NB2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794227222; x=1794832022;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=auUowkHUVqWY9moHr++cNLc5S5EI9m+OJlbauxvV4NY=;
        b=PqyLg/66+mAWvtzCbbhpdrtuU8vZaPT85gLlBdtb1aqWYUJH+XmoGpUhn+tCVYIeJa
         ZyCvaNSWibaNnLxqJKG08QxF/VI6u0DHdweCtBDW8GxnW2w/6/S06vx8yoFj3b8nisMB
         5cOuEOABRkSermA+/NQkPc+sV4Xxc3AkE62Kjm6iJiVXrlPvpwM/zmoQE/2thGUQKuyG
         o6gsrzlE1YmNQsMCXYa6ccFiRLM/KD+xwm4fwRn3UCz5RzKYQb88RpZGJOgjospL3V+b
         ALhoNx9wbxGEpLqjTkF2mYSn//SKlbsZDAjiGWR8wg7DLkcZHVizKRNkOeHmMUj/PmE9
         zXBA==
X-Forwarded-Encrypted: i=1; AL+hErH9swdIdFVgfL7pl3GLySdRo2JL/YB3oedv+pR7Xey3vgFn1YH3s6d2+mUI1049dLB2JViq3cNbEnKu@vger.kernel.org
X-Gm-Message-State: APuU4Z85MKC8gBXn/LGomP5w3GFbTL4DdTSxX3yfopw4QgZ3ZjuezP86
	k0B17IS5HcojgS4ZUsdEPTDGQs4RrkyrEDpBAWjVycA0jx047WI6Dhk/mBgwCGD3yJ0=
X-Gm-Gg: AYBFou2QSuTwkfhWFw5QpHkM0+/yaftDEf0dXNUzKqMB/xTzveKjL5EMhz/isgi3Z4s
	9npj9QHWQzJCDa4S4tJaQtwcIXzzTdmNNvIMSO0e/Lm91pn1tAjUKawVsHdfYaFgPiE4aX0R/Qv
	I1mk3Vd5p7wNFWzE8IF8znYOr0Xsjb2L+oQbEoW1VzZMYpdiowPlxeiIddq5XMxlPYC+YtMZUZy
	EimHJds01L3fVawt9Z7WF12nRvCo+klf+sQluU9x2y4YTL/noMPdEyOVGBMZ4PcQlhDBNllZxym
	tzIl4E1NhGpujFL9G+U6zL+cFZpQE8ksCK3+qEX9dl7EjDdGw87IU7VFm98ivXlqKUq+PDU3yF9
	s40Olz6t49CBk/t/RJWZbOF5nKR3i35lKZprCw7o4HPOu2p8KHtA1b8d/FGopC+++Izr6JemhHI
	VapHWylOV96ziFWRQHiCvIp6YPgC7/7UmnF7xO0IWc+/0eVofn0sUWIFrIqS7uiKaZ/ADoPZOcn
	7Do8Xvn2GPTAdP0UgDgsOtWlAwcYuzysm0qtvzS7NfPrE2dQSvIy8d3awXGJviIlmu4mGElLeLR
	UQdI92umy2Gh7HXL8YwIEkFklb0Dasu52sGSJ9uViVG/i/+WVIFvHA3RHPwCs0YvhUZBZTdh6gi
	DPacBbKr73H7IPRlv4yOSApjNZVPWjMYlbjG612HEKXohv1bbbSphChhiiUA=
X-Received: by 2002:a17:902:d547:b0:2ed:2305:5244 with SMTP id d9443c01a7336-2ed8379d007mr36355115ad.46.1794227222400;
        Mon, 09 Nov 2026 04:27:02 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:3d70:1891:1a66:b169])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed81734d95sm9934985ad.65.2026.11.09.04.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 04:27:01 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: jgross@suse.com
Cc: sstabellini@kernel.org,
	oleksandr_tyshchenko@epam.com,
	xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	martin.petersen@oracle.com,
	stable@vger.kernel.org
Subject: [PATCH] xen/scsiback: unbind the IRQ before draining in-flight requests
Date: Mon,  9 Nov 2026 21:26:54 +0900
Message-ID: <20261109122654.30859-1-yhlee@isslab.korea.ac.kr>
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

Unbind and clear info->irq before the drain: nothing is admitted once the
handler is gone, and the ring stays mapped until the drain finishes.  The
notify at the end of scsiback_send_response() is then a no-op, because
notify_remote_via_irq() resolves irq 0 through evtchn_from_irq() to port 0,
which VALID_EVTCHN() rejects (events_base.c:539-545, :411-421).

Reproduced in a nested-Xen lab with KASAN.  Reaching the window needed two
test-only usleep_range() delays, one after wait_event() returns and one at
the top of scsiback_do_resp_with_sense() once the teardown has started.
With both off neither arm produced anything in 4 rounds each; with both on
the unpatched driver crashed in 6 of 6 valid cells, the patched in 0 of 7:

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
Reported to the Xen security team first; xen-scsiback is not security supported, so posting here as suggested.

 drivers/xen/xen-scsiback.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index c7036e0e41bda1..647a3c7e2a2b39 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -603,11 +603,13 @@ static int scsiback_gnttab_data_map(struct vscsiif_request *ring_req,
 
 static void scsiback_disconnect(struct vscsibk_info *info)
 {
+	/* Stop admitting requests before draining the in-flight ones. */
+	unbind_from_irqhandler(info->irq, info);
+	info->irq = 0;
+
 	wait_event(info->waiting_to_free,
 		atomic_read(&info->nr_unreplied_reqs) == 0);
 
-	unbind_from_irqhandler(info->irq, info);
-	info->irq = 0;
 	xenbus_unmap_ring_vfree(info->dev, info->ring.sring);
 }
 

base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.43.0

