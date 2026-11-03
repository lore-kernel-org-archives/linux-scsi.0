Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793732374;
	b=IUY0DAmnL3VAgkP1Bs8mWeNi2MnJZy1Aoo6plW57OoRKlGrmzaCePAyzn8a+qqLF7U40
	 t57IYet47opyY8Z7z98S2kVHdguObLEaWn6DENo9GWqRD3XkPKtec15pGNp0NmaKzTAkv
	 9THj0MCJU435/hZsp93Ehbj1T5dhVdjgW3E/98YLkw39U2EuAcONeFHa1bV4GiRcNx/1Q
	 mrA/WU4IT+zfjPKY0w5zQvrHtxwKsBD+JRBtI0bmk1Su2XSz4yyCuzyYsV6aiy9ufD0Ld
	 9cSNSkjMzauzGoF7zt8XCW2/UTInArsxkNNc9pcMQdLl83lUmJ5esN8WTqn5EQnZgCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793732374;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=bt8zI+uZoNGoZFvS1umYm2OEZ8ZGy+WSdchUMDGM+5Y=;
	b=WSWAcaPtPuSmxwONTHlbvufYNwM8lpeo/w/MBy2C+3WAfmyDrpYiyaFAey5vyLSVv44m
	 3fOCIOWH6jDqRR+YS5D5tOMKTV26quPc+ef01aSCHHEm7TV7nk4/2Yc7gICB8l/+HpRh1
	 6CK4K841TST7YRvnYaZudExhUWcPctEiCUVIiWHompHNqRLWk5gUpS9sbOBn/mbX+032N
	 wP2NGAM5eNAJJNa3FBjjg1syk8Ic8vCtPmkKwLALPj6T74vMbpukFUeBpL5x518ky4ZVJ
	 m9kU0SvDuJUtQ3PodACXu3Y4YA682RZXMALt64L9aLDbqXzytQ1r6BnarwANFroxnUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.35
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498C0606A335;
	Tue,  3 Nov 2026 18:59:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 498C0606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jJyYG6hNsz8Xrr9;
	Wed, 04 Nov 2026 02:59:30 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 6A3IxKnB077140;
	Wed, 4 Nov 2026 02:59:20 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 4 Nov 2026 02:59:24 +0800 (CST)
X-Zmail-TransId: 2afa6aea2f0cb8f-d30d5
X-Mailer: Zmail v1.0
Message-ID: <202611040259247915t_cYYK0k5pPbEqfdTAQu@zte.com.cn>
Date: Wed, 4 Nov 2026 02:59:24 +0800 (CST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <martin.petersen@oracle.com>, <alim.akhtar@samsung.com>,
        <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>
Cc: <james.bottomley@hansenpartnership.com>, <peter.griffin@linaro.org>,
        <beanhuo@micron.com>, <stanleyjhu@google.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHYyIDAvMl0gc2NzaTogdWZzOiBmaXggYW4gUlBNQiB0ZWFyZG93biBjeWNsZSBhbmQgYSBzaGlmdCBVQg==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A3IxKnB077140
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Wed, 04 Nov 2026 02:59:30 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEA2F12.000/4jJyYG6hNsz8Xrr9

Two independent fixes in the UFS stack, found while reading the probe and
remove paths and the task-management hooks.

Patch 1 is in the core RPMB glue.  ufs_rpmb_probe() registers a child
device whose parent is the RPMB device, then registers an rpmb_dev on top
of it.  device_add() takes a reference on the parent, and
rpmb_dev_unregister() is only called from ufs_rpmb_device_release(), i.e.
when that reference count drops to zero.  The remove path and the probe
error path call device_unregister() on the child directly, so the
reference held by the rpmb_dev never goes away, the release callback never
runs, and the RPMB child stays registered while the devm-allocated
ufs_rpmb is freed together with the host.  Unregister the rpmb_dev first,
as mmc_blk_remove_rpmb_part() does, and let the release callback tolerate
an already unregistered device.

Patch 2 is in the Exynos host driver.  The nexus type masks are built with
(1 << tag); controllers can expose 32 unified task tags, and tag 31
shifts a 32-bit int into its sign bit.  Commit 01aad16c2257 fixed the
same expression in exynos_ufs_post_link() and noted that the UTMRL access
should be changed as well, but the four remaining mask computations were
missed.

The patches share no code: patch 1 is the core RPMB glue, patch 2 is
confined to the Exynos host hooks, so they can be applied in any order and
need review from different people.  Both carry Fixes: and Cc: stable.

Related work: Dmitry Baryshkov's "scsi: ufs: rpmb: register and unregister
the ufs_rpmb bus" (September 2026) is still under review; the teardown fix
in patch 1 becomes reachable once that patch lands.  Stanley Jhu's earlier
series ("scsi: ufs: rpmb: Fix bus registration and device lifecycle", v3,
September 2026) also calls rpmb_dev_unregister() in ufs_rpmb_remove() to
break the cyclic refcount, but it is not in linux-next as of next-20261030.
This patch is the narrower fix: unregister the rpmb_dev before the child
device and let release tolerate an already unregistered device.

Testing: both apply to v7.4-rc1 (Martin's for-next tip, 6628e7d4c6b2), pass
checkpatch.pl --strict with 0 errors/0 warnings/0 checks, and the two
touched objects build with W=1.

Patch 1 was exercised on QEMU/x86-64 with a synthetic hba and a fake RPMB
WLUN, on top of Dmitry's still unmerged "scsi: ufs: rpmb: register and
unregister the ufs_rpmb bus" patch - without it device_register() fails
with -EINVAL and the teardown path is unreachable.  Before this patch,
ufs_rpmb_remove() leaves the rpmb0 class device registered because the
child device is never released; with it, rpmb0 is gone.

Patch 2 was exercised with a synthetic hook that calls both nexus helpers
with tag 31 in a UBSAN kernel.  The unpatched and the patched code write
the same value (0x80000000), because GCC wraps the undefined signed shift
under -fno-strict-overflow; no runtime symptom was observed, and the
patch is a well-definedness cleanup that matches the BIT() usage added by
01aad16c2257.  There is no Exynos board on this machine, so the driver
itself was not probed.

Changes in v2:
- Rebased onto Martin's for-next (v7.4-rc1, 6628e7d4c6b2).  v1 was generated
  against linux-next next-20261030 (7649ba73f9e7), which is not an ancestor
  of for-next, so the series did not apply there.  No code changes.
- Patch 2: dropped the claim that the shift trips UBSAN.  Testing shows GCC
  wraps it under -fno-strict-overflow, so it is a well-definedness cleanup.
- Refreshed the testing paragraph for the new base.

v1: https://lore.kernel.org/all/20261103185229490gmhePBF5_11x_thf4X-Rw@zte.com.cn/

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
