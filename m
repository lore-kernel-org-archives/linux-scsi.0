Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795094244;
	b=WFPPV1mo4cJQhPXBD0pWPEs7T4GG6ltzeGkEhIZA7aVLtdLSHSGURZ1tVKPyC73E2hn0
	 /D9Xe8mPi2+vZyqO1uSsKMfNGAeyrJm5HEQn38f4sOf/xt59BeedPyDTeW52/wJtLLFtU
	 OlFGQzjrFVj3HTmRgr1UD2VJpmEBXZAJ7ILB8R03YDcXce52KDy1z0sv+A7mxzf/Pl54G
	 Xc038FtVZ6nUCvqX/v7EJbDVNrRRSQwgF2laqsFMIefiEXO8bWyjX4RFuzLi2Pb8gt6aO
	 NH9579UMZw4MFABR4GrJNV2JKrxOpeM1blKsMXB6Uy0VZyJVag79OJfQPXjdcrWpp6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795094244;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1F5PhsVSMvlAKbqeP5i5JDJo+bg6gq7qbiCDaCKQio0=;
	b=Kbf9rro2Y8YTckGYvkba9BBzt4+9nguihMkbg67SHXXLsovSNj+5jIYkkW8VXP5lPxSM
	 70/NQrK2srX8hg1wWGveTTwOwPgjGH8cYJ8QEb+Hk9X3D5K1QQx+Ru2ww1mzDHRJygjPU
	 CG8+SX6AqID0GEI7g6XDIhESEy8sdkMndErLoeLPjK8fKfnduAT1YekUhDmLLOUafgvoL
	 Gtx39wcZ74NYFYfmYyCPri6J3P54rAv16LyTXK42VMABQXX4OdJj/68LjGG8EkIMeb1Om
	 /EGt1Zha2/zHk72B/84ZVUa7ftAY5q2XVAeCk/fU5qqsFLPJQ0oC7KL5SUdwD0zY7uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="dMc79+3/";
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DCE60A2613
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 13:17:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11DCE60A2613
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=dMc79+3/
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8b67f25e6e1so1421750b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 05:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795094243; x=1795699043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1F5PhsVSMvlAKbqeP5i5JDJo+bg6gq7qbiCDaCKQio0=;
        b=dMc79+3/bbz2dq/bJUjd6kyg4QIMok8By+PE3QK8cvP6ZawvYbZUM2YRgN4WmchUGo
         9cMCKmDqt7cBFOeH6A4qxfuGvgJnyvlamjSTmtMkbWxM+xGEcWswf4ZwbqNsl/SvPaXy
         zPCk6pxp4IBpZa9hNMp3Davj09P/kLs6qcW89RuyrDEv4GBJLHhEgHUb3s/9QOeiRu10
         +T1LfJVBnstPqqdz/eTr2mBE0x3w+PivdvlePMqVqEjGmyph0JKJ2Bjvo5h4Ir/IXDbs
         wEqNgxOUUlKXDZICvVHa1OEPQ2Gdn3oAoytRqBZpg4RRBT9Zd6vWlCR1UIjho5DM5SX5
         vbkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795094243; x=1795699043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1F5PhsVSMvlAKbqeP5i5JDJo+bg6gq7qbiCDaCKQio0=;
        b=gt4HKNvXSgwMC2OzGaylkvjmwEQdli7QQTrCpqHVsdatSRnls1ei3fPHNxC9b7mtMI
         46fnY4el0/KmADHYAFqwBtwmvKzFPFO1v8cJvyyFGXFDg1rjQPEDPDQ9eCHIyuUSJ2U6
         0dUaM7X/u7haf/+tgoj4ui9HCQIyC79mTvEtX2NBM9fq3SDQM5a6f1vg+/QOkoAhWAyM
         rHfndM+nxOQYjv1SRFS/qoQk/7DMVJo0iyPaSIChv6E7TqhNVKiEq5GMs7OuG8aH/hwy
         tAjVu+4wYfc0HbxB9XTShwxiTkgTGCEWbdYLmc2ozOJVnrrQwXO+1BA3FbADjPUuUqBe
         6yyQ==
X-Forwarded-Encrypted: i=1; AL+hErE+Nh+Tyf847F8PzVIFK9vawprMz8BOhjHblofgxfToYs8ZYGtSDHL3X3eWwEB/Z5zA5jZfNGZhRTTL@vger.kernel.org
X-Gm-Message-State: APuU4Z8w5NQuR9EAD+YEvtyQAxyFU3d29h6c//0ICVoC+UnRcDiBWFEk
	6F+2h7v0tYm+MzCtBP4UWydr5x66BLOxeanv93Qw6UnycPjpCSI7lIuWVSZgqEkCkbU=
X-Gm-Gg: AYBFou3jCKZb4sEisY65Fwphxw3xfREp2jJz9ohcPUlFImh367+ojRgLSMj4zn+C2+2
	YSYszGXGlp4h0x9OW/COrPnR6r1fzbpIfYXmQWG8E5HcKSGw0aHYypXP4Yv81eAcoF0YKZ0gbFu
	UK3vVmCfvHSca+oDhATbtGoAdFcrcbmORRv0zR/1MfSamdw9V1LMBYzE/EdUN9j6KMLxq4TCA9S
	dDIjSzo4e4iwHAbbMao8t0rN4ShvXwcToUO37KhviasPqp3WATulYAYN1HU+qEmzSKYosMc0ZeH
	ZCLE2swuxNTFAvLlFviSwjTGJKp7qD+hPKpVVLMxwoMwh7cSNbkxxXaGXIhz7tS4ae+D4gnsJvC
	+4P/tiWafliKDybzZ9btQtPVQvCNTiO8F46o5lrd5Ar9sF4CW4S4GMqRaBxeKW1RRpp6lke8Sv7
	3LF5Wjh9g10Cwm7xCBpxIbtUEP+7Fx8KZSMnT1I8eHRGnJepX/Xvgc5/fMRtqFnKRC0vI76+UQ9
	4kE9EPkUgLB1Ez8AitTKP83nlMJrfG53UEark87tCgYbaUGRMqU78t7DnHvwOncTNXGMEjukyPp
	DKv6VJkTaSZXA1JIRHTebz/etDsptzJpmE/O+onAepuphqn1qTF+TPQdJjecZdr7/YEtVlZfk1T
	oeuvhMGrLZSQxJ3ggaweGVBZIikAmrhbB0l8Tgw==
X-Received: by 2002:a05:6a00:230c:b0:8ba:f51a:1bc1 with SMTP id d2e1a72fcca58-8c5d3639dadmr5519001b3a.24.1795094243488;
        Thu, 19 Nov 2026 05:17:23 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:1076:1f1f:dde8:a816])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c5c7f99f91sm2809467b3a.5.2026.11.19.05.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 05:17:23 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/4] IB/isert: do not leak the receive descriptor of a dropped Data-Out
Date: Thu, 19 Nov 2026 22:17:00 +0900
Message-ID: <20261119131700.2722108-5-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119131700.2722108-1-yhlee@isslab.korea.ac.kr>
References: <20261119131700.2722108-1-yhlee@isslab.korea.ac.kr>
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

