Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795001967;
	b=wiNt+pku9Q6wh9ddmWPvh9NbHUo/vZQCSAGbWDtwYRerPtgVYmVMus0QagnaoM2oZ/r+
	 uB8VnPRVjxaeNhVOsvpCtGDxgg2l4ZYc/Mdo0eq3hGDtQxD+lHL2rkyRSZvLlpto72Ezb
	 VBlBwBCOQfKDrPHMvW8EOBA7Hqfk6MOGo2C9YewgYJpOAirzjBZkFByrJq/3sff55nAtE
	 r7VFsvzUTrsR7C4Q1nde0IZE0MDoRy/8GveIVp3s1VbIti/q1md/N/cCv9cOjfI6KxT4s
	 R/ElKJhW60FKFPOpx19g7bj4mPaX3Zq171NgETR8valeChWyHo+PdG2tA1bvtVBkc+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001967;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1F5PhsVSMvlAKbqeP5i5JDJo+bg6gq7qbiCDaCKQio0=;
	b=kLl0fvc07DTATwvNado/UWa/DYIxAOHNeqS9tVFeRrT7/7dAH0uS10AajcPRXwBOnLwh
	 CusI3kiyTMFmWlMjJRLudK8E+GmRZIO3w2XZ1igRbN2sBmGlxumwGrxdHC06LFGYDuAaZ
	 TfGwqyEcsDWubRkOTsU1GNwABtiameK0RqsSBlh6XvEpWMX70hi8kE0V9BhBy1QtpJKKE
	 eJ9wTXyDfpRmNzzMHW99y+AY/vkvSmyTWfJqmPWBbs9ovXHYSyAcZsMs6el/jEi7KV1lV
	 wED7eq/kAUtSG+RCwUQMSrQN3ZEMmrslQdozdEb6vqcdFLP9AxlOaOhI/u7/9bNGf+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Q47akWcP;
	arc=none smtp.remote-ip=74.125.82.41
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7608606A33B
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 11:39:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7608606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Q47akWcP
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1b50a4bd2f3so1311944c88.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 03:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795001966; x=1795606766; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1F5PhsVSMvlAKbqeP5i5JDJo+bg6gq7qbiCDaCKQio0=;
        b=Q47akWcPtA5FiPd6ZuJYeD3bZtbUIIDPkSCk+a0Ar7dv6cLiUvyNqhidnDc8QI/d//
         0WOL3fLcco1KOikDVg4p2tKn59d8u9TbkiMLb5FBoSS0Fy49p3PxtcMkVkk4WzUsGcb0
         y5h5gmKD1Gn/hMF0R8gqLXou/uVnQrx5LNIoPDEIZyjtIK/fNSk4aTCAAMrlacEBh5wP
         3c3WNfS0I9lBNriwo2iS84p8ENJUu+Mhfp00C7fbtc2hMpmMqnO7++0LNP6MBL6Al0sv
         Xr1cOh8eYDJjJ4mX1k0XaNphFuicghaf6M6FjXjKMOAdX3BJYfqmCnol7xUwTdQ9oX7o
         P3fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795001966; x=1795606766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1F5PhsVSMvlAKbqeP5i5JDJo+bg6gq7qbiCDaCKQio0=;
        b=hhoXstXgU4XrnWwB7z/Lt/2pgs3AymTSxcULifr7asq8/4YaVJVLui7D+EIch/jIOQ
         pepNpJn0WfBP4tkFv3tnXGnTDudHIqS4S/D+lPRFsRk+tBBK0GleXmHPbcV2wd+EKWB9
         V62XGaqgMm1XTHq1fyBHbOKx1V95t/cvrtNcMOhjeveKpCO4JSwx+Us8f83lSgxvdG3F
         Px04lci47XeNXT8a/Roek2xAoKjUqHZZMrJl2tBdBYGA0GXxYbb7XvryjNMhYvTFG8tv
         FGJ9pXct/vCpB80wu7DaQU4do/HvPSESttWZ09gxO+AZ0taZtmlpa0JgXX9J7NK7U11j
         56UQ==
X-Forwarded-Encrypted: i=1; AL+hErEuf1c/+jSpPxu63hPKtl3Vye4lduji7TRGF8FqDwe+ejPOMkR9fr8Q/Q3O5r15kiSemNpP4ztSAhCc@vger.kernel.org
X-Gm-Message-State: APuU4Z8oIi82v/3WBgMkUzl0RsZ3I7mJkWUl/RmvMlceeE28y85wgKBv
	9U91yUfvkd/UEc5drSLq4SaHAkmRYjmSMvY4Yrif4lNapyI4FcM91zVJtOJ1qCKsPX4=
X-Gm-Gg: AYBFou0Eih76NZpGR91N+jSU/2IQ7I+6CCdPPj39KQZ3SFXZYDDwb8Yc3NXykj08JTw
	c5UhdjmxQ15jKgksiyDHw1SEs6ixQrWomJ2MlmZxGFSGwC7tc0PoBnpc9o9p3Nq5YbPwh5QRbiy
	+FpDLa6rcJ0ZULUJbjYvrfws/c4v3mQNv3bjQR7NrD/IMTdJAl5PIdl2LHXdwLHlrCJb4B5ty+p
	iG4Pg4uGsG4VZCfbAzk4QrrTgqk91V74KGJsn3xMVuM50tNOgHBXjqBgb4gSFNMpSWSS7Y7qmbK
	8dpjSJeW+W+uke2WKEIHySkXSBGwPg6VsxpoUDCZsNJdhioTxuOTgN1GwoSTXZB5Bhm9x8Ilpky
	MNvvm4k3fgLIno634fc+RWaulRxGeNaMqVq49Wfk4TDlIYsz2V3J7Y7zQwd7BnVdZhzU550e9k9
	NQqv57FDRl+en3pT+DdR+UYS151EYxcOjNmRh0uETaokOhZ4erOyGsNr32xqoRmFT6IwNmkK7qX
	3shf5w3BaYhvy7xIvY/pOjo64/xG7J/II5o32NzmJu5/buMj9rTtaCPaeDn0JHtAsaoHQksbFa4
	5ryxEOjMJOJJm5vLaDWV/sz1EDdjjONXu8i2INnDfE5cxWSaCvBl4Lig6+6pchox83AEfO8pWfT
	jVKTqznB7G3xDE1n/WqiC0ZDVcwVPFA3h5qiZ/A==
X-Received: by 2002:a05:701b:21c5:b0:1b3:aee5:20c5 with SMTP id a92af1059eb24-1b543d02824mr2306544c88.22.1795001965044;
        Wed, 18 Nov 2026 03:39:25 -0800 (PST)
Received: from localhost.localdomain ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5446f954dsm6044662c88.2.2026.11.18.03.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 03:39:24 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] IB/isert: do not leak the receive descriptor of a dropped Data-Out
Date: Wed, 18 Nov 2026 20:39:05 +0900
Message-ID: <20261118113905.2361969-5-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118113905.2361969-1-yhlee@isslab.korea.ac.kr>
References: <20261118113905.2361969-1-yhlee@isslab.korea.ac.kr>
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

isert_handle_iscsi_dataout() works on the command it finds by ITT, which
holds the descriptor of the SCSI Command PDU and not of this Data-Out,
which is why the function posts its own descriptor explicitly when it
succeeds.  None of its other returns do, and isert_recv_done() ignores
what the handler returned, so each such Data-Out costs one of the
ISERT_QP_MAX_RECV_DTOS buffers.  That includes the returns where
iscsit_check_dataout_hdr() answers 0 without a command at all: 200
Data-Outs carrying an ITT that matches no command stop the connection
after exactly 128 of them, with no response to a NOP-Out sent afterwards
and nothing logged beyond the per-PDU "Unable to locate ITT" message;
with this patch all 200 are taken and the NOP-Out is answered, in 5 boots
out of 5.

So give isert_handle_iscsi_dataout()'s other returns the same post its
success path already does.

That one function only.  Everywhere else a handler returns non-zero, the
command isert allocated still holds that descriptor and the response
posts it from isert_post_response(), so re-posting from
isert_recv_done() would post the same descriptor twice; the second post
is skipped only while the descriptor has not been refilled, which is not
something the receive path can promise.  iscsit_handle_logout_cmd() even
returns 1 for an ordinary logout.

Fixes: 4366b19ca5eb ("iser-target: Change the recv buffers posting logic")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index b7dcfc5f88b916..804148ace398aa 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1141,17 +1141,16 @@ isert_handle_iscsi_dataout(struct isert_conn *isert_conn,
 	int rc, sg_nents, sg_off, page_off;
 
 	rc = iscsit_check_dataout_hdr(conn, buf, &cmd);
-	if (rc < 0)
-		return rc;
-	else if (!cmd)
-		return 0;
+	if (rc < 0 || !cmd)
+		goto repost;
 	/*
 	 * FIXME: Unexpected unsolicited_data out
 	 */
 	if (!cmd->unsolicited_data) {
 		isert_err("Received unexpected solicited data payload\n");
 		dump_stack();
-		return -1;
+		rc = -1;
+		goto repost;
 	}
 
 	isert_dbg("Unsolicited DataOut unsol_data_len: %u, "
@@ -1169,7 +1168,8 @@ isert_handle_iscsi_dataout(struct isert_conn *isert_conn,
 	if (page_off) {
 		isert_err("unexpected non-page aligned data payload\n");
 		dump_stack();
-		return -1;
+		rc = -1;
+		goto repost;
 	}
 	isert_dbg("Copying DataOut: sg_start: %p, sg_off: %u "
 		  "sg_nents: %u from %p %u\n", sg_start, sg_off,
@@ -1180,13 +1180,18 @@ isert_handle_iscsi_dataout(struct isert_conn *isert_conn,
 
 	rc = iscsit_check_dataout_payload(cmd, hdr, false);
 	if (rc < 0)
-		return rc;
+		goto repost;
 
 	/*
 	 * multiple data-outs on the same command can arrive -
 	 * so post the buffer before hand
 	 */
 	return isert_post_recv(isert_conn, rx_desc);
+
+repost:
+	/* Nothing else owns this Data-Out's receive descriptor. */
+	isert_post_recv(isert_conn, rx_desc);
+	return rc;
 }
 
 static int
-- 
2.43.0

