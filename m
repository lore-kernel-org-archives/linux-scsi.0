Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.231.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793113682;
	b=fEMvTeu3uHrkwhvgEpxC0eLD8S3kIX65e2u4/tYmJWOvijgjqmTenjxohUV8/RGhVe2U
	 VY1pFTZVN1yMG/s3XuyP0I3EwA8EwrahlMVrSi2PBmJOfHiuVGTfAAvc7rhLdvOWhpW75
	 ClwiDDfkm+UB/8QUd4KA3S2nLExSGDiT91pf4evqSij8Bxyd3653eu6lGcHkNnd7c/c8N
	 CMVLkxpncYehSbUhi+GE+in6YDnS/8tH4/E0e2/wmZuSOUPuaAfUe4ng7RR/xnyojzRP1
	 0ed4VCMticyG7x4b1cfR8Njzqcy22l1R3f3Ec9ipNHo2uNCM1byGAvLj+5IsOjMyChw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793113682;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=1KzTeYbxSizdExmDLUTY3oH0bwSQMee2NZJRt9PMZ0c=;
	b=3m8ugfGOoDTkI0hdw5CyKv9iBigI0Wo2BSJgf8M38Jfz6Ux7vSfOTBaBHy1XnHxXj17N
	 /Ue2KYM1tVKXF1Y/petkLhQSXwM8ssqMyeERaIZzeMy3ZIfsknejyaqarGEX/1qWbGclV
	 Q2uk3e9mPm5JaPqtM0Vs8UdWEZuMXP3nKhPwqtjfx+haGDDib9LaLOeOJ2zWlZIaaaFhq
	 8amceDSncJYvx/f8bGtmjlb5vVNe4BJvWMGPvjGRArpLQ8h/WQEtoByNBt93IypU3vhDE
	 pb4XdO0ix8FVr1Lj507xHfhsF0JfbnX7SHb6tyPBQscFaK0n11YTv9orCzCuR58849A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0nJKW8S6;
	arc=none smtp.remote-ip=74.125.231.131
Received: from mail-oo2-f3.google.com (mail-oo2-f3.google.com [74.125.231.131])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA43B606A335
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 15:08:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA43B606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0nJKW8S6
Received: by mail-oo2-f3.google.com with SMTP id 46e09a7af769-8459f7bc7c0so2212379a34.1
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 08:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793113681; x=1793718481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1KzTeYbxSizdExmDLUTY3oH0bwSQMee2NZJRt9PMZ0c=;
        b=0nJKW8S6y7i+XLa6TPGMvU6QxLKy9bw6wEcfFTBpFlLA8HJkuCw+P3q11A9CRHn0JO
         LRbj2FMNQ3jCfMrsnhP6CnZnf7pkC5IRUyU7LxQXBMyRHw4tNedJGfnZeO3qwSg2pym3
         IypH6124GeziLwLLdO1Dno+EQszr/ENlTzJPrhtRWuaOUa/75B6x0xk8DPmcc+wfkK64
         poeK4EsUjAQg4AcVKN5wGUmmEcEsks+t9+dKX5tFophAUiWQAxydvsbPBaV5DIy4T1Mm
         kEl/EesO2/+KU5huhumAHWXlclun2AU3sw4nAcuW9ZnII415N6+rRa8jcnV5OU3MsApr
         aiyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793113681; x=1793718481;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1KzTeYbxSizdExmDLUTY3oH0bwSQMee2NZJRt9PMZ0c=;
        b=xZPik+krJ/AbOBRTSrIr2YhYrYvu5xf/YyT+df5LZZRvkX3PH3Ncwh0nFS6+DMAcSF
         cvw2IuIXAWgOtEe+MiVV2knzPZB78fo1uVV8B7Vr5W15je64asychxT5+4mpHQgC6CQE
         5NCxqivzFYHnz9k6HoWBNFmcMfKXV2anyGGncB5LbPED9f4dXYlq0Am4G2rMupAr30O0
         oIl7dM680BN+7WPyrvPwa15G3czhxGKat1r/56HYimBSoCZV5twHH/BPW/RE6jP8La91
         9tHzMRjQ2OS/BfpQni1XhAz7FsP7ar+cGUOGACsJT0fJ5D3kI6JJNNiyWwUxMARAAXGg
         7ntQ==
X-Gm-Message-State: AFq9FYIBGx8hC/H8b5voi/c7GmwIj1yrvAgHpjzv24QiuLnG3vrJhVo4
	05ogd8oxrD+j7VG3C7kZ/aj+HIfvV90aKiCwkFazPuxA2+gCGfbPaPX9
X-Gm-Gg: AYBFou3Mdec8MRQWTO6qwEpGxzmOp0Y7PIol9RrIbaXvQKy9bkO1e76PjGqF+dQaTit
	uuWmICBZvZ6iblh65e8xDp2/lJQNnOOEOo43/My4saPk4gtIvdDAZaWSaAzcWRqB87c4ykz3JWU
	+IHsN75/PGGciHAT4/npiB1cibO4z3BOF+RwfJVqSFwaGFqAKaUMs2om65q+Q/N4Dcv2FzA3DqI
	FK0L8hxeXPByck/Py+2ku0wojpO79CI2KCGNqQ+AgYwK+tUWu7c1jdBtKD/OjIoUmBqOie3DDBd
	yumUBrJjlkaJU2hYtSk+uwwhDttBHzDR9azIDW72Ovsw9r54aIqXbu7XtUrg8QnEKI8aLy5H6uV
	sSt1X+tlMAc0UR8dcfcxaK1yFnmuFOKqes1LXLdY7Lex7xVNHM7ToePWs9DhrYNbtC/sNzXM9BB
	G+GVjgW91pxmi/oSiK3ksoTxi1x1vngioUHU+DQ7J45CRtUdVFYI3XKS+8fIBxWRq9Dq0PQ83fJ
	vBRLLVcGQY6uAYUnF5bf9aLV/nR8jEmvEPyDjt3ZKvhitzIrwxiz2iDW4aTRYs/1q4Fg6LILcsI
	iVRds91Yuxm+72+9P0zwyGO7rUqqzaTOT91nrNoA
X-Received: by 2002:a05:6830:927:b0:7f8:4ebe:2854 with SMTP id 46e09a7af769-850fb0769c4mr8385648a34.4.1793113680898;
        Tue, 27 Oct 2026 08:08:00 -0700 (PDT)
Received: from localhost.localdomain ([14.116.239.36])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-850fa99ccfbsm11397711a34.5.2026.10.27.08.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 08:08:00 -0700 (PDT)
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
Subject: [PATCH] scsi: qedi: fix OOB read in login/text response completion
Date: Tue, 27 Oct 2026 23:07:52 +0800
Message-ID: <20261027150752.951217-1-bsdhenrymartin@gmail.com>
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

qedi_process_text_resp() and qedi_process_login_resp() take the payload
length straight from the CQE field (hdr_second_dword &
ISCSI_{LOGIN,TEXT}_RESPONSE_HDR_DATA_SEG_LEN_MASK, 24 bits) written
back by the adapter, without any bounds check:

	pld_len = cqe_text_response->hdr_second_dword &
		  ISCSI_TEXT_RESPONSE_HDR_DATA_SEG_LEN_MASK;
	qedi_conn->gen_pdu.resp_wr_ptr = qedi_conn->gen_pdu.resp_buf + pld_len;
	...
	__iscsi_complete_pdu(conn, ..., qedi_conn->gen_pdu.resp_buf,
			     (qedi_conn->gen_pdu.resp_wr_ptr -
			      qedi_conn->gen_pdu.resp_buf));

resp_buf is an 8192-byte buffer (qedi_iscsi.c).  A CQE whose data
segment length exceeds the buffer makes resp_wr_ptr point past its end,
and the fabricated length is then passed to __iscsi_complete_pdu() as
the response buffer size: an out-of-bounds read of the buffer (and
beyond) delivered to the iscsi userspace daemon over the iscsi_recv_pdu
netlink unicast.

Clamp the payload length to the response buffer size before computing
the write pointer, in both the login and text response handlers.

This issue was discovered by Tencent CodeBuddy Security.

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Cc: stable@vger.kernel.org
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
 drivers/scsi/qedi/qedi_fw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 854efa4f61d87..24724fcba6571 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -115,6 +115,8 @@ static void qedi_process_text_resp(struct qedi_ctx *qedi,
 
 	pld_len = cqe_text_response->hdr_second_dword &
 		  ISCSI_TEXT_RESPONSE_HDR_DATA_SEG_LEN_MASK;
+	if (pld_len > qedi_conn->gen_pdu.resp_buf_size)
+		pld_len = qedi_conn->gen_pdu.resp_buf_size;
 	qedi_conn->gen_pdu.resp_wr_ptr = qedi_conn->gen_pdu.resp_buf + pld_len;
 
 	memset(task_ctx, '\0', sizeof(*task_ctx));
@@ -292,6 +294,8 @@ static void qedi_process_login_resp(struct qedi_ctx *qedi,
 	resp_hdr_ptr->status_detail = cqe_login_response->status_detail;
 	pld_len = cqe_login_response->hdr_second_dword &
 		  ISCSI_LOGIN_RESPONSE_HDR_DATA_SEG_LEN_MASK;
+	if (pld_len > qedi_conn->gen_pdu.resp_buf_size)
+		pld_len = qedi_conn->gen_pdu.resp_buf_size;
 	qedi_conn->gen_pdu.resp_wr_ptr = qedi_conn->gen_pdu.resp_buf + pld_len;
 
 	spin_lock(&qedi_conn->list_lock);
-- 
2.43.7
