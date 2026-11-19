Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795088954;
	b=R09Dh7vwkIuj5I8fDGpj1zjtWzIxGoc2jJYdmUzvTWnAWdDgdtYw3AsXhmcR70nTVAfe
	 Pcw/Nc+7/cq4nuK0M6s7mS7fp4ns9+CsYyqlPTjuSO7/UDsOSdtMf18f60i4SDqkdiTPu
	 TTHFdOUY3dJioS1ncblVU5Vsq759785+OP3wEyc+F6fYxOi0Lm9Bk8p8yLwYPmd9WT4jx
	 DHe81W37ILGWgq6c+csDYPIS2CNIu6YA2TyhbN5Tbug9zB9BWtfqe/+R68pSpnHxn9XO9
	 W19KcMVXN5Xhdum5o72mnnr9KtiLEFqZOrGT0r6DucxkSVQzLqYUBNmvhLR3cp+kXmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795088954;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=V8cFoJc9O1FyvpgAM1QXs9eTUtN4GtxZlx3q/AytIcU=;
	b=AP5EAQbJIo4+HrW9B5RfBNFOJsLXIVrEd6FNWKODZVpcY/tu6N2nVG1Lf2inQ4zpd64E
	 fpc4B/ntvPX9r+POxZPq0wvfiWggzlYZStWiYBcOrYvCzpaJ7YjRn3YjtoRDBfYG/sxKF
	 KNx/Sz/Kl0Nd41Nv96ucLnxcw96c8uwZKX+r/Ft0FnynNTjRnhfweba92HR9GFZ0E8Rp4
	 Ehgy/bkrIF2tuIAW5jaBU1SI0ma+ppkgGYgbkj1ELzwZ2tVNLj8cGrAZtyZ2Dv/Zf3P4e
	 /2XL2E1fTjCId5jbEDmI8EXvLNgiuY2ptxaHXMzbY5yMbuvqTT38daFHe1u4O9U7c2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=sOuJoHSQ;
	arc=none smtp.remote-ip=203.254.224.34
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE0D606A330
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 11:49:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABE0D606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=sOuJoHSQ
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261119114912epoutp04b633fb7ce923e8f00d4d2298618aeeb9~pb_QdnhLQ2601226012epoutp04n
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 11:49:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261119114912epoutp04b633fb7ce923e8f00d4d2298618aeeb9~pb_QdnhLQ2601226012epoutp04n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795088952;
	bh=V8cFoJc9O1FyvpgAM1QXs9eTUtN4GtxZlx3q/AytIcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOuJoHSQy/FsaBi+xAWsd54QFG26GgZTY+9c5oBs8MAlkJC0t81NteH1mx7h/9Lkh
	 +WNjTixwdHn4CtxwELVCGiLb2VZotNyjmKDq9FI8X7Yj79ujgRs2bWpIyeH1eeOwvF
	 pfchCEPJv/ZdB0JfU+eaIR62sIBHSVdpl/BEFW9Q=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20261119114911epcas5p42ed076ec2a5f3e7644a7527de73e9c76~pb_P3UFun1070610706epcas5p4K;
	Thu, 19 Nov 2026 11:49:11 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.95]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jVcFL4hd8z6B9m5; Thu, 19 Nov
	2026 11:49:10 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20261119095718epcas5p3d519849e454c3d68cf1b148356946fee~pacjjUVkQ0907609076epcas5p3F;
	Thu, 19 Nov 2026 09:57:18 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261119095715epsmtip12d8d40021c1e7d3c3a70db6b85d7b1c6~pacha4GTB2192721927epsmtip1S;
	Thu, 19 Nov 2026 09:57:15 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com, kbusch@kernel.org, hch@lst.de,
	sagi@grimberg.me, James.Bottomley@HansenPartnership.com, mkp@kernel.org,
	bernd@bsbernd.com, joannelkoong@gmail.com, miklos@szeredi.hu
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	fuse-devel@lists.linux.dev, joshi.k@samsung.com, anuj20.g@samsung.com
Subject: [PATCH v4 1/5] io_uring/rsrc: pass import flags to
 io_import_reg_buf()
Date: Thu, 19 Nov 2026 15:26:11 +0530
Message-Id: <20261119095615.1840522-2-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261119095615.1840522-1-anuj20.g@samsung.com>
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
X-CMS-MailID: 20261119095718epcas5p3d519849e454c3d68cf1b148356946fee
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261119095718epcas5p3d519849e454c3d68cf1b148356946fee
References: <20261119095615.1840522-1-anuj20.g@samsung.com>
	<CGME20261119095718epcas5p3d519849e454c3d68cf1b148356946fee@epcas5p3.samsung.com>

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
index 16b6bccf01f9..4382dcc98c06 100644
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
 		io_req_clear_flags(req, REQ_F_IMPORT_BUFFER);
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
index b51cdf8178fc..4875facd4a12 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1374,9 +1374,9 @@ inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
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
index edbfe8174f6c..4120873d6ed4 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -67,21 +67,14 @@ int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
 
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
index 3ecb842147a4..22b0a763febd 100644
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
index 1972d52bce9d..cdf499f2c343 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -277,7 +277,7 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 	if (WARN_ON_ONCE(!(ioucmd->flags & IORING_URING_CMD_FIXED)))
 		return -EINVAL;
 
-	return io_import_reg_buf(req, iter, ubuf, len, rw, issue_flags);
+	return io_import_reg_buf(req, iter, ubuf, len, rw, issue_flags, 0);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
-- 
2.25.1

