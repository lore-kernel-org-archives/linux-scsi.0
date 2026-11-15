Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794733174;
	b=BbEDXOGuEShzYxmaDvUe+8j/XnMnpr0ZpNLo/VtkU6icfEOldKshx+7v34PLxlc1nFRu
	 8F2yAZWYd8xM+49ZvhDn2QkJehXtOCX/8fS6CjnTxP9J2qZhEoYgcfDYQXJ7spJN+yaXC
	 A3pUpsagzv3jAS1Kge+X+N9os6398Jc67HG9jzRNYKk6G5IuBfkhneoKOiuzq+fKLZsmA
	 EAPcESLk2PDKDouwpf5/P63PoW0qYCN73FewbVOKweFX6fkCrqpPq65ZU1KVPueUxH/NH
	 /RjR5zB5XlkBlClwkVISSnnsi3BpFOke2PrJYNZB7nRWEfdRa/7+BWfqOs95mR1njbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794733174;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bfgcvzbcu0GB8A+loCRLH2fTP7BpBf7AqSBWg6Ca8TU=;
	b=szOqEACRyzc9jdRCdqW/kAraZSYRHV28YZmoLrBwVqE+QqU5cTGs4+w2AQW4jQm6x7di
	 tT1qJuH7+xW74mosQyRNadHervYeQ6ylEzjM7Q1fI5hFJx6mw9aWF23U6RbhjW3MJrA/r
	 VGMS14z96reNesu1Ch02ynYZDkhspz6FNZltzroWT6RDny71mBzSKIpUY/Zcccr5d8vM+
	 y8V7jkS38E0l5+L5KkL7Qh6q8ETpIr1ZNpOqFwOvDufhFxKOpNq9sT+B4aXBLjuMxLFNH
	 XuzISWZc6MMvtWgbJ7+oM3M7+OriHY+vTm7H8doxCTvV9Fc+8loowtG8Tsa4wFDNv5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NsnscGB0;
	arc=none smtp.remote-ip=209.85.216.52
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32390606A323
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 08:59:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32390606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NsnscGB0
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3ae7626d14aso1273526a91.2
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 00:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794733173; x=1795337973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bfgcvzbcu0GB8A+loCRLH2fTP7BpBf7AqSBWg6Ca8TU=;
        b=NsnscGB06RsAuOm/sNj/84bZQPVJ+3VLasXoa6KyppDCjtdGh0rkP6IPnYq2I4SA9q
         tfniGtsIdp3YG8bYDOB8mTeD1bK13SSuxNaOvpqRJRvMHlOAqYDlp32PLFIe8dM8pyz9
         ONMZ5myb4J//ehiFcMmQDo0yd70sKKStGS4dPm8ltsuICobX1CuVPpbiVsxsPtHVmIt2
         RAaly/cOwcEor9glU+cuZWi9dcWykqlpViMQbFzLXM9IzCaSGmy5idx5rM6vjUTUmhbu
         UwAIoemHRR4Fy9IcZsEWCEdgo75ohHZacPYiWXG1IuRrTAIFkZGsVCW6c27yTrJ3tnvT
         K9Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794733173; x=1795337973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bfgcvzbcu0GB8A+loCRLH2fTP7BpBf7AqSBWg6Ca8TU=;
        b=rkSS5y0rZoFH5+Rltx1LqZhSzR3gfNF9VY2mVRYU2HdfNg4GRUllfhV/548sgw+DxT
         RzyEvgwV9qcPfxO78ZxnxOSxX1jZrF0Ztfaf5gshA8w0/fNj53km5Bi4h3+gqDPIVAWX
         8tRUQg5cA9row/paV8N8a+f/guqgMpntOzOXgmv6SB0ReTjRA/bO8NctJKvr11MwMLc6
         AKt1VhPVb/+0iaHYNfBo/YYr4DpwljXeGEKQNIgpkFpdMeMQCll+/JVMJVwIEVVSR+Gp
         Mf9VODBtUHzhoap1zjkYNzLEBQcUyXAi6H4jUFp/6ee0EPuqYRwsQJP7JMjWW1R4O221
         8ddw==
X-Forwarded-Encrypted: i=1; AL+hErF5H57ZvTlgdXuAso2lkRveIi9tEyvGsdEsaTxeMPglyr++rb37enr5GVAOnHnYXq4WBeEhJIsLWPiJ@vger.kernel.org
X-Gm-Message-State: APuU4Z/SJaXy2Ch5gBCct2YOFXLexw/xCfI7KqzfysAW/7GF8H34HE45
	aaazznEtwou1Uzmnd5BTs/6nHiG4a0ymKezWT9vK/skisYDJpZjjRhZi
X-Gm-Gg: AYBFou3pDOe7WUSc+yzSETZszhvXYReq3/U7MIJvhUaU1zpGQMG+c6XMdfnKnY4nR7l
	TTGiOOc8hT8ejDdNmb9zHjzdSBY10jy8LFyDRKCO2KBbcOj/0p7wSTHdfd5cHnxukjIMuywkCDG
	1u4e4g81MhmY7Vt2Vxn+VoPEMQggkNfPQ78/aNrBKfb3KQaeDUAhAK0jnfJaaPQGXRPW7octvTV
	Qz0008i6dNj/3Mc88A2OrmTlEjJxwQthSNYQ5xj7oJKkZIsNBvKtnXjsEIGOhzIyq7TezbjUhFr
	8bDmHWbvYxkcekjVZSTzj/qPCXCHKdj/tSE998wflDOyyDAUXXu3hfweYE5WdNpSfzqRWAe65qj
	B2D00qGbWmJELridjeKlyjQ2CUjt89s5wBMrhwyZ8rwuA+y7V6g7HieLORW7/CDXwz8CAVD6CxR
	QdWS2nRoB9ThZ2GGaQtFufyOpMpRGD4LLHZ94sCSiBWfKYl6n2w7O7KafMBEede8wuzHPbsHh8c
	qxTHvZU8pUj0FleDPfcMZUwIuNrh9TjJJm7hIBE3ncKAS/D2MI0YSZogKiBe2dJFXZ3DlBkOohn
	DAfVIwLrALRca1vKufOSZe3QOVofw/60b3ueqB55Y7kcQ6qaN6X/X9pqQogdbMp+PhNYyKoJCZR
	RN6tOUwBLupSmmP4wIXC41Y6dBE/cut7Hb10doHRMOqQyOcpD0zBck3dLCU6JKgHnXnBKQYZhR3
	/WcZh4e7snFDMvRM/hepyydfbt3wBbr5qlZLlTAyniCD3AfOpI4YFQP+8A7iPnHyJmclItjgIS6
	v+qqRnOODRDaF/jB2ggrVeD351z7hfccikRVfCJgjrTAa+6dVV5oiRaafGHzo4GHqx7XjBtQJ9F
	+RBhad6F9w==
X-Received: by 2002:a17:90b:4e8f:b0:3ac:7749:2f0 with SMTP id 98e67ed59e1d1-3b1b0b52e04mr7258091a91.44.1794733173431;
        Sun, 15 Nov 2026 00:59:33 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197c6c9c5sm16770310a91.1.2026.11.15.00.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 00:59:33 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sujal Tuladhar <sujaltuladhar1231@gmail.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] scsi: target: iscsi: don't re-arm Time2Retain on a closing session
Date: Sun, 15 Nov 2026 19:27:46 +1030
Message-Id: <e43c5b85225ade84c13948ebc6eafb9c583115d5.1794732723.git.danjwade95@gmail.com>
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

iscsi_target_login_sess_out() re-arms the Time2Retain timer of the
session whose login just failed.  In the window closed by the previous
patch that session may already be on its way out: iscsit_close_session()
stops that timer, then sleeps in iscsit_check_session_usage_count() on
the reference this path is about to drop, and frees the session as soon
as it is dropped.  A re-arm therefore lands between the stop and the
free, and leaves an armed timer on freed memory.

->session_close is set before the free is committed to, so test it here
too and skip the re-arm.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wade <danjwade95@gmail.com>
---
 drivers/target/iscsi/iscsi_target_login.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index de0cd95aff0..1f41e5274f2 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1168,7 +1168,13 @@ void iscsi_target_login_sess_out(struct iscsit_conn *conn,
 	 */
 	if (!zero_tsih && conn->sess) {
 		spin_lock_bh(&conn->sess->conn_lock);
-		if (conn->sess->session_state == TARG_SESS_STATE_FAILED) {
+		/*
+		 * iscsit_close_session() stopped this timer before sleeping on
+		 * the usage count this path drops, so re-arming it would leave
+		 * the timer armed on freed memory.
+		 */
+		if (conn->sess->session_state == TARG_SESS_STATE_FAILED &&
+		    !atomic_read(&conn->sess->session_close)) {
 			struct se_portal_group *se_tpg =
 					&conn->tpg->tpg_se_tpg;
 
-- 
2.39.0.windows.2

