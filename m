Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.231.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793113655;
	b=TmRA7mjwSMOt1bFCSv09J3UazrAI3VP1RBoHUwbzxCrbXu8DkPb4WKo7YIbxLQAWnXfm
	 gkge6cMnJGu7KpFCLrdYtdO+680UcftTRnNJFCW+Gf20qg0invzSgbcXLCrLgMQIifE+p
	 dXhdj3KayeZ4EO+dLCWX2rOSie2xMFt6S70E1T10i8gg8iUW7GCSHm8wE8hAJEWHzLoeH
	 3VsiSCdwFUNFa7wbds8fCCtkG+lhOeQUFjpfANoZhrBFeN/MefYnYD5CZWGzIveiimSM4
	 f6FGFpiXrDUBOvQxyHjFjrkFXd36KPf0gpqB4Y0b4cadTyFzZrDdtDkdcixjlCqNkrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793113655;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=mxxURynAR9bAxx4Uoj/0ut49X9XR1HFcD/rz/A3dVCU=;
	b=a9TEWdgmLdhGZOfO0hx4YxOHyMupIfDG2K6IphTx3OniBe1BeP9BLOXkoJ8ckKxJeVMp
	 gFsYQnO8MlqPaVoB6JapiSEyF9GEUhWBIZrYlja0xk7HrejlZjj47zQw0RpNFuPu3NFZi
	 7sAhZ/jsE3grfX7dK2Eogu/8TckdTeZIlpEJ+ioczQP2f8yjzz2tFxlqbWKVcVCw176GM
	 D62SV+I9UjBetg6jTrLPsqwnImtuFxTIkY3OrNx1Mwpxbj6GjHbrA1HSpRy6T39IojxmV
	 C/W+qMtoxGCNdMsRUffL/SFEDp80L1ATZJai5R9aLL4lzXYx7Og5XOUoVBKAlpMf2Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pio6rIqo;
	arc=none smtp.remote-ip=74.125.231.200
Received: from mail-oi2-f8.google.com (mail-oi2-f8.google.com [74.125.231.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C91606A31E
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 15:07:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3C91606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pio6rIqo
Received: by mail-oi2-f8.google.com with SMTP id 5614622812f47-539edfadfa9so1771523b6e.0
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 08:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793113653; x=1793718453; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mxxURynAR9bAxx4Uoj/0ut49X9XR1HFcD/rz/A3dVCU=;
        b=pio6rIqoVvBFD4OXEdzToeCLjwWtoTweeKR6MCtT/UloGziG1bqsYU+jO8UiUKU2YA
         2bSh992AF9MKghf37YyuB4AozwHoXyuCZBIEZTUBzKm7XiQ+L3/HzcZ9BIDX6mRUA1cA
         waVy34j4xO5fhA/uwxC+IoumHD5aRr8k1raiR1PxwXZuP444zRIuISqASaYfBHbBzxxY
         F9RLYzpaFRGv9XqIMQCviqmA/Q62yPLj1/f9noiWgUruUNxuPx8cxdWXgYBvOPZBGtMd
         QofyHI137pP/03jgyQPbDEGsXll+AY7Mj0UBRP+kH6uMtWz82pYknxyx9MdkTv717A/X
         tbxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793113653; x=1793718453;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mxxURynAR9bAxx4Uoj/0ut49X9XR1HFcD/rz/A3dVCU=;
        b=CIDI5ClkJyCRwL+CxXPzmiI7zKw5jKoxYVt/nxc3apmqxHuAJSv0ko8QaTcG2gZ4Ut
         wWeezQq/OuvclZ7UWThHmQ7NicrTyMc2/LKm9XgHQl3owVUBCNgOml6K0AV6lnE63E82
         +NY5E2AjIP6p83FkDBsUA+ufcMBDqDjY6treRBv91Oyu2YyQYSw0zN3IsVFeZVzJwlHk
         GO4ul5EW6h97kLaId5thv1NTmX2LHA/3G5tqWncy9zlv8+5K5jW5Y2MFheelU1Pjy8c+
         fEB+HAXaqOQLD40pGkVqlrfU2IwR85bEPQcY+a5B2c2aRV4NKgo/58aJVjArtjDZRLQn
         PT4w==
X-Gm-Message-State: AFq9FYK+zOG5XsTOlXYFyRX7uLGv7wkG5GWtu5mGdcuhRzSgAo0/CT3t
	bTvw5s4DG6T0kLa5MIWCyg4AU6R5Lsf5TB36Mkbst2kKzFZQ7M8qH7F9
X-Gm-Gg: AYBFou34YeWcfl+wncbeZ7ScTunNUhUnNt5PiUlfvizbFF76atdE88iB6DEQ8DhhBOF
	8GhUfVOCKFi7MTIUn31HcgyofjR7O9uS0Q6YZQ1aJ4+S7f8TWWzUlk6Ayn+6p9gKIsCPsmzBXVD
	W8wwpJfz8q7zTzUoGjzXVF6aRoCJaDxG5OL1otaGetdhOw0+ywyfCDPRuVBt+w0U+gmO2muSQUl
	GtoOMmBr9FL+ttraRaK8eOFEZ0DjbCPL5pu1t0dZdVzu3zu5dtMYHFu66ywJS5q8UDYBKb/Tf//
	AYNj01/H7YAhbX/+G4e8HgxEMMyD7EgGqqu2yL+d6UW2x+RI9rwqKPpw14jZCr7vLE8PePuqvDm
	pZrrdlE4sx/IXi5NOTpTB4Ew8kVvqnFZK86732LEbLC7oQD+9QB5y3bEFmQWgdv+LddHHYWooR7
	rD8RQuhgx01UreOAv8J4W5Xu3ozqsj8ybM4CeGsIaC2yKJl68AdDL3GH9Gxxj/XK22vIAHq5ICL
	996PksYft/tVI1Eqsxj2+2x01ZT7haVbFsQhgl3MV6UredCpLVU219do9Mhd8vDzYAcz3QN5pXP
	sDk8QJqt8vn2mF6U1g==
X-Received: by 2002:a05:6808:1494:b0:4f8:4a95:9b3b with SMTP id 5614622812f47-55c003d7fdfmr6129548b6e.68.1793113653505;
        Tue, 27 Oct 2026 08:07:33 -0700 (PDT)
Received: from localhost.localdomain ([14.22.11.180])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-55c0424775dsm7448276b6e.5.2026.10.27.08.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 08:07:32 -0700 (PDT)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Henry Martin <bsdhenrymartin@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: bnx2i: fix OOB write in login/text response padding
Date: Tue, 27 Oct 2026 23:07:18 +0800
Message-ID: <20261027150718.949711-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.43.7
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

bnx2i_process_login_resp() and bnx2i_process_text_resp() take the
payload length straight from the CQE field (login->data_length /
text->data_length, u32) written back by the adapter, without any bounds
check:

	pld_len = login->data_length;
	bnx2i_conn->gen_pdu.resp_wr_ptr =
			bnx2i_conn->gen_pdu.resp_buf + pld_len;

	pad_len = 0;
	if (pld_len & 0x3)
		pad_len = 4 - (pld_len % 4);

	if (pad_len) {
		int i = 0;
		for (i = 0; i < pad_len; i++) {
			bnx2i_conn->gen_pdu.resp_wr_ptr[0] = 0;
			bnx2i_conn->gen_pdu.resp_wr_ptr++;
		}
	}

resp_buf is an 8192-byte DMA buffer (ISCSI_DEF_MAX_RECV_SEG_LEN).  A
CQE whose data_length exceeds the buffer makes resp_wr_ptr point past
its end, and the pad loop then writes 1-3 zero bytes out of bounds.
The data_length is also passed on to __iscsi_complete_pdu() as the
response buffer size, so a login response with a fabricated data_length
turns into an out-of-bounds read of the same buffer delivered to the
iscsi userspace daemon.  The login response path is reachable before
authentication.

Clamp the payload length to the response buffer size before computing
the write pointer and pad bytes, in both the login and text response
handlers.

This issue was discovered by Tencent CodeBuddy Security.

Fixes: cf4e6363859d ("[SCSI] bnx2i: Add bnx2i iSCSI driver.")
Cc: stable@vger.kernel.org
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index d24cc2c795d61..735cfdb28289b 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1466,6 +1466,8 @@ static int bnx2i_process_login_resp(struct iscsi_session *session,
 	resp_hdr->status_class = login->status_class;
 	resp_hdr->status_detail = login->status_detail;
 	pld_len = login->data_length;
+	if (pld_len > bnx2i_conn->gen_pdu.resp_buf_size)
+		pld_len = bnx2i_conn->gen_pdu.resp_buf_size;
 	bnx2i_conn->gen_pdu.resp_wr_ptr =
 					bnx2i_conn->gen_pdu.resp_buf + pld_len;
 
@@ -1528,6 +1530,8 @@ static int bnx2i_process_text_resp(struct iscsi_session *session,
 	resp_hdr->exp_cmdsn = cpu_to_be32(text->exp_cmd_sn);
 	resp_hdr->max_cmdsn = cpu_to_be32(text->max_cmd_sn);
 	pld_len = text->data_length;
+	if (pld_len > bnx2i_conn->gen_pdu.resp_buf_size)
+		pld_len = bnx2i_conn->gen_pdu.resp_buf_size;
 	bnx2i_conn->gen_pdu.resp_wr_ptr = bnx2i_conn->gen_pdu.resp_buf +
 					  pld_len;
 	pad_len = 0;
-- 
2.43.7
