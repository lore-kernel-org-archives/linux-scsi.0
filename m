Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.231.201
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793155018;
	b=rkxSq5jpFxS3E6Vnz1WLFQwTxn7kR248adIxOnSOgcRSXxhAZPAekf4kBW7YVkzboQVo
	 gToLu1wMUDtevk1mQGla8llTIjawhnKJVH1cI9aljysELXE2t0cJptAMkBbLWfzoXVt18
	 akugU7oFQkYRS3Nrn7DqTCbgkOH7yTrQ92ru3jO8P2sbBVDoSyJSfZW3H4wzU5ANPkN8Z
	 efi5J5p2EXNV6yAGOKKMuak07l5DmcaROvflQMphfXmT6TITWGiV02lnSHu/+KE0LLfIo
	 ZRDEGHuPRD/ywWgOUdITE2we7qTf/c2wA2eGP/G/f97qmVyodtbUzyOtufDO9GWoRMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793155018;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=z0OSDcJuGoiVpog7HD3YMgsCa/cRBsgA/6QWbSk+j6E=;
	b=CJeNrNSj9bM8dgZKzj+qzeZrUEZlrMvJJ+HiFpxKSwbO+IwhDN+D4vZ1jZVAmVhvUjxi
	 kUfJIm07ErukqPzcdFcJLEEAcnmT+k58IA4bWfgRbqWhociQ5Ugo2iVVUj3mXX/GifrOg
	 LWKccK8N9F5EeBtnUiLheojDaQADXyFXWPRYlHWfiT7Wenhrfk3/BAshFNHDI66uJNp/b
	 xX06ERh/f3IMrofQd0gIxn2AGA/K1vB9TyCOcvYqsd86xvxmCH2kekQqKNrE+E9RZ5pGP
	 4OKPNVZUwTZ2NMgQEH8wVTiGM/xxMlyfm/zDBnxtyPfZjtv+D2w/BUYcLf80e3hA1Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nakEMdqa;
	arc=none smtp.remote-ip=74.125.231.201
Received: from mail-oi2-f9.google.com (mail-oi2-f9.google.com [74.125.231.201])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32518606A31E
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 02:36:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32518606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nakEMdqa
Received: by mail-oi2-f9.google.com with SMTP id 5614622812f47-4f61e12e8e0so106825b6e.0
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 19:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793155016; x=1793759816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=z0OSDcJuGoiVpog7HD3YMgsCa/cRBsgA/6QWbSk+j6E=;
        b=nakEMdqaUeTld5vVcr7Yy0fq4SnRBp79o6/Xs5DxMJlXF/Hk+AAJ2x3S+0QLpLRuP5
         3ngIGa5xKn/rVgxzv6SuxZ4SGtfbe2l+Kq03UlGeyS4pORiwiZyQgMOxJ+wYJzBiB6dQ
         7F3AJNeEN0je5DoOXrDZwoph0wkahsPf0K7WRyrsWyVih5rlWbeesi0t1E6IcBVlKeJi
         3f7j8+nt9U1YyJU/NoPJVIJ9IpKtyTVIiyFBbkUvSZhswSYbb9QEwvmEoGWCwVtn4DkB
         88Kl5kg2KQuH5SjHlztEFy31cjtlcxYbcA+FIIjVB+gUucXqSe80DVvQ4/TuFNl3AH9a
         aHHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793155016; x=1793759816;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z0OSDcJuGoiVpog7HD3YMgsCa/cRBsgA/6QWbSk+j6E=;
        b=GQ1PQuNhRO2+OktlspQVDEiaye/h8asIQbc9dCaQ1zEBjzI2M8xfMpYYGwqTM42fnq
         Hc4j8KntG8UjwQMLprWNrRHyYp3MGOkRKkLc5Pmyu3sHsXR7IVRY7wZeBaEDs1/L6O2v
         t4ManW1OmaYm/3g1nPOAgSAqezge8Ya/QS0rR9QyGO4PqjNRYgsRPo4QImdATDh28CRx
         asurn0YCDJs9ZDVeafenk4JjBD6gepmD9fgeJrS4GBa13DeR9eidjlbdbakFvAbGKQUb
         lxOc8CGhL1P8cmnfeI8gbIlsY2/740CtrzDwW/7V7oYy+FP3rkRHcYYp7Sjsrz/SGWQd
         57gg==
X-Gm-Message-State: AFq9FYLLUnwn+lNVSNvk3Ru7HyxvrmzT2V5cViXc6VERnKAdTpweYjwE
	8g52VKiAzij6SxN2CskBGR7+YH9ntmvM9qB2w1fJ5KRyyiJtT6YZbI9y
X-Gm-Gg: AYBFou36QPYDJUVmkEUPD1VUWywyj8JZIsW+369NOQCLe07TRzhEylCnopYYsOtNoW0
	EfA9mNrKP+YUyqEdnue4bs4n5pEU95D2P0hBykpkW0/U7MPrEh4c6RfZknKAcv2trPyMb/abIaJ
	tjL78WVfFSxuOwI+Zqzimmg5MXnug28azbdKMTlyizSFb+nGVe0yjk3PHkz8Vzxn724YS0yJP9Y
	PK1y83NbwrsIW7oRnhLKDwPtzHofGceGSBIyF4wfMonm3lCNzD7pqeIqJls5ICMlVgHRHz8lnYf
	QyntlDOeE5pKmCUMPo6gcIAp6q+x8otebHZXRkqr+3fSeVu/YqhkNFQJ03vOshXlreJHqJyMtsd
	GkEbuyWh7zfHawXncXkQLSrY5DBc/z8b7tuhgclnOWhSvao9VfWMXLwnL9Wjgqyw5H+lSESPZty
	C56RY/LKxEyKhDTYeQzv0B7fgyxMFU1TD2LX9EB8q9O65swGTKCbisu5gT+P3GkyucyQjisij3l
	YBYLfCGEZu0MtdOlUREgqgD+s1J8bdl7sya4wVFhp8b+8ni70VBGq5P1fPH0FhcKKPjrGZgJDHK
	oien0hpmIOzpckJxD7mwun8NBHtgL8CsmgmWgHcsjlFgtqDWa/Kw4qGqhI4rqh9RHS8K2OfrRlD
	Eh7HScN9KBMYmiAU=
X-Received: by 2002:a05:6870:8a09:b0:48f:e25e:e202 with SMTP id 586e51a60fabf-4a8bb5e13e9mr920244fac.61.1793155016073;
        Tue, 27 Oct 2026 19:36:56 -0700 (PDT)
Received: from localhost.localdomain ([14.116.239.38])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a8b785d108sm1478108fac.9.2026.10.27.19.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 19:36:54 -0700 (PDT)
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
Subject: [PATCH v2] scsi: qedi: fix OOB read in login/text response completion
Date: Wed, 28 Oct 2026 10:36:46 +0800
Message-ID: <20261028023646.2151626-1-bsdhenrymartin@gmail.com>
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
back by the adapter.  The same raw value feeds the PDU header's
dlength field and the amount of payload buffered, and neither is
bounded:

    hton24(resp_hdr_ptr->dlength, <raw 24-bit value>);
    ...
    pld_len = <raw 24-bit value>;
    qedi_conn->gen_pdu.resp_wr_ptr = qedi_conn->gen_pdu.resp_buf + pld_len;

resp_buf is an 8192-byte buffer (qedi_iscsi.c).  A CQE whose data
segment length exceeds the buffer makes resp_wr_ptr point past its end:
the data segment is delivered to __iscsi_complete_pdu() with a
fabricated length, an out-of-bounds read of the buffer delivered to the
iscsi userspace daemon over the iscsi_recv_pdu netlink unicast.

Clamp the payload length to the response buffer size once, before the
header is populated, and use the clamped value for both dlength and the
buffer pointer, so the header always matches the bytes actually
delivered.

This issue was discovered by Tencent CodeBuddy Security.

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Cc: stable@vger.kernel.org
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---

v2: Clamp before populating resp_hdr_ptr->dlength and feed the clamped
    value to hton24(), so the embedded header does not advertise more
    payload than iscsi_recv_pdu() copies after the buffer bound is
    enforced (sashiko review).

---
 drivers/scsi/qedi/qedi_fw.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 854efa4f61d87..ddab627826180 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -102,9 +102,11 @@ static void qedi_process_text_resp(struct qedi_ctx *qedi,
 	resp_hdr_ptr->flags = cqe_text_response->flags;
 	resp_hdr_ptr->hlength = 0;
 
-	hton24(resp_hdr_ptr->dlength,
-	       (cqe_text_response->hdr_second_dword &
-		ISCSI_TEXT_RESPONSE_HDR_DATA_SEG_LEN_MASK));
+	pld_len = cqe_text_response->hdr_second_dword &
+		  ISCSI_TEXT_RESPONSE_HDR_DATA_SEG_LEN_MASK;
+	if (pld_len > qedi_conn->gen_pdu.resp_buf_size)
+		pld_len = qedi_conn->gen_pdu.resp_buf_size;
+	hton24(resp_hdr_ptr->dlength, pld_len);
 
 	resp_hdr_ptr->itt = build_itt(cqe->cqe_solicited.itid,
 				      conn->session->age);
@@ -113,8 +115,6 @@ static void qedi_process_text_resp(struct qedi_ctx *qedi,
 	resp_hdr_ptr->exp_cmdsn = cpu_to_be32(cqe_text_response->exp_cmd_sn);
 	resp_hdr_ptr->max_cmdsn = cpu_to_be32(cqe_text_response->max_cmd_sn);
 
-	pld_len = cqe_text_response->hdr_second_dword &
-		  ISCSI_TEXT_RESPONSE_HDR_DATA_SEG_LEN_MASK;
 	qedi_conn->gen_pdu.resp_wr_ptr = qedi_conn->gen_pdu.resp_buf + pld_len;
 
 	memset(task_ctx, '\0', sizeof(*task_ctx));
@@ -279,9 +279,11 @@ static void qedi_process_login_resp(struct qedi_ctx *qedi,
 	resp_hdr_ptr->flags = cqe_login_response->flags_attr;
 	resp_hdr_ptr->hlength = 0;
 
-	hton24(resp_hdr_ptr->dlength,
-	       (cqe_login_response->hdr_second_dword &
-		ISCSI_LOGIN_RESPONSE_HDR_DATA_SEG_LEN_MASK));
+	pld_len = cqe_login_response->hdr_second_dword &
+		  ISCSI_LOGIN_RESPONSE_HDR_DATA_SEG_LEN_MASK;
+	if (pld_len > qedi_conn->gen_pdu.resp_buf_size)
+		pld_len = qedi_conn->gen_pdu.resp_buf_size;
+	hton24(resp_hdr_ptr->dlength, pld_len);
 	resp_hdr_ptr->itt = build_itt(cqe->cqe_solicited.itid,
 				      conn->session->age);
 	resp_hdr_ptr->tsih = cqe_login_response->tsih;
@@ -290,8 +292,6 @@ static void qedi_process_login_resp(struct qedi_ctx *qedi,
 	resp_hdr_ptr->max_cmdsn = cpu_to_be32(cqe_login_response->max_cmd_sn);
 	resp_hdr_ptr->status_class = cqe_login_response->status_class;
 	resp_hdr_ptr->status_detail = cqe_login_response->status_detail;
-	pld_len = cqe_login_response->hdr_second_dword &
-		  ISCSI_LOGIN_RESPONSE_HDR_DATA_SEG_LEN_MASK;
 	qedi_conn->gen_pdu.resp_wr_ptr = qedi_conn->gen_pdu.resp_buf + pld_len;
 
 	spin_lock(&qedi_conn->list_lock);
-- 
2.43.7
