From: Bob Stlt <bobstlt40-Re5JQEeQqe8ybS5Ee8rs3A@public.gmane.org>
Subject: [PATCH] SCSI: LIBSCSI: Fixed codeing style errors
Date: Sun, 17 Apr 2016 23:05:34 +0800
Message-ID: <1460905534-2536-1-git-send-email-bobstlt40@gmail.com.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBAABBSF45G4AKGQEUS5PALA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org
Cc: jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bob Stlt <bobstlt40-Re5JQEeQqe8ybS5Ee8rs3A@public.gmane.org>, Bob Stlt <bobstlt40-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Fixed codeing style formatting errors.

Signed-off-by: Bob Stlt <bobstlt40-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/scsi/libiscsi.c | 90 ++++++++++++++++++++++++-------------------------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 6bffd91..41be9d3 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -197,7 +197,7 @@ static int iscsi_prep_ecdb_ahs(struct iscsi_task *task)
 	pad_len = iscsi_padding(rlen);
 
 	rc = iscsi_add_hdr(task, sizeof(ecdb_ahdr->ahslength) +
-	                   sizeof(ecdb_ahdr->ahstype) + ahslength + pad_len);
+			sizeof(ecdb_ahdr->ahstype) + ahslength + pad_len);
 	if (rc)
 		return rc;
 
@@ -210,10 +210,10 @@ static int iscsi_prep_ecdb_ahs(struct iscsi_task *task)
 	memcpy(ecdb_ahdr->ecdb, cmd->cmnd + ISCSI_CDB_SIZE, rlen);
 
 	ISCSI_DBG_SESSION(task->conn->session,
-			  "iscsi_prep_ecdb_ahs: varlen_cdb_len %d "
-		          "rlen %d pad_len %d ahs_length %d iscsi_headers_size "
-		          "%u\n", cmd->cmd_len, rlen, pad_len, ahslength,
-		          task->hdr_len);
+			"iscsi_prep_ecdb_ahs: varlen_cdb_len %d "
+			"rlen %d pad_len %d ahs_length %d iscsi_headers_size "
+			"%u\n", cmd->cmd_len, rlen, pad_len, ahslength,
+			task->hdr_len);
 	return 0;
 }
 
@@ -236,10 +236,10 @@ static int iscsi_prep_bidi_ahs(struct iscsi_task *task)
 	rlen_ahdr->read_length = cpu_to_be32(scsi_in(sc)->length);
 
 	ISCSI_DBG_SESSION(task->conn->session,
-			  "bidi-in rlen_ahdr->read_length(%d) "
-		          "rlen_ahdr->ahslength(%d)\n",
-		          be32_to_cpu(rlen_ahdr->read_length),
-		          be16_to_cpu(rlen_ahdr->ahslength));
+			"bidi-in rlen_ahdr->read_length(%d) "
+			"rlen_ahdr->ahslength(%d)\n",
+			be32_to_cpu(rlen_ahdr->read_length),
+			be16_to_cpu(rlen_ahdr->ahslength));
 	return 0;
 }
 
@@ -500,7 +500,7 @@ static void iscsi_free_task(struct iscsi_task *task)
 	if (conn->login_task == task)
 		return;
 
-	kfifo_in(&session->cmdpool.queue, (void*)&task, sizeof(void*));
+	kfifo_in(&session->cmdpool.queue, (void *)&task, sizeof(void *));
 
 	if (sc) {
 		/* SCSI eh reuses commands to verify us */
@@ -736,7 +736,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
 		if (!kfifo_out(&session->cmdpool.queue,
-				 (void*)&task, sizeof(void*)))
+				 (void *)&task, sizeof(void *)))
 			return NULL;
 	}
 	/*
@@ -831,7 +831,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	struct iscsi_session *session = conn->session;
 	struct scsi_cmnd *sc = task->sc;
 
-	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
+	iscsi_update_cmdsn(session, (struct iscsi_nopin *)rhdr);
 	conn->exp_statsn = be32_to_cpu(rhdr->statsn) + 1;
 
 	sc->result = (DID_OK << 16) | rhdr->cmd_status;
@@ -901,12 +901,12 @@ invalid_datalen:
 	}
 
 	if (rhdr->flags & (ISCSI_FLAG_CMD_UNDERFLOW |
-	                   ISCSI_FLAG_CMD_OVERFLOW)) {
+			ISCSI_FLAG_CMD_OVERFLOW)) {
 		int res_count = be32_to_cpu(rhdr->residual_count);
 
 		if (res_count > 0 &&
 		    (rhdr->flags & ISCSI_FLAG_CMD_OVERFLOW ||
-		     res_count <= scsi_bufflen(sc)))
+			res_count <= scsi_bufflen(sc)))
 			/* write side for bidi or uni-io set_resid */
 			scsi_set_resid(sc, res_count);
 		else
@@ -939,7 +939,7 @@ iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	sc->result = (DID_OK << 16) | rhdr->cmd_status;
 	conn->exp_statsn = be32_to_cpu(rhdr->statsn) + 1;
 	if (rhdr->flags & (ISCSI_FLAG_DATA_UNDERFLOW |
-	                   ISCSI_FLAG_DATA_OVERFLOW)) {
+			ISCSI_FLAG_DATA_OVERFLOW)) {
 		int res_count = be32_to_cpu(rhdr->residual_count);
 
 		if (res_count > 0 &&
@@ -978,7 +978,7 @@ static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 
 static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 {
-        struct iscsi_nopout hdr;
+	struct iscsi_nopout hdr;
 	struct iscsi_task *task;
 
 	if (!rhdr && conn->ping_task)
@@ -1080,7 +1080,7 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			spin_unlock(&conn->session->back_lock);
 			spin_lock(&conn->session->frwd_lock);
 			iscsi_send_nopout(conn,
-					  (struct iscsi_nopin*)&rejected_pdu);
+						(struct iscsi_nopin *)&rejected_pdu);
 			spin_unlock(&conn->session->frwd_lock);
 			spin_lock(&conn->session->back_lock);
 		} else {
@@ -1097,7 +1097,7 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 				rc = ISCSI_ERR_BAD_ITT;
 			} else
 				rc = iscsi_nop_out_rsp(task,
-					(struct iscsi_nopin*)&rejected_pdu,
+					(struct iscsi_nopin *)&rejected_pdu,
 					NULL, 0);
 		}
 		break;
@@ -1173,9 +1173,9 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			  opcode, conn->id, itt, datalen);
 
 	if (itt == ~0U) {
-		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
+		iscsi_update_cmdsn(session, (struct iscsi_nopin *)hdr);
 
-		switch(opcode) {
+		switch (opcode) {
 		case ISCSI_OP_NOOP_IN:
 			if (datalen) {
 				rc = ISCSI_ERR_PROTO;
@@ -1188,7 +1188,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			/* In RX path we are under back lock */
 			spin_unlock(&session->back_lock);
 			spin_lock(&session->frwd_lock);
-			iscsi_send_nopout(conn, (struct iscsi_nopin*)hdr);
+			iscsi_send_nopout(conn, (struct iscsi_nopin *)hdr);
 			spin_unlock(&session->frwd_lock);
 			spin_lock(&session->back_lock);
 			break;
@@ -1207,7 +1207,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		goto out;
 	}
 
-	switch(opcode) {
+	switch (opcode) {
 	case ISCSI_OP_SCSI_CMD_RSP:
 	case ISCSI_OP_SCSI_DATA_IN:
 		task = iscsi_itt_to_ctask(conn, hdr->itt);
@@ -1233,7 +1233,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		return ISCSI_ERR_BAD_OPCODE;
 	}
 
-	switch(opcode) {
+	switch (opcode) {
 	case ISCSI_OP_SCSI_CMD_RSP:
 		iscsi_scsi_cmd_rsp(conn, hdr, task, data, datalen);
 		break;
@@ -1241,7 +1241,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		iscsi_data_in_rsp(conn, hdr, task);
 		break;
 	case ISCSI_OP_LOGOUT_RSP:
-		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
+		iscsi_update_cmdsn(session, (struct iscsi_nopin *)hdr);
 		if (datalen) {
 			rc = ISCSI_ERR_PROTO;
 			break;
@@ -1250,14 +1250,14 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		goto recv_pdu;
 	case ISCSI_OP_LOGIN_RSP:
 	case ISCSI_OP_TEXT_RSP:
-		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
+		iscsi_update_cmdsn(session, (struct iscsi_nopin *)hdr);
 		/*
 		 * login related PDU's exp_statsn is handled in
 		 * userspace
 		 */
 		goto recv_pdu;
 	case ISCSI_OP_SCSI_TMFUNC_RSP:
-		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
+		iscsi_update_cmdsn(session, (struct iscsi_nopin *)hdr);
 		if (datalen) {
 			rc = ISCSI_ERR_PROTO;
 			break;
@@ -1267,14 +1267,14 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
 		break;
 	case ISCSI_OP_NOOP_IN:
-		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
+		iscsi_update_cmdsn(session, (struct iscsi_nopin *)hdr);
 		if (hdr->ttt != cpu_to_be32(ISCSI_RESERVED_TAG) || datalen) {
 			rc = ISCSI_ERR_PROTO;
 			break;
 		}
 		conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
 
-		rc = iscsi_nop_out_rsp(task, (struct iscsi_nopin*)hdr,
+		rc = iscsi_nop_out_rsp(task, (struct iscsi_nopin *)hdr,
 				       data, datalen);
 		break;
 	default:
@@ -1383,7 +1383,7 @@ void iscsi_session_failure(struct iscsi_session *session,
 	dev = get_device(&conn->cls_conn->dev);
 	spin_unlock_bh(&session->frwd_lock);
 	if (!dev)
-	        return;
+		return;
 	/*
 	 * if the host is being removed bypass the connection
 	 * recovery initialization because we are going to kill
@@ -1503,8 +1503,8 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 
 	if (conn->task) {
 		rc = iscsi_xmit_task(conn);
-	        if (rc)
-		        goto done;
+		if (rc)
+			goto done;
 	}
 
 	/*
@@ -2534,11 +2534,11 @@ iscsi_pool_init(struct iscsi_pool *q, int max, void ***items, int item_size)
 	 * the array. */
 	if (items)
 		num_arrays++;
-	q->pool = kzalloc(num_arrays * max * sizeof(void*), GFP_KERNEL);
+	q->pool = kzalloc(num_arrays * max * sizeof(void *), GFP_KERNEL);
 	if (q->pool == NULL)
 		return -ENOMEM;
 
-	kfifo_init(&q->queue, (void*)q->pool, max * sizeof(void*));
+	kfifo_init(&q->queue, (void *)q->pool, max * sizeof(void *));
 
 	for (i = 0; i < max; i++) {
 		q->pool[i] = kzalloc(item_size, GFP_KERNEL);
@@ -2546,7 +2546,7 @@ iscsi_pool_init(struct iscsi_pool *q, int max, void ***items, int item_size)
 			q->max = i;
 			goto enomem;
 		}
-		kfifo_in(&q->queue, (void*)&q->pool[i], sizeof(void*));
+		kfifo_in(&q->queue, (void *)&q->pool[i], sizeof(void *));
 	}
 
 	if (items) {
@@ -2793,7 +2793,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 
 	/* initialize SCSI PDU commands pool */
 	if (iscsi_pool_init(&session->cmdpool, session->cmds_max,
-			    (void***)&session->cmds,
+			    (void ***)&session->cmds,
 			    cmd_task_size + sizeof(struct iscsi_task)))
 		goto cmdpool_alloc_fail;
 
@@ -2905,8 +2905,8 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	/* allocate login_task used for the login/text sequences */
 	spin_lock_bh(&session->frwd_lock);
 	if (!kfifo_out(&session->cmdpool.queue,
-                         (void*)&conn->login_task,
-			 sizeof(void*))) {
+			(void *)&conn->login_task,
+			 sizeof(void *))) {
 		spin_unlock_bh(&session->frwd_lock);
 		goto login_task_alloc_fail;
 	}
@@ -2924,8 +2924,8 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	return cls_conn;
 
 login_task_data_alloc_fail:
-	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
-		    sizeof(void*));
+	kfifo_in(&session->cmdpool.queue, (void *)&conn->login_task,
+		    sizeof(void *));
 login_task_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
 	return NULL;
@@ -2968,8 +2968,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	kfree(conn->local_ipaddr);
 	/* regular RX path uses back_lock */
 	spin_lock_bh(&session->back_lock);
-	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
-		    sizeof(void*));
+	kfifo_in(&session->cmdpool.queue, (void *)&conn->login_task,
+			sizeof(void *));
 	spin_unlock_bh(&session->back_lock);
 	if (session->leadconn == conn)
 		session->leadconn = NULL;
@@ -3022,7 +3022,7 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 		mod_timer(&conn->transport_timer,
 			  jiffies + (conn->recv_timeout * HZ));
 
-	switch(conn->stop_stage) {
+	switch (conn->stop_stage) {
 	case STOP_CONN_RECOVER:
 		/*
 		 * unblock eh_abort() if it is blocked. re-try all
@@ -3197,7 +3197,7 @@ int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
 	struct iscsi_session *session = conn->session;
 	int val;
 
-	switch(param) {
+	switch (param) {
 	case ISCSI_PARAM_FAST_ABORT:
 		sscanf(buf, "%d", &session->fast_abort);
 		break;
@@ -3310,7 +3310,7 @@ int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
 	struct iscsi_session *session = cls_session->dd_data;
 	int len;
 
-	switch(param) {
+	switch (param) {
 	case ISCSI_PARAM_FAST_ABORT:
 		len = sprintf(buf, "%d\n", session->fast_abort);
 		break;
@@ -3488,7 +3488,7 @@ int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	int len;
 
-	switch(param) {
+	switch (param) {
 	case ISCSI_PARAM_PING_TMO:
 		len = sprintf(buf, "%u\n", conn->ping_timeout);
 		break;
-- 
2.6.6

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
