Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.3.219.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793124113;
	b=E+x1ZGGXa1IugiFWBoXlG9ZKvvw5mrdiV8c7TYedLsBrF4GgdSlDYXPMtpLWoQ8AbDG/
	 ebl3qUpL3p6PtY6AwskyyAQRBFCGL+BKeOC0zDR9bIJNvPlsm4vWxOdO0B1/En4uokwHl
	 HID/OVvvfin2GkXUo+sbe/lPslqNfrfagXo0AZEduvc7IDo1nzRVF5Um/IEB3ddSPqzOM
	 BoP2S0GYzusX3bgFkXsHHgUubOX93tpc30wKpLDcXRDede4JTLUQajLwGzo1AUdiiQ0qs
	 YX4LC6zVLaP4noHbnrI9adljKDqH7O1FsFkw7H6lQrR1HuwD8GA+VGUdSZwS+Sf8V2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793124113;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:DKIM-Signature:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy:X-KSMG-AntiPhishing:
	 X-KSMG-AntiSpam-Interceptor-Info:X-KSMG-AntiSpam-Status:
	 X-KSMG-AntiVirus:X-KSMG-AntiVirus-Status:X-KSMG-KATA-Status:
	 X-KSMG-LinksScanning:X-KSMG-Message-Action:X-KSMG-Rule-ID;
	bh=qOdW7WofTCTc0l5wghtUGi34GVtMNdVoKH9J/yGAT+k=;
	b=P05S3xBa7MsVzH5bEzLuDyLF7SXZp6ZCRd4EqaeUZJBE7Q9u2NmHGT3CUEnRjPeNIBWS
	 wcaOkCQYc/dBT3wXA49B61nYnN8USz6YT74SEGBk1DuDOUv0rxyMSHCds7VrLyZVfQLwh
	 wraSPXZw6VNTxo82wxbym7kNk6KAiSRb2Saj8iSAEkfgEnqgve6CkttDZwCWGDhmDjPLc
	 dQeClM46gfYF5cSRo/JzUA1G6q3pf+5YlziilTnHvA+63aW9pJlCROFguzj7kPjfWVe3V
	 q3NKdLNkhbCKQSqAV0uIw3QQvkshMpmTLCPiHyZDyAcrsK3lx4XNQ66GspZwN7+slUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yadro.com;
	spf=pass smtp.mailfrom=yadro.com;
	dkim=pass header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-02 header.b=l6z4cscm;
	dkim=pass header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-03 header.b="w/TXvcnT";
	arc=none smtp.remote-ip=195.3.219.148
Received: from mta-01.yadro.com (mta-01.yadro.com [195.3.219.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F172606A325;
	Tue, 27 Oct 2026 18:01:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F172606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-02 header.b=l6z4cscm;
	dkim=pass (2048-bit key, unprotected) header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-03 header.b=w/TXvcnT
Received: from mta-01.yadro.com (localhost [127.0.0.1])
	by mta-01.yadro.com (Postfix) with ESMTP id 96A0220029;
	Tue, 27 Oct 2026 21:01:42 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-01.yadro.com 96A0220029
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-02;
	t=1793124102; bh=qOdW7WofTCTc0l5wghtUGi34GVtMNdVoKH9J/yGAT+k=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=l6z4cscmL904YXncvrgZBeLqNpnCUVU78JJWW9ciMm4s50jDpUg3bdedOu+mmMiMU
	 qQw0GS4mT9SXoIt2IrarNur/j5gkyHMrDWMBFgEM2IxxzS+ZXRk1fyhjgV/NHTVBcd
	 s6J4OVdzxukTk0vQUNEVvmfV5mOWeXsggvho0JVJHhf27A9GkrE67hXfPrCZCfeC33
	 NZ7vMCAeOf9yP8bAsWLlYtgLufXOsBK6NilaJUEvUK00CwHx5MVqPKQrnWJNk6aifE
	 BNyG4XSxZ8U1Z4YfPdr3f/op/WkhQHInUx6TDhv7LtDDGRVzvdGRvVyHlOSt3onO6R
	 NBooW43pSwm4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1793124102; bh=qOdW7WofTCTc0l5wghtUGi34GVtMNdVoKH9J/yGAT+k=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=w/TXvcnTw2ko7auipSGgdrxbvCBdmSsZuSv9ODF61/vkNoIg6a0eN0d3v8UTmuoLr
	 VSVINE1s/9vUUGaaKEC55Tpup/ybVlwZrf/ZImpvH98WwuOQZm76BdvhXk9DxdQojm
	 rkdxfaaLmVycxP77avYFBwHn1rk1hD1DZdABRMLJEM0dqyY1FBbkrt0I+aQZY6V6P0
	 7o3z1fYZUz3PYUCjk/clOEQOPBsUkv6cwBemE8yLu21qSkSpxWBvx0U8eZTXE61MmV
	 6ZhYuRLi+A+EixBNfGjk6m5DOi7sFlcAtsSbCkPVx4FNObAzkBwPeWxn4KbI+C9oQZ
	 A95OYe8FHTPIQ==
Received: from RTM-EXCH-06.corp.yadro.com (unknown [10.34.9.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-01.yadro.com (Postfix) with ESMTPS;
	Tue, 27 Oct 2026 21:01:42 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.34.9.247) by
 RTM-EXCH-06.corp.yadro.com (10.34.9.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 21:01:44 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Martin Petersen <martin.petersen@oracle.com>, Maurizio Lombardi
	<mlombard@redhat.com>, Laurence Oberman <loberman@redhat.com>,
	<target-devel@vger.kernel.org>
CC: <michael.christie@oracle.com>, <linux-scsi@vger.kernel.org>,
	<linux@yadro.com>, Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 2/2] scsi: target: iscsi: fix hanging WRITE_PENDING commands
Date: Tue, 27 Oct 2026 21:01:23 +0300
Message-ID: <20261027180123.13163-3-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261027180123.13163-1-d.bogdanov@yadro.com>
References: <20261027180123.13163-1-d.bogdanov@yadro.com>
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
Content-Type: text/plain
X-ClientProxiedBy: RTM-EXCH-04.corp.yadro.com (10.34.9.204) To
 RTM-EXCH-06.corp.yadro.com (10.34.9.206)
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2026/10/27 10:49:00 #28748526
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Scanned
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5

When Data comes for an aborted WRITE command in WRITE_PENDING state it
is silently received and the command does not pass to the target. That leads
to hanging of other session with LUN_RESET aborting that command.

Pass the aborted WRITE commands when all Data has been gathered.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/iscsi/iscsi_target.c      | 17 -----------------
 drivers/target/iscsi/iscsi_target_erl1.c |  8 --------
 2 files changed, 25 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 62ada3a52210e..03d618cd76721 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1518,23 +1518,6 @@ __iscsit_check_dataout_hdr(struct iscsit_conn *conn, void *buf,
 			if (hdr->flags & ISCSI_FLAG_CMD_FINAL)
 				iscsit_stop_dataout_timer(cmd);
 
-			return iscsit_dump_data_payload(conn, payload_length, 1);
-		}
-	} else {
-		/*
-		 * For the normal solicited data path:
-		 *
-		 * Check for a delayed TASK_ABORTED status and dump any
-		 * incoming data out payload if one exists.  Also, when the
-		 * ISCSI_FLAG_CMD_FINAL is set to denote the end of the current
-		 * data out sequence, we decrement outstanding_r2ts.  Once
-		 * outstanding_r2ts reaches zero, go ahead and send the delayed
-		 * TASK_ABORTED status.
-		 */
-		if (se_cmd->transport_state & CMD_T_ABORTED) {
-			if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
-			    --cmd->outstanding_r2ts < 1)
-				iscsit_stop_dataout_timer(cmd);
 
 			return iscsit_dump_data_payload(conn, payload_length, 1);
 		}
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index d8ca06e697d63..44b851e4a602d 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -908,8 +908,6 @@ int iscsit_execute_cmd(struct iscsit_cmd *cmd, int ooo)
 				return 0;
 			}
 			spin_unlock_bh(&cmd->istate_lock);
-			if (cmd->se_cmd.transport_state & CMD_T_ABORTED)
-				return 0;
 			return transport_send_check_condition_and_sense(se_cmd,
 					cmd->sense_reason, 0);
 		}
@@ -927,9 +925,6 @@ int iscsit_execute_cmd(struct iscsit_cmd *cmd, int ooo)
 
 			if (!(cmd->cmd_flags &
 					ICF_NON_IMMEDIATE_UNSOLICITED_DATA)) {
-				if (cmd->se_cmd.transport_state & CMD_T_ABORTED)
-					return 0;
-
 				iscsit_set_dataout_sequence_values(cmd);
 				conn->conn_transport->iscsit_get_dataout(conn, cmd, false);
 			}
@@ -942,9 +937,6 @@ int iscsit_execute_cmd(struct iscsit_cmd *cmd, int ooo)
 
 		if ((cmd->data_direction == DMA_TO_DEVICE) &&
 		    !(cmd->cmd_flags & ICF_NON_IMMEDIATE_UNSOLICITED_DATA)) {
-			if (cmd->se_cmd.transport_state & CMD_T_ABORTED)
-				return 0;
-
 			iscsit_set_unsolicited_dataout(cmd);
 		}
 		return target_submit(&cmd->se_cmd);
-- 
2.25.1

