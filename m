Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792550234;
	b=ViSi/SHqw5Veum2X+bdv9e/NFjegH1HmYLuPldmiGmeK4XQBHjjMThPzd2Lv3GjzJ+lE
	 QE9Yw5JryGPxEbvT7jnkxV871Qle1aCuo9YD+F3SjZpeFdGg+SGzPmgXdd06ldnFi76BE
	 zvttMBhV2UkQGWKaAJRlrIly6a674VVnjlo4XPcEh4kt82Ppbi3An7LBqMMMkNua14XAt
	 CEAVyS+Gsf2EqYqitkaOe9ZjZPkGikB93fGfE80Q8wht503VnPXvxpcFlYUjTNRzT+sam
	 PaUCYPjK53aSyB0Thpt+/rt6oI6KVDNct0R+lAVE2JM13EHqxyyLidPabpDGMCupxEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792550234;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9vPNZ6Ehiz5jNR8DE5F11lom06bT0Pz/K9tXsklccZ8=;
	b=xzxvXFK7NU5vbWIFqIEe1X2RBInXrOeVnU8cQskoAfYoRJMhDU/eaHYTJRMGJGcOMYD3
	 fsCXWtcll8r7oHjmqwEHDLj/ub57Iw5hREPc7IzBKZMC5qCz2JzGUuLmcWiGhcGyOFKGz
	 1pU3oqmiG3T1kvwd/hNnsJKjzUPpMa8x8Gr2gVVPZr6P3eyOkpXLw6TWDOfcUjLgI3uEf
	 Csnaa30/e3cmsFUZz+ryEYipz0iQvas/OXyQfp/J2Ge40PM07LjO/G6vym67cFP/S3OUa
	 N1Un7f1ftmtcqPpGw0yR+3TmY+/ziq8RqzKZ/kqRym/KdZYwur7ASEutxlNaDpS1YrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OQrIetDu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C40606A319;
	Wed, 21 Oct 2026 02:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OQrIetDu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B801F000CA;
	Wed, 21 Oct 2026 02:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792550233;
	bh=9vPNZ6Ehiz5jNR8DE5F11lom06bT0Pz/K9tXsklccZ8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OQrIetDuV6Tx9jpmddnARUJcwYOtUDvqKEwI0M0w3Rb20xuZDx8i64gJYVFRPxqOw
	 /m3NNbZNACUC3e9iVLIvULOw0rhAi+sPW95vuP47Pyle8Ydu/OKvOsDXpKbzYaiV8N
	 lFDTjanqkKktq6ZaUAFuBOGt6uXujak3wUDEjBTANxK4CbBG3qiOQGmV9IJfiCurAO
	 gxeP4lDeYlqhThC+cGn2yxqTbTjW8qdsfcoqknazgq9CKn2Mco8TKoKFgoMbD944uA
	 mJMKwP42599igDZdK0D5fhEvwqRAa+gf4gwwYPVofE2cW4WYZvb/XPM88NhlOOCZhH
	 azPq55dClrz/g==
Message-ID: <sashiko-outbox-179705@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: elx: efct: hold a node reference across
 asynchronous session setup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261021022209.2580332-1-yhlee@isslab.korea.ac.kr>
References: <20261021022209.2580332-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 02:37:13 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] scsi: elx: efct: incomplete shutdown check in efct_node_regist=
rable()
- [Critical] scsi: elx: efct: xa_erase() race with xa_store() in efct_lio_s=
etup_session()
- [High] scsi: elx: efct: session leak on post-setup bailout in efct_lio_se=
tup_session()
- [High] scsi: elx: efct: TOCTOU race before efc_scsi_sess_reg_complete()
--

commit 9faa68f52085fb309e7aece4f85020881ca6843a
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: elx: efct: hold a node reference across asynchronous session setup

This commit takes a kref on struct efc_node while efct_lio_setup_session() =
is
queued on lio_wq and adds efct_node_registrable() checks under efc->lock to
bail out if the node has shut down during asynchronous session setup.

> diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efc=
t_lio.c
> index 67d686dd6fb33..add939366bc6a 100644
> --- a/drivers/scsi/elx/efct/efct_lio.c
> +++ b/drivers/scsi/elx/efct/efct_lio.c
> @@ -1062,17 +1062,42 @@ _efct_tgt_node_free(struct kref *arg)
>  	kfree(tgt_node);
>  }
> =20
> +/*
> + * Report whether the node state machine may still have a session regist=
ered
> + * for @node. The caller must hold efc->lock, which is also held by the =
paths
> + * that shut a node down.
> + */
> +static bool efct_node_registrable(struct efc_node *node)
> +{
> +	return node->nport && !node->req_free;
> +}
> +
>  static int efct_session_cb(struct se_portal_group *se_tpg,
>  			   struct se_session *se_sess, void *private)
>  {
>  	struct efc_node *node =3D private;
>  	struct efct_node *tgt_node;
>  	struct efct *efct =3D node->efc->base;
> +	unsigned long flags;
> =20
>  	tgt_node =3D kzalloc_obj(*tgt_node);
>  	if (!tgt_node)
>  		return -ENOMEM;
> =20
> +	/*
> +	 * target_setup_session() sleeps, so the node may have entered
> +	 * shutdown since it was called. Refuse the session in that case:
> +	 * efct_scsi_del_initiator() only queues the removal work once
> +	 * node->tgt_node is set, so either it sees the session below or
> +	 * there is no session to remove at all.
> +	 */
> +	spin_lock_irqsave(&node->efc->lock, flags);
> +	if (!efct_node_registrable(node)) {
> +		spin_unlock_irqrestore(&node->efc->lock, flags);
> +		kfree(tgt_node);
> +		return -ENODEV;
> +	}

[Severity: Critical]
Is checking node->nport and !node->req_free in efct_node_registrable()
sufficient to detect a node that has already entered shutdown?

When a remote initiator logs in and efc_d_send_prli_rsp() queues
efct_lio_setup_session(), a shutdown event arriving before efct_session_cb()
sets node->tgt_node runs __efc_d_initiate_shutdown() in
drivers/scsi/elx/libefc/efc_device.c:

    if (node->nport->enable_tgt)
        rc =3D efc->tt.scsi_del_node(efc, node,
            EFC_SCSI_INITIATOR_DELETED);

    if (rc =3D=3D EFC_SCSI_CALL_COMPLETE || rc < 0)
        efc_node_post_event(node,
            EFC_EVT_NODE_DEL_INI_COMPLETE, NULL);

Because node->tgt_node is still NULL, efct_scsi_del_initiator() returns
-EIO without queuing efct_lio_remove_session().

In drivers/scsi/elx/libefc/efc_node.c, efc_node_initiate_cleanup() ->
efc_node_check_els_quiesced() then checks whether the hardware node is still
attached or ELS IOs are active:

    } else {
        /*
         * hw node detach hasn't completed,
         * transition and wait
         */
        node_printf(node, "HW node still attached\n");
        efc_node_transition(node, __efc_node_wait_node_free,
                            NULL);
    }

While the node waits in __efc_node_wait_node_free (or
__efc_node_wait_els_shutdown, or __efc_d_wait_del_node for an
initiator+target node), node->nport is still non-NULL (cleared only in
efc_node_free()) and node->req_free is still false (set only on entry to
__efc_node_shutdown()). Similarly, efc_node_handle_implicit_logo() and
efc_node_handle_explicit_logo() reset node->req_free =3D false while keeping
node->nport valid:

    /* Re-attach node with the same HW node resources */
    node->req_free =3D false;
    rc =3D efc_node_attach(node);
    efc_node_transition(node, __efc_d_wait_node_attach, NULL);

In all of these states, efct_node_registrable(node) returns true even though
efct_scsi_del_initiator() has already run for that login. When the detach
later completes and the node reaches efc_node_free() without calling
efct_scsi_del_initiator() again, won't this leak se_sess and tgt_node and
leave dangling pointers to the freed struct efc_node in efct->lookup and
se_sess->fabric_sess_ptr?

> +
>  	kref_init(&tgt_node->ref);
>  	tgt_node->release =3D _efct_tgt_node_free;
> =20
> @@ -1086,6 +1111,7 @@ static int efct_session_cb(struct se_portal_group *=
se_tpg,
>  	tgt_node->port_fc_id =3D node->nport->fc_id;
>  	tgt_node->vpi =3D node->nport->indicator;
>  	tgt_node->rpi =3D node->rnode.indicator;
> +	spin_unlock_irqrestore(&node->efc->lock, flags);
> =20
>  	spin_lock_init(&tgt_node->active_ios_lock);
>  	INIT_LIST_HEAD(&tgt_node->active_ios);
> @@ -1157,15 +1183,25 @@ static void efct_lio_setup_session(struct work_st=
ruct *work)
>  		container_of(work, struct efct_lio_wq_data, work);
>  	struct efct *efct =3D wq_data->efct;
>  	struct efc_node *node =3D wq_data->ptr;
> +	struct efc *efc =3D node->efc;
>  	char wwpn[WWN_NAME_LEN];
>  	struct efct_lio_tpg *tpg;
>  	struct efct_node *tgt_node;
>  	struct se_portal_group *se_tpg;
>  	struct se_session *se_sess;
> +	unsigned long flags;
>  	int watermark;
>  	int ini_count;
>  	u64 id;
> =20
> +	spin_lock_irqsave(&efc->lock, flags);
> +	if (!efct_node_registrable(node)) {
> +		spin_unlock_irqrestore(&efc->lock, flags);
> +		efc_log_debug(efct, "node %p shut down before session setup\n",
> +			      node);
> +		goto done;
> +	}
> +
>  	/* Check to see if it's belongs to vport,
>  	 * if not get physical port
>  	 */
> @@ -1176,8 +1212,9 @@ static void efct_lio_setup_session(struct work_stru=
ct *work)
>  		tpg =3D efct->tgt_efct.tpg;
>  		se_tpg =3D &tpg->tpg;
>  	} else {
> +		spin_unlock_irqrestore(&efc->lock, flags);
>  		efc_log_err(efct, "failed to init session\n");
> -		return;
> +		goto done;
>  	}
> =20
>  	/*
> @@ -1186,14 +1223,28 @@ static void efct_lio_setup_session(struct work_st=
ruct *work)
>  	 * ConfigFS NodeACLs.
>  	 */
>  	efct_format_wwn(wwpn, sizeof(wwpn), "",	efc_node_get_wwpn(node));
> +	spin_unlock_irqrestore(&efc->lock, flags);
> =20
>  	se_sess =3D target_setup_session(se_tpg, 0, 0, TARGET_PROT_NORMAL, wwpn,
>  				       node, efct_session_cb);
>  	if (IS_ERR(se_sess)) {
>  		efc_log_err(efct, "failed to setup session\n");
> -		kfree(wq_data);
> +		spin_lock_irqsave(&efc->lock, flags);
> +		if (!efct_node_registrable(node)) {
> +			spin_unlock_irqrestore(&efc->lock, flags);
> +			goto done;
> +		}
> +		spin_unlock_irqrestore(&efc->lock, flags);
>  		efc_scsi_sess_reg_complete(node, -EIO);
> -		return;
> +		goto done;
>  	}

[Severity: High]
Can dropping efc->lock before calling efc_scsi_sess_reg_complete() here (and
before efc_scsi_sess_reg_complete(node, 0) below) race with node teardown?

In drivers/scsi/elx/libefc/efc_node.c, efc_scsi_sess_reg_complete()
re-acquires efc->lock and posts an event to the node:

    spin_lock_irqsave(&efc->lock, flags);
    /* Notify the node to resume */
    efc_node_post_event(node, evt, NULL);
    spin_unlock_irqrestore(&efc->lock, flags);

If the node finishes shutting down on another CPU in the window after
efct_lio_setup_session() releases efc->lock and before
efc_scsi_sess_reg_complete() re-acquires it, __efc_node_shutdown() sets
node->req_free =3D true and efc_node_post_event() calls efc_node_free(node),
which clears node->nport =3D NULL while leaving node->req_free set to true.

When efc_scsi_sess_reg_complete() then calls efc_node_post_event(),
node->evtdepth returns to 0 with node->req_free still true:

    if (node->evtdepth =3D=3D 0 && node->req_free)
        free_node =3D true;

    if (free_node)
        efc_node_free(node);

In efc_node_free(), if node->refound is set, efc_node_find(node->nport,
FC_FID_DIR_SERV) runs before the !node->nport check:

    if (node->refound) {
        ns =3D efc_node_find(node->nport, FC_FID_DIR_SERV);
    }

    if (!node->nport) {
        efc_log_err(efc, "Node already Freed\n");
        return;
    }

Wouldn't calling efc_node_free() a second time dereference a NULL
node->nport inside efc_node_find()?

> +
> +	spin_lock_irqsave(&efc->lock, flags);
> +	if (!efct_node_registrable(node)) {
> +		spin_unlock_irqrestore(&efc->lock, flags);
> +		efc_log_debug(efct, "node %p shut down during session setup\n",
> +			      node);
> +		goto done;
> +	}

[Severity: High]
What cleans up se_sess and tgt_node when efct_lio_setup_session() takes this
goto done path after target_setup_session() has already succeeded?

By the time target_setup_session() returns a valid se_sess,
efct_session_cb() has allocated tgt_node and set node->tgt_node =3D tgt_nod=
e,
and target_setup_session() has registered se_sess with
se_sess->fabric_sess_ptr =3D node.

If efct_node_registrable(node) is false here (for instance, if the node
completed __efc_node_shutdown() and efc_node_free() while
transport_register_session() was running, or if efct_scsi_del_initiator()
ran after efct_session_cb() unlocked efc->lock and failed its GFP_ATOMIC
allocation of wq_data), efct_lio_remove_session() will not be queued for
this session.

Jumping directly to done frees wq_data and drops node->ref without calling
target_remove_session(se_sess) or freeing tgt_node. Doesn't this leak
se_sess and tgt_node, leave se_sess->fabric_sess_ptr pointing to a freed
struct efc_node, and leave efct->tgt_efct.initiator_count unbalanced if
efct_scsi_del_initiator() already decremented it?

> =20
>  	tgt_node =3D node->tgt_node;
>  	id =3D (u64) tgt_node->port_fc_id << 32 | tgt_node->node_fc_id;
> =20
>  	efc_log_debug(efct, "new initiator sess=3D%p node=3D%p id: %llx\n",
>  		      se_sess, node, id);
> =20
> -	if (xa_err(xa_store(&efct->lookup, id, tgt_node, GFP_KERNEL)))
> +	if (xa_err(xa_store(&efct->lookup, id, tgt_node, GFP_ATOMIC)))
>  		efc_log_err(efct, "Node lookup store failed\n");
> +	spin_unlock_irqrestore(&efc->lock, flags);

[Severity: Critical]
Could xa_store() here insert tgt_node into efct->lookup after
efct_scsi_del_initiator() has already called xa_erase()?

Inside target_setup_session(), efct_session_cb() sets
node->tgt_node =3D tgt_node and releases node->efc->lock before
target_setup_session() returns to efct_lio_setup_session().

If the node enters shutdown during that unlocked window,
__efc_d_initiate_shutdown() -> efct_scsi_del_initiator() sees
node->tgt_node !=3D NULL and erases id from efct->lookup before queuing
efct_lio_remove_session():

    id =3D (u64) tgt_node->port_fc_id << 32 | tgt_node->node_fc_id;
    xa_erase(&efct->lookup, id);

    wq_data->ptr =3D node;
    wq_data->efct =3D efct;
    INIT_WORK(&wq_data->work, efct_lio_remove_session);
    queue_work(lio_wq, &wq_data->work);

Because efct_scsi_del_initiator() returns EFC_SCSI_CALL_ASYNC, the node
waits in __efc_d_wait_del_node for efct_lio_remove_session() to run on
lio_wq behind efct_lio_setup_session(). In __efc_d_wait_del_node,
node->nport is non-NULL and node->req_free is false, so
efct_node_registrable(node) still evaluates to true.

efct_lio_setup_session() then runs xa_store(&efct->lookup, id, tgt_node,
GFP_ATOMIC) after the xa_erase() in efct_scsi_del_initiator() has already
happened. When efct_lio_remove_session() subsequently frees tgt_node
without erasing id again, won't efct->lookup retain a dangling tgt_node
pointer that efct_node_find() in drivers/scsi/elx/efct/efct_unsol.c can
dereference via kref_get(&node->ref)?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021022209.2580=
332-1-yhlee@isslab.korea.ac.kr?part=3D1
