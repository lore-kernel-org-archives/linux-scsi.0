Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792592920;
	b=36223n8RXKWuFsCjkab9VWMRPI8WxGhVGi3J42KIzBMtV53u32zC03gOK6GuvRZXixAN
	 5J3Ysicg98dXE01q1vnh2p9awXbQn9jWOh+THWAWHICbvEAUWVpPwAQflJVyMgd01KPJu
	 zO+2FfjcGjq07wXIHhtcQCcqHjKxzCRxRAtiqy63X42AVfb42nf9VFw3j1JdPDxzx5s9K
	 hOr4R8ld4jkbs4cF7ENvAhCqGakyl6SlhFWE8xOP5AyAmy7qQsHaTDezufMPGYS7jd1OZ
	 vyAsCnI2hkxECepoIXqZTwY5OoUX3mJu5eU4k4LDmk5snradF5WWav3S9DmhQAkOvsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792592920;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=THQdWGmIhH0FTJ2AYWLaPXO0qgFc481igXA5oXACP+U=;
	b=aaISOj7PkCFgimKf3bm5jtzphCuuMCN4r9fAomUDKfaoUvAq/rwo+othS97F+ngUg6YY
	 G17knUO1Ez8zV01mZCV/u8MDmTJlNQWxIKAAfZh3tMmNqqmN5APUrlW+pmPR645MNICZF
	 AM+A8NyUj3VQmt0wKqwtdcrYzw3XS0Ybrz8YD5+dDrJk/ZTuIDXhzqsn0lUTG4u3mIn0M
	 QexXxOqpuUoVAB38BPPtfV/hn4FnpqUi7wxJDLPS5KuxXFCXbLh1SuJdIz6gUZWVtbrYo
	 qzySgV9uivO50Nx2Nr0EG5o8UhL+DM81M9KySLILAeW7hX5N/pomElt3ywmvd0TE3kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=idNd4Eta;
	arc=none smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F613606A319
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 14:28:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F613606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=idNd4Eta
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e8b20a899fso4428345ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 07:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792592918; x=1793197718; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=THQdWGmIhH0FTJ2AYWLaPXO0qgFc481igXA5oXACP+U=;
        b=idNd4EtaIZdESBxBFQa7ZOi7u4V6s7qVUQsQoeW6KZ4FexN/vp3uxo4dc6jiDeQP6u
         jwsLoUrylERmSk0250pwAPac3N/sLs+hE1IOf1FU0XtWP30qEY3NMb7kRJbWFYEm0obD
         /nWRCsF2O7kFyW5fLS1Jpl6AdrQf8AvTIV5pBWzEyP+hRYp+bfXX3GgUQ2RQ4PGjR1WS
         LwFCoqTuga5P8fdC6pe7/DkwoyL9hUMyY0gL3AoC3XAQvrVjXasM0OCQktFYmCq5egxB
         99HoF0rDgSR1wfKJyafIc3p/PKrWv6cRWM/SPS3Gd4NleSKj3anWVmj1Nf7TodiTngsG
         R1ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792592918; x=1793197718;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=THQdWGmIhH0FTJ2AYWLaPXO0qgFc481igXA5oXACP+U=;
        b=ZQEyQaoXr013PgrYSKM14ZDtSsaP0tdMz/G0sQlDmfILI632CBjqG7JgzqGObUb9ZZ
         /8pGNCNtN2qSJV620LjjF3T2aLOluI0B3xoxOhowfrBBkCSr3UDZVYS8MmBc7eEATOGP
         La/vBCvzUUN7hcqghstA2Jafj6uf0p9DTtXVaSTPNttgnGb0J3FkwS1EpO/74IHGpXh2
         4EeAxQYMnPgQf4SQ/EOjS2B1G2x1qbhSddZJ9K2LvkRmfExKr8UH4GJrgz5bNe4Yf48S
         FjIQuCFavJoUYnsr5kBvJ0Yv8XH9YS9DQ+LlM/cgKAv22/do+TboVOmLAkH2rkb9XvuW
         3sWA==
X-Forwarded-Encrypted: i=1; AKwUvBzkhqWSc/43Ca7MySF/VsjQ0m1yh3DCtjZy0BnKWT12wN0JT/EIe9Zpi18miirBGrXJrceAzuK7BnlT@vger.kernel.org
X-Gm-Message-State: AFq9FYL1KbHQqIF5nw3BLbsHI4txNGmLXjJ1xPur4hfPU1Z1ok7ZviLS
	YmO0vN3LofskClOHYOBUzR5MG4BskGcr94dfuTVbHW7LX9tbW+iEJDAi0SomxaKoP5s=
X-Gm-Gg: AYBFou1RRv3Gmsop7kgTKXO50zrHYmHRBw3ldRrSv3hYyUHYovmTSSkQ+zx5on20Ppl
	kaPsi8e2RqYTXnbXtNA1XFvht3JAZtoBCa79ukmDslR7tuZqq09nqJA0qMc0o5eBcXhlFabRwgz
	IBgehpPXzCXGSipGuKaosYFAOVk/dLvOTp2DGUg20Ey4UntvUXIlWFCU4khraNVAMjShPWqlnHk
	W2HhWW0KoCDZDiorTmvW6UiKf67/Sfw+D0A7pkKz7jYIcBpQD1KB3nMmddbLC8iQRvivvrczn5t
	Th9VMjIok2+8icyHQziWFPKnUHd93neAffLPvmnAUR0dWZo8eD2z+g25WuQE9A5xNzdVVvkuYST
	EkycTu5XEDwwIq5a3OTYRITynUIgXXRHqqD+H+HfEYGpURhe0i1aKjFbo7mrYGRbpMGiDmfmzQJ
	x4qnfGes+ppMH910TIqS8J36o6/74xqXMF5m4JPx/T6Qgx8CDw/IEmUV/uKghpVgWN2OSGmvBOB
	9E3JUteLNMGr73HIAdZ6V0SGI89IpPnBqZmQWukuBXrT+apNKkGtjcG/Q/M4t4ks5DKskNRXw5z
	JlY=
X-Received: by 2002:a17:903:2305:b0:2e2:f379:82b9 with SMTP id d9443c01a7336-2ea4402ba77mr16143635ad.61.1792592917350;
        Wed, 21 Oct 2026 07:28:37 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:2813:c015:8111:4bd6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea3b49e5f6sm12498005ad.70.2026.10.21.07.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 07:28:36 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Ram Vegesna <ram.vegesna@broadcom.com>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: James Smart <jsmart2021@gmail.com>,
	Hannes Reinecke <hare@suse.de>,
	Mike Christie <michael.christie@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v3] scsi: elx: efct: fix target session lifetime against node teardown
Date: Wed, 21 Oct 2026 23:28:18 +0900
Message-ID: <20261021142818.2782104-1-yhlee@isslab.korea.ac.kr>
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

efct_scsi_new_initiator() hands a bare struct efc_node pointer to lio_wq
and returns EFC_SCSI_CALL_ASYNC, so the node state machine keeps running
while efct_lio_setup_session() is still queued. Three things go wrong
over that window.

The node itself can be freed under the work item. efc_node_alloc() takes
a single reference and efc_node_free() drops it as the last step of a
node shutdown, which a peer LOGO, an FC link down, a domain or fabric
change or target teardown can all start. efct_get_vport_tpg() reads
node->nport before target_setup_session(), efct_session_cb() reads it
from inside that call, and node->tgt_node is read after it returns. The
node pool is created with curr_nr == min_nr, so mempool_free() calls
kfree() rather than refilling the reserve and the work item reads freed
slab memory:

  BUG: KASAN: slab-use-after-free in efct_lio_setup_session+0xd63/0xe20
  Read of size 8 at addr ffff888002d538a0 by task kworker/u4:0/12

  CPU: 0 UID: 0 PID: 12 Comm: kworker/u4:0 Tainted: G                 N  7.3.0-00343-g88d83015fdb1-dirty #5 PREEMPT(lazy)
  Tainted: [N]=TEST
  Workqueue: efct-kunit-wq efct_lio_setup_session
  Call Trace:
   <TASK>
   print_report+0xcd/0x620
   ? efct_lio_setup_session+0xd63/0xe20
   ? __virt_addr_valid+0x208/0x3f0
   ? efct_lio_setup_session+0xd63/0xe20
   kasan_report+0xfb/0x130
   ? efct_lio_setup_session+0xd63/0xe20
   efct_lio_setup_session+0xd63/0xe20
   ? __pfx_efct_lio_setup_session+0x10/0x10
   ? lock_acquire+0x100/0x2d0
   ? process_one_work+0x835/0x1c40
   ? process_one_work+0x735/0x1c40
   ? lock_release+0xc3/0x250
   process_one_work+0x88b/0x1c40
   ? __pfx_process_one_work+0x10/0x10
   ? lock_acquire+0x100/0x2d0
   ? worker_thread+0x2c7/0x11b0
   ? lock_is_held_type+0x84/0xf0
   ? __pfx_efct_lio_setup_session+0x10/0x10
   worker_thread+0x649/0x11b0
   ? __pfx_worker_thread+0x10/0x10
   kthread+0x3aa/0x550
   ? _raw_spin_unlock_irq+0x23/0x40
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x493/0x940
   ? __pfx_ret_from_fork+0x10/0x10
   ? __switch_to+0x22/0xdc0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x19/0x30
   </TASK>

  Allocated by task 33:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   __kasan_kmalloc+0x8f/0xa0
   __kmalloc_noprof+0x23b/0x580
   mempool_alloc_noprof+0x143/0x230
   efct_kt_node_alloc.isra.0+0x38/0x4b0
   efct_kt_uaf_after_cb+0x7a/0x370
   kunit_try_run_case+0x1ca/0x4c0
   kunit_generic_run_threadfn_adapter+0x7b/0xe0
   kthread+0x3aa/0x550
   ret_from_fork+0x493/0x940
   ret_from_fork_asm+0x19/0x30

  Freed by task 12:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   kasan_save_free_info+0x3b/0x60
   __kasan_slab_free+0x43/0x70
   kfree+0x119/0x490
   mempool_free+0xbc/0x100
   efc_node_free+0x311/0x4a0
   efct_lio_setup_session+0xa57/0xe20
   process_one_work+0x88b/0x1c40
   worker_thread+0x649/0x11b0
   kthread+0x3aa/0x550
   ret_from_fork+0x493/0x940
   ret_from_fork_asm+0x19/0x30

  The buggy address belongs to the object at ffff888002d53800
   which belongs to the cache kmalloc-1k of size 1024
  The buggy address is located 160 bytes inside of
   freed 1024-byte region [ffff888002d53800, ffff888002d53c00)

Teardown can also run while the session does not exist yet.
__efc_d_initiate_shutdown() moves the node to __efc_d_wait_del_node and
only then calls efct_scsi_del_initiator(), which finds node->tgt_node
still NULL and returns -EIO without queueing the removal work. The node
waits there with node->nport set and node->req_free still clear, since
req_free is only set later in __efc_node_shutdown(). The setup work
therefore sees nothing wrong, registers a session, and nothing ever
removes it: the se_session and the struct efct_node leak, and
se_session->fabric_sess_ptr keeps pointing at a node that is freed
moments later.

Or teardown can run just after the session became visible.
efct_session_cb() publishes node->tgt_node from inside
target_setup_session(). If efct_scsi_del_initiator() runs between that
and the end of the setup work it erases the efct->lookup entry and
queues the removal work, and the tail of the setup work then puts the
entry back. efct_lio_remove_session() frees the struct efct_node without
erasing the key a second time, so efct->lookup keeps a freed pointer
that efct_node_find() returns, and takes a reference on, for every
inbound FCP or BLS frame. That is the case the comment above
efct_node_find() states cannot happen.

Give the node a reference for the life of the work item, and give the
backend an explicit session state, read and written under efc->lock,
which is the lock the node state machine holds when it calls in. The
work claims EFCT_TGT_SESS_SETUP before it is queued and reaches
EFCT_TGT_SESS_REGISTERED in the same critical section that stores the
lookup entry, so a store can no longer follow an erase.

efct_scsi_del_initiator() now decides from that state rather than from
node->tgt_node. While a setup is in flight it marks the node
EFCT_TGT_SESS_DELETE_PENDING and returns EFC_SCSI_CALL_ASYNC, so the
node waits in __efc_d_wait_del_node instead of running ahead of the work
that still holds the session. The work unwinds the session it built and
then calls efc_scsi_del_initiator_complete(), which posts the
EFC_EVT_NODE_DEL_INI_COMPLETE the node is parked on. Once the session is
registered the existing removal path runs unchanged. Every exit from the
work now reports exactly one completion, either that one or a session
registration result, so no path leaves the node waiting.

The same state closes a smaller hole next door. An initiator that
repeats PRLI while registration is pending used to get a second session
for one node, which left the first one unreachable.
efct_scsi_new_initiator() now returns EFC_SCSI_CALL_ASYNC for the
repeat, which is what the first PRLI already made the node wait for.

Two earlier versions got the handshake wrong. v1 gated the work on
node->nport and node->req_free, which is not enough, because req_free is
only set well after efct_scsi_del_initiator() has run and returned. v2
replaced that with the state above but reported the two races with
EFC_SCSI_CALL_COMPLETE, which let efc_d_send_prli_rsp() and
__efc_d_initiate_shutdown() advance the node while the work was still in
flight, so this version reports them asynchronously instead.

Fixes: 692e5d73a811 ("scsi: elx: efct: LIO backend interface routines")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/elx/efct/efct_lio.c | 98 +++++++++++++++++++++++++++++---
 drivers/scsi/elx/efct/efct_lio.h |  9 +++
 drivers/scsi/elx/libefc/efclib.h |  2 +
 3 files changed, 101 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
index 67d686dd6fb33..9ddab907556da 100644
--- a/drivers/scsi/elx/efct/efct_lio.c
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -1062,17 +1062,33 @@ _efct_tgt_node_free(struct kref *arg)
 	kfree(tgt_node);
 }
 
+/* True only while a setup is in flight. The caller holds efc->lock. */
+static bool efct_tgt_sess_may_register(struct efc_node *node)
+{
+	return node->tgt_sess_state == EFCT_TGT_SESS_SETUP &&
+	       node->nport && !node->req_free;
+}
+
 static int efct_session_cb(struct se_portal_group *se_tpg,
 			   struct se_session *se_sess, void *private)
 {
 	struct efc_node *node = private;
 	struct efct_node *tgt_node;
 	struct efct *efct = node->efc->base;
+	unsigned long flags;
 
 	tgt_node = kzalloc_obj(*tgt_node);
 	if (!tgt_node)
 		return -ENOMEM;
 
+	/* target_setup_session() sleeps, so the node may be in teardown now */
+	spin_lock_irqsave(&node->efc->lock, flags);
+	if (!efct_tgt_sess_may_register(node)) {
+		spin_unlock_irqrestore(&node->efc->lock, flags);
+		kfree(tgt_node);
+		return -ENODEV;
+	}
+
 	kref_init(&tgt_node->ref);
 	tgt_node->release = _efct_tgt_node_free;
 
@@ -1086,6 +1102,7 @@ static int efct_session_cb(struct se_portal_group *se_tpg,
 	tgt_node->port_fc_id = node->nport->fc_id;
 	tgt_node->vpi = node->nport->indicator;
 	tgt_node->rpi = node->rnode.indicator;
+	spin_unlock_irqrestore(&node->efc->lock, flags);
 
 	spin_lock_init(&tgt_node->active_ios_lock);
 	INIT_LIST_HEAD(&tgt_node->active_ios);
@@ -1157,15 +1174,28 @@ static void efct_lio_setup_session(struct work_struct *work)
 		container_of(work, struct efct_lio_wq_data, work);
 	struct efct *efct = wq_data->efct;
 	struct efc_node *node = wq_data->ptr;
+	struct efc *efc = node->efc;
 	char wwpn[WWN_NAME_LEN];
 	struct efct_lio_tpg *tpg;
 	struct efct_node *tgt_node;
 	struct se_portal_group *se_tpg;
 	struct se_session *se_sess;
+	unsigned long flags;
+	bool deleted = false;
 	int watermark;
 	int ini_count;
 	u64 id;
 
+	spin_lock_irqsave(&efc->lock, flags);
+	if (!efct_tgt_sess_may_register(node)) {
+		deleted = node->tgt_sess_state == EFCT_TGT_SESS_DELETE_PENDING;
+		node->tgt_sess_state = EFCT_TGT_SESS_NONE;
+		spin_unlock_irqrestore(&efc->lock, flags);
+		efc_log_debug(efct, "node %p torn down before session setup\n",
+			      node);
+		goto done;
+	}
+
 	/* Check to see if it's belongs to vport,
 	 * if not get physical port
 	 */
@@ -1176,8 +1206,10 @@ static void efct_lio_setup_session(struct work_struct *work)
 		tpg = efct->tgt_efct.tpg;
 		se_tpg = &tpg->tpg;
 	} else {
+		node->tgt_sess_state = EFCT_TGT_SESS_NONE;
+		spin_unlock_irqrestore(&efc->lock, flags);
 		efc_log_err(efct, "failed to init session\n");
-		return;
+		goto done;
 	}
 
 	/*
@@ -1186,14 +1218,38 @@ static void efct_lio_setup_session(struct work_struct *work)
 	 * ConfigFS NodeACLs.
 	 */
 	efct_format_wwn(wwpn, sizeof(wwpn), "",	efc_node_get_wwpn(node));
+	spin_unlock_irqrestore(&efc->lock, flags);
 
 	se_sess = target_setup_session(se_tpg, 0, 0, TARGET_PROT_NORMAL, wwpn,
 				       node, efct_session_cb);
 	if (IS_ERR(se_sess)) {
 		efc_log_err(efct, "failed to setup session\n");
-		kfree(wq_data);
-		efc_scsi_sess_reg_complete(node, -EIO);
-		return;
+		spin_lock_irqsave(&efc->lock, flags);
+		deleted = node->tgt_sess_state == EFCT_TGT_SESS_DELETE_PENDING;
+		node->tgt_sess_state = EFCT_TGT_SESS_NONE;
+		spin_unlock_irqrestore(&efc->lock, flags);
+		goto done;
+	}
+
+	spin_lock_irqsave(&efc->lock, flags);
+	if (!efct_tgt_sess_may_register(node)) {
+		deleted = node->tgt_sess_state == EFCT_TGT_SESS_DELETE_PENDING;
+		tgt_node = node->tgt_node;
+		node->tgt_node = NULL;
+		node->tgt_sess_state = EFCT_TGT_SESS_NONE;
+		spin_unlock_irqrestore(&efc->lock, flags);
+		/*
+		 * kfree() and not kref_put(), because the release would post a
+		 * second completion. Nothing else can reach tgt_node, it never
+		 * entered efct->lookup and node->tgt_node is clear.
+		 */
+		efc_log_debug(efct, "node %p torn down during session setup\n",
+			      node);
+		target_stop_session(se_sess);
+		target_wait_for_sess_cmds(se_sess);
+		target_remove_session(se_sess);
+		kfree(tgt_node);
+		goto done;
 	}
 
 	tgt_node = node->tgt_node;
@@ -1202,8 +1258,10 @@ static void efct_lio_setup_session(struct work_struct *work)
 	efc_log_debug(efct, "new initiator sess=%p node=%p id: %llx\n",
 		      se_sess, node, id);
 
-	if (xa_err(xa_store(&efct->lookup, id, tgt_node, GFP_KERNEL)))
+	if (xa_err(xa_store(&efct->lookup, id, tgt_node, GFP_ATOMIC)))
 		efc_log_err(efct, "Node lookup store failed\n");
+	node->tgt_sess_state = EFCT_TGT_SESS_REGISTERED;
+	spin_unlock_irqrestore(&efc->lock, flags);
 
 	efc_scsi_sess_reg_complete(node, 0);
 
@@ -1216,6 +1274,17 @@ static void efct_lio_setup_session(struct work_struct *work)
 	atomic_set(&efct->tgt_efct.io_high_watermark, watermark);
 
 	kfree(wq_data);
+	kref_put(&node->ref, node->release);
+	return;
+
+done:
+	/* every exit owes the node exactly one completion */
+	if (deleted)
+		efc_scsi_del_initiator_complete(efc, node);
+	else
+		efc_scsi_sess_reg_complete(node, -EIO);
+	kfree(wq_data);
+	kref_put(&node->ref, node->release);
 }
 
 int efct_scsi_new_initiator(struct efc *efc, struct efc_node *node)
@@ -1223,6 +1292,10 @@ int efct_scsi_new_initiator(struct efc *efc, struct efc_node *node)
 	struct efct *efct = node->efc->base;
 	struct efct_lio_wq_data *wq_data;
 
+	/* a repeated PRLI waits for the in-flight setup, it does not add one */
+	if (node->tgt_sess_state != EFCT_TGT_SESS_NONE)
+		return EFC_SCSI_CALL_ASYNC;
+
 	/*
 	 * Since LIO only supports initiator validation at thread level,
 	 * we are open minded and accept all callers.
@@ -1231,6 +1304,10 @@ int efct_scsi_new_initiator(struct efc *efc, struct efc_node *node)
 	if (!wq_data)
 		return -ENOMEM;
 
+	/* the work outlives this call and undoes both of these */
+	kref_get(&node->ref);
+	node->tgt_sess_state = EFCT_TGT_SESS_SETUP;
+
 	wq_data->ptr = node;
 	wq_data->efct = efct;
 	INIT_WORK(&wq_data->work, efct_lio_setup_session);
@@ -1287,17 +1364,22 @@ int efct_scsi_del_initiator(struct efc *efc, struct efc_node *node, int reason)
 	if (reason == EFCT_SCSI_INITIATOR_MISSING)
 		return EFC_SCSI_CALL_COMPLETE;
 
-	if (!tgt_node) {
-		efc_log_err(efct, "tgt_node is NULL\n");
-		return -EIO;
+	if (node->tgt_sess_state == EFCT_TGT_SESS_SETUP) {
+		/* the setup work unwinds it and completes the delete */
+		node->tgt_sess_state = EFCT_TGT_SESS_DELETE_PENDING;
+		return EFC_SCSI_CALL_ASYNC;
 	}
 
+	if (node->tgt_sess_state != EFCT_TGT_SESS_REGISTERED || !tgt_node)
+		return EFC_SCSI_CALL_COMPLETE;
+
 	wq_data = kzalloc_obj(*wq_data, GFP_ATOMIC);
 	if (!wq_data)
 		return -ENOMEM;
 
 	id = (u64) tgt_node->port_fc_id << 32 | tgt_node->node_fc_id;
 	xa_erase(&efct->lookup, id);
+	node->tgt_sess_state = EFCT_TGT_SESS_NONE;
 
 	wq_data->ptr = node;
 	wq_data->efct = efct;
diff --git a/drivers/scsi/elx/efct/efct_lio.h b/drivers/scsi/elx/efct/efct_lio.h
index 569a0d4b1894c..8f550ad0e349b 100644
--- a/drivers/scsi/elx/efct/efct_lio.h
+++ b/drivers/scsi/elx/efct/efct_lio.h
@@ -65,6 +65,15 @@ struct efct_scsi_tgt_nport {
 	struct efct_lio_nport	*lio_nport;
 };
 
+/* Target session state of a struct efc_node, kept under efc->lock. */
+enum efct_tgt_sess_state {
+	EFCT_TGT_SESS_NONE = 0,
+	EFCT_TGT_SESS_SETUP,
+	EFCT_TGT_SESS_REGISTERED,
+	/* teardown raced setup; the setup work must unwind it */
+	EFCT_TGT_SESS_DELETE_PENDING,
+};
+
 struct efct_node {
 	struct list_head	list_entry;
 	struct kref		ref;
diff --git a/drivers/scsi/elx/libefc/efclib.h b/drivers/scsi/elx/libefc/efclib.h
index 57e3386128127..7c00a3fd79ad6 100644
--- a/drivers/scsi/elx/libefc/efclib.h
+++ b/drivers/scsi/elx/libefc/efclib.h
@@ -336,6 +336,8 @@ struct efc_node {
 	struct list_head	els_ios_list;
 	void			*ini_node;
 	void			*tgt_node;
+	/* enum efct_tgt_sess_state, private to the target backend */
+	u8			tgt_sess_state;
 
 	struct efc_remote_node	rnode;
 	/* Declarations private to FC trannport */

base-commit: f47d223627f80cb7a1eb14c585fe6cb35de5e984
-- 
2.43.0

