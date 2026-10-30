Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793324759;
	b=pof+mkqvLc47SSitlu+r0aZdaTfRyRqzSwBlZewl5JY3LerShXh9dVJrwOrQHQPzuylr
	 Xb7PGYuwU6NbpeZYY0Qr6MX+39UMv2f+xSoO1zz83nkQ7XiU/e6Z7WHR7xFTo2DxQEFkO
	 bzOIqeNIhQyiUCZPwTWynOIm5RH3Mih73n+L01iYj2ZQaSCrbmLtF2btIYDdJT2S/Bl0K
	 LhGjOngtGHSL+0UDHJizahOiELNHWtMEHkox35VGkoskSmYTmCqHFt6nnCyJNvr+gsjks
	 tKEoeU5fqy1iGlqck1SrDiKZ/GE0VhiO6jqfbrN8SAXkNTIyr4k10mxpLOfpvqZHEoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793324759;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ODvSAgyV/h/yeJCArNYdVO3F0icLZBSUlmTqdaSk0qI=;
	b=3HsQt2BRQ9+BA42+ZVQ+QQ7Ztart8ex/uCffmk8tqo5D/ROZYrCyKnK9X3y2LfMRMlpA
	 XlfhN3fS0yDabA2PQ8E3PX2sbtHZPrwrORsBoTLfq+TxWlaFcE8f7JfbZCADbgHPc9f+L
	 mMak2O8klV4daGitZkTM9DXTXnIIikMlIjG8YMscytbqwocktPZqb+q2f1ojMpqWW/sQh
	 DKSdrojC2ulKvTp4xMeRpBZ67v6oyObRT/AxScVLXBLC+RbgYwVYP6RM347Gppgn90E9k
	 b83amjxWVM4Dy1KQCvLsTqIBiWHF0RfqIbyDnCIvzuC81KyCSnpD5YUVvKGC2POkWaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="ERqyOc/a";
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B6A606A31E
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 01:45:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32B6A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ERqyOc/a
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-35c76e9614aso409577eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 18:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793324758; x=1793929558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ODvSAgyV/h/yeJCArNYdVO3F0icLZBSUlmTqdaSk0qI=;
        b=ERqyOc/arjTQd+ob0SEMV+H7q4Sy3FNhJRpQZPrMFbzh/E7RaYSsx85yXrbbSpeTG8
         G8nhEDEu/PHW9IE3C06owdQOgNh23BEWdm8ZkeVeKfMj7eAtN2cC1+ws5FKJX/cSVmH3
         xGaFOU8syrrCQgUzYsRapYSJB0Jr8cpHtywlildS/bewHJ/c5VmiarVfQYw4azvQyHgO
         k0v3/8cg7XM8yqd2KEieXWELvfTW3h7yWSPvJj3hrSX7jfRXJdb9cgCFmDiTTfrMBTD7
         4TYzVAxMBqpPXfu7FF8I2Y74oDsbHfQ+860jLEIesNsKe6qiDsAAE2IfU8VwziBF005P
         U4gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793324758; x=1793929558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ODvSAgyV/h/yeJCArNYdVO3F0icLZBSUlmTqdaSk0qI=;
        b=qd5nlbsXJ0kDwAJrYZjY86LiOl/LXGsDIGog2IyGyDY0d686YaEZtn86btlUfkM0Ue
         PL+5gWg40KYqmJ5AwF0h58RKPN0UHcfNnIqe6aCFais5ZGkolJ+LM9kG013KitH1zWFG
         fPRKNX4sSGxvEatYft+uKoiKjWsDDnDsy6oN+6SzqOMxhVdb7FzY0JiSK8wIZF2vWSWm
         boOi+axkGWWn1T+ulCLdAqF2GIee8peD/9xApKa6vA9LOVDW1kbXGP6GvW3z/HOVtB23
         JVv71q2ZcvmrspKKdcDdu7MwEUtfqdDdvIU8jt+LUJwBf3ExbYKk8zOuklFznrgXI+f8
         4Oyw==
X-Forwarded-Encrypted: i=1; AKwUvBw8U2iTswcWMx+HFOVX8PCIwr1BMxs+Ye9EMyWg5BoYYiAA7llrLm87+T0b5XeIsg2k0w/riud3Jq33@vger.kernel.org
X-Gm-Message-State: AFq9FYJ5+qvjyR1L31tV219xkWy3Ssnqfkl+Kg+4rEvlW79if5ujOAM/
	tXJFNWM4XzBXUmHUdzTuipJYt6KojmC9BEoRV2jqGgf/x10yPBey70NcPSMlwpg=
X-Gm-Gg: AYBFou2Z0to8Em+viEBByTYCBNMjKAWA1nVfLs6TeCYr67YN7RdzngZjMlVimdU2Lxl
	XxorfsmdKQsgSq7wvnO1DXizQbaC+le+L7oooVZ9bqCnO3D3sm02hvXe4fnDPOx1cw1K6t4ZtEc
	uY0lN+tH9xBXvJ1Gw6eTLTN03wvi/fU9RsMOA2Xhi+6JMC/XPIpHndF5QnFtPRmOEusLNi+usx4
	LTx2jQ9H236HqI1KrkneFa6+kxmJFTpDMp7z2CvUz0xVWXD6BpPslO2DMHW6PBGLa1AE2Xo+x4P
	PlIuEYvpJtKmxQKj9WdsI2CC3naQYBTjeJ82M3PIL8W1XgRjlJ98p7WZNSWRkZa4LietcPmDA3s
	VfJTlMPBf9AMqHpXlRSde3TgFtx0hisy4pN83+yWfvsd9rk8o5G5WWyKZ3WZGMOYcnnOlI5pXQy
	t5b/JbnyACU8aM1idTO6s5RNfqBcMIR+exMXwv+Iz5TQplU53XOE6kc+4WR+NiQDJ3mHKMmc5G6
	0OXHs3fOsZq/Xu2Pt1axzqNpGtWGxavl32lf0VNAtX5GoIiqwHmOjuHuBTYPZMbF3c9M9E+H3A1
	DDJkVoHlLpM6AjJfLGw5HF6nMb9aAfUGp2/M+xZWQqucG5OjWrk9FBTLzb8coczvBuLBp1hABn9
	7/QbF7pHZPBPv9RE/
X-Received: by 2002:a05:693c:639c:10b0:36a:1f8:a56e with SMTP id 5a478bee46e88-36a423bb931mr1471206eec.23.1793324757946;
        Thu, 29 Oct 2026 18:45:57 -0700 (PDT)
Received: from anuj-MacBookPro.. ([2406:7400:63:75fd:f9a4:4062:7980:1324])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428fa380sm2209020eec.12.2026.10.29.18.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 18:45:57 -0700 (PDT)
From: Anuj Gupta <anuj1072538@gmail.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	bernd@bsbernd.com,
	joannelkoong@gmail.com,
	miklos@szeredi.hu
Cc: io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	joshi.k@samsung.com,
	anuj20.g@samsung.com
Subject: [PATCH v3 1/5] io_uring/rsrc: pass import flags to io_import_reg_buf()
Date: Fri, 30 Oct 2026 07:15:36 +0530
Message-ID: <20261030014540.3065403-2-anuj1072538@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261030014540.3065403-1-anuj1072538@gmail.com>
References: <20261030014540.3065403-1-anuj1072538@gmail.com>
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

From: Anuj Gupta <anuj20.g@samsung.com>

Give io_import_reg_buf() the import flags argument and drop the
__io_import_reg_buf() variant, which only existed to pass them.

No functional change.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c       |  6 +++---
 io_uring/rsrc.c      |  6 +++---
 io_uring/rsrc.h      | 13 +++----------
 io_uring/rw.c        |  5 +++--
 io_uring/uring_cmd.c |  2 +-
 5 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 533afd335627..5d0f7c0a1825 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -663,7 +663,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (req->flags & REQ_F_IMPORT_BUFFER) {
 		ret = io_import_reg_buf(req, &kmsg->msg.msg_iter,
 					(u64)(uintptr_t)sr->buf, sr->len,
-					ITER_SOURCE, issue_flags);
+					ITER_SOURCE, issue_flags, 0);
 		if (unlikely(ret))
 			return ret;
 		req->flags &= ~REQ_F_IMPORT_BUFFER;
@@ -1242,7 +1242,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (req->flags & REQ_F_IMPORT_BUFFER) {
 		ret = io_import_reg_buf(req, &kmsg->msg.msg_iter,
 					(u64)(uintptr_t)sr->buf, sr->len,
-					ITER_DEST, issue_flags);
+					ITER_DEST, issue_flags, 0);
 		if (unlikely(ret)) {
 			kmsg->msg.msg_inq = -1;
 			sel.buf_list = NULL;
@@ -1536,7 +1536,7 @@ static int io_send_zc_import(struct io_kiocb *req,
 	if (!(sr->flags & IORING_SEND_VECTORIZED)) {
 		ret = io_import_reg_buf(notif, &kmsg->msg.msg_iter,
 					(u64)(uintptr_t)sr->buf, sr->len,
-					ITER_SOURCE, issue_flags);
+					ITER_SOURCE, issue_flags, 0);
 	} else {
 		unsigned uvec_segs = kmsg->msg.msg_iter.nr_segs;
 
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index e0345c3e764e..e9e4221ef86f 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1366,9 +1366,9 @@ inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 	return NULL;
 }
 
-int __io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
-			u64 buf_addr, size_t len, int ddir,
-			unsigned issue_flags, unsigned import_flags)
+int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+		      u64 buf_addr, size_t len, int ddir,
+		      unsigned issue_flags, unsigned import_flags)
 {
 	struct io_rsrc_node *node;
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 418d236152ff..6226c7862d4e 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -66,21 +66,14 @@ int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
 
 struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 				      unsigned issue_flags);
-int __io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
-			u64 buf_addr, size_t len, int ddir,
-			unsigned issue_flags, unsigned import_flags);
+int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+		      u64 buf_addr, size_t len, int ddir,
+		      unsigned issue_flags, unsigned import_flags);
 int __io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
 			unsigned nr_iovs, unsigned issue_flags,
 			unsigned import_flags);
 
-static inline int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
-				    u64 buf_addr, size_t len, int ddir,
-				    unsigned issue_flags)
-{
-	return __io_import_reg_buf(req, iter, buf_addr, len, ddir, issue_flags, 0);
-}
-
 static inline int io_import_reg_vec(int ddir, struct iov_iter *iter,
 				    struct io_kiocb *req, struct iou_vec *vec,
 				    unsigned nr_iovs, unsigned issue_flags)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 3a8559ff4dc6..327215e0f8b2 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -360,8 +360,9 @@ static int io_init_rw_fixed(struct io_kiocb *req, unsigned int issue_flags,
 	int ret;
 
 	if (!io->bytes_done) {
-		ret = __io_import_reg_buf(req, &io->iter, rw->addr, rw->len, ddir,
-					  issue_flags, IO_REGBUF_IMPORT_ALLOW_DMABUF);
+		ret = io_import_reg_buf(req, &io->iter, rw->addr, rw->len, ddir,
+					issue_flags,
+					IO_REGBUF_IMPORT_ALLOW_DMABUF);
 		if (ret)
 			return ret;
 		iov_iter_save_state(&io->iter, &io->iter_state);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index b5486b56ee0c..4dac3ba162ae 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -279,7 +279,7 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 	if (WARN_ON_ONCE(!(ioucmd->flags & IORING_URING_CMD_FIXED)))
 		return -EINVAL;
 
-	return io_import_reg_buf(req, iter, ubuf, len, rw, issue_flags);
+	return io_import_reg_buf(req, iter, ubuf, len, rw, issue_flags, 0);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
-- 
2.43.0

