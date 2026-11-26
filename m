Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795657016;
	b=XriNWBvdmOhKycQ6x1mtGZEU2EXYqk0vIBv4rGc6d2U8YKIKtljT/dgt/71cJxdXuI0d
	 vmEP/cotwIb4Ib7C69HIYmBcAw+KQ8tAqjfK/RL2JjTMQ5+ypK3LgDMdXrN3T5SPz+X93
	 9HEpx/6xZUBs/ZgJLGDZ6AprhHy5gMKqW4YH3q03CueY/9Kv8Pp2XtjB6uYvcwCaBXdzp
	 ZfcOWnOGOLpTbwsKCw33un93CLSwBx581sCJSMlq5kgLKq2hiK3GH2s/gUkz/RPZV59un
	 FkOPfmX03QMknxb6N2ITYhSyxlwgE07dfau2ElB/q7FaOwD9o7IqPdFHR300aFatxog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795657016;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0ONTDc/ySzGKj+/9hGNst87EjvfnG8jWay9zEngGSmA=;
	b=AUWtbk/vKgnFRxL2Zif73gDZanq0n4kOE8mLhUllIiaJ9UuyChZfl6qauX0aeB8hDpcp
	 RTZ8z7MCSxFEcmog3+NZVOMQwEeTMKuklc0CmyZvplfi5Vldt1sDpyz/rMo8f464v65/7
	 ldooLiRg3rcEsFnBIoOJ4sPWcrJSS5g0enGIWm8y1bC93a5KM8+kbCiRKBJPfUTIr5f10
	 bku8p/v9wjWb64cxPA7gtlGS9LfXolNSADZG8IhePwz4k0txogW6Ppup7h01SWjGpCoU1
	 Y8XNfjo+ctRUKDNrA6lCtNQ/ZzMsWvuxOJggA1XS0G4lb8VbnnXHaXt4xqhDv3UIm8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jCJMTtV3;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C58606A321
	for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2026 01:36:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28C58606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jCJMTtV3
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3b09a83d12aso4476502a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 17:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795657015; x=1796261815; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0ONTDc/ySzGKj+/9hGNst87EjvfnG8jWay9zEngGSmA=;
        b=jCJMTtV3Fg1ztxOOwJsoJtoeXuyMNNjxrZGGUgThjQOmuw7sXBhI4zCwRzbCdLu9tm
         5FpSTBHePOQQnduznAkRlDthCnoVEs+9UDcmQBlXGEFBvtNsQUz55JqvlrugZiwRNY7L
         2pHtRkuEER41k6K4C1AOwCqxnN0WvfKjob4aQ5iIk8c3b/fXi18+2wNCCutKhoKR3SQf
         HFCIlnHFVAJqyrB9FxPbtkO6tFsDS+fHovHHCkd5xn5dlHCgZsAzE+oZFB4qHglTuARd
         0IqUkMUVrbR6bebqCS/ydMkN89fOjEvQBefQ/hCy91UrwaPapvFUEoVFZIFYxhOFoZg1
         UKFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795657015; x=1796261815;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0ONTDc/ySzGKj+/9hGNst87EjvfnG8jWay9zEngGSmA=;
        b=khFj3Y0fd5aM/1I5kJYNDE9rc58p/XMhjG0ZJSDbXdERyP6721dnqU9y/KhnSB2niT
         CczDW20UMRmiPCiPqvyU3ufUKrBQZTtOZPXSX51tP+vpc71hTJxCpFhimTVMK+ojU/kS
         FeJAWmF4Ks3i46VzROfIpYoWceJQPQUoszurn5qkrXc8WwkbUSS5CeXigLN+OAJXr10V
         LHakGsekMTF683cLRqxoGr5QNkhROIMJ3kVVZVNcI+4aP76N1ZPxEOqWejOxlJwwPVH/
         gjqamx/v0aYFqh2pAlRQpwkQLpKSFbdmdUnIPMg3UgEel+FQAUmGGJboNi65+Soiw19z
         uQFg==
X-Forwarded-Encrypted: i=1; AL+hErH+0/JWyOO6e8sVQT9mo5zKaIoQ+dYtEXVoMnL7sWzGcZE2b/QiZ4Pa3iFnWVra6VQWTC4ONJ6ory+Y@vger.kernel.org
X-Gm-Message-State: APuU4Z/oudoSSWFYEGYzfEApYwMfLbDqZv8YuZzb8hdDRp3+xUuLk30M
	Qy3aKe50opfzNx1I8pUOFSkqY4tEkEcM0mN6rA2wXPIUIcXbqNCfgCxC
X-Gm-Gg: AZFdTZeOT+N8wytWSrSSNtSwV8d5pm3giB+WOPJWS44gC9SXHT60klTK8Oh+Spr3xtQ
	UN/89Y+ieUwHl1bZTIbdOg569LTAhh3cqatSPPjuVapaVHQ+L6y2xm27EoBHsdqOCwqhLldCa8+
	Ty/OHbg6ZsnUvYj6Sew+qXwDWozZy/FRH52u6kz64V7xV/RXN/NVXy6ZLBzt+TnoAO6KQt9KQMA
	LPSyuRprbxLEwXVUkmAn3t4LImZMTqTtzOxnT3zPQA13TjTHLXube5LMAKNOxBKjNrVwKWXLDLc
	NBueQZGV/l7EeNV7/ZNI2C0q5rIq8R7sa2BOg0nahkWHxW0yTOzWDM6lDIG0n71NngZaTIRj4b5
	Sc1k70+aXoeZNyCku5pRzl9Hd0z2AkYOIXqd4NYCUVb/wN1hGz7ncyqvg7KNInUchdGe1ibjXpB
	faSVN96MB7rPeDzVTR+2hVrKLQYfgaSvRQXoC0vOuKZ4hxfqBAXRxaUK1SqMWZm6gbeDNEnzIMG
	at0dWKbMut8QXZ3+dl54r0bPMr6aM4J/ld8D0ih5+q77Ss6lEkd/QsL7zoOst+xros+vQXzfvI8
	wfBipN1HhIy/K7Cm3w3HDPgoAk6qa7nv6uIZyWrP/ym57XN6ffjpE7YVbXTZtpsP+teK4JBVkWf
	mUi5teen8Eo5aHewl0JxpMaEEWfO4HoREY5MLdyWkTxQc5bY=
X-Received: by 2002:a17:90b:1dcd:b0:3b0:968f:fdef with SMTP id 98e67ed59e1d1-3b41c9758d8mr19690426a91.49.1795657015247;
        Wed, 25 Nov 2026 17:36:55 -0800 (PST)
Received: from lwq-server.tail118c18.ts.net ([74.176.208.23])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b44b21e19fsm11338967a91.0.2026.11.25.17.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 17:36:54 -0800 (PST)
From: Yaohan Li <shunsheng1218@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: target: core: use list_for_each_entry() in __core_scsi3_alloc_registration()
Date: Thu, 26 Nov 2026 09:36:50 +0800
Message-Id: <20261126013650.2169132-1-shunsheng1218@gmail.com>
X-Mailer: git-send-email 2.34.1
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

In __core_scsi3_alloc_registration(), the ALL_TG_PT=1 loop iterates over
dev->dev_sep_list with list_for_each_entry_safe() while dropping
dev->se_port_lock across each iteration.

list_for_each_entry_safe() caches the next entry pointer before the loop
body runs. While dev->se_port_lock is dropped, another CPU can remove
that cached next LUN via core_tpg_remove_lun(), calling
list_del(&lun->lun_dev_link) and poisoning or freeing it. On the next
iteration, the loop dereferences the stale cached pointer, causing a
wild-memory-access / general protection fault (or use-after-free).

Meanwhile, the current entry lun_tmp cannot be unlinked or freed while
dev->se_port_lock is dropped: the loop holds a live percpu_ref reference
on lun_tmp->lun_ref, and core_tpg_remove_lun() (the only site that
unlinks lun_dev_link) waits for transport_clear_lun_ref(lun) before
acquiring dev->se_port_lock and calling list_del(&lun->lun_dev_link).
After re-acquiring dev->se_port_lock and calling percpu_ref_put(),
core_tpg_remove_lun() still cannot unlink lun_tmp until dev->se_port_lock
is released.

Switch the loop to list_for_each_entry() so each step reads the current
lun_tmp->lun_dev_link.next under dev->se_port_lock. This prevents
dereferencing removed entries without skipping remaining live LUNs.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Yaohan Li <shunsheng1218@gmail.com>
---
Testing:
  Reproduced KASAN wild-memory-access [0xdead000000000100-0xdead000000000107]
  and general protection fault in __core_scsi3_alloc_registration() on
  unmodified 666539eecdf4 under QEMU/KVM x86_64 (CONFIG_KASAN=y,
  CONFIG_PROVE_LOCKING=y, CONFIG_PROVE_RCU=y, CONFIG_DEBUG_ATOMIC_SLEEP=y)
  using tcm_loop + configfs (4 loopback HBAs, SG_IO PROUT REGISTER
  ALL_TG_PT=1 racing with concurrent configfs port symlink unlink of the
  middle LUN HBA3 while a timing-only kprobe parks the walker at
  target_depend_item() on HBA2).

  With this patch applied:
  - inject (middle LUN HBA3 removed mid-walk): PROUT REGISTER returns
    SAM_STAT_GOOD (status=0); PR IN READ KEYS and PR IN READ FULL STATUS on
    all 3 surviving target ports (HBA1, HBA2, HBA4) confirm 3 registrations
    with key 0x1234567890abcdef and ALL_TG_PT=1; direct PROUT RESERVE,
    PR IN READ RESERVATION, and PROUT REGISTER key update on HBA4 (the
    surviving LUN after removed middle LUN HBA3) all return status=0.
  - ctl (same kprobe, no unlink): 4 keys / 4 full-status descriptors.
  - 0 KASAN, 0 GPF, 0 lockdep, 0 WARNINGs.
  - Compiled drivers/target/target_core_pr.o with W=1 (0 warnings).
AI assistance:
  AI tools assisted with initial defect triage, patch/commit-message
  drafting, and QEMU test-harness preparation; the author reviewed the
  locking and percpu_ref invariants, verified the historical Fixes commit
  and QEMU KASAN/lockdep results, and takes full responsibility for the
  patch.

 drivers/target/target_core_pr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index ca1a2802aa228..660772d4674aa 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -703,7 +703,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 	struct se_dev_entry *deve_tmp;
 	struct se_node_acl *nacl_tmp;
 	struct se_lun_acl *lacl_tmp;
-	struct se_lun *lun_tmp, *next, *dest_lun;
+	struct se_lun *lun_tmp, *dest_lun;
 	const struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
 	struct t10_pr_registration *pr_reg, *pr_reg_atp, *pr_reg_tmp, *pr_reg_tmp_safe;
 	int ret;
@@ -726,7 +726,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 	 * for ALL_TG_PT=1
 	 */
 	spin_lock(&dev->se_port_lock);
-	list_for_each_entry_safe(lun_tmp, next, &dev->dev_sep_list, lun_dev_link) {
+	list_for_each_entry(lun_tmp, &dev->dev_sep_list, lun_dev_link) {
 		if (!percpu_ref_tryget_live(&lun_tmp->lun_ref))
 			continue;
 		spin_unlock(&dev->se_port_lock);
-- 
2.34.1

