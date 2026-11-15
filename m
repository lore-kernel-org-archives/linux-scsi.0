Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794733171;
	b=tA4Dbwk3kAVxj8I88x7Vayklnv0U1gJFwjQVlEyDqAZEuKA8gOxxMgJvYUfSa72asSh6
	 FQVJFJ0WV1AcEqVYge+vziXPVFRPngHjURXwtqhyr0BTISACby/Fhwe//wcu8RcbYmaY2
	 iHRUOGFbl5G7RO00UJMhrTEqZt3w92kUxWBp/Sz8ymp+wBoIPN5B82k2Ec6gvWnZDkoE2
	 mv7uZ0qTEWOwwSsNrIH9IUI0jeR+NEEFFpnc8KciwXnJnPcUZzz9eoRrMXSCk3eAx1eN9
	 SSdw1pnPTQsigtVenqvglLT57TVBlO4CDk6jX2rAUMgvvr/xZ9avYiY5ICZrqYSB4RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794733171;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RetYn0BIqzHeFHXhT42j9H/gxZJ9ddxXCM6J09DUuKI=;
	b=nah6obHiSZNoyBiIZySsk7IYn8T/D1pfpuHP0orCgFbyR/TVecWHy4lfTfClkcDdOVsU
	 2Yjq64BzT9cJmyc2Vl3bw6P7in7ebElBq8zJgeR6lW/h5KElzYh8bIIlL2tLw0r0I3E4z
	 OyaDxgOH0zmvpIYplm/d5p+qUSk2PHM6FFvU0YsTETBZyAh1Ap5otmEkLVpy7LuusORKN
	 Jp3Av4oWj+f4xjMEGNyLdiwlIKtEZijS+LRVoeGbMO5vz8Igy6H/qW/llZHNeHM3W3WX5
	 Wd9q8PxMYiKhpN0hHEVxddatw5kQPCjErTCRSSp30BZaXt4PDqF93ubdcJiVbkw4S+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i90xKGzE;
	arc=none smtp.remote-ip=209.85.215.178
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F228606A31E
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 08:59:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F228606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i90xKGzE
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc4aa0246b7so908762a12.3
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 00:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794733170; x=1795337970; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RetYn0BIqzHeFHXhT42j9H/gxZJ9ddxXCM6J09DUuKI=;
        b=i90xKGzE+Tp3hLUZQfiRTmtiGnVbak69A05wCd0MR5g4YSOFoo/9aGCDiFrYikMGuD
         lMBogwWW6V1oVGLg62FWVoooUkgxiPsZApgVtNa94uR66gDwyM8qJlsCFxUizEss9QQk
         4UwUFhT66nYMW7nVdU3EzpHMf6YsjPXp4yhynHqStlVFZq5U43pXyyPy3Qi0qGX4pIGi
         8uHI2kOgGPfOLj2Mctz/wxU9WBmAL7AVJnaYiwtq+NlFpNEheooJY9aDZYaXtAdEexuJ
         6QdVzCrxMg+M+QDsOKyhXcbZlxZmAtNdy/LcDY8h7zZ1DDEQwPi+GVzAfL5GwN4IvxG+
         14xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794733170; x=1795337970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RetYn0BIqzHeFHXhT42j9H/gxZJ9ddxXCM6J09DUuKI=;
        b=vsgQPxM8R8/DWONsUDhUxiAbvRcKFz83kZ1AGAOooGJDUiPW2sciwfMogbEELbpzvq
         c4Ro0F1m5V78z3k0iwlY696SVLY47WlZB6TI4mvoG/BekLS72U/r2E4UPeuMv+06sxVO
         RoeW1HJ+/J+T3wn7VUqP++JiPFvEM1mXT0VQ4htvpdi+KLdNWxxmHrCDF+lDXIKO1/h/
         NWcy7DLoeAJHsH5HvD8O6vPehRTvoVtrJBoMOlqzH9Pt2KFFhBC2u9NUj3rkTN3Bxwhs
         qatKrsqOVORiwCau25X490grFPW9xvGSwURtfT5ffwV+TH5/gARa2YBYWTM97WdhPXZ9
         MPeg==
X-Forwarded-Encrypted: i=1; AL+hErH/DAP/uDpFSTWfm50QhIumkFS3Dln5NY3buZc5nPXsSwY99Uj7cOxEaDP4BHLVolceGcfc47mgsDxH@vger.kernel.org
X-Gm-Message-State: APuU4Z9FZmzqmALzI5ESK65INfzH8szuXNHEAC/axkOTtpaWUjb9frHg
	AX9T1fx9TnANwl7L4tjUrf9lmzmE5apivLCvGTV9i0LMtw1YrSaKEVc4
X-Gm-Gg: AYBFou2klTnWVdIBNOOgZeVZ5mFg+QsavMEWNRu/WqEC2cie/rpUQiUoiL7jNVAVV4H
	8Mw3DRFZADVRmgGpapsIw8ggxEHk1Jo1tt/T0Igu3JP2C0ukK4hIM67mIDDKFRJbvUEavFgA2SA
	zxaQWi4dyb+yPxW29EPDTUKZvPuJgYPUoBlgWHTVkpjdKqvDjbKjYytL6+AOoH8pvCni2KXeMJQ
	kO5cCid15PckpMTY5/vu30xjI+auX1vDTXv7COgaubN4s8vEWDTICnyLlszTQ0gwmwu4a5AGa0S
	EjSksy4N+Rp81RXUEWmLtC6xFmeulkjcMNobRhyI6xkEHKmSrSHMuGmlYLuBsVtqbuU3q922YT1
	0Lk3Rojywvb4DHI27WGmsJTiWVSkrAvyuq/bYXtPoMSdHt7qNEyf3rAjHTlL1z7Fq7nReHSZKms
	cNoNyaJyZhsW/TVCUtT68z047U7Mq223JW5fBDdW4xJzXfFB9YS7KxuKhRUMcrQm+5vsrXclJIv
	YRESDFKhGMKKSe643PrpBL4Ya3tCobE0sE1VBH2MaGWw6i2csswV0Q4BZvRsJZqWIiSz8NMWK8L
	wSBHYIhwm19wkxKj4tgjkDKuMJcTwkhc5EovXGBwAfr3ZOlxahXQZ+Yh1kSluxgZtQAiICNENzT
	qoJlH4wzBGpNSF090QJx3EauPepk8sfql6A/Jybvt4IPf/6ZvA1kSqe0Tm8fXx5gIPQgMUbnDt2
	xDVGn6opIEjB7mfdrrfFU7ToZJlTQV92JKSX1Rm4qF7yJvHESOu7FTuQymL7uDmgzf2+UXhqihM
	rbtrawpiyVXAEESi3LNpc4ySU+gzO5d3mCHxNH5is03FbXDMKMx4BKUyrtLrIeNy8T3ubEhNhxT
	w6DqTcxhDg==
X-Received: by 2002:a17:90b:3f46:b0:3b1:8301:95c0 with SMTP id 98e67ed59e1d1-3b1b0b95db4mr5779358a91.61.1794733169887;
        Sun, 15 Nov 2026 00:59:29 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197c6c9c5sm16770310a91.1.2026.11.15.00.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 00:59:29 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sujal Tuladhar <sujaltuladhar1231@gmail.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] scsi: target: iscsi: don't attach a connection to a closing session
Date: Sun, 15 Nov 2026 19:27:45 +1030
Message-Id: <3ae0ce68449390d9e3893e5328367c4db3818f96.1794732723.git.danjwade95@gmail.com>
X-Mailer: git-send-email 2.39.0.windows.2
In-Reply-To: <cover.1794732723.git.danjwade95@gmail.com>
References: <cover.1794732723.git.danjwade95@gmail.com>
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

iscsi_login_non_zero_tsih_s2() finds a session on tpg_sess_list, skips it
if it is already marked for teardown, and takes a usage count it holds
across the whole login negotiation.  That skip is sampled once, before
the negotiation, and never re-evaluated.

If the session's last connection goes away while the login is still
negotiating, iscsit_close_connection() sees ->nconn reach zero, commits
to the free under ->conn_lock and calls iscsit_close_session(), which
sleeps in iscsit_check_session_usage_count() on the reference the login
holds.  iscsi_post_login_handler() then attaches the new connection,
arms its NOP-In timer and drops that reference, which is what releases the
free.  conn->sess is left dangling and the timer walks the freed session:

  BUG: KASAN: slab-use-after-free in iscsit_allocate_cmd+0x6de/0x780
   iscsit_handle_nopin_timeout <- call_timer_fn <- run_timer_softirq
  Freed by task ...: kfree <- iscsit_close_session
                     <- iscsit_close_connection
                     <- iscsit_take_action_for_connection_exit

MaxConnections does not prevent this.
iscsi_login_post_auth_non_zero_tsih() tests
(atomic_read(&sess->nconn) + 1) > MaxConnections after the reference is
taken, and ->nconn is 0 here, so (0 + 1) > 1 is false even at the
default of 1.

iscsit_close_connection() tests ->nconn under sess->conn_lock and
iscsi_post_login_handler() attaches under the same lock, so publishing the
close decision in that critical section and re-testing it in the one that
attaches makes the two mutually exclusive.  ->session_close is already
that flag: only ever set, never cleared, and the logout and explicit close
branches already require it.  Set it in the ERL=0 fall-back branch too and
refuse the login when it is set, dropping only the reference the login
took so iscsit_close_session() can finish the free it committed to.

The refused connection is torn down here because its kthreads were started
before the final login response went out.

Tested on mainline with KASAN: unpatched, the reproducer produces the
report above and then a general protection fault; with the series applied
the login is refused and it no longer triggers.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wade <danjwade95@gmail.com>
---
 drivers/target/iscsi/iscsi_target.c       |  6 ++++
 drivers/target/iscsi/iscsi_target_login.c | 41 +++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 124ff269b8e..ee7df7f2723 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4431,6 +4431,12 @@ int iscsit_close_connection(
 	 */
 	if (!atomic_read(&sess->session_reinstatement) &&
 	     atomic_read(&sess->session_fall_back_to_erl0)) {
+		/*
+		 * Publish the close decision under ->conn_lock so a non-leading
+		 * login attaching in iscsi_post_login_handler() sees it.  The
+		 * branches below already require ->session_close.
+		 */
+		atomic_set(&sess->session_close, 1);
 		spin_unlock_bh(&sess->conn_lock);
 		complete_all(&sess->session_wait_comp);
 		iscsit_close_session(sess, true);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index f4df5518171..de0cd95aff0 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -660,6 +660,33 @@ void iscsit_stop_kthreads(struct iscsit_conn *conn)
 	spin_unlock(&iscsit_global->ts_bitmap_lock);
 }
 
+/*
+ * Drop a connection whose kthreads are already running but that must not enter
+ * full feature phase.  conn->sess must not be touched once this returns.
+ */
+static void iscsi_post_login_fail_conn(struct iscsit_conn *conn)
+{
+	/*
+	 * iscsi_target_tx_thread() only leaves cleanup to this context while
+	 * conn_state is TARG_CONN_STATE_IN_LOGIN; otherwise it would reach
+	 * iscsit_close_connection() and walk the session being refused.
+	 */
+	conn->conn_state = TARG_CONN_STATE_IN_LOGIN;
+	iscsit_stop_kthreads(conn);
+	iscsit_dec_conn_usage_count(conn);
+
+	if (conn->sock) {
+		sock_release(conn->sock);
+		conn->sock = NULL;
+	}
+	if (conn->conn_transport->iscsit_wait_conn)
+		conn->conn_transport->iscsit_wait_conn(conn);
+	if (conn->conn_transport->iscsit_free_conn)
+		conn->conn_transport->iscsit_free_conn(conn);
+
+	iscsit_free_conn(conn);
+}
+
 void iscsi_post_login_handler(
 	struct iscsi_np *np,
 	struct iscsit_conn *conn,
@@ -690,6 +717,20 @@ void iscsi_post_login_handler(
 		conn->param_list = NULL;
 
 		spin_lock_bh(&sess->conn_lock);
+		/*
+		 * The skip filter in iscsi_login_non_zero_tsih_s2() sampled this
+		 * before the negotiation.  Re-test under the lock that serialises
+		 * against the ->nconn test in iscsit_close_connection().
+		 */
+		if (atomic_read(&sess->session_close)) {
+			spin_unlock_bh(&sess->conn_lock);
+			pr_err("iSCSI session is closing, failing login on CID: %u\n",
+			       conn->cid);
+			iscsi_post_login_fail_conn(conn);
+			/* Last access to @sess: this lets close_session() free it. */
+			iscsit_dec_session_usage_count(sess);
+			return;
+		}
 		atomic_set(&sess->session_continuation, 0);
 		if (sess->session_state == TARG_SESS_STATE_FAILED) {
 			pr_debug("Moving to"
-- 
2.39.0.windows.2

