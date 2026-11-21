Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795279146;
	b=adFj35NimMiClTlNmHDNFeiwtQtdB3I0O74XIDIJx5au6Wn/IOMtRQCUV0tClbIBdwQQ
	 64gdLvALLf8E4J2RDGjHbzXzT4sEFh+Mf8D2WBee8mOTba6ZISyzUW7QGT+owPD9AAUBe
	 pfvOUoj37xaD4HE7h3MQZuishOE1PrTU1xxn7dfzzx0jyAXXG7BIfsyEwywo9fUqzL5A3
	 C+GSA0X6VExxUn6Ppv/fxr/zEVg0qLJQfWxWCrblLQb4P1FB1jg+nd9507/Cr9uVBH2qE
	 t499nBBFCEHgrh3Jlqbh8s8oH/tR5mfCfr4RcCrEJVkBkZfBqldw5KO0WH8k2BuSHBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795279146;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Subject:From:To:Cc:
	 Date:Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=aJagQIak0BRtppgANFUQl/qR942eiwZ9P0AShQ9wWS0=;
	b=K34vHhoD83Jqb4aVgsYnptmGhVkbRxQTQmPJL/oxRi+8XHqzig8ry/kTWHc0rkFsgT27
	 EX1g0zbhtz8CF+gAfHE6q1GlSV/afjB4hbzCvQEgchH1aXVRRX+9IUEx26zSSucuvBk2S
	 qlDv2EOiOR/nnru1ZFWMGW+lNAQXXJkZxo3ngkUS/j1Xms7ZVJC1udele+nktE9+PAXBJ
	 CYyhHPO6P/GuXE/7GUoRJ8UBqns7ONNlx3V/658fY0fXvgXC1gZIBgCzBDH/x3v/fhuFx
	 yiVTsWtpJXmcNvFrxlkJRoQFayEmHl10YDR39iiPMLu1jAZuKxDcVj7wbTQtbB5DEdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oZaGse3B;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7025606A334
	for <linux-scsi@vger.kernel.org>; Sat, 21 Nov 2026 16:39:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7025606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oZaGse3B
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so1846426f8f.1
        for <linux-scsi@vger.kernel.org>; Sat, 21 Nov 2026 08:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795279144; x=1795883944; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aJagQIak0BRtppgANFUQl/qR942eiwZ9P0AShQ9wWS0=;
        b=oZaGse3BRu13yzlOR83x5vEkHZPhBpB3/wKNUHuVByLLjz1dOEKr1S6G8WE4hP237Y
         esy4s7j2RizS5XZHqk3AzIzX0Dvcn33IgYjpS3PfUo7hZlLeaPi/iygiKJr3eiEr/IJ4
         +mB5YglndJpcWaXm0wHieAE07b9/gYGD2XUSCOvhj4hmscdJUTodvEqaNCoaC4KPXMwf
         vxyKf/47hIeM2SrQ0kuGYSQRCCyIaeD+2pdkYH4IuNIHiqmAIT8+W/9+gwIQIe/pWR+M
         QYiMSN5/VgCE7lV1Qg7kH/n7E1HXYdciP+BmnKVy6biCcNIi9WyoRMXBLRkZk21nXgWM
         xtPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795279144; x=1795883944;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aJagQIak0BRtppgANFUQl/qR942eiwZ9P0AShQ9wWS0=;
        b=azGYu0sBK+G1kBetUPoq4DdTsiLwoQuUeJsjcmTTEfX2APGfWEwSpqDaecmO85iupr
         631SZg/4JDs4zgUzqCFKN3mmuEHaOCab9obW9BlGh23W/lxVKLC5uiRZq4NdvJO9NLok
         gARbRzf+khK0qYSYfBiFCSeKFRTrvcmoQxU6miA38Nw1vt+aEHOf5V5RmMUPfBAeOJ09
         EBLU5WzWPdCoAdALVh8AzqeuLjnJZbzQr4hsQvErE18Z4Sv/zzEWKtRpWH3MJpdAndfU
         1wMggZ4vvczL2bY+YubFTEyxj81+cSXanRY3g7xMRRj/u3rCQ18zsiTTzOwTZNJQz+oz
         ORvg==
X-Gm-Message-State: APuU4Z9Q5tL/LozSy+McYNckXvqsb6Hjf/do6cdh61Ei+h0WPjW0y/Fm
	/RAUk+EEObnKD9/hs9nYaWX2KOoydSd3iTTnFq7vUvUjpLOCdeEmoYAkUPpmDidjlmxJPn2Q
X-Gm-Gg: AZFdTZcWSSN8A1Gq06Ymcc8ZVsyxVuLQVCo+cUPx9Y+x3l702OBxYBZ2IZ4c05fYl9x
	DK01sQPcHGK5amzwxkAA8wZYisrFa6WIH3sO+vqo4ZtHhCtOIu9ZxVRYQvG6CCQX/PeIEjWgsll
	Z6zcT+MdyC7vtEOdfO00lk+eIaSRsCsZtr6D3a67rMdkdBYmLBDfLzb/yGsoR+xJc6swJQQY5+k
	U2yKv//K/028UIj/9n7encbtJIqk+ksC4piFojkdYgAHjsFHYfPN9XE+dtNZLKT483crTYzE2l+
	V1Tzh9M/YjfRxjgHsYggpDwiS9h6JojBRCJPz1xxIdPygZjaBCVqQIwNFWYyD4+ZQyFuULG08Be
	QOtpN/afDkgsV0ciWKaIpTBZSzk6PQqyJh9CNcHBbtGXCd8WzJgMW9AGsuUcQwWeskQSF7yDlXc
	4den4VgKCPlHfLGtGXm/+Zfar14VeGfYqeulvg6J59g3RaF8Oy24yWWpM5IsTpn3ssR6DsRh6cZ
	HfCoJRvgBqXlPCYFkFabTzhDi/hULTdSRKio9hbrHyabQlkDw4ZSVEkGAMGPKmxYzN0lwFD1p2r
	xfbnovQNX07wYkMUnpPrToAUGtVNW1Xuh3GeV/qiXWze
X-Received: by 2002:a05:600c:1549:b0:4bb:6a2d:b440 with SMTP id 5b1f17b1804b1-4bb887e0699mr151063275e9.2.1795279144008;
        Sat, 21 Nov 2026 08:39:04 -0800 (PST)
Received: from [10.77.1.44] ([94.188.8.172])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf61b8sm11212895f8f.19.2026.11.21.08.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 08:39:03 -0800 (PST)
Subject: [PATCH 1/1] scsi: target: iscsi: fix use-after-free in iscsit_stop_session()
From: Vitalii Dodonov <dreamer.two@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org,target-devel@vger.kernel.org
Date: Sat, 21 Nov 2026 19:38:57 +0300
Message-ID: <179527913740.32224.16728687439026782592@gmail.com>
In-Reply-To: <179527913740.32224.2426414360492240680@gmail.com>
References: <179527913740.32224.2426414360492240680@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

iscsit_stop_session() walks sess->sess_conn_list with
list_for_each_entry_safe() while dropping sess->conn_lock inside the loop.
A connection that is being shut down concurrently removes itself from that
list with list_del() under the same lock, which leaves LIST_POISON1 in
conn->conn_list.next.

Taking a reference on the next connection keeps the object alive, but not
the list links: the next iteration computes conn_tmp = list_next_entry()
from the poisoned pointer and passes it to iscsit_inc_conn_usage_count(),
which takes a spinlock inside the bogus struct and faults on
0xdead000000000004.

This is reachable whenever a session has more than one connection: on
logout (iscsit_logout_post_handler -> iscsit_stop_session) and on session
reinstatement, when a new login arrives while the old connections are
being closed (iscsi_check_for_session_reinstatement -> iscsit_stop_session).
With MaxConnections=1 list_is_last() is true, conn_tmp is never
dereferenced and the bug stays hidden, which is why single-connection
setups never hit it.

Fix it by taking a snapshot of the connections (with a reference on each)
while holding conn_lock, and using only the snapshot afterwards.  The
allocation happens before conn_lock is taken, on paths that already block
in iscsit_cause_connection_reinstatement(..., 1) and in
wait_for_completion(&sess->session_wait_comp).  The order in which the
connections are reinstated is unchanged.

Tested with a LIO target (MaxConnections=8) and a Microsoft iSCSI
initiator that adds MC/S connections and then reboots gracefully while
I/O is in flight: the stock module panics in 2 of 8 cycles (general
protection fault, address 0xdead000000000004), the patched module
survives 118 of 118 cycles.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: stable@vger.kernel.org
Signed-off-by: Vitalii Dodonov <dreamer.two@gmail.com>
---
 drivers/target/iscsi/iscsi_target.c | 68 ++++++++++++++++++++---------
 1 file changed, 47 insertions(+), 21 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index f3b7569..e644fe0 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4672,36 +4672,62 @@ void iscsit_stop_session(
 	int session_sleep,
 	int connection_sleep)
 {
-	u16 conn_count = atomic_read(&sess->nconn);
-	struct iscsit_conn *conn, *conn_tmp = NULL;
-	int is_last;
+	struct iscsit_conn *conn, **conns = NULL;
+	unsigned int i, n, conn_count = 0;
+
+	/*
+	 * sess_conn_list may only be walked while holding sess->conn_lock: a
+	 * connection that is being shut down concurrently runs
+	 * iscsit_close_connection(), which removes itself from that list with
+	 * list_del() under the same lock and leaves LIST_POISON1 in
+	 * conn->conn_list.next.  Pinning the connection itself is not enough,
+	 * because the list links are poisoned as well, so take a snapshot of
+	 * the connections (with a reference on each) and work on that snapshot
+	 * only.
+	 *
+	 * The sleeping variant is called from process context only --
+	 * iscsi_target_tx_thread(), the login workqueue (session
+	 * reinstatement), configfs, iscsit_release_sessions_for_tpg() -- with
+	 * no locks held, and this function already blocks below in
+	 * iscsit_cause_connection_reinstatement(conn, 1) and in
+	 * wait_for_completion(&sess->session_wait_comp), so the GFP_KERNEL
+	 * allocation does not add a new constraint.
+	 */
+	if (connection_sleep) {
+		conn_count = atomic_read(&sess->nconn);
+		if (conn_count) {
+			conns = kcalloc(conn_count, sizeof(*conns), GFP_KERNEL);
+			if (!conns)
+				pr_warn("Unable to allocate %u connection slots for session %u, shutting down without waiting\n",
+					conn_count, sess->sid);
+		}
+	}
 
 	spin_lock_bh(&sess->conn_lock);
 
-	if (connection_sleep) {
-		list_for_each_entry_safe(conn, conn_tmp, &sess->sess_conn_list,
-				conn_list) {
-			if (conn_count == 0)
+	if (connection_sleep && conns) {
+		i = 0;
+		list_for_each_entry(conn, &sess->sess_conn_list, conn_list) {
+			if (i == conn_count)
 				break;
-
-			if (list_is_last(&conn->conn_list, &sess->sess_conn_list)) {
-				is_last = 1;
-			} else {
-				iscsit_inc_conn_usage_count(conn_tmp);
-				is_last = 0;
-			}
 			iscsit_inc_conn_usage_count(conn);
+			conns[i++] = conn;
+		}
+		spin_unlock_bh(&sess->conn_lock);
 
-			spin_unlock_bh(&sess->conn_lock);
+		for (n = 0; n < i; n++) {
+			conn = conns[n];
 			iscsit_cause_connection_reinstatement(conn, 1);
-			spin_lock_bh(&sess->conn_lock);
-
 			iscsit_dec_conn_usage_count(conn);
-			if (is_last == 0)
-				iscsit_dec_conn_usage_count(conn_tmp);
-			conn_count--;
 		}
-	} else {
+		kfree(conns);
+
+		spin_lock_bh(&sess->conn_lock);
+	} else if (!connection_sleep || conn_count) {
+		/*
+		 * Either the caller does not want to wait, or the snapshot could
+		 * not be allocated: tear the connections down without waiting.
+		 */
 		list_for_each_entry(conn, &sess->sess_conn_list, conn_list)
 			iscsit_cause_connection_reinstatement(conn, 0);
 	}
