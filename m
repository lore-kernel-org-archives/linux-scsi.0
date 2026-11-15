Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794739234;
	b=faF4+KztYXThVS41tSpkHfLph7MJEVYcSVRLjA2eHxjnQG0fYAg+r8uCWy8NVgguID0d
	 PYW04S5+A3XQ8FjBGEbZfXe2AKlBpYcq3wVhE4PQSkHO7vLgb3H2nV5k7OuKbAMfrcSdy
	 0tzFaPCJKtcCBjYzqj9E5zhrtVDLzjtuCFA7+zw37iEDRgiomxux6WdtuscDXyynzJZgc
	 p4UjMeINs6bw8Vf9DLti1c4bnpHlKa7ZNkPX/mv8iIBZR1I7ufIwgLcunKPmY5qDt+HNU
	 jv3BMK9YdPGCSYw3NkLEZY0IWadwNlnkqj9hxsQimTd5GijE+9sf3VzEkq5//GcYyiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794739234;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SexY85KTBkcPpSSz9lzCXLt6aG4hGRBeEAEDC3GPaE4=;
	b=f9sJ24RbeA4KdDxer8BCcQbmZCAhfqPbzltHciMGDMij6tGRi2SI8IW0zh2zotVo6CTA
	 hGJZJ6jVpDupVTBDE+eNBtRcY34jY3gfEhoPwKjOT/pTSTOeypgwutvE2MZQHJqaFZeS/
	 cgjMN6XUOhMzjqSCQYXfbrWIjVzxE7VRj72FcGl/UcNr22vlPdRcLXXk0VQFqJRp62n/I
	 02HwsGWgLQ+Jg7o3x3KtJG5wUI2GTY8gQiC8EUGruHFri8IceLK4Xotx346NqyGFKJDXx
	 88ISkts/0eEXoBqrWESqjFhtv8gfTzO1/TuWVqXnAr7+8ZiFG7MXFdzd+/q6VPOupHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aJz93gn6;
	arc=none smtp.remote-ip=209.85.216.47
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20F1606A882
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 10:40:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E20F1606A882
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aJz93gn6
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3b0a519049aso2973778a91.1
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 02:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794739233; x=1795344033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SexY85KTBkcPpSSz9lzCXLt6aG4hGRBeEAEDC3GPaE4=;
        b=aJz93gn60oQrWRhk19r5rrqgl8h5ouq1q2TpxrDF7I6W2npEFiCPrMR0obV/dLg3Dh
         A34f8HBYPYnaBH7KUORMLnYN2Lp9fJO722RkkKVl0Du9O1Ra/Vb9Jh/UGHCvYGoYO8h+
         9P9mVa2mvaSXPAi+kkVW1K4ZvvQ/oec4lA0DehAdTrQB5M6nefO0QGxW5UPCUo1+t/Ae
         /aS2wv3XadJ5jkgluS49wzJGuifg0EkX00tfBSQipRiFTLNAVeItRIG4Dpk5yez0yaDi
         6Xs/Q7tXzW+qfUbCtuE30eGn8Pv+Hj9mPIoVojsvsNsAV3z5uPuFwe7ywT/o1okGjF0e
         psQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794739233; x=1795344033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SexY85KTBkcPpSSz9lzCXLt6aG4hGRBeEAEDC3GPaE4=;
        b=UHv8z08qI98fWpI0TpO3oqYDguGTLtNExinR8u7bm2hCQ41fL9+0Xsg4zX88UyrIIM
         ktl7kQUSo/qKX0NSnqtCIAF1vNV8MAt7ZORcpc4sCS3kDvVdDflYzxVgN0ySHfCnlTEs
         wIsalowkMJiA4trn8Df/OXVh0QcT4dPehhTzFcKSCuDAWEetxAbuBys6ZXhGQ+KR+jH3
         dSZ8HCz8jvFP+O5pcUSpXlGa+jlGYBRP6M/tYHfiqrdcucul8qQlH86DWroli1yRSYYE
         2mf7aLMKVaDCqYCwPZTA+7/wN1cVLehPIiUS2GFlDuysuWmIqA6yKXnTaeZlJq8uKqmv
         gy6g==
X-Forwarded-Encrypted: i=1; AL+hErEUvk1yhCgPaYLMUB+/yamGk8J70oB7zNfPizsHNuMtLqtVwHMnBHnUIFO+Rx616W1bBd854QOjyYrA@vger.kernel.org
X-Gm-Message-State: APuU4Z8jBnG0c186zuLCSbVMcL0NtYw8ijsTbrKggxxivpa5yO4FQKyS
	SxljiyhwDL/E69nRFkJ+5YzgJnChSNrCLhstf1WMcI6jO/Hb3913JBPc
X-Gm-Gg: AYBFou00bTWdX7bMmPZW5eLBdT6JbJ16DY4hyTty2qTAr7Df1879gfmrhwUYl+9VElT
	vKIa5LZac029GyOFJ2IFdpG+oF8/vO5EML9dV8Gf7qAZVH8ajhB7itIgt0+TYa5+WfTKwsq608P
	w3Vpq8otNpX5skP5INJPzNdILk1tMLiEBrP0L35QREUM7RrUko9Yv1DBVnSNA6ANZ/4q7+PBlg9
	9B/dUC6DK8dq2YIXtLZ3ajz3uk/uf0WLlk+kjE3/0sT1BW0q1nLnMiCxjHEN3WAvQ1F8ETnoZa2
	sPgYBN5HJ5O265V3p8bH9j8rU6z3kIoFcGPTNlxWUse4mFC3fe500wgvhJycKFoWhEg9dq8fdSU
	dE09PcwSDmPpOt6RXbnc83Jx9j13tCvy9TqVwSBmshyl9NxfonqPfYU3jjGetSIIqP+ti7Kxem4
	FIE5kbbpfAUBQluJadLMH0Epb8XrkOqm/ajTTYcYapE9XKy+SgawUvQCS6oPYdF/RscVYoWoiIN
	1B4iHm8Yq6hU8LbDLzqW16nm5TyVQ1RQIOX6Cud5remekNy7tpPU4XBBGAPfcchyovjCrSMz68F
	gy+AaEjI94tdfTfTFvQJZFZ+/p6PxpnHHNDL8BXAwN0pl3NT5w0YWoIhS9cjGv9nOj/XcpS/OpW
	bPnCDa8Ub2Je4vRfRI5HjwLW6mAFIvkA5Ci7fdRJUwmxpR05MDrH6A+AOvEbxtKOS9wcjn4LuEV
	2lYKVvoR7wbiDVt2zcs0WABQdjw5VQklvQPVW5EPhXXdkpLMSQawSRZO77kqYUrH5oj6a5WQARL
	ppPTCJ7H4YtUy+kjhIU6dH+F0bsrx+txVouVL3pL4dPDxMmkl71sI5jAbVZjInz
X-Received: by 2002:a17:90b:5107:b0:3ac:9d83:885e with SMTP id 98e67ed59e1d1-3b1b0d06feamr7368179a91.52.1794739233252;
        Sun, 15 Nov 2026 02:40:33 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f8d4612sm26739145ad.57.2026.11.15.02.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 02:40:32 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sujal Tuladhar <sujaltuladhar1231@gmail.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] scsi: target: iscsi: factor out iscsit_stop_kthreads()
Date: Sun, 15 Nov 2026 21:10:05 +1030
Message-Id: <e6199ca99e81a80af4c4c8f43885c628377b22d2.1794739041.git.danjwade95@gmail.com>
X-Mailer: git-send-email 2.39.0.windows.2
In-Reply-To: <cover.1794739041.git.danjwade95@gmail.com>
References: <cover.1794739041.git.danjwade95@gmail.com>
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

iscsi_target_do_tx_login_io() stops a connection's RX and TX kthreads
and releases its thread-set bitmap slot inline on its error path. The
next patch needs that same teardown from iscsi_post_login_handler(), so
move it to a helper beside iscsit_start_kthreads().

No functional change.

Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wade <danjwade95@gmail.com>
---
 drivers/target/iscsi/iscsi_target_login.c | 17 +++++++++++++++++
 drivers/target/iscsi/iscsi_target_login.h |  1 +
 drivers/target/iscsi/iscsi_target_nego.c  | 17 ++---------------
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index c282b6a7029..f4df5518171 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -643,6 +643,23 @@ int iscsit_start_kthreads(struct iscsit_conn *conn)
 	return ret;
 }
 
+void iscsit_stop_kthreads(struct iscsit_conn *conn)
+{
+	if (conn->rx_thread && conn->rx_thread_active) {
+		send_sig(SIGINT, conn->rx_thread, 1);
+		complete(&conn->rx_login_comp);
+		kthread_stop(conn->rx_thread);
+	}
+	if (conn->tx_thread && conn->tx_thread_active) {
+		send_sig(SIGINT, conn->tx_thread, 1);
+		kthread_stop(conn->tx_thread);
+	}
+	spin_lock(&iscsit_global->ts_bitmap_lock);
+	bitmap_release_region(iscsit_global->ts_bitmap, conn->bitmap_id,
+			      get_order(1));
+	spin_unlock(&iscsit_global->ts_bitmap_lock);
+}
+
 void iscsi_post_login_handler(
 	struct iscsi_np *np,
 	struct iscsit_conn *conn,
diff --git a/drivers/target/iscsi/iscsi_target_login.h b/drivers/target/iscsi/iscsi_target_login.h
index 03c7d695d58..02c5f6ecbec 100644
--- a/drivers/target/iscsi/iscsi_target_login.h
+++ b/drivers/target/iscsi/iscsi_target_login.h
@@ -20,6 +20,7 @@ extern int iscsit_get_login_rx(struct iscsit_conn *, struct iscsi_login *);
 extern int iscsit_put_login_tx(struct iscsit_conn *, struct iscsi_login *, u32);
 extern void iscsit_free_conn(struct iscsit_conn *);
 extern int iscsit_start_kthreads(struct iscsit_conn *);
+extern void iscsit_stop_kthreads(struct iscsit_conn *);
 extern void iscsi_post_login_handler(struct iscsi_np *, struct iscsit_conn *, u8);
 extern void iscsi_target_login_sess_out(struct iscsit_conn *, bool, bool);
 extern int iscsi_target_login_thread(void *);
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index b03ed154ca3..d56b28446d3 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -362,21 +362,8 @@ static int iscsi_target_do_tx_login_io(struct iscsit_conn *conn, struct iscsi_lo
 	return 0;
 
 err:
-	if (login->login_complete) {
-		if (conn->rx_thread && conn->rx_thread_active) {
-			send_sig(SIGINT, conn->rx_thread, 1);
-			complete(&conn->rx_login_comp);
-			kthread_stop(conn->rx_thread);
-		}
-		if (conn->tx_thread && conn->tx_thread_active) {
-			send_sig(SIGINT, conn->tx_thread, 1);
-			kthread_stop(conn->tx_thread);
-		}
-		spin_lock(&iscsit_global->ts_bitmap_lock);
-		bitmap_release_region(iscsit_global->ts_bitmap, conn->bitmap_id,
-				      get_order(1));
-		spin_unlock(&iscsit_global->ts_bitmap_lock);
-	}
+	if (login->login_complete)
+		iscsit_stop_kthreads(conn);
 	return -1;
 }
 
-- 
2.39.0.windows.2

