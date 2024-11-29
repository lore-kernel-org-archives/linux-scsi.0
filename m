Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDD3145324;
	Fri, 29 Nov 2024 15:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732894823; cv=none; b=ntz20drc66H2s2VLz+fZDXj9X8aG4CEaCvOibeDg2BpwD88uyC39qGrnNdpHXXg2ljq17iIp66SFxAzBFzgXyuzbdFwe7dX42y31kotILwLhL/idkfO5bIZ2elBIZakNiS8/nu82JsFWuZwqtu/cREUppAjZUWiZV3CP1znnSgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732894823; c=relaxed/simple;
	bh=Pz4Z/pmoaFhspNJs2NAP4XsQqvwgtBsp5wBHAFUSblw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rQxkgN62AQJpY6mCwdctoH80Nw+Gvo4QkU+SchTPjK22X5ulCCcF0zkHQvE0GpTp2nHpC1YPOqfzKFu7OOfXJ9npk2uplbqS9KyRr5P1eYzdO2w9CNRM7LA7Dxo3x2gqFTXFVwTdAkUtfePrx82x2q/r3vDhKZj5oNlR7MQr5sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=pOMNsc93; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=XXIBr7le; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="pOMNsc93";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="XXIBr7le"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 114F0E0008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1732894346; bh=6r7QDkXtT+7/W0SwfpvnLNeMRvi4uYNH4riUPdpekxw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=pOMNsc93UuPe0nuw0FbiIxzCxpDjjUrISBr5H/ypSgWt20hBuXnEMezS8Qv+Ux4dS
	 ydrFW/3NOrEW0fYiYH/shBvK4+9+Hpw1PBk8V9FU06YQKcRcR1dGTLhqrbWcmJcko9
	 lFu23a9I7VSmGXxbNgdNyL/OJmMZ4p+ylt6A+2QKL55HCU4Xs9RkrkY2qxOzz+Qfjl
	 teAGtUFZSTOePOqrta86MQE8WSA2ZEqk99o05TTF5jGsADd32KrsdU2M9MqZh2eqfm
	 Dfzpo4kgJORRdOvabuns+oB2mt2VyTK+yu3+qkrlDyTBF+SkmW+w+mMWh2stot+p66
	 M1T+ho34UZX1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1732894346; bh=6r7QDkXtT+7/W0SwfpvnLNeMRvi4uYNH4riUPdpekxw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=XXIBr7le/EZ3GnhCMlmG5b2ZyrcN/LLRPmiEnoTX4YP9UcCdjjDk7EMPHyhthYFVR
	 R//32QVbxMIws0TBy1uLr8n83xDNVCkEscm1/NeH+ajkly4suoIjJ82ppCLaQws+8g
	 eNUo4buQQGbMTwkBmxQsLzseQJqtTnIDW4weRZHK2heo/4jPDF7ZNHT7y/yV3Ip3TA
	 ErMBqNJOQGlx/8jFGrmoIF8Y+EiPEWYA2E9IzrwjA/iBg5UFjJ1zB/IulyHvm41VgJ
	 EceOW8DpantAGoYgqLWELMXJzmZUww5W7Od8DgDmaG8dQ5Nxm58BgDCDJcojbFh/RE
	 UokYiXumvFLSg==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <martin.petersen@oracle.com>, <bootc@bootc.net>, <bostroesser@gmail.com>,
	<michael.christie@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
	<linux@yadro.com>
Subject: [PATCH 04/10] target: Fix some obvious style problems
Date: Fri, 29 Nov 2024 18:30:50 +0300
Message-ID: <20241129153056.6985-5-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.3
In-Reply-To: <20241129153056.6985-1-a.kovaleva@yadro.com>
References: <20241129153056.6985-1-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-10.corp.yadro.com (172.17.11.60) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

Fix obvious style problems, that checkpatch can solve by itself.
Patch was made automatically with this command:

./scripts/checkpatch.pl --fix-inplace -f ./drivers/target/**/*.{c,h}

and then carefully checked manually.

Warnings and errors that were fixed are:
  WARNING: quoted string split across lines
  WARNING: unnecessary whitespace before a quoted newline
  WARNING: break quoted strings at a space character
  WARNING: Integer promotion: Using 'h' in '%hu' is unnecessary
  ERROR: trailing whitespace
  ERROR: code indent should use tabs where possible
  WARNING: please, no spaces at the start of a line
  WARNING: please, no space before tabs
  WARNING: break quoted strings at a space character
  WARNING: Missing a blank line after declarations
  WARNING: space prohibited between function name and open parenthesis '('
  ERROR: space prohibited after that open parenthesis '('
  ERROR: space required before the open parenthesis '('
  ERROR: space prohibited before that close parenthesis ')'
  ERROR: do not initialise statics to NULL
  WARNING: sizeof buf should be sizeof(buf)
  WARNING: space prohibited before semicolon
  WARNING: Possible repeated word: 'the'
  WARNING: Possible repeated word: 'calling'
  WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
  WARNING: Unnecessary typecast of c90 int constant - '(unsigned long long)0' could be '0ULL'
  ERROR: spaces required around that '=' (ctx:VxW)
  ERROR: space required after that ',' (ctx:VxV)
  WARNING: Statements should start on a tabstop
  WARNING: Symbolic permissions 'S_IWUSR | S_IRUGO' are not preferred. Consider using octal permissions '0644'.
  WARNING: Symbolic permissions 'S_IWUSR' are not preferred. Consider using octal permissions '0200'.
  WARNING: Prefer __packed over __attribute__((__packed__))
  WARNING: Comparisons should place the constant on the right side of the test

Then all format strings arguments were aligned by parenthesis by
git-clang-format util.

Note: The functions, where checkpatch.pl + clang-format made mistakes:
lio_target_nacl_info_show
lio_target_nacl_info_show
iscsit_get_seq_holder_for_datain
core_alua_show_tg_pt_gp_info
target_core_item_version_show
target_pr_res_pr_holder_tg_port_show
target_tg_pt_gp_alua_access_type_store
core_scsi3_update_aptpl_buf
core_scsi3_update_aptpl_buf
core_scsi3_update_aptpl_buf
pscsi_show_configfs_dev_params
rd_show_configfs_dev_params
core_tmr_drain_state_list
core_tmr_lun_reset
tcmu_global_max_data_area_op
ft_del_wwn

Reviewed-by: Dmitriy Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
---
 drivers/target/iscsi/cxgbit/cxgbit_target.c   |  2 +-
 drivers/target/iscsi/iscsi_target.c           | 60 +++++++++----------
 drivers/target/iscsi/iscsi_target_configfs.c  |  4 +-
 drivers/target/iscsi/iscsi_target_erl0.c      |  3 +-
 drivers/target/iscsi/iscsi_target_erl1.c      |  4 +-
 drivers/target/iscsi/iscsi_target_erl2.c      | 16 ++---
 drivers/target/iscsi/iscsi_target_login.c     | 19 +++---
 drivers/target/iscsi/iscsi_target_nego.c      |  5 +-
 .../target/iscsi/iscsi_target_parameters.c    | 18 +++---
 drivers/target/iscsi/iscsi_target_tmr.c       | 10 ++--
 drivers/target/iscsi/iscsi_target_tpg.c       | 45 +++++++-------
 drivers/target/iscsi/iscsi_target_util.c      |  9 +--
 drivers/target/sbp/sbp_target.c               |  6 +-
 drivers/target/target_core_alua.c             | 16 ++---
 drivers/target/target_core_configfs.c         | 20 +++----
 drivers/target/target_core_device.c           |  6 +-
 drivers/target/target_core_fabric_configfs.c  |  3 +-
 drivers/target/target_core_fabric_lib.c       |  2 +-
 drivers/target/target_core_iblock.c           |  2 +-
 drivers/target/target_core_pr.c               | 33 +++++-----
 drivers/target/target_core_pscsi.c            |  2 +-
 drivers/target/target_core_rd.c               |  4 +-
 drivers/target/target_core_sbc.c              |  1 +
 drivers/target/target_core_spc.c              |  2 +-
 drivers/target/target_core_stat.c             |  2 +-
 drivers/target/target_core_tmr.c              |  2 +-
 drivers/target/target_core_tpg.c              |  6 +-
 drivers/target/target_core_transport.c        | 14 ++---
 drivers/target/target_core_user.c             | 12 ++--
 drivers/target/target_core_xcopy.c            | 16 ++---
 drivers/target/tcm_fc/tcm_fc.h                |  2 +-
 drivers/target/tcm_fc/tfc_conf.c              |  2 +-
 drivers/target/tcm_fc/tfc_sess.c              |  1 +
 33 files changed, 182 insertions(+), 167 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index 95301f3c62a2..826b951ed7c2 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -1312,7 +1312,7 @@ static int cxgbit_rx_login_pdu(struct cxgbit_sock *csk)
 	login_req = (struct iscsi_login_req *)login->req;
 	memcpy(login_req, pdu_cb->hdr, sizeof(*login_req));
 
-	target_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x, CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %hu, Length: %u\n",
+	target_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x, CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %u, Length: %u\n",
 		     login_req->flags, login_req->itt, login_req->cmdsn, login_req->exp_statsn,
 		     login_req->cid, pdu_cb->dlen);
 	/*
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 313b829d6c54..0ad150d92805 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1173,7 +1173,7 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 			  cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun),
 			  conn->cmd_cnt);
 
-	target_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x, ExpXferLen: %u, Length: %u, CID: %hu\n",
+	target_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x, ExpXferLen: %u, Length: %u, CID: %u\n",
 		     hdr->itt, hdr->cmdsn, be32_to_cpu(hdr->data_length), payload_length,
 		     conn->cid);
 
@@ -1467,7 +1467,7 @@ __iscsit_check_dataout_hdr(struct iscsit_conn *conn, void *buf,
 	/* iSCSI write */
 	atomic_long_add(payload_length, &conn->sess->rx_data_octets);
 
-	target_debug("Got DataOut ITT: 0x%08x, TTT: 0x%08x, DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
+	target_debug("Got DataOut ITT: 0x%08x, TTT: 0x%08x, DataSN: 0x%08x, Offset: %u, Length: %u, CID: %u\n",
 		     hdr->itt, hdr->ttt, hdr->datasn, ntohl(hdr->offset), payload_length,
 		     conn->cid);
 
@@ -1725,7 +1725,7 @@ int iscsit_setup_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 		if (!cmd)
 			return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
 						 (unsigned char *)hdr);
-		
+
 		return iscsit_reject_cmd(cmd, ISCSI_REASON_PROTOCOL_ERROR,
 					 (unsigned char *)hdr);
 	}
@@ -1804,7 +1804,7 @@ int iscsit_process_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 
 		cmdsn_ret = iscsit_sequence_cmd(conn, cmd,
 				(unsigned char *)hdr, hdr->cmdsn);
-                if (cmdsn_ret == CMDSN_LOWER_THAN_EXP)
+		if (cmdsn_ret == CMDSN_LOWER_THAN_EXP)
 			return 0;
 		if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER)
 			return -1;
@@ -1835,7 +1835,7 @@ int iscsit_process_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	if (cmd)
 		iscsit_free_cmd(cmd, false);
 
-        return 0;
+	return 0;
 }
 EXPORT_SYMBOL(iscsit_process_nop_out);
 
@@ -1972,7 +1972,7 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	hdr->flags &= ~ISCSI_FLAG_CMD_FINAL;
 	function = hdr->flags;
 
-	target_debug("Got Task Management Request ITT: 0x%08x, CmdSN: 0x%08x, Function: 0x%02x, RefTaskTag: 0x%08x, RefCmdSN: 0x%08x, CID: %hu\n",
+	target_debug("Got Task Management Request ITT: 0x%08x, CmdSN: 0x%08x, Function: 0x%02x, RefTaskTag: 0x%08x, RefCmdSN: 0x%08x, CID: %u\n",
 		     hdr->itt, hdr->cmdsn, function, hdr->rtt, hdr->refcmdsn, conn->cid);
 
 	if ((function != ISCSI_TM_FUNC_ABORT_TASK) &&
@@ -2100,6 +2100,7 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 
 	if (!(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
 		int cmdsn_ret = iscsit_sequence_cmd(conn, cmd, buf, hdr->cmdsn);
+
 		if (cmdsn_ret == CMDSN_HIGHER_THAN_EXP) {
 			out_of_order_cmdsn = 1;
 		} else if (cmdsn_ret == CMDSN_LOWER_THAN_EXP) {
@@ -2316,7 +2317,7 @@ int iscsit_logout_closesession(struct iscsit_cmd *cmd, struct iscsit_conn *conn)
 	struct iscsit_conn *conn_p;
 	struct iscsit_session *sess = conn->sess;
 
-	target_debug("Received logout request CLOSESESSION on CID: %hu for SID: %u.\n", conn->cid,
+	target_debug("Received logout request CLOSESESSION on CID: %u for SID: %u.\n", conn->cid,
 		     conn->sess->sid);
 
 	atomic_set(&sess->session_logout, 1);
@@ -2346,7 +2347,7 @@ int iscsit_logout_closeconnection(struct iscsit_cmd *cmd, struct iscsit_conn *co
 	struct iscsit_conn *l_conn;
 	struct iscsit_session *sess = conn->sess;
 
-	target_debug("Received logout request CLOSECONNECTION for CID: %hu on CID: %hu.\n",
+	target_debug("Received logout request CLOSECONNECTION for CID: %u on CID: %u.\n",
 		     cmd->logout_cid, conn->cid);
 
 	/*
@@ -2393,7 +2394,7 @@ int iscsit_logout_removeconnforrecovery(struct iscsit_cmd *cmd, struct iscsit_co
 {
 	struct iscsit_session *sess = conn->sess;
 
-	target_debug("Received explicit REMOVECONNFORRECOVERY logout for CID: %hu on CID: %hu.\n",
+	target_debug("Received explicit REMOVECONNFORRECOVERY logout for CID: %u on CID: %u.\n",
 		     cmd->logout_cid, conn->cid);
 
 	if (sess->sess_ops->ErrorRecoveryLevel != 2) {
@@ -2404,7 +2405,7 @@ int iscsit_logout_removeconnforrecovery(struct iscsit_cmd *cmd, struct iscsit_co
 	}
 
 	if (conn->cid == cmd->logout_cid) {
-		target_err("Received Logout Request REMOVECONNFORRECOVERY with CID: %hu on CID: %hu, implementation error.\n",
+		target_err("Received Logout Request REMOVECONNFORRECOVERY with CID: %u on CID: %u, implementation error.\n",
 			   cmd->logout_cid, conn->cid);
 		cmd->logout_response = ISCSI_LOGOUT_CLEANUP_FAILED;
 		iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
@@ -2503,7 +2504,7 @@ int iscsit_handle_snack(
 	hdr			= (struct iscsi_snack *) buf;
 	hdr->flags		&= ~ISCSI_FLAG_CMD_FINAL;
 
-	target_debug("Got ISCSI_INIT_SNACK, ITT: 0x%08x, ExpStatSN: 0x%08x, Type: 0x%02x, BegRun: 0x%08x, RunLength: 0x%08x, CID: %hu\n",
+	target_debug("Got ISCSI_INIT_SNACK, ITT: 0x%08x, ExpStatSN: 0x%08x, Type: 0x%02x, BegRun: 0x%08x, RunLength: 0x%08x, CID: %u\n",
 		     hdr->itt, hdr->exp_statsn, hdr->flags, hdr->begrun, hdr->runlength, conn->cid);
 
 	if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
@@ -2723,7 +2724,7 @@ static int iscsit_send_conn_drop_async_message(
 	hdr->param2		= cpu_to_be16(conn->sess->sess_ops->DefaultTime2Wait);
 	hdr->param3		= cpu_to_be16(conn->sess->sess_ops->DefaultTime2Retain);
 
-	target_debug("Sending Connection Dropped Async Message StatSN: 0x%08x, for CID: %hu on CID: %hu\n",
+	target_debug("Sending Connection Dropped Async Message StatSN: 0x%08x, for CID: %u on CID: %u\n",
 		     cmd->stat_sn, cmd->logout_cid, conn->cid);
 
 	return conn->conn_transport->iscsit_xmit_pdu(conn, cmd, NULL, NULL, 0);
@@ -2778,7 +2779,7 @@ iscsit_build_datain_pdu(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 	hdr->datasn		= cpu_to_be32(datain->data_sn);
 	hdr->offset		= cpu_to_be32(datain->offset);
 
-	target_debug("Built DataIN ITT: 0x%08x, StatSN: 0x%08x, DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
+	target_debug("Built DataIN ITT: 0x%08x, StatSN: 0x%08x, DataSN: 0x%08x, Offset: %u, Length: %u, CID: %u\n",
 		     cmd->init_task_tag, ntohl(hdr->statsn), ntohl(hdr->datasn), ntohl(hdr->offset),
 		     datain->length, conn->cid);
 }
@@ -2874,7 +2875,7 @@ iscsit_build_logout_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 		 * is stopped in iscsit_logout_post_handler_diffcid().
 		 */
 
-		target_debug("iSCSI CID: %hu logout on CID: %hu successful.\n", cmd->logout_cid,
+		target_debug("iSCSI CID: %u logout on CID: %u successful.\n", cmd->logout_cid,
 			     conn->cid);
 		cmd->logout_response = ISCSI_LOGOUT_SUCCESS;
 		break;
@@ -2896,7 +2897,7 @@ iscsit_build_logout_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 		cr = iscsit_get_inactive_connection_recovery_entry(
 				conn->sess, cmd->logout_cid);
 		if (!cr) {
-			target_err("Unable to locate CID: %hu for REMOVECONNFORRECOVERY Logout Request.\n",
+			target_err("Unable to locate CID: %u for REMOVECONNFORRECOVERY Logout Request.\n",
 				   cmd->logout_cid);
 			cmd->logout_response = ISCSI_LOGOUT_CID_NOT_FOUND;
 			break;
@@ -2904,7 +2905,7 @@ iscsit_build_logout_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 
 		iscsit_discard_cr_cmds_by_expstatsn(cr, cmd->exp_stat_sn);
 
-		target_debug("iSCSI REMOVECONNFORRECOVERY logout for recovery for CID: %hu on CID: %hu successful.\n",
+		target_debug("iSCSI REMOVECONNFORRECOVERY logout for recovery for CID: %u on CID: %u successful.\n",
 			     cmd->logout_cid, conn->cid);
 		cmd->logout_response = ISCSI_LOGOUT_SUCCESS;
 		break;
@@ -2924,7 +2925,7 @@ iscsit_build_logout_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
 	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
-	target_debug("Built Logout Response ITT: 0x%08x StatSN: 0x%08x Response: 0x%02x CID: %hu on CID: %hu\n",
+	target_debug("Built Logout Response ITT: 0x%08x StatSN: 0x%08x Response: 0x%02x CID: %u on CID: %u\n",
 		     cmd->init_task_tag, cmd->stat_sn, hdr->response, cmd->logout_cid, conn->cid);
 
 	return 0;
@@ -2950,7 +2951,7 @@ iscsit_build_nopin_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 {
 	hdr->opcode		= ISCSI_OP_NOOP_IN;
 	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
-        hton24(hdr->dlength, cmd->buf_ptr_size);
+	hton24(hdr->dlength, cmd->buf_ptr_size);
 	if (nopout_response)
 		put_unaligned_le64(0xFFFFFFFFFFFFFFFFULL, &hdr->lun);
 	hdr->itt		= cmd->init_task_tag;
@@ -2984,7 +2985,7 @@ static int iscsit_send_unsolicited_nopin(
 
 	iscsit_build_nopin_rsp(cmd, conn, hdr, false);
 
-	target_debug("Sending Unsolicited NOPIN TTT: 0x%08x StatSN: 0x%08x CID: %hu\n", hdr->ttt,
+	target_debug("Sending Unsolicited NOPIN TTT: 0x%08x StatSN: 0x%08x CID: %u\n", hdr->ttt,
 		     cmd->stat_sn, conn->cid);
 
 	ret = conn->conn_transport->iscsit_xmit_pdu(conn, cmd, NULL, NULL, 0);
@@ -3048,7 +3049,7 @@ static int iscsit_send_r2t(
 	hdr->data_offset	= cpu_to_be32(r2t->offset);
 	hdr->data_length	= cpu_to_be32(r2t->xfer_len);
 
-	target_debug("Built %sR2T, ITT: 0x%08x, TTT: 0x%08x, StatSN: 0x%08x, R2TSN: 0x%08x, Offset: %u, DDTL: %u, CID: %hu\n",
+	target_debug("Built %sR2T, ITT: 0x%08x, TTT: 0x%08x, StatSN: 0x%08x, R2TSN: 0x%08x, Offset: %u, DDTL: %u, CID: %u\n",
 		     (!r2t->recovery_r2t) ? "" : "Recovery ", cmd->init_task_tag,
 		     r2t->targ_xfer_tag, ntohl(hdr->statsn), r2t->r2t_sn, r2t->offset,
 		     r2t->xfer_len, conn->cid);
@@ -3184,7 +3185,7 @@ void iscsit_build_rsp_pdu(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
 	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
-	target_debug("Built SCSI Response, ITT: 0x%08x, StatSN: 0x%08x, Response: 0x%02x, SAM Status: 0x%02x, CID: %hu\n",
+	target_debug("Built SCSI Response, ITT: 0x%08x, StatSN: 0x%08x, Response: 0x%02x, SAM Status: 0x%02x, CID: %u\n",
 		     cmd->init_task_tag, cmd->stat_sn, cmd->se_cmd.scsi_status,
 		     cmd->se_cmd.scsi_status, conn->cid);
 }
@@ -3206,7 +3207,7 @@ static int iscsit_send_response(struct iscsit_cmd *cmd, struct iscsit_conn *conn
 	   ((cmd->se_cmd.se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
 	    (cmd->se_cmd.se_cmd_flags & SCF_EMULATED_TASK_SENSE))) {
 		put_unaligned_be16(cmd->se_cmd.scsi_sense_length, cmd->sense_buffer);
-		cmd->se_cmd.scsi_sense_length += sizeof (__be16);
+		cmd->se_cmd.scsi_sense_length += sizeof(__be16);
 
 		padding		= -(cmd->se_cmd.scsi_sense_length) & 3;
 		hton24(hdr->dlength, (u32)cmd->se_cmd.scsi_sense_length);
@@ -3261,7 +3262,7 @@ iscsit_build_task_mgt_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
 	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
-	target_debug("Built Task Management Response ITT: 0x%08x, StatSN: 0x%08x, Response: 0x%02x, CID: %hu\n",
+	target_debug("Built Task Management Response ITT: 0x%08x, StatSN: 0x%08x, Response: 0x%02x, CID: %u\n",
 		     cmd->init_task_tag, cmd->stat_sn, hdr->response, conn->cid);
 }
 EXPORT_SYMBOL(iscsit_build_task_mgt_rsp);
@@ -3386,10 +3387,7 @@ iscsit_build_sendtargets_response(struct iscsit_cmd *cmd,
 				else
 					sockaddr = &np->np_sockaddr;
 
-				len = sprintf(buf, "TargetAddress="
-					      "%pISpc,%hu",
-					      sockaddr,
-					      tpg->tpgt);
+				len = sprintf(buf, "TargetAddress=%pISpc,%hu", sockaddr, tpg->tpgt);
 				len += 1;
 
 				if ((len + payload_len) > buffer_len) {
@@ -3467,7 +3465,7 @@ iscsit_build_text_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 	hdr->exp_cmdsn = cpu_to_be32(conn->sess->exp_cmd_sn);
 	hdr->max_cmdsn = cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
-	target_debug("Built Text Response: ITT: 0x%08x, TTT: 0x%08x, StatSN: 0x%08x, Length: %u, CID: %hu F: %d C: %d\n",
+	target_debug("Built Text Response: ITT: 0x%08x, TTT: 0x%08x, StatSN: 0x%08x, Length: %u, CID: %u F: %d C: %d\n",
 		     cmd->init_task_tag, cmd->targ_xfer_tag, cmd->stat_sn, text_length, conn->cid,
 		     !!(hdr->flags & ISCSI_FLAG_CMD_FINAL),
 		     !!(hdr->flags & ISCSI_FLAG_TEXT_CONTINUE));
@@ -3518,7 +3516,7 @@ static int iscsit_send_reject(
 
 	iscsit_build_reject(cmd, conn, hdr);
 
-	target_debug("Built Reject PDU StatSN: 0x%08x, Reason: 0x%02x, CID: %hu\n",
+	target_debug("Built Reject PDU StatSN: 0x%08x, Reason: 0x%02x, CID: %u\n",
 		     ntohl(hdr->statsn), hdr->reason, conn->cid);
 
 	return conn->conn_transport->iscsit_xmit_pdu(conn, cmd, NULL,
@@ -4180,7 +4178,7 @@ int iscsit_close_connection(
 	int conn_logout = (conn->conn_state == TARG_CONN_STATE_IN_LOGOUT);
 	struct iscsit_session	*sess = conn->sess;
 
-	target_debug("Closing iSCSI connection CID %hu on SID: %u\n", conn->cid, sess->sid);
+	target_debug("Closing iSCSI connection CID %u on SID: %u\n", conn->cid, sess->sid);
 	/*
 	 * Always up conn_logout_comp for the traditional TCP and HW_OFFLOAD
 	 * case just in case the RX Thread in iscsi_target_rx_opcode() is
@@ -4466,7 +4464,7 @@ int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
 	if (tpg->tpg_tiqn)
 		tpg->tpg_tiqn->tiqn_nsessions--;
 
-	target_debug("Decremented number of active iSCSI Sessions on iSCSI TPG: %hu to %u\n",
+	target_debug("Decremented number of active iSCSI Sessions on iSCSI TPG: %u to %u\n",
 		     tpg->tpgt, tpg->nsessions);
 
 	ida_free(&sess_ida, sess->session_index);
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index bf820981b0da..c0f63c51a6cc 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -210,7 +210,7 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 	if (ret < 0)
 		return ERR_PTR(-EINVAL);
 
-	target_debug("LIO_Target_ConfigFS: REGISTER -> %s TPGT: %hu PORTAL: %s\n",
+	target_debug("LIO_Target_ConfigFS: REGISTER -> %s TPGT: %u PORTAL: %s\n",
 		     config_item_name(&se_tpg->se_tpg_wwn->wwn_group.cg_item), tpg->tpgt, name);
 	/*
 	 * Assume ISCSI_TCP by default.  Other network portals for other
@@ -252,7 +252,7 @@ static void lio_target_call_delnpfromtpg(
 		return;
 
 	se_tpg = &tpg->tpg_se_tpg;
-	target_debug("LIO_Target_ConfigFS: DEREGISTER -> %s TPGT: %hu PORTAL: %pISpc\n",
+	target_debug("LIO_Target_ConfigFS: DEREGISTER -> %s TPGT: %u PORTAL: %pISpc\n",
 		     config_item_name(&se_tpg->se_tpg_wwn->wwn_group.cg_item), tpg->tpgt,
 		     &tpg_np->tpg_np->np_sockaddr);
 
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 0607cc3b6f07..c34a04b7e91f 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -334,6 +334,7 @@ static int iscsit_dataout_check_datasn(
 		data_sn = cmd->data_sn;
 	else {
 		struct iscsi_seq *seq = cmd->seq_ptr;
+
 		data_sn = seq->data_sn;
 	}
 
@@ -866,7 +867,7 @@ static void iscsit_handle_connection_cleanup(struct iscsit_conn *conn)
 	    !atomic_read(&sess->session_fall_back_to_erl0))
 		iscsit_connection_recovery_transport_reset(conn);
 	else {
-		target_debug("Performing cleanup for failed iSCSI Connection ID: %hu from %s\n",
+		target_debug("Performing cleanup for failed iSCSI Connection ID: %u from %s\n",
 			     conn->cid, sess->sess_ops->InitiatorName);
 		iscsit_close_connection(conn);
 	}
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 54dc01d289cf..91b36e46181d 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -460,7 +460,7 @@ int iscsit_handle_status_snack(
 	if (!begrun) {
 		begrun = conn->exp_statsn;
 	} else if (conn->exp_statsn > begrun) {
-		target_err("Got Status SNACK Begrun: 0x%08x, RunLength: 0x%08x but already got ExpStatSN: 0x%08x on CID: %hu.\n",
+		target_err("Got Status SNACK Begrun: 0x%08x, RunLength: 0x%08x but already got ExpStatSN: 0x%08x on CID: %u.\n",
 			   begrun, runlength, conn->exp_statsn, conn->cid);
 		return 0;
 	}
@@ -1174,7 +1174,7 @@ void iscsit_start_dataout_timer(
 	if (cmd->dataout_timer_flags & ISCSI_TF_RUNNING)
 		return;
 
-	target_debug("Starting DataOUT timer for ITT: 0x%08x on CID: %hu.\n", cmd->init_task_tag,
+	target_debug("Starting DataOUT timer for ITT: 0x%08x on CID: %u.\n", cmd->init_task_tag,
 		     conn->cid);
 
 	cmd->dataout_timer_flags &= ~ISCSI_TF_STOP;
diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
index 96fb0ea0ad4c..b28cf293b9be 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -232,7 +232,7 @@ void iscsit_discard_cr_cmds_by_expstatsn(
 		}
 
 		dropped_count++;
-		target_debug("Dropping Acknowledged ITT: 0x%08x, StatSN: 0x%08x, CID: %hu.\n",
+		target_debug("Dropping Acknowledged ITT: 0x%08x, StatSN: 0x%08x, CID: %u.\n",
 			     cmd->init_task_tag, cmd->stat_sn, cr->cid);
 
 		iscsit_remove_cmd_from_connection_recovery(cmd, sess);
@@ -243,15 +243,15 @@ void iscsit_discard_cr_cmds_by_expstatsn(
 	}
 	spin_unlock(&cr->conn_recovery_cmd_lock);
 
-	target_debug("Dropped %u total acknowledged commands on CID: %hu less than old ExpStatSN: 0x%08x\n",
+	target_debug("Dropped %u total acknowledged commands on CID: %u less than old ExpStatSN: 0x%08x\n",
 		     dropped_count, cr->cid, exp_statsn);
 
 	if (!cr->cmd_count) {
-		target_debug("No commands to be reassigned for failed connection CID: %hu on SID: %u\n",
+		target_debug("No commands to be reassigned for failed connection CID: %u on SID: %u\n",
 			     cr->cid, sess->sid);
 		iscsit_remove_inactive_connection_recovery_entry(cr, sess);
 		iscsit_attach_active_connection_recovery_entry(sess, cr);
-		target_debug("iSCSI connection recovery successful for CID: %hu on SID: %u\n",
+		target_debug("iSCSI connection recovery successful for CID: %u on SID: %u\n",
 			     cr->cid, sess->sid);
 		iscsit_remove_active_connection_recovery_entry(cr, sess);
 	} else {
@@ -275,7 +275,7 @@ int iscsit_discard_unacknowledged_ooo_cmdsns_for_conn(struct iscsit_conn *conn)
 			continue;
 
 		dropped_count++;
-		target_debug("Dropping unacknowledged CmdSN: 0x%08x during connection recovery on CID: %hu\n",
+		target_debug("Dropping unacknowledged CmdSN: 0x%08x during connection recovery on CID: %u\n",
 			     ooo_cmdsn->cmdsn, conn->cid);
 		iscsit_remove_ooo_cmdsn(sess, ooo_cmdsn);
 	}
@@ -294,7 +294,7 @@ int iscsit_discard_unacknowledged_ooo_cmdsns_for_conn(struct iscsit_conn *conn)
 	}
 	spin_unlock_bh(&conn->cmd_lock);
 
-	target_debug("Dropped %u total unacknowledged commands on CID: %hu for ExpCmdSN: 0x%08x.\n",
+	target_debug("Dropped %u total unacknowledged commands on CID: %u for ExpCmdSN: 0x%08x.\n",
 		     dropped_count, conn->cid, sess->exp_cmd_sn);
 	return 0;
 }
@@ -333,7 +333,7 @@ int iscsit_prepare_cmds_for_reallegiance(struct iscsit_conn *conn)
 
 		if ((cmd->iscsi_opcode != ISCSI_OP_SCSI_CMD) &&
 		    (cmd->iscsi_opcode != ISCSI_OP_NOOP_OUT)) {
-			target_debug("Not performing reallegiance on Opcode: 0x%02x, ITT: 0x%08x, CmdSN: 0x%08x, CID: %hu\n",
+			target_debug("Not performing reallegiance on Opcode: 0x%02x, ITT: 0x%08x, CmdSN: 0x%08x, CID: %u\n",
 				     cmd->iscsi_opcode, cmd->init_task_tag, cmd->cmd_sn, conn->cid);
 
 			list_del_init(&cmd->i_conn_node);
@@ -364,7 +364,7 @@ int iscsit_prepare_cmds_for_reallegiance(struct iscsit_conn *conn)
 		}
 
 		cmd_count++;
-		target_debug("Preparing Opcode: 0x%02x, ITT: 0x%08x, CmdSN: 0x%08x, StatSN: 0x%08x, CID: %hu for reallegiance.\n",
+		target_debug("Preparing Opcode: 0x%02x, ITT: 0x%08x, CmdSN: 0x%08x, StatSN: 0x%08x, CID: %u for reallegiance.\n",
 			     cmd->iscsi_opcode, cmd->init_task_tag, cmd->cmd_sn, cmd->stat_sn,
 			     conn->cid);
 
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 0450408bd9a3..1ba5af73aa01 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -207,6 +207,7 @@ static int iscsi_login_set_conn_values(
 	__be16 cid)
 {
 	int ret;
+
 	conn->sess		= sess;
 	conn->cid		= be16_to_cpu(cid);
 	/*
@@ -230,10 +231,10 @@ __printf(2, 3) int iscsi_change_param_sprintf(
 	va_list args;
 	unsigned char buf[64];
 
-	memset(buf, 0, sizeof buf);
+	memset(buf, 0, sizeof(buf));
 
 	va_start(args, fmt);
-	vsnprintf(buf, sizeof buf, fmt, args);
+	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 
 	if (iscsi_change_param_value(buf, conn->param_list, 0) < 0) {
@@ -571,7 +572,7 @@ int iscsi_login_post_auth_non_zero_tsih(
 	 */
 	conn_ptr = iscsit_get_conn_from_cid_rcfr(sess, cid);
 	if (conn_ptr) {
-		target_err("Connection exists with CID %hu for %s, performing connection reinstatement.\n",
+		target_err("Connection exists with CID %u for %s, performing connection reinstatement.\n",
 			   conn_ptr->cid, sess->sess_ops->InitiatorName);
 
 		iscsit_connection_reinstatement_rcfr(conn_ptr);
@@ -591,7 +592,7 @@ int iscsi_login_post_auth_non_zero_tsih(
 		cr = iscsit_get_inactive_connection_recovery_entry(
 				sess, cid);
 		if (cr) {
-			target_debug("Performing implicit logout for connection recovery on CID: %hu\n",
+			target_debug("Performing implicit logout for connection recovery on CID: %u\n",
 				     conn->cid);
 			iscsit_discard_cr_cmds_by_expstatsn(cr, exp_statsn);
 		}
@@ -757,7 +758,7 @@ void iscsi_post_login_handler(
 	target_debug("Moving to TARG_SESS_STATE_LOGGED_IN.\n");
 	sess->session_state = TARG_SESS_STATE_LOGGED_IN;
 
-	target_debug("iSCSI Login successful on CID: %hu from %pISpc to %pISpc,%hu\n", conn->cid,
+	target_debug("iSCSI Login successful on CID: %u from %pISpc to %pISpc,%u\n", conn->cid,
 		     &conn->login_sockaddr, &conn->local_sockaddr, tpg->tpgt);
 
 	spin_lock_bh(&sess->conn_lock);
@@ -776,7 +777,7 @@ void iscsi_post_login_handler(
 	if (tpg->tpg_tiqn)
 		tpg->tpg_tiqn->tiqn_nsessions++;
 
-	target_debug("Incremented number of active iSCSI sessions to %u on iSCSI Target Portal Group: %hu\n",
+	target_debug("Incremented number of active iSCSI sessions to %u on iSCSI Target Portal Group: %u\n",
 		     tpg->nsessions, tpg->tpgt);
 	spin_unlock_bh(&se_tpg->session_lock);
 
@@ -961,7 +962,7 @@ int iscsit_get_login_rx(struct iscsit_conn *conn, struct iscsi_login *login)
 	payload_length	= ntoh24(login_req->dlength);
 	padding = ((-payload_length) & 3);
 
-	target_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x, CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %hu, Length: %u\n",
+	target_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x, CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %u, Length: %u\n",
 		     login_req->flags, login_req->itt, login_req->cmdsn, login_req->exp_statsn,
 		     login_req->cid, payload_length);
 	/*
@@ -1304,11 +1305,11 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	/*
 	 * SessionType: Discovery
 	 *
-	 * 	Locates Default Portal
+	 *	Locates Default Portal
 	 *
 	 * SessionType: Normal
 	 *
-	 * 	Locates Target Portal from NP -> Target IQN
+	 *	Locates Target Portal from NP -> Target IQN
 	 */
 	rc = iscsi_target_locate_portal(np, conn, login);
 	if (rc < 0) {
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 4f60ec03c95c..523b780211b3 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -332,6 +332,7 @@ static int iscsi_target_do_tx_login_io(struct iscsit_conn *conn, struct iscsi_lo
 	 */
 	if (login->login_complete) {
 		int rc = iscsit_start_kthreads(conn);
+
 		if (rc) {
 			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 					    ISCSI_LOGIN_STATUS_NO_RESOURCES);
@@ -1220,7 +1221,7 @@ int iscsi_target_locate_portal(
 		goto out;
 	}
 	conn->tpg_np = tpg_np;
-	target_debug("Located Portal Group Object: %hu\n", conn->tpg->tpgt);
+	target_debug("Located Portal Group Object: %u\n", conn->tpg->tpgt);
 	/*
 	 * Setup crc32c modules from libcrypto
 	 */
@@ -1267,7 +1268,7 @@ int iscsi_target_locate_portal(
 	sess->se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
 			&conn->tpg->tpg_se_tpg, i_buf);
 	if (!sess->se_sess->se_node_acl) {
-		target_err("iSCSI Initiator Node: %s is not authorized to access iSCSI target portal group: %hu.\n",
+		target_err("iSCSI Initiator Node: %s is not authorized to access iSCSI target portal group: %u.\n",
 			   i_buf, conn->tpg->tpgt);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_TGT_FORBIDDEN);
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 4b8429c53904..9c2c70de8d75 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -32,7 +32,7 @@ int iscsi_login_rx_data(
 		return -1;
 	}
 
-	return 0 ;
+	return 0;
 }
 
 int iscsi_login_tx_data(
@@ -78,18 +78,18 @@ void iscsi_dump_sess_ops(struct iscsi_sess_ops *sess_ops)
 	target_debug("InitiatorAlias: %s\n", sess_ops->InitiatorAlias);
 	target_debug("TargetName: %s\n", sess_ops->TargetName);
 	target_debug("TargetAlias: %s\n", sess_ops->TargetAlias);
-	target_debug("TargetPortalGroupTag: %hu\n", sess_ops->TargetPortalGroupTag);
-	target_debug("MaxConnections: %hu\n", sess_ops->MaxConnections);
+	target_debug("TargetPortalGroupTag: %u\n", sess_ops->TargetPortalGroupTag);
+	target_debug("MaxConnections: %u\n", sess_ops->MaxConnections);
 	target_debug("InitialR2T: %s\n", (sess_ops->InitialR2T) ? "Yes" : "No");
 	target_debug("ImmediateData: %s\n", (sess_ops->ImmediateData) ? "Yes" : "No");
 	target_debug("MaxBurstLength: %u\n", sess_ops->MaxBurstLength);
 	target_debug("FirstBurstLength: %u\n", sess_ops->FirstBurstLength);
-	target_debug("DefaultTime2Wait: %hu\n", sess_ops->DefaultTime2Wait);
-	target_debug("DefaultTime2Retain: %hu\n", sess_ops->DefaultTime2Retain);
-	target_debug("MaxOutstandingR2T: %hu\n", sess_ops->MaxOutstandingR2T);
+	target_debug("DefaultTime2Wait: %u\n", sess_ops->DefaultTime2Wait);
+	target_debug("DefaultTime2Retain: %u\n", sess_ops->DefaultTime2Retain);
+	target_debug("MaxOutstandingR2T: %u\n", sess_ops->MaxOutstandingR2T);
 	target_debug("DataPDUInOrder: %s\n", (sess_ops->DataPDUInOrder) ? "Yes" : "No");
 	target_debug("DataSequenceInOrder: %s\n", (sess_ops->DataSequenceInOrder) ? "Yes" : "No");
-	target_debug("ErrorRecoveryLevel: %hu\n", sess_ops->ErrorRecoveryLevel);
+	target_debug("ErrorRecoveryLevel: %u\n", sess_ops->ErrorRecoveryLevel);
 	target_debug("SessionType: %s\n", (sess_ops->SessionType) ? "Discovery" : "Normal");
 }
 
@@ -1298,6 +1298,7 @@ static int iscsi_enforce_integrity_rules(
 					&tmpptr, 0);
 			if (FirstBurstLength > MaxBurstLength) {
 				char tmpbuf[11];
+
 				memset(tmpbuf, 0, sizeof(tmpbuf));
 				sprintf(tmpbuf, "%u", MaxBurstLength);
 				if (iscsi_update_param_value(param, tmpbuf))
@@ -1422,8 +1423,7 @@ int iscsi_encode_text_output(
 			*length += 1;
 			output_buf = textbuf + *length;
 			SET_PSTATE_PROPOSER(param);
-			iscsi_check_proposer_for_optional_reply(param,
-							        keys_workaround);
+			iscsi_check_proposer_for_optional_reply(param, keys_workaround);
 			target_debug("Sending key: %s=%s\n", param->name, param->value);
 		}
 	}
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index c9f55f3cf7e3..0382ec46c68d 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -39,7 +39,7 @@ u8 iscsit_tmr_abort_task(
 
 	ref_cmd = iscsit_find_cmd_from_itt(conn, hdr->rtt);
 	if (!ref_cmd) {
-		target_err("Unable to locate RefTaskTag: 0x%08x on CID: %hu.\n", hdr->rtt,
+		target_err("Unable to locate RefTaskTag: 0x%08x on CID: %u.\n", hdr->rtt,
 			   conn->cid);
 		return (iscsi_sna_gte(be32_to_cpu(hdr->refcmdsn), conn->sess->exp_cmd_sn) &&
 			iscsi_sna_lte(be32_to_cpu(hdr->refcmdsn), (u32) atomic_read(&conn->sess->max_cmd_sn))) ?
@@ -111,7 +111,7 @@ u8 iscsit_tmr_task_reassign(
 	struct iscsi_tm *hdr = (struct iscsi_tm *) buf;
 	u64 ret, ref_lun;
 
-	target_debug("Got TASK_REASSIGN TMR ITT: 0x%08x, RefTaskTag: 0x%08x, ExpDataSN: 0x%08x, CID: %hu\n",
+	target_debug("Got TASK_REASSIGN TMR ITT: 0x%08x, RefTaskTag: 0x%08x, ExpDataSN: 0x%08x, CID: %u\n",
 		     hdr->itt, hdr->rtt, hdr->exp_datasn, conn->cid);
 
 	if (conn->sess->sess_ops->ErrorRecoveryLevel != 2) {
@@ -121,7 +121,7 @@ u8 iscsit_tmr_task_reassign(
 
 	ret = iscsit_find_cmd_for_recovery(conn->sess, &ref_cmd, &cr, hdr->rtt);
 	if (ret == -2) {
-		target_err("Command ITT: 0x%08x is still alligent to CID: %hu\n",
+		target_err("Command ITT: 0x%08x is still alligent to CID: %u\n",
 			   ref_cmd->init_task_tag, cr->cid);
 		return ISCSI_TMF_RSP_TASK_ALLEGIANT;
 	} else if (ret == -1) {
@@ -175,7 +175,7 @@ static void iscsit_task_reassign_remove_cmd(
 	ret = iscsit_remove_cmd_from_connection_recovery(cmd, sess);
 	spin_unlock(&cr->conn_recovery_cmd_lock);
 	if (!ret) {
-		target_debug("iSCSI connection recovery successful for CID: %hu on SID: %u\n",
+		target_debug("iSCSI connection recovery successful for CID: %u on SID: %u\n",
 			     cr->cid, sess->sid);
 		iscsit_remove_active_connection_recovery_entry(cr, sess);
 	}
@@ -425,7 +425,7 @@ static int iscsit_task_reassign_complete(
 	if (ret != 0)
 		return ret;
 
-	target_debug("Completed connection reallegiance for Opcode: 0x%02x, ITT: 0x%08x to CID: %hu.\n",
+	target_debug("Completed connection reallegiance for Opcode: 0x%02x, ITT: 0x%08x to CID: %u.\n",
 		     cmd->iscsi_opcode, cmd->init_task_tag, conn->cid);
 
 	return 0;
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 2d069354f384..566132ab601e 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -245,8 +245,7 @@ int iscsit_tpg_add_portal_group(struct iscsi_tiqn *tiqn, struct iscsi_portal_gro
 	spin_lock(&tiqn->tiqn_tpg_lock);
 	list_add_tail(&tpg->tpg_list, &tiqn->tiqn_tpg_list);
 	tiqn->tiqn_ntpgs++;
-	target_debug("CORE[%s]_TPG[%hu] - Added iSCSI Target Portal Group\n", tiqn->tiqn,
-		     tpg->tpgt);
+	target_debug("CORE[%s]_TPG[%u] - Added iSCSI Target Portal Group\n", tiqn->tiqn, tpg->tpgt);
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
 	return 0;
@@ -270,7 +269,7 @@ int iscsit_tpg_del_portal_group(
 	spin_unlock(&tpg->tpg_state_lock);
 
 	if (iscsit_release_sessions_for_tpg(tpg, force) < 0) {
-		target_err("Unable to delete iSCSI Target Portal Group: %hu while active sessions exist, and force=0\n",
+		target_err("Unable to delete iSCSI Target Portal Group: %u while active sessions exist, and force=0\n",
 			   tpg->tpgt);
 		tpg->tpg_state = old_state;
 		return -EPERM;
@@ -292,7 +291,7 @@ int iscsit_tpg_del_portal_group(
 	list_del(&tpg->tpg_list);
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
-	target_debug("CORE[%s]_TPG[%hu] - Deleted iSCSI Target Portal Group\n", tiqn->tiqn,
+	target_debug("CORE[%s]_TPG[%u] - Deleted iSCSI Target Portal Group\n", tiqn->tiqn,
 		     tpg->tpgt);
 
 	kfree(tpg);
@@ -306,7 +305,7 @@ int iscsit_tpg_enable_portal_group(struct iscsi_portal_group *tpg)
 	int ret;
 
 	if (tpg->tpg_state == TPG_STATE_ACTIVE) {
-		target_err("iSCSI target portal group: %hu is already active, ignoring request.\n",
+		target_err("iSCSI target portal group: %u is already active, ignoring request.\n",
 			   tpg->tpgt);
 		return -EINVAL;
 	}
@@ -337,7 +336,7 @@ int iscsit_tpg_enable_portal_group(struct iscsi_portal_group *tpg)
 
 	spin_lock(&tiqn->tiqn_tpg_lock);
 	tiqn->tiqn_active_tpgs++;
-	target_debug("iSCSI_TPG[%hu] - Enabled iSCSI Target Portal Group\n", tpg->tpgt);
+	target_debug("iSCSI_TPG[%u] - Enabled iSCSI Target Portal Group\n", tpg->tpgt);
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
 	return 0;
@@ -353,7 +352,7 @@ int iscsit_tpg_disable_portal_group(struct iscsi_portal_group *tpg, int force)
 
 	spin_lock(&tpg->tpg_state_lock);
 	if (tpg->tpg_state == TPG_STATE_INACTIVE) {
-		target_err("iSCSI Target Portal Group: %hu is already inactive, ignoring request.\n",
+		target_err("iSCSI Target Portal Group: %u is already inactive, ignoring request.\n",
 			   tpg->tpgt);
 		spin_unlock(&tpg->tpg_state_lock);
 		return -EINVAL;
@@ -367,7 +366,7 @@ int iscsit_tpg_disable_portal_group(struct iscsi_portal_group *tpg, int force)
 		spin_lock(&tpg->tpg_state_lock);
 		tpg->tpg_state = old_state;
 		spin_unlock(&tpg->tpg_state_lock);
-		target_err("Unable to disable iSCSI Target Portal Group: %hu while active sessions exist, and force=0\n",
+		target_err("Unable to disable iSCSI Target Portal Group: %u while active sessions exist, and force=0\n",
 			   tpg->tpgt);
 		return -EPERM;
 	}
@@ -378,7 +377,7 @@ int iscsit_tpg_disable_portal_group(struct iscsi_portal_group *tpg, int force)
 
 	spin_lock(&tiqn->tiqn_tpg_lock);
 	tiqn->tiqn_active_tpgs--;
-	target_debug("iSCSI_TPG[%hu] - Disabled iSCSI Target Portal Group\n", tpg->tpgt);
+	target_debug("iSCSI_TPG[%u] - Disabled iSCSI Target Portal Group\n", tpg->tpgt);
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
 	return 0;
@@ -513,7 +512,7 @@ static int iscsit_tpg_release_np(
 {
 	iscsit_clear_tpg_np_login_thread(tpg_np, tpg, true);
 
-	target_debug("CORE[%s] - Removed Network Portal: %pISpc,%hu on %s\n", tpg->tpg_tiqn->tiqn,
+	target_debug("CORE[%s] - Removed Network Portal: %pISpc,%u on %s\n", tpg->tpg_tiqn->tiqn,
 		     &np->np_sockaddr, tpg->tpgt, np->np_transport->name);
 
 	tpg_np->tpg_np = NULL;
@@ -626,7 +625,7 @@ int iscsit_ta_authentication(struct iscsi_portal_group *tpg, u32 authentication)
 
 out:
 	a->authentication = authentication;
-	target_debug("%s iSCSI Authentication Methods for TPG: %hu.\n",
+	target_debug("%s iSCSI Authentication Methods for TPG: %u.\n",
 		     a->authentication ? "Enforcing" : "Disabling", tpg->tpgt);
 
 	return 0;
@@ -649,7 +648,7 @@ int iscsit_ta_login_timeout(
 	}
 
 	a->login_timeout = login_timeout;
-	target_debug("Set Logout Timeout to %u for Target Portal Group %hu\n", a->login_timeout,
+	target_debug("Set Logout Timeout to %u for Target Portal Group %u\n", a->login_timeout,
 		     tpg->tpgt);
 
 	return 0;
@@ -667,7 +666,7 @@ int iscsit_ta_generate_node_acls(
 	}
 
 	a->generate_node_acls = flag;
-	target_debug("iSCSI_TPG[%hu] - Generate Initiator Portal Group ACLs: %s\n", tpg->tpgt,
+	target_debug("iSCSI_TPG[%u] - Generate Initiator Portal Group ACLs: %s\n", tpg->tpgt,
 		     (a->generate_node_acls) ? "Enabled" : "Disabled");
 
 	if (flag == 1 && a->cache_dynamic_acls == 0) {
@@ -695,7 +694,7 @@ int iscsit_ta_default_cmdsn_depth(
 	}
 
 	a->default_cmdsn_depth = tcq_depth;
-	target_debug("iSCSI_TPG[%hu] - Set Default CmdSN TCQ Depth to %u\n", tpg->tpgt,
+	target_debug("iSCSI_TPG[%u] - Set Default CmdSN TCQ Depth to %u\n", tpg->tpgt,
 		     a->default_cmdsn_depth);
 
 	return 0;
@@ -718,7 +717,7 @@ int iscsit_ta_cache_dynamic_acls(
 	}
 
 	a->cache_dynamic_acls = flag;
-	target_debug("iSCSI_TPG[%hu] - Cache Dynamic Initiator Portal Group ACLs %s\n", tpg->tpgt,
+	target_debug("iSCSI_TPG[%u] - Cache Dynamic Initiator Portal Group ACLs %s\n", tpg->tpgt,
 		     (a->cache_dynamic_acls) ? "Enabled" : "Disabled");
 
 	return 0;
@@ -736,7 +735,7 @@ int iscsit_ta_demo_mode_write_protect(
 	}
 
 	a->demo_mode_write_protect = flag;
-	target_debug("iSCSI_TPG[%hu] - Demo Mode Write Protect bit: %s\n", tpg->tpgt,
+	target_debug("iSCSI_TPG[%u] - Demo Mode Write Protect bit: %s\n", tpg->tpgt,
 		     (a->demo_mode_write_protect) ? "ON" : "OFF");
 
 	return 0;
@@ -754,7 +753,7 @@ int iscsit_ta_prod_mode_write_protect(
 	}
 
 	a->prod_mode_write_protect = flag;
-	target_debug("iSCSI_TPG[%hu] - Production Mode Write Protect bit: %s\n", tpg->tpgt,
+	target_debug("iSCSI_TPG[%u] - Production Mode Write Protect bit: %s\n", tpg->tpgt,
 		     (a->prod_mode_write_protect) ? "ON" : "OFF");
 
 	return 0;
@@ -772,7 +771,7 @@ int iscsit_ta_demo_mode_discovery(
 	}
 
 	a->demo_mode_discovery = flag;
-	target_debug("iSCSI_TPG[%hu] - Demo Mode Discovery bit: %s\n", tpg->tpgt,
+	target_debug("iSCSI_TPG[%u] - Demo Mode Discovery bit: %s\n", tpg->tpgt,
 		     (a->demo_mode_discovery) ? "ON" : "OFF");
 
 	return 0;
@@ -790,7 +789,7 @@ int iscsit_ta_default_erl(
 	}
 
 	a->default_erl = default_erl;
-	target_debug("iSCSI_TPG[%hu] - DefaultERL: %u\n", tpg->tpgt, a->default_erl);
+	target_debug("iSCSI_TPG[%u] - DefaultERL: %u\n", tpg->tpgt, a->default_erl);
 
 	return 0;
 }
@@ -807,7 +806,7 @@ int iscsit_ta_t10_pi(
 	}
 
 	a->t10_pi = flag;
-	target_debug("iSCSI_TPG[%hu] - T10 Protection information bit: %s\n", tpg->tpgt,
+	target_debug("iSCSI_TPG[%u] - T10 Protection information bit: %s\n", tpg->tpgt,
 		     (a->t10_pi) ? "ON" : "OFF");
 
 	return 0;
@@ -825,7 +824,7 @@ int iscsit_ta_fabric_prot_type(
 	}
 
 	a->fabric_prot_type = prot_type;
-	target_debug("iSCSI_TPG[%hu] - T10 Fabric Protection Type: %u\n", tpg->tpgt, prot_type);
+	target_debug("iSCSI_TPG[%u] - T10 Fabric Protection Type: %u\n", tpg->tpgt, prot_type);
 
 	return 0;
 }
@@ -842,7 +841,7 @@ int iscsit_ta_tpg_enabled_sendtargets(
 	}
 
 	a->tpg_enabled_sendtargets = flag;
-	target_debug("iSCSI_TPG[%hu] - TPG enabled bit required for SendTargets: %s\n", tpg->tpgt,
+	target_debug("iSCSI_TPG[%u] - TPG enabled bit required for SendTargets: %s\n", tpg->tpgt,
 		     (a->tpg_enabled_sendtargets) ? "ON" : "OFF");
 
 	return 0;
@@ -860,7 +859,7 @@ int iscsit_ta_login_keys_workaround(
 	}
 
 	a->login_keys_workaround = flag;
-	target_debug("iSCSI_TPG[%hu] - TPG enabled bit for login keys workaround: %s ", tpg->tpgt,
+	target_debug("iSCSI_TPG[%u] - TPG enabled bit for login keys workaround: %s ", tpg->tpgt,
 		     (a->login_keys_workaround) ? "ON" : "OFF");
 
 	return 0;
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index f64f35083b61..04eb268b9bc9 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -383,7 +383,7 @@ struct iscsit_cmd *iscsit_find_cmd_from_itt(
 	}
 	spin_unlock_bh(&conn->cmd_lock);
 
-	target_err("Unable to locate ITT: 0x%08x on CID: %hu", init_task_tag, conn->cid);
+	target_err("Unable to locate ITT: 0x%08x on CID: %u", init_task_tag, conn->cid);
 	return NULL;
 }
 EXPORT_SYMBOL(iscsit_find_cmd_from_itt);
@@ -406,7 +406,7 @@ struct iscsit_cmd *iscsit_find_cmd_from_itt_or_dump(
 	}
 	spin_unlock_bh(&conn->cmd_lock);
 
-	target_err("Unable to locate ITT: 0x%08x on CID: %hu, dumping payload\n", init_task_tag,
+	target_err("Unable to locate ITT: 0x%08x on CID: %u, dumping payload\n", init_task_tag,
 		   conn->cid);
 	if (length)
 		iscsit_dump_data_payload(conn, length, 1);
@@ -430,7 +430,7 @@ struct iscsit_cmd *iscsit_find_cmd_from_ttt(
 	}
 	spin_unlock_bh(&conn->cmd_lock);
 
-	target_err("Unable to locate TTT: 0x%08x on CID: %hu\n", targ_xfer_tag, conn->cid);
+	target_err("Unable to locate TTT: 0x%08x on CID: %u\n", targ_xfer_tag, conn->cid);
 	return NULL;
 }
 
@@ -1197,7 +1197,7 @@ int iscsit_fe_sendpage_sg(
 		struct kvec *iov_d = &cmd->iov_data[iov_off];
 
 		tx_sent = tx_data(conn, iov_d, 1, ISCSI_CRC_LEN);
-		if (ISCSI_CRC_LEN != tx_sent) {
+		if (tx_sent != ISCSI_CRC_LEN) {
 			if (tx_sent == -EAGAIN) {
 				target_err("tx_data() returned -EAGAIN\n");
 				goto send_datacrc;
@@ -1301,6 +1301,7 @@ int tx_data(
 
 	while (msg_data_left(&msg)) {
 		int tx_loop = sock_sendmsg(conn->sock, &msg);
+
 		if (tx_loop <= 0) {
 			target_debug("tx_loop: %d total_tx %d\n", tx_loop, total_tx);
 			return tx_loop;
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 75914c19c872..4d551eefa4a6 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1351,7 +1351,7 @@ static void sbp_sense_mangle(struct sbp_target_request *req)
 
 	WARN_ON(se_cmd->scsi_sense_length < 18);
 
-	switch (sense[0] & 0x7f) { 		/* sfmt */
+	switch (sense[0] & 0x7f) { /* sfmt */
 	case 0x70: /* current, fixed */
 		status[0] = 0 << 6;
 		break;
@@ -1673,6 +1673,7 @@ static char *sbp_get_fabric_wwn(struct se_portal_group *se_tpg)
 static u16 sbp_get_tag(struct se_portal_group *se_tpg)
 {
 	struct sbp_tpg *tpg = container_of(se_tpg, struct sbp_tpg, se_tpg);
+
 	return tpg->tport_tpgt;
 }
 
@@ -2133,6 +2134,7 @@ static ssize_t sbp_tpg_attrib_mgt_orb_timeout_show(struct config_item *item,
 	struct se_portal_group *se_tpg = attrib_to_tpg(item);
 	struct sbp_tpg *tpg = container_of(se_tpg, struct sbp_tpg, se_tpg);
 	struct sbp_tport *tport = tpg->tport;
+
 	return sprintf(page, "%d\n", tport->mgt_orb_timeout);
 }
 
@@ -2168,6 +2170,7 @@ static ssize_t sbp_tpg_attrib_max_reconnect_timeout_show(struct config_item *ite
 	struct se_portal_group *se_tpg = attrib_to_tpg(item);
 	struct sbp_tpg *tpg = container_of(se_tpg, struct sbp_tpg, se_tpg);
 	struct sbp_tport *tport = tpg->tport;
+
 	return sprintf(page, "%d\n", tport->max_reconnect_timeout);
 }
 
@@ -2203,6 +2206,7 @@ static ssize_t sbp_tpg_attrib_max_logins_per_lun_show(struct config_item *item,
 	struct se_portal_group *se_tpg = attrib_to_tpg(item);
 	struct sbp_tpg *tpg = container_of(se_tpg, struct sbp_tpg, se_tpg);
 	struct sbp_tport *tport = tpg->tport;
+
 	return sprintf(page, "%d\n", tport->max_logins_per_lun);
 }
 
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 20fe346c270a..1caddbc73631 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -315,6 +315,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 
 	while (len < cmd->data_length) {
 		bool found = false;
+
 		alua_access_state = (ptr[0] & 0x0f);
 		/*
 		 * Check the received ALUA access state, and determine if
@@ -470,6 +471,7 @@ static inline sense_reason_t core_alua_state_lba_dependent(
 
 			if (segment_mult) {
 				u64 tmp = lba;
+
 				start_lba = do_div(tmp, segment_size * segment_mult);
 
 				last_lba = first_lba + segment_size - 1;
@@ -496,7 +498,7 @@ static inline sense_reason_t core_alua_state_lba_dependent(
 				    lba_map_mem_list) {
 			if (map_mem->lba_map_mem_alua_pg_id != tg_pt_gp_id)
 				continue;
-			switch(map_mem->lba_map_mem_alua_state) {
+			switch (map_mem->lba_map_mem_alua_state) {
 			case ALUA_ACCESS_STATE_STANDBY:
 				spin_unlock(&dev->t10_alua.lba_map_lock);
 				return TCM_ALUA_TG_PT_STANDBY;
@@ -1144,7 +1146,7 @@ int core_alua_do_port_transition(
 	spin_unlock(&lu_gp->lu_gp_lock);
 
 	if (!rc) {
-		target_debug("Successfully processed LU Group: %s all ALUA TG PT Group IDs: %hu %s transition to primary state: %s\n",
+		target_debug("Successfully processed LU Group: %s all ALUA TG PT Group IDs: %u %s transition to primary state: %s\n",
 			     config_item_name(&lu_gp->lu_gp_group.cg_item), l_tg_pt_gp->tg_pt_gp_id,
 			     (explicit) ? "explicit" : "implicit", core_alua_dump_state(new_state));
 	}
@@ -1229,7 +1231,7 @@ static int core_alua_set_tg_pt_secondary_state(
 			ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG :
 			ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA;
 
-	target_debug("Successful %s ALUA transition TG PT Group: %s ID: %hu to secondary access state: %s\n",
+	target_debug("Successful %s ALUA transition TG PT Group: %s ID: %u to secondary access state: %s\n",
 		     (explicit) ? "explicit" : "implicit",
 		     config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item), tg_pt_gp->tg_pt_gp_id,
 		     (offline) ? "OFFLINE" : "ONLINE");
@@ -1404,7 +1406,7 @@ int core_alua_set_lu_gp_id(struct t10_alua_lu_gp *lu_gp, u16 lu_gp_id)
 			if (!lu_gp_id)
 				goto again;
 
-			target_warn("ALUA Logical Unit Group ID: %hu already exists, ignoring request\n",
+			target_warn("ALUA Logical Unit Group ID: %u already exists, ignoring request\n",
 				    lu_gp_id);
 			spin_unlock(&lu_gps_lock);
 			return -EINVAL;
@@ -1669,7 +1671,7 @@ int core_alua_set_tg_pt_gp_id(
 			if (!tg_pt_gp_id)
 				goto again;
 
-			target_err("ALUA Target Port Group ID: %hu already exists, ignoring request\n",
+			target_err("ALUA Target Port Group ID: %u already exists, ignoring request\n",
 				   tg_pt_gp_id);
 			spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 			return -EINVAL;
@@ -1924,7 +1926,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 		 * with the default_tg_pt_gp.
 		 */
 		if (!tg_pt_gp_new) {
-			target_debug("Target_Core_ConfigFS: Moving %s/tpgt_%hu/%s from ALUA Target Port Group: alua/%s, ID: %hu back to default_tg_pt_gp\n",
+			target_debug("Target_Core_ConfigFS: Moving %s/tpgt_%u/%s from ALUA Target Port Group: alua/%s, ID: %u back to default_tg_pt_gp\n",
 				     tpg->se_tpg_tfo->tpg_get_wwn(tpg),
 				     tpg->se_tpg_tfo->tpg_get_tag(tpg),
 				     config_item_name(&lun->lun_group.cg_item),
@@ -1942,7 +1944,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 
 	target_swap_tg_pt_gp(lun, tg_pt_gp, tg_pt_gp_new);
 	spin_unlock(&lun->lun_tg_pt_gp_lock);
-	target_debug("Target_Core_ConfigFS: %s %s/tpgt_%hu/%s to ALUA Target Port Group: alua/%s, ID: %hu\n",
+	target_debug("Target_Core_ConfigFS: %s %s/tpgt_%u/%s to ALUA Target Port Group: alua/%s, ID: %u\n",
 		     (move) ? "Moving" : "Adding", tpg->se_tpg_tfo->tpg_get_wwn(tpg),
 		     tpg->se_tpg_tfo->tpg_get_tag(tpg), config_item_name(&lun->lun_group.cg_item),
 		     config_item_name(&tg_pt_gp_new->tg_pt_gp_group.cg_item),
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 433afdc20dc1..c30a8687e4c3 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -166,6 +166,7 @@ static struct target_fabric_configfs *target_core_get_fabric(
 	mutex_lock(&g_tf_lock);
 	list_for_each_entry(tf, &g_tf_list, tf_list) {
 		const char *cmp_name = tf->tf_ops->fabric_alias;
+
 		if (!cmp_name)
 			cmp_name = tf->tf_ops->fabric_name;
 		if (!strcmp(cmp_name, name)) {
@@ -1840,11 +1841,9 @@ static ssize_t target_pr_res_pr_all_tgt_pts_show(struct config_item *item,
 	if (!dev->dev_pr_res_holder) {
 		len = sprintf(page, "No SPC-3 Reservation holder\n");
 	} else if (dev->dev_pr_res_holder->pr_reg_all_tg_pt) {
-		len = sprintf(page, "SPC-3 Reservation: All Target"
-			" Ports registration\n");
+		len = sprintf(page, "SPC-3 Reservation: All Target Ports registration\n");
 	} else {
-		len = sprintf(page, "SPC-3 Reservation: Single"
-			" Target Port registration\n");
+		len = sprintf(page, "SPC-3 Reservation: Single Target Port registration\n");
 	}
 
 	spin_unlock(&dev->dev_reservation_lock);
@@ -2423,7 +2422,7 @@ static ssize_t target_dev_alua_lu_gp_store(struct config_item *item,
 		 * with NULL
 		 */
 		if (!lu_gp_new) {
-			target_debug("Target_Core_ConfigFS: Releasing %s/%s from ALUA LU Group: core/alua/lu_gps/%s, ID: %hu\n",
+			target_debug("Target_Core_ConfigFS: Releasing %s/%s from ALUA LU Group: core/alua/lu_gps/%s, ID: %u\n",
 				     config_item_name(&hba->hba_group.cg_item),
 				     config_item_name(&dev->dev_group.cg_item),
 				     config_item_name(&lu_gp->lu_gp_group.cg_item),
@@ -2446,7 +2445,7 @@ static ssize_t target_dev_alua_lu_gp_store(struct config_item *item,
 	__core_alua_attach_lu_gp_mem(lu_gp_mem, lu_gp_new);
 	spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
 
-	target_debug("Target_Core_ConfigFS: %s %s/%s to ALUA LU Group: core/alua/lu_gps/%s, ID: %hu\n",
+	target_debug("Target_Core_ConfigFS: %s %s/%s to ALUA LU Group: core/alua/lu_gps/%s, ID: %u\n",
 		     (move) ? "Moving" : "Adding", config_item_name(&hba->hba_group.cg_item),
 		     config_item_name(&dev->dev_group.cg_item),
 		     config_item_name(&lu_gp_new->lu_gp_group.cg_item), lu_gp_new->lu_gp_id);
@@ -2692,7 +2691,7 @@ static ssize_t target_lu_gp_lu_gp_id_store(struct config_item *item,
 	if (ret < 0)
 		return -EINVAL;
 
-	target_debug("Target_Core_ConfigFS: Set ALUA Logical Unit Group: core/alua/lu_gps/%s to ID: %hu\n",
+	target_debug("Target_Core_ConfigFS: Set ALUA Logical Unit Group: core/alua/lu_gps/%s to ID: %u\n",
 		     config_item_name(&alua_lu_gp_cg->cg_item), lu_gp->lu_gp_id);
 
 	return count;
@@ -2792,7 +2791,7 @@ static void target_core_alua_drop_lu_gp(
 	struct t10_alua_lu_gp *lu_gp = container_of(to_config_group(item),
 			struct t10_alua_lu_gp, lu_gp_group);
 
-	target_debug("Target_Core_ConfigFS: Releasing ALUA Logical Unit Group: core/alua/lu_gps/%s, ID: %hu\n",
+	target_debug("Target_Core_ConfigFS: Releasing ALUA Logical Unit Group: core/alua/lu_gps/%s, ID: %u\n",
 		     config_item_name(item), lu_gp->lu_gp_id);
 	/*
 	 * core_alua_free_lu_gp() is called from target_core_alua_lu_gp_ops->release()
@@ -2873,6 +2872,7 @@ static ssize_t target_tg_pt_gp_alua_access_status_show(struct config_item *item,
 		char *page)
 {
 	struct t10_alua_tg_pt_gp *tg_pt_gp = to_tg_pt_gp(item);
+
 	return sprintf(page, "%s\n",
 		core_alua_dump_status(tg_pt_gp->tg_pt_gp_alua_access_status));
 }
@@ -3077,7 +3077,7 @@ static ssize_t target_tg_pt_gp_tg_pt_gp_id_store(struct config_item *item,
 	if (ret < 0)
 		return -EINVAL;
 
-	target_debug("Target_Core_ConfigFS: Set ALUA Target Port Group: core/alua/tg_pt_gps/%s to ID: %hu\n",
+	target_debug("Target_Core_ConfigFS: Set ALUA Target Port Group: core/alua/tg_pt_gps/%s to ID: %u\n",
 		     config_item_name(&alua_tg_pt_gp_cg->cg_item), tg_pt_gp->tg_pt_gp_id);
 
 	return count;
@@ -3209,7 +3209,7 @@ static void target_core_alua_drop_tg_pt_gp(
 	struct t10_alua_tg_pt_gp *tg_pt_gp = container_of(to_config_group(item),
 			struct t10_alua_tg_pt_gp, tg_pt_gp_group);
 
-	target_debug("Target_Core_ConfigFS: Releasing ALUA Target Port Group: alua/tg_pt_gps/%s, ID: %hu\n",
+	target_debug("Target_Core_ConfigFS: Releasing ALUA Target Port Group: alua/tg_pt_gps/%s, ID: %u\n",
 		     config_item_name(item), tg_pt_gp->tg_pt_gp_id);
 	/*
 	 * core_alua_free_tg_pt_gp() is called from target_core_alua_tg_pt_gp_ops->release()
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 0317d77331c8..ea94ceabfadb 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -595,7 +595,7 @@ int core_dev_add_initiator_node_lun_acl(
 			lun_access_ro, nacl, tpg) < 0)
 		return -EINVAL;
 
-	target_debug("%s_TPG[%hu]_LUN[%llu->%llu] - Added %s ACL for  InitiatorNode: %s\n",
+	target_debug("%s_TPG[%u]_LUN[%llu->%llu] - Added %s ACL for  InitiatorNode: %s\n",
 		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
 		     lun->unpacked_lun, lacl->mapped_lun, lun_access_ro ? "RO" : "RW",
 		     nacl->initiatorname);
@@ -626,7 +626,7 @@ int core_dev_del_initiator_node_lun_acl(
 		core_disable_device_list_for_node(lun, deve, nacl, tpg);
 	mutex_unlock(&nacl->lun_entry_mutex);
 
-	target_debug("%s_TPG[%hu]_LUN[%llu] - Removed ACL for InitiatorNode: %s Mapped LUN: %llu\n",
+	target_debug("%s_TPG[%u]_LUN[%llu] - Removed ACL for InitiatorNode: %s Mapped LUN: %llu\n",
 		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
 		     lun->unpacked_lun, nacl->initiatorname, lacl->mapped_lun);
 
@@ -637,7 +637,7 @@ void core_dev_free_initiator_node_lun_acl(
 	struct se_portal_group *tpg,
 	struct se_lun_acl *lacl)
 {
-	target_debug("%s_TPG[%hu] - Freeing ACL for %s InitiatorNode: %s Mapped LUN: %llu\n",
+	target_debug("%s_TPG[%u] - Freeing ACL for %s InitiatorNode: %s Mapped LUN: %llu\n",
 		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
 		     tpg->se_tpg_tfo->fabric_name, lacl->se_lun_nacl->initiatorname,
 		     lacl->mapped_lun);
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index f56baa63a278..f4db86c41790 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -404,6 +404,7 @@ static struct config_group *target_fabric_make_nodeacl(
 
 	if (tf->tf_ops->fabric_init_nodeacl) {
 		int ret = tf->tf_ops->fabric_init_nodeacl(se_nacl, name);
+
 		if (ret) {
 			configfs_remove_default_groups(&se_nacl->acl_fabric_stat_group);
 			core_tpg_del_initiator_node_acl(se_nacl);
@@ -860,7 +861,7 @@ static ssize_t target_fabric_tpg_base_rtpi_store(struct config_item *item,
 		return -EINVAL;
 
 	if (se_tpg->enabled) {
-		target_info("%s_TPG[%hu] - Can not change RTPI on enabled TPG",
+		target_info("%s_TPG[%u] - Can not change RTPI on enabled TPG",
 			    se_tpg->se_tpg_tfo->fabric_name,
 			    se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg));
 		return -EINVAL;
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index c0fda2769553..36b6301808fe 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -103,7 +103,7 @@ static int srp_get_pr_transport_id(
 	unsigned char *buf)
 {
 	const char *p;
-	unsigned len, count, leading_zero_bytes;
+	unsigned int len, count, leading_zero_bytes;
 	int rc;
 
 	p = nacl->initiatorname;
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 1731fa059d4d..60a07baa9729 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -731,7 +731,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	struct scatterlist *sg;
 	u32 sg_num = sgl_nents;
 	blk_opf_t opf;
-	unsigned bio_cnt;
+	unsigned int bio_cnt;
 	int i, rc;
 	struct sg_mapping_iter prot_miter;
 	unsigned int miter_dir;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index c2c6fd957dff..8b97beffbf64 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -526,17 +526,17 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 
 			return 0;
 		}
-       } else if (we && registered_nexus) {
-               /*
-                * Reads are allowed for Write Exclusive locks
-                * from all registrants.
-                */
-               if (cmd->data_direction == DMA_FROM_DEVICE) {
+	} else if (we && registered_nexus) {
+		/*
+		 * Reads are allowed for Write Exclusive locks
+		 * from all registrants.
+		 */
+		if (cmd->data_direction == DMA_FROM_DEVICE) {
 			target_debug("Allowing READ CDB: 0x%02x for %s reservation\n", cdb[0],
 				     core_scsi3_pr_dump_type(pr_reg_type));
 
-                       return 0;
-               }
+			return 0;
+		}
 	}
 	target_debug("%s Conflict for %sregistered nexus %s CDB: 0x%2x for %s reservation\n",
 		     transport_dump_cmd_direction(cmd), (registered_nexus) ? "" : "un",
@@ -1357,6 +1357,7 @@ void core_scsi3_free_all_registrations(
 	pr_res_holder = dev->dev_pr_res_holder;
 	if (pr_res_holder != NULL) {
 		struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
+
 		__core_scsi3_complete_pro_release(dev, pr_res_nacl,
 						  pr_res_holder, 0, 0);
 	}
@@ -2236,7 +2237,7 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 	 * a PERSISTENT RESERVE OUT command with RESERVE service action through
 	 * a registered I_T nexus with the following parameters:
 	 *    a) RESERVATION KEY set to the value of the reservation key that is
-	 * 	 registered with the logical unit for the I_T nexus; and
+	 *	 registered with the logical unit for the I_T nexus; and
 	 */
 	if (res_key != pr_reg->pr_res_key) {
 		target_err("SPC-3 PR RESERVE: Received res_key: 0x%016Lx does not match existing SA REGISTER res_key: 0x%016Lx\n",
@@ -2279,6 +2280,7 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 		 */
 		if (!is_reservation_holder(pr_res_holder, pr_reg)) {
 			struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
+
 			target_err("SPC-3 PR: Attempted RESERVE from [%s]: %s while reservation already held by [%s]: %s, returning RESERVATION_CONFLICT\n",
 				   cmd->se_tfo->fabric_name, se_sess->se_node_acl->initiatorname,
 				   pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
@@ -2298,6 +2300,7 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 		if ((pr_res_holder->pr_res_type != type) ||
 		    (pr_res_holder->pr_res_scope != scope)) {
 			struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
+
 			target_err("SPC-3 PR: Attempted RESERVE from [%s]: %s trying to change TYPE and/or SCOPE, while reservation already held by [%s]: %s, returning RESERVATION_CONFLICT\n",
 				   cmd->se_tfo->fabric_name, se_sess->se_node_acl->initiatorname,
 				   pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
@@ -2514,6 +2517,7 @@ core_scsi3_emulate_pro_release(struct se_cmd *cmd, int type, int scope,
 	if ((pr_res_holder->pr_res_type != type) ||
 	    (pr_res_holder->pr_res_scope != scope)) {
 		struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
+
 		target_err("SPC-3 PR RELEASE: Attempted to release reservation from [%s]: %s with different TYPE and/or SCOPE  while reservation already held by [%s]: %s, returning RESERVATION_CONFLICT\n",
 			   cmd->se_tfo->fabric_name, se_sess->se_node_acl->initiatorname,
 			   pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
@@ -2609,7 +2613,7 @@ core_scsi3_emulate_pro_clear(struct se_cmd *cmd, u64 res_key)
 	 * registered I_T nexus with the following parameter:
 	 *
 	 *	a) RESERVATION KEY field set to the value of the reservation key
-	 * 	   that is registered with the logical unit for the I_T nexus.
+	 *	   that is registered with the logical unit for the I_T nexus.
 	 */
 	if (res_key != pr_reg_n->pr_res_key) {
 		target_err("SPC-3 PR REGISTER: Received res_key: 0x%016Lx does not match existing SA REGISTER res_key: 0x%016Lx\n",
@@ -2624,6 +2628,7 @@ core_scsi3_emulate_pro_clear(struct se_cmd *cmd, u64 res_key)
 	pr_res_holder = dev->dev_pr_res_holder;
 	if (pr_res_holder) {
 		struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
+
 		__core_scsi3_complete_pro_release(dev, pr_res_nacl,
 						  pr_res_holder, 0, 0);
 	}
@@ -3165,7 +3170,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	spin_unlock(&dev->se_port_lock);
 
 	if (!dest_se_tpg || !dest_tf_ops) {
-		target_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate fabric ops from Relative Target Port Identifier: %hu\n",
+		target_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate fabric ops from Relative Target Port Identifier: %u\n",
 			   rtpi);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_put_pr_reg;
@@ -3263,7 +3268,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 */
 	dest_se_deve = core_get_se_deve_from_rtpi(dest_node_acl, rtpi);
 	if (!dest_se_deve) {
-		target_err("Unable to locate %s dest_se_deve from RTPI: %hu\n",
+		target_err("Unable to locate %s dest_se_deve from RTPI: %u\n",
 			   dest_tf_ops->fabric_name, rtpi);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
@@ -3297,7 +3302,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 * The received on I_T Nexus must be the reservation holder.
 	 *
 	 * From spc4r17 section 5.7.8  Table 50 --
-	 * 	Register behaviors for a REGISTER AND MOVE service action
+	 *	Register behaviors for a REGISTER AND MOVE service action
 	 */
 	if (!is_reservation_holder(pr_res_holder, pr_reg)) {
 		target_warn("SPC-3 PR REGISTER_AND_MOVE: Calling I_T Nexus is not reservation holder\n");
@@ -3392,7 +3397,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		dest_pr_reg->pr_res_generation = pr_tmpl->pr_generation++;
 	spin_unlock(&dev->dev_reservation_lock);
 
-	target_debug("SPC-3 PR [%s] Service Action: REGISTER_AND_MOVE created new reservation holder TYPE: %s on object RTPI: %hu  PRGeneration: 0x%08x\n",
+	target_debug("SPC-3 PR [%s] Service Action: REGISTER_AND_MOVE created new reservation holder TYPE: %s on object RTPI: %u  PRGeneration: 0x%08x\n",
 		     dest_tf_ops->fabric_name, core_scsi3_pr_dump_type(type), rtpi,
 		     dest_pr_reg->pr_res_generation);
 	target_debug("SPC-3 PR Successfully moved reservation from %s Fabric Node: %s%s -> %s Fabric Node: %s %s\n",
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 25288d8b82c8..4f300d366edc 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -43,7 +43,7 @@ static enum rq_end_io_ret pscsi_req_done(struct request *, blk_status_t);
 
 /*	pscsi_attach_hba():
  *
- * 	pscsi_get_sh() used scsi_host_lookup() to locate struct Scsi_Host.
+ *	pscsi_get_sh() used scsi_host_lookup() to locate struct Scsi_Host.
  *	from the passed SCSI Host ID.
  */
 static int pscsi_attach_hba(struct se_hba *hba, u32 host_id)
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 974b6527f1ce..cd14fcb4b0f8 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -237,7 +237,7 @@ static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length, int block
 	/*
 	 * prot_length=8byte dif data
 	 * tot sg needed = rd_page_count * (PGSZ/block_size) *
-	 * 		   (prot_length/block_size) + pad
+	 *		   (prot_length/block_size) + pad
 	 * PGSZ canceled each other.
 	 */
 	total_sg_needed = (rd_dev->rd_page_count * prot_length / block_size) + 1;
@@ -617,7 +617,7 @@ static int rd_init_prot(struct se_device *dev)
 {
 	struct rd_dev *rd_dev = RD_DEV(dev);
 
-        if (!dev->dev_attrib.pi_prot_type)
+	if (!dev->dev_attrib.pi_prot_type)
 		return 0;
 
 	return rd_build_prot_space(rd_dev, dev->prot_length,
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 20756a92a2af..37164a9f7d32 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -870,6 +870,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 	case VARIABLE_LENGTH_CMD:
 	{
 		u16 service_action = get_unaligned_be16(&cdb[8]);
+
 		switch (service_action) {
 		case WRITE_SAME_32:
 			sectors = transport_get_sectors_32(cdb);
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index f8e6698eede1..671d0e3122e6 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1291,7 +1291,7 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 
 	if (buf) {
 		len = cpu_to_be32(lun_count * 8);
-		memcpy(buf, &len, min_t(int, sizeof len, cmd->data_length));
+		memcpy(buf, &len, min_t(int, sizeof(len), cmd->data_length));
 		transport_kunmap_data_sg(cmd);
 	}
 
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index c42cbde8a31b..b0495d87e951 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -214,7 +214,7 @@ static ssize_t target_stat_lu_indx_show(struct config_item *item, char *page)
 static ssize_t target_stat_lu_lun_show(struct config_item *item, char *page)
 {
 	/* FIXME: scsiLuDefaultLun */
-	return snprintf(page, PAGE_SIZE, "%llu\n", (unsigned long long)0);
+	return snprintf(page, PAGE_SIZE, "%llu\n", 0ULL);
 }
 
 static ssize_t target_stat_lu_lu_name_show(struct config_item *item, char *page)
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 09bc8afe5252..0a5a09d63b48 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -359,7 +359,7 @@ int core_tmr_lun_reset(
 	struct se_portal_group *tmr_tpg = NULL;
 	struct se_session *tmr_sess = NULL;
 	bool tas;
-        /*
+	/*
 	 * TASK_ABORTED status bit, this is configurable via ConfigFS
 	 * struct se_device attributes.  spc4r17 section 7.4.6 Control mode page
 	 *
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 9992714af597..5af85cd960ef 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -207,7 +207,7 @@ static void target_add_node_acl(struct se_node_acl *acl)
 	list_add_tail(&acl->acl_list, &tpg->acl_node_list);
 	mutex_unlock(&tpg->acl_node_mutex);
 
-	target_debug("%s_TPG[%hu] - Added %s ACL with TCQ Depth: %d for %s Initiator Node: %s\n",
+	target_debug("%s_TPG[%u] - Added %s ACL with TCQ Depth: %d for %s Initiator Node: %s\n",
 		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
 		     acl->dynamic_node_acl ? "DYNAMIC" : "", acl->queue_depth,
 		     tpg->se_tpg_tfo->fabric_name, acl->initiatorname);
@@ -356,7 +356,7 @@ void core_tpg_del_initiator_node_acl(struct se_node_acl *acl)
 	core_tpg_wait_for_nacl_pr_ref(acl);
 	core_free_device_list_for_node(acl, tpg);
 
-	target_debug("%s_TPG[%hu] - Deleted ACL with TCQ Depth: %d for %s Initiator Node: %s\n",
+	target_debug("%s_TPG[%u] - Deleted ACL with TCQ Depth: %d for %s Initiator Node: %s\n",
 		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
 		     acl->queue_depth, tpg->se_tpg_tfo->fabric_name, acl->initiatorname);
 
@@ -438,7 +438,7 @@ static int target_tpg_register_rtpi(struct se_portal_group *se_tpg)
 	if (se_tpg->rtpi_manual) {
 		ret = xa_insert(&tpg_xa, se_tpg->tpg_rtpi, se_tpg, GFP_KERNEL);
 		if (ret) {
-			target_info("%s_TPG[%hu] - Can not set RTPI %#x, it is already busy",
+			target_info("%s_TPG[%u] - Can not set RTPI %#x, it is already busy",
 				    se_tpg->se_tpg_tfo->fabric_name,
 				    se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg), se_tpg->tpg_rtpi);
 			return -EINVAL;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4bfce006eefd..3d6d0e525bd0 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1079,8 +1079,7 @@ void transport_dump_vpd_proto_id(
 		sprintf(buf+len, "IEEE 1394\n");
 		break;
 	case 0x40:
-		sprintf(buf+len, "SCSI Remote Direct Memory Access"
-				" Protocol\n");
+		sprintf(buf + len, "SCSI Remote Direct Memory Access Protocol\n");
 		break;
 	case 0x50:
 		sprintf(buf+len, "Internet SCSI (iSCSI)\n");
@@ -1089,8 +1088,7 @@ void transport_dump_vpd_proto_id(
 		sprintf(buf+len, "SAS Serial SCSI Protocol\n");
 		break;
 	case 0x70:
-		sprintf(buf+len, "Automation/Drive Interface Transport"
-				" Protocol\n");
+		sprintf(buf + len, "Automation/Drive Interface Transport Protocol\n");
 		break;
 	case 0x80:
 		sprintf(buf+len, "AT Attachment Interface ATA/ATAPI\n");
@@ -1115,7 +1113,7 @@ transport_set_vpd_proto_id(struct t10_vpd *vpd, unsigned char *page_83)
 	 *
 	 * from spc3r23.pdf section 7.5.1
 	 */
-	 if (page_83[1] & 0x80) {
+	if (page_83[1] & 0x80) {
 		vpd->protocol_identifier = (page_83[0] & 0xf0);
 		vpd->protocol_identifier_set = 1;
 		transport_dump_vpd_proto_id(vpd, NULL, 0);
@@ -1259,8 +1257,8 @@ int transport_dump_vpd_ident(
 			&vpd->device_identifier[0]);
 		break;
 	default:
-		sprintf(buf, "T10 VPD Device Identifier encoding unsupported:"
-			" 0x%02x", vpd->device_identifier_code_set);
+		sprintf(buf, "T10 VPD Device Identifier encoding unsupported: 0x%02x",
+			vpd->device_identifier_code_set);
 		ret = -EINVAL;
 		break;
 	}
@@ -1341,6 +1339,7 @@ target_check_max_data_sg_nents(struct se_cmd *cmd, struct se_device *dev,
 			cmd->residual_count = (size - mtl);
 		} else if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
 			u32 orig_dl = size + cmd->residual_count;
+
 			cmd->residual_count = (orig_dl - mtl);
 		} else {
 			cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
@@ -1353,6 +1352,7 @@ target_check_max_data_sg_nents(struct se_cmd *cmd, struct se_device *dev,
 		 */
 		if (cmd->prot_length) {
 			u32 sectors = (mtl / dev->dev_attrib.block_size);
+
 			cmd->prot_length = dev->prot_length * sectors;
 		}
 	}
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 4e4c3fcb9ca8..5d4804b9f851 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -260,8 +260,7 @@ static const struct kernel_param_ops tcmu_global_max_data_area_op = {
 	.get = tcmu_get_global_max_data_area,
 };
 
-module_param_cb(global_max_data_area_mb, &tcmu_global_max_data_area_op, NULL,
-		S_IWUSR | S_IRUGO);
+module_param_cb(global_max_data_area_mb, &tcmu_global_max_data_area_op, NULL, 0644);
 MODULE_PARM_DESC(global_max_data_area_mb,
 		 "Max MBs allowed to be allocated to all the tcmu device's "
 		 "data areas.");
@@ -297,7 +296,7 @@ static const struct kernel_param_ops tcmu_block_netlink_op = {
 	.get = tcmu_get_block_netlink,
 };
 
-module_param_cb(block_netlink, &tcmu_block_netlink_op, NULL, S_IWUSR | S_IRUGO);
+module_param_cb(block_netlink, &tcmu_block_netlink_op, NULL, 0644);
 MODULE_PARM_DESC(block_netlink, "Block new netlink commands.");
 
 static int tcmu_fail_netlink_cmd(struct tcmu_nl_cmd *nl_cmd)
@@ -349,7 +348,7 @@ static const struct kernel_param_ops tcmu_reset_netlink_op = {
 	.set = tcmu_set_reset_netlink,
 };
 
-module_param_cb(reset_netlink, &tcmu_reset_netlink_op, NULL, S_IWUSR);
+module_param_cb(reset_netlink, &tcmu_reset_netlink_op, NULL, 0200);
 MODULE_PARM_DESC(reset_netlink, "Reset netlink commands.");
 
 /* multicast group */
@@ -379,7 +378,7 @@ static int tcmu_genl_cmd_done(struct genl_info *info, int completed_cmd)
 	    !info->attrs[TCMU_ATTR_DEVICE_ID]) {
 		target_err("TCMU_ATTR_CMD_STATUS or TCMU_ATTR_DEVICE_ID not set, doing nothing\n");
 		return -EINVAL;
-        }
+	}
 
 	dev_id = nla_get_u32(info->attrs[TCMU_ATTR_DEVICE_ID]);
 	rc = nla_get_s32(info->attrs[TCMU_ATTR_CMD_STATUS]);
@@ -1360,7 +1359,7 @@ static bool tcmu_handle_completion(struct tcmu_cmd *cmd,
 
 	if (entry->rsp.scsi_status == SAM_STAT_CHECK_CONDITION) {
 		transport_copy_sense_to_cmd(se_cmd, entry->rsp.sense_buffer);
-		if (!read_len_valid )
+		if (!read_len_valid)
 			goto done;
 		else
 			se_cmd->se_cmd_flags |= SCF_TREAT_READ_AS_NORMAL;
@@ -1879,6 +1878,7 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
 	vm_fault_t ret = 0;
 
 	int mi = tcmu_find_mem_index(vmf->vma);
+
 	if (mi < 0)
 		return VM_FAULT_SIGBUS;
 
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 23b4f75e74ea..2404572beb57 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -30,7 +30,7 @@
 #include "target_core_ua.h"
 #include "target_core_xcopy.h"
 
-static struct workqueue_struct *xcopy_wq = NULL;
+static struct workqueue_struct *xcopy_wq;
 
 static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop);
 
@@ -122,7 +122,7 @@ static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op
 	 * Extract RELATIVE INITIATOR PORT IDENTIFIER
 	 */
 	ript = get_unaligned_be16(&desc[2]);
-	target_debug("XCOPY 0xe4: RELATIVE INITIATOR PORT IDENTIFIER: %hu\n", ript);
+	target_debug("XCOPY 0xe4: RELATIVE INITIATOR PORT IDENTIFIER: %u\n", ript);
 	/*
 	 * Check for supported code set, association, and designator type
 	 */
@@ -215,7 +215,7 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 		return -EINVAL;
 	}
 	if (tdll > RCR_OP_MAX_TARGET_DESC_COUNT * XCOPY_TARGET_DESC_LEN) {
-		target_err("XCOPY target descriptor supports a maximum two src/dest descriptors, tdll: %hu too large..\n",
+		target_err("XCOPY target descriptor supports a maximum two src/dest descriptors, tdll: %u too large..\n",
 			   tdll);
 		/* spc4r37 6.4.3.4 CSCD DESCRIPTOR LIST LENGTH field */
 		*sense_ret = TCM_TOO_MANY_TARGET_DESCS;
@@ -300,7 +300,7 @@ static int target_xcopy_parse_segdesc_02(struct xcopy_op *xop, unsigned char *p)
 
 	desc_len = get_unaligned_be16(&desc[2]);
 	if (desc_len != 0x18) {
-		target_err("XCOPY segment desc 0x02: Illegal desc_len: %hu\n", desc_len);
+		target_err("XCOPY segment desc 0x02: Illegal desc_len: %u\n", desc_len);
 		return -EINVAL;
 	}
 
@@ -309,7 +309,7 @@ static int target_xcopy_parse_segdesc_02(struct xcopy_op *xop, unsigned char *p)
 
 	if (xop->stdi > XCOPY_CSCD_DESC_ID_LIST_OFF_MAX ||
 	    xop->dtdi > XCOPY_CSCD_DESC_ID_LIST_OFF_MAX) {
-		target_err("XCOPY segment desc 0x02: unsupported CSCD ID > 0x%x; stdi: %hu dtdi: %hu\n",
+		target_err("XCOPY segment desc 0x02: unsupported CSCD ID > 0x%x; stdi: %u dtdi: %u\n",
 			   XCOPY_CSCD_DESC_ID_LIST_OFF_MAX, xop->stdi, xop->dtdi);
 		return -EINVAL;
 	}
@@ -320,7 +320,7 @@ static int target_xcopy_parse_segdesc_02(struct xcopy_op *xop, unsigned char *p)
 	xop->nolb = get_unaligned_be16(&desc[10]);
 	xop->src_lba = get_unaligned_be64(&desc[12]);
 	xop->dst_lba = get_unaligned_be64(&desc[20]);
-	target_debug("XCOPY seg desc 0x02: nolb: %hu src_lba: %llu dst_lba: %llu\n", xop->nolb,
+	target_debug("XCOPY seg desc 0x02: nolb: %u src_lba: %llu dst_lba: %llu\n", xop->nolb,
 		     (unsigned long long)xop->src_lba, (unsigned long long)xop->dst_lba);
 
 	return 0;
@@ -393,7 +393,7 @@ static struct se_node_acl xcopy_pt_nacl;
 
 static int xcopy_pt_get_cmd_state(struct se_cmd *se_cmd)
 {
-        return 0;
+	return 0;
 }
 
 static void xcopy_pt_undepend_remotedev(struct xcopy_op *xop)
@@ -813,7 +813,7 @@ static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop)
 	}
 
 	if (se_cmd->data_length < (XCOPY_HDR_LEN + tdll + sdll + inline_dl)) {
-		target_err("XCOPY parameter truncation: data length %u too small for tdll: %hu sdll: %u inline_dl: %u\n",
+		target_err("XCOPY parameter truncation: data length %u too small for tdll: %u sdll: %u inline_dl: %u\n",
 			   se_cmd->data_length, tdll, sdll, inline_dl);
 		ret = TCM_PARAMETER_LIST_LENGTH_ERROR;
 		goto out;
diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
index 00e5573c6296..5dacf917c3c5 100644
--- a/drivers/target/tcm_fc/tcm_fc.h
+++ b/drivers/target/tcm_fc/tcm_fc.h
@@ -20,7 +20,7 @@ struct ft_transport_id {
 	__u8	__resvd1[7];
 	__u8	wwpn[8];
 	__u8	__resvd2[8];
-} __attribute__((__packed__));
+} __packed;
 
 /*
  * Session (remote port).
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index df2414b8c0cd..56b5e8947d1a 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -37,7 +37,7 @@ static LIST_HEAD(ft_wwn_list);
 DEFINE_MUTEX(ft_lport_lock);
 
 unsigned int ft_debug_logging;
-module_param_named(debug_logging, ft_debug_logging, int, S_IRUGO|S_IWUSR);
+module_param_named(debug_logging, ft_debug_logging, int, 0644);
 MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
 
 /*
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index e69b6211886e..92748e94ec29 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -231,6 +231,7 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
 					     sess, ft_sess_alloc_cb);
 	if (IS_ERR(sess->se_sess)) {
 		int rc = PTR_ERR(sess->se_sess);
+
 		kfree(sess);
 		sess = ERR_PTR(rc);
 	}
-- 
2.40.3

