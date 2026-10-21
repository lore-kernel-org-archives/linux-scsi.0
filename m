Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792588133;
	b=sUtm0M9co9TTNIb4Nv8NQp2VHesLJLZLrAaUKXVuHFnyLpi6sQw14Jh6Fi1hlymCCVY1
	 o2QUSH0zEM+n9nh/ngjDjsQO619EAtpavXUrvHeIOreErWFI6Wx23vgPTgLLHzvQ/lFj1
	 U+dWo72owqNJx0qQDnXebq8JYDke11T445obvep/LQPKnnAA21Qncww2LgpCA0SdcecOv
	 A0EZqxjld5bk1my4ppA9gJplrapDODeHEy0LYeTaNx6Ll+RWpnNwDrN2/4/eLzQNK5vuG
	 wKTExmNPjnSILmKfhfYnr9Rgkiyija9hYXnbC4SZpvNLsAD4Xoh5yFOQwaEYLaD78Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792588133;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7Ve8ZNksPYVItMCXMNZb+IruVuyPRZOJDuAdFAJU5Yk=;
	b=LysU/Rtdy2LSa6p756XAd3F0KHGKD8cbS0P753+j4FLE15wWZPuwehywCilQjb1hFOWq
	 jzaCm7X63BblJEzr8aHQFArGBvNMJRjRjUpFhkTI4eDTX0WHQu6sprEpBU1j4DslzePrY
	 pViiscioT4e2hUP3c/9xh+ufEZ/+9VFbpUSoQjRTMHXKqWtlTzyE14FLV+0ogQzto/I28
	 Q26FFa3ZfbjS4WteRno1SZnohHjALZprDi+owJBdzQykg6+dpeJqFcijnY1AKIZu15rG3
	 8Tu9eMzcPw9K035c73BuD/8ty8YFE9IQ2Dj8qRXjPYc6nEtrtGxn97Q0XGZtxCCukgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=S4gwn3cy;
	arc=none smtp.remote-ip=74.125.82.53
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC63606A321
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 13:08:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CC63606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=S4gwn3cy
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-18cdcfc05ffso689442c88.1
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 06:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792588131; x=1793192931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7Ve8ZNksPYVItMCXMNZb+IruVuyPRZOJDuAdFAJU5Yk=;
        b=S4gwn3cyFGOKzCs0BoufHQqIDvW0Fn6fef5tjun/OK0UuOvXJornzAJHMw7QQJN8FG
         pAkpmZUfjE4vJohYdBe8MqR4sm9s1Zt3mud3Fk2Wg/SMc6LdWPJO0oeceiYhZn5iD4hd
         gAdKs7e9bX6OyOjIVQuWc02WWF0fPqBnnWj3OZRA/8bP01/WNbvCBroPSCKSQx5OSdiS
         7/JSzmvC4bN1+T/+P4C/1idY46gVoUmTIhmv0IGP9AXnLTnEEGSNlMyu9s3Z3fD98gYh
         G1Q21d/1rmgXdiMzLJogsAlgSFbyIzsGON0W/g76CcDKbYwxIx8p/hygQO5JOTK4abxn
         73KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792588131; x=1793192931;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7Ve8ZNksPYVItMCXMNZb+IruVuyPRZOJDuAdFAJU5Yk=;
        b=kA0ThUQwYMNE21c7rUrT5Pki+nkgfYy5v8XDSL/1uF1B29bb7krjZRXp821Hv+9kyl
         pll9VeRh64QTXFXnQwX2pOrUroMMnD0FXFSzTpQqAt2wT3LpJFbnI15H5XXcH49adsjQ
         PgTh6zVVzkJlwDRKkUjEFiuQ+7muP/SGfwTr3CuWJdAZOT0Lvzis1RpH4RTsW5j2xcTO
         Pzc2YkKDhqf2QQLiZ4963kWDSO/1LOZXLRanj3FmvlyX37oJ9O2/EhPjL48AFwCVITO/
         5T+r95wr5flHUW+Wr8IasedBB2caDPogdcdGc9bVYin3BcHCVdaBWb/SafD+du0zZTo9
         dX/w==
X-Forwarded-Encrypted: i=1; AKwUvBw/h8WNYBSBP/9yhy9lO4Do4yxAxXCv8p1bLhEE04mrBAhQsotq4Pu71gB2nOAVQ5EloATEtoCIPbgP@vger.kernel.org
X-Gm-Message-State: AFq9FYKLXZIGpyV/JLK8n/HLQLhiOKrOraUdFci1BkCCAkTD0yQwSL6V
	+bzPFBVXj8bhlT0sw7/L4YnHdreeNOahzwpa2VFmZrRbnTmLJa+wVMkJwNRaFndf/4w=
X-Gm-Gg: AYBFou0OSZ6AJI+XtnxZkpiQ7/x98Gh2KjU4aEuY49TyluBoD570skSFq6dfwBCoY02
	nlbEqElDY7kIkbDyWRwiMO4FlrJ3QPbvm5AIYQOXCPR2MD3YS4EjMbdNhtS5L6VplkwDIvqfHcs
	hU9U5qe3toINdSs6gqLtqOyuUcvs9bFpPEYw14xLyEOPYqLpzfQ1/iFZ0pmvzYg6Ir9G0gNfVqb
	FGUthZbfOvYcVG+4jzb2r5/BFCBBRfU3qqoeQzlbAbbP5hK0SXHwY+DaBYUgWNQ8voKXb44SP3W
	PoS75zFTHv7ivSe4PPwH4CRp+q6cu7AcPKG/GOsUU7UwvJNFTEf24WDUO3dASinOK+pWX+8uZKa
	kl4i3XhpQl3MK0qa0zePYDtnxR7obSHJ2CCzGh7UO6U4k8jqbkNcY/V+tt+d2biOh/yvos/u39i
	seF/H4hDYWWlAi63QhFhqJtmu+8NAGbxz5PX1Y/k4oyNtWwfGNEoNtt4MQngiP8w90hzsr6AP67
	PwJ+3J4OTdUapt6m0ORMMdrBj+omjAOb5qM80jYcaMM6AiyfQyX5y8gcClD9hKto1z3FF4EIc4e
	3TfFGLsr8alskB1bANlQBLU=
X-Received: by 2002:a05:7022:4092:b0:18a:3911:ec1 with SMTP id a92af1059eb24-190a7ff8258mr2087001c88.39.1792588130972;
        Wed, 21 Oct 2026 06:08:50 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:e416:85ef:f22:6c5d])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19035c0c9a6sm5923746c88.3.2026.10.21.06.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 06:08:50 -0700 (PDT)
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
Subject: [PATCH v2] scsi: elx: efct: fix target session lifetime against node teardown
Date: Wed, 21 Oct 2026 22:08:02 +0900
Message-ID: <20261021130802.2691833-1-yhlee@isslab.korea.ac.kr>
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

  BUG: KASAN: slab-use-after-free in efct_lio_setup_session+0xc44/0xde0
  Read of size 8 at addr ffff888002d538a0 by task kworker/u4:0/12

  CPU: 0 UID: 0 PID: 12 Comm: kworker/u4:0 Tainted: G                 N  7.3.0-00342-gbe448252d3e7-dirty #4 PREEMPT(lazy)
  Tainted: [N]=TEST
  Workqueue: efct-kunit-wq efct_lio_setup_session
  Call Trace:
   <TASK>
   print_report+0xcd/0x620
   ? efct_lio_setup_session+0xc44/0xde0
   ? __virt_addr_valid+0x208/0x3f0
   ? efct_lio_setup_session+0xc44/0xde0
   kasan_report+0xfb/0x130
   ? efct_lio_setup_session+0xc44/0xde0
   efct_lio_setup_session+0xc44/0xde0
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
   efct_lio_setup_session+0xa4a/0xde0
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
lookup entry. efct_scsi_del_initiator() now decides from that state
rather than from node->tgt_node. While a setup is in flight it marks the
node EFCT_TGT_SESS_DELETE_PENDING and reports completion instead of
-EIO, and the setup work unwinds the session it built instead of
publishing it. Once the session is registered the existing removal path
runs unchanged, and because the state transition and the lookup store
share one critical section, a store can no longer follow an erase.

The same state closes a smaller hole next door. An initiator that
repeats PRLI while registration is pending used to get a second session
for one node, which left the first one unreachable;
efct_scsi_new_initiator() now reports completion rather than building
it.

An earlier version gated the work on node->nport and node->req_free
instead, which is not enough, because req_free is only set well after
efct_scsi_del_initiator() has already run and returned.

Fixes: 692e5d73a811 ("scsi: elx: efct: LIO backend interface routines")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/elx/efct/efct_lio.c | 90 +++++++++++++++++++++++++++++---
 drivers/scsi/elx/efct/efct_lio.h |  9 ++++
 drivers/scsi/elx/libefc/efclib.h |  2 +
 3 files changed, 94 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
index 67d686dd6fb33..634200c1a61b5 100644
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
@@ -1157,15 +1174,26 @@ static void efct_lio_setup_session(struct work_struct *work)
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
 	int watermark;
 	int ini_count;
 	u64 id;
 
+	spin_lock_irqsave(&efc->lock, flags);
+	if (!efct_tgt_sess_may_register(node)) {
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
@@ -1176,8 +1204,10 @@ static void efct_lio_setup_session(struct work_struct *work)
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
@@ -1186,14 +1216,43 @@ static void efct_lio_setup_session(struct work_struct *work)
 	 * ConfigFS NodeACLs.
 	 */
 	efct_format_wwn(wwpn, sizeof(wwpn), "",	efc_node_get_wwpn(node));
+	spin_unlock_irqrestore(&efc->lock, flags);
 
 	se_sess = target_setup_session(se_tpg, 0, 0, TARGET_PROT_NORMAL, wwpn,
 				       node, efct_session_cb);
 	if (IS_ERR(se_sess)) {
 		efc_log_err(efct, "failed to setup session\n");
-		kfree(wq_data);
+		spin_lock_irqsave(&efc->lock, flags);
+		if (!efct_tgt_sess_may_register(node)) {
+			node->tgt_sess_state = EFCT_TGT_SESS_NONE;
+			spin_unlock_irqrestore(&efc->lock, flags);
+			goto done;
+		}
+		node->tgt_sess_state = EFCT_TGT_SESS_NONE;
+		spin_unlock_irqrestore(&efc->lock, flags);
 		efc_scsi_sess_reg_complete(node, -EIO);
-		return;
+		goto done;
+	}
+
+	spin_lock_irqsave(&efc->lock, flags);
+	if (!efct_tgt_sess_may_register(node)) {
+		tgt_node = node->tgt_node;
+		node->tgt_node = NULL;
+		node->tgt_sess_state = EFCT_TGT_SESS_NONE;
+		spin_unlock_irqrestore(&efc->lock, flags);
+		/*
+		 * No kref_put(), because efct_scsi_del_initiator() already
+		 * reported completion. tgt_node never reached efct->lookup
+		 * and node->tgt_node is cleared above, so nothing else can
+		 * reach it and its count is the one kref_init() gave it.
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
@@ -1202,8 +1261,10 @@ static void efct_lio_setup_session(struct work_struct *work)
 	efc_log_debug(efct, "new initiator sess=%p node=%p id: %llx\n",
 		      se_sess, node, id);
 
-	if (xa_err(xa_store(&efct->lookup, id, tgt_node, GFP_KERNEL)))
+	if (xa_err(xa_store(&efct->lookup, id, tgt_node, GFP_ATOMIC)))
 		efc_log_err(efct, "Node lookup store failed\n");
+	node->tgt_sess_state = EFCT_TGT_SESS_REGISTERED;
+	spin_unlock_irqrestore(&efc->lock, flags);
 
 	efc_scsi_sess_reg_complete(node, 0);
 
@@ -1215,7 +1276,9 @@ static void efct_lio_setup_session(struct work_struct *work)
 			efct->tgt_efct.watermark_min : watermark;
 	atomic_set(&efct->tgt_efct.io_high_watermark, watermark);
 
+done:
 	kfree(wq_data);
+	kref_put(&node->ref, node->release);
 }
 
 int efct_scsi_new_initiator(struct efc *efc, struct efc_node *node)
@@ -1223,6 +1286,10 @@ int efct_scsi_new_initiator(struct efc *efc, struct efc_node *node)
 	struct efct *efct = node->efc->base;
 	struct efct_lio_wq_data *wq_data;
 
+	/* a repeated PRLI must not build a second session for one node */
+	if (node->tgt_sess_state != EFCT_TGT_SESS_NONE)
+		return EFC_SCSI_CALL_COMPLETE;
+
 	/*
 	 * Since LIO only supports initiator validation at thread level,
 	 * we are open minded and accept all callers.
@@ -1231,6 +1298,10 @@ int efct_scsi_new_initiator(struct efc *efc, struct efc_node *node)
 	if (!wq_data)
 		return -ENOMEM;
 
+	/* the work outlives this call and undoes both of these */
+	kref_get(&node->ref);
+	node->tgt_sess_state = EFCT_TGT_SESS_SETUP;
+
 	wq_data->ptr = node;
 	wq_data->efct = efct;
 	INIT_WORK(&wq_data->work, efct_lio_setup_session);
@@ -1287,17 +1358,22 @@ int efct_scsi_del_initiator(struct efc *efc, struct efc_node *node, int reason)
 	if (reason == EFCT_SCSI_INITIATOR_MISSING)
 		return EFC_SCSI_CALL_COMPLETE;
 
-	if (!tgt_node) {
-		efc_log_err(efct, "tgt_node is NULL\n");
-		return -EIO;
+	if (node->tgt_sess_state == EFCT_TGT_SESS_SETUP) {
+		/* hand the session being built back to the setup work */
+		node->tgt_sess_state = EFCT_TGT_SESS_DELETE_PENDING;
+		return EFC_SCSI_CALL_COMPLETE;
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

