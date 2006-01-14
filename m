From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [RESEND PATCH 1/8] iscsi: whitespace cleanup
Date: Fri, 13 Jan 2006 18:05:35 -0600
Message-ID: <1137197135.2720.31.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:30388 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1423144AbWANAFr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 19:05:47 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k0E05kb4021721
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 18:05:47 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From FUJITA Tomonori <tomof@acm.org>:

Remove extra whitespaces.

Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 1067d77..49d6dd5 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -687,7 +687,7 @@ iscsi_hdr_recv(struct iscsi_conn *conn)
 		switch(conn->in.opcode) {
 		case ISCSI_OP_LOGIN_RSP:
 		case ISCSI_OP_TEXT_RSP:
-		case ISCSI_OP_LOGOUT_RSP: 
+		case ISCSI_OP_LOGOUT_RSP:
 			rc = iscsi_check_assign_cmdsn(session,
 						 (struct iscsi_nopin*)hdr);
 			if (rc)
@@ -728,12 +728,12 @@ iscsi_hdr_recv(struct iscsi_conn *conn)
 			}
 			spin_unlock(&session->lock);
 			break;
-		case ISCSI_OP_NOOP_IN: 
+		case ISCSI_OP_NOOP_IN:
 			if (hdr->ttt != ISCSI_RESERVED_TAG) {
 				rc = ISCSI_ERR_PROTO;
 				break;
 			}
-			rc = iscsi_check_assign_cmdsn(session, 
+			rc = iscsi_check_assign_cmdsn(session,
 						(struct iscsi_nopin*)hdr);
 			if (rc)
 				break;
@@ -768,7 +768,7 @@ iscsi_hdr_recv(struct iscsi_conn *conn)
 				if (!rc && hdr->ttt != ISCSI_RESERVED_TAG)
 					rc = iscsi_recv_pdu(iscsi_handle(conn),
 							    hdr, NULL, 0);
-			} else 
+			} else
 				rc = ISCSI_ERR_PROTO;
 			break;
 		case ISCSI_OP_REJECT:
@@ -930,7 +930,7 @@ static int iscsi_scsi_data_in(struct isc
 				      sc->request_bufflen, ctask->data_offset);
 		if (rc == -EAGAIN)
 			return rc;
-		if (conn->datadgst_en) 
+		if (conn->datadgst_en)
 			iscsi_recv_digest_update(conn, sc->request_buffer, i);
 		rc = 0;
 		goto done;
@@ -1025,7 +1025,7 @@ iscsi_data_recv(struct iscsi_conn *conn)
 		conn->in.hdr = &conn->hdr;
 		conn->senselen = (conn->data[0] << 8) | conn->data[1];
 		rc = iscsi_cmd_rsp(conn, conn->in.ctask);
-		if (!rc && conn->datadgst_en) 
+		if (!rc && conn->datadgst_en)
 			iscsi_recv_digest_update(conn, conn->data,
 						 conn->in.datalen);
 	}
@@ -1052,7 +1052,7 @@ iscsi_data_recv(struct iscsi_conn *conn)
 		rc = iscsi_recv_pdu(iscsi_handle(conn), conn->in.hdr,
 				    conn->data, conn->in.datalen);
 
-		if (!rc && conn->datadgst_en && 
+		if (!rc && conn->datadgst_en &&
 			conn->in.opcode != ISCSI_OP_LOGIN_RSP)
 			iscsi_recv_digest_update(conn, conn->data,
 			  			conn->in.datalen);
@@ -1681,7 +1681,7 @@ iscsi_cmd_init(struct iscsi_conn *conn, 
 		zero_data(ctask->hdr.dlength);
 	}
 
-	iscsi_buf_init_virt(&ctask->headbuf, (char*)&ctask->hdr, 
+	iscsi_buf_init_virt(&ctask->headbuf, (char*)&ctask->hdr,
 			    sizeof(struct iscsi_hdr));
 	conn->scsicmd_pdus_cnt++;
 }
@@ -1747,7 +1747,7 @@ static inline int
 handle_xmstate_r_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 {
 	ctask->xmstate &= ~XMSTATE_R_HDR;
-	if (conn->hdrdgst_en) 
+	if (conn->hdrdgst_en)
 		iscsi_hdr_digest(conn, &ctask->headbuf, (u8*)ctask->hdrext);
 	if (!iscsi_sendhdr(conn, &ctask->headbuf, 0)) {
 		BUG_ON(ctask->xmstate != XMSTATE_IDLE);
@@ -1761,7 +1761,7 @@ static inline int
 handle_xmstate_w_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 {
 	ctask->xmstate &= ~XMSTATE_W_HDR;
-	if (conn->hdrdgst_en) 
+	if (conn->hdrdgst_en)
 		iscsi_hdr_digest(conn, &ctask->headbuf, (u8*)ctask->hdrext);
 	if (iscsi_sendhdr(conn, &ctask->headbuf, ctask->imm_count)) {
 		ctask->xmstate |= XMSTATE_W_HDR;
@@ -2149,7 +2149,7 @@ unsolicit_head_again:
 solicit_head_again:
 		r2t = ctask->r2t;
 		if (conn->hdrdgst_en)
-			iscsi_hdr_digest(conn, &r2t->headbuf, 
+			iscsi_hdr_digest(conn, &r2t->headbuf,
 					(u8*)r2t->dtask->hdrext);
 		if (iscsi_sendhdr(conn, &r2t->headbuf, r2t->data_count)) {
 			ctask->xmstate &= ~XMSTATE_SOL_DATA;


