Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793324772;
	b=VqEKmSGQCHxWUjye7ZOwC6oVoUIyPPVSIVMzZsoL8O0r7BP7KXX2I+ns3fdt1UOQsOTJ
	 SN7M45qcrer7MJ4Kkt2Chsdi/wdv4ZkioGfxEEsx/RCDvWsJTS46zSpRHFZFPMwvPCrch
	 +t5K+n57QwzgesJKLAstXLtPyF2cPtSLNv1tGoc4u4wtvrCK9yLppusySTNLNafhzDmdd
	 e+3+3U/qNLsTqZFHiFL5gGviMDrzkhQf/aGLlZAPt5npe8iUYW2xjKEQrtESyjI1dX7Jv
	 lv2Um0ZBj2470EuwvyzOfNMkSGEs3duLewMe6mUUMkZ/xUc8tIGg3GwGzoRsKBHZt5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793324772;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lCyrcMpBQiz0VtWC05/bFg8KKUJTwPO8EsDhKRgsAck=;
	b=jLdbeqbPi2QMY8vFQKUe6IrMkOBqVFqI+nU4ytL/ppC+8yIUpsFX188nDD+4Id6InKqg
	 rGhxYS1iz/6Jv58U16anpWs8i65E0l3cAf9YF0vtyJY3c389mecu49jxlURVXePnhh+kt
	 mgKQlurYr3UhnDFdh2WBAT9bV69FwC2qW+M8btj5g+5STNo8SNzo0e7grWtFhYEvUgD65
	 1Q0WgJwzK3UiOt40wwUx6WqQRKjHiHODy8sXdRwTfTGC9lobYc8KlophsnMLHhOWs8mPg
	 iHC3uvmplBYqWL0b37N17rxklJZnXpF+zlIGatrkxSLpBZBLGPsFrmyXslvfhEmsA/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="mP1cJL/M";
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C103606A321
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 01:46:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C103606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mP1cJL/M
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-35cd4e8bdbdso352743eec.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 18:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793324771; x=1793929571; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lCyrcMpBQiz0VtWC05/bFg8KKUJTwPO8EsDhKRgsAck=;
        b=mP1cJL/MpFzT6P3oH6WSjjB1MEHetUrgSXupQ7NyBzECGts+xtuiX3NQv+D7joCawY
         44Dmki5CtdoN29CZkIe9KQKJGnN2B4xWMlxBhENhWOeDoKNpuUOyVDT9lMIml3DcG9RS
         Jn6miet0U2fXe16f3NBzAw3dHSo8SMKHrNSqxSNMNea11SXGuik+yVhPxHN0Gyd+nHaC
         vqvLDU0LyGz9xjIrW7SU3hFy5ntKvRzbkpX/O8FHF6j0z362uQrwQzghqUgfhhX3eeaw
         v5z9c92JOVCTREB4HJBKiGpctKDYzFT4llI0JTN6HpIA2ECzBlU4lhEusNzAc9N9SEQc
         zduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793324771; x=1793929571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lCyrcMpBQiz0VtWC05/bFg8KKUJTwPO8EsDhKRgsAck=;
        b=hnGW2Ayp4A2VrfNEOLZzkf01cGzNm2zloSDIqxf+/f+sRstAw5mo6rN5ud0RKyOPeG
         aTcx2aTUo76Y32/BcHIa7fZ/eTGHcxMbsNnXuTCOGqppOiFJxFV1I6YJ+Tsd+gYAaP0+
         DrHdCHel2FFTqNGYAOsKd0wX/KzgWR5uYAdTLW/qRBWiVZX2edqz9BFXlokwVyo2oiGJ
         cm2LjrhdVivT9+WE/udBusHM7Lzt1Lqsgqhr4knH7uLyIlSxYb9vWod8lWPfJGybaMPQ
         BpVB79zcSgHJDaEkY37m9U/UIxmiZGFszT1Jg8gkWYgbHy7ajXLsiQboJf65Mlj2xunu
         HMZg==
X-Forwarded-Encrypted: i=1; AKwUvByAbBBW/nRi+h3XIPCA08fHFpc7hKg5UsBy4KmFgbqabu7nsPWp95rwjNPsLfU89KwHzYz6qAwczuwe@vger.kernel.org
X-Gm-Message-State: AFq9FYId/2jUtGm1Wv/GPzWaUqJzgZTvgylZBV2scxiFvM3hpyQvg3PZ
	eye/H1I1e6AE3rod8SubVR4jMwO79O2sUyOpfJuq+kXp23VbTKPKl1M=
X-Gm-Gg: AYBFou2bstSTi9EvGxBojHmzUubKo6KUqpMBjZZg6Hp2mCps5DG+iNKxYT/7MR1bgBq
	rmOlR1BOLXS0Rs/FgYjS94zdN6kgleMW22pfzz4ZzbbMta/BzOu/PpHz/A33e4MPbz06vMVaW2+
	RuS9KcYb6B+GsdLsqQssYHAztH3Nz1uYjwFLWx39qRNh4tU2/7POw5j8Q2exOhg0349n1JaZz18
	Esdv/cIIX3ruMMEj6tUGJ0nRGydEhNJfk+uJX9ORaw5vuwXgw/p16+yzQLlJhBS0qrrn8t/i1Q7
	vU9bOsP0Go6PBm3xYMepkUNOFscWU3S23lqrXvqBdvDj0atnHPwLPmKfZh2OuLFv6J5REBFKvZW
	VSmPeES5OEXXKaAP3ALUF/ixry5ghJbEFBMkfU9O9rxKtUjRnVvCwCR2sHdO9UNLB5aBqyo/pPL
	Ewnt+5TULXEz8mEldxDnv7ceb8vn4By06+LZlr9J865VLC0cOu6Vf000/g2pNWbNuxFlMjItfCP
	gcx/Jd9PlutvJwwSzyi2tJ5xWEqIqLgJh//adks7y6Xw/lWcW1cuwUWMSf6Aqw66BkfL77QNNXw
	ztdsQO7zWhv7Dv1g7So6v+bsbIK98zelHKD7640uNZyIENEXRB0HENuw2+8ZD/GeHRBTXbaSeJ0
	6qHlJ1Bf/qJUgsDw93A==
X-Received: by 2002:a05:701b:4189:20b0:182:6c6c:d876 with SMTP id a92af1059eb24-1ac5cb1a331mr1177745c88.8.1793324770340;
        Thu, 29 Oct 2026 18:46:10 -0700 (PDT)
Received: from anuj-MacBookPro.. ([2406:7400:63:75fd:f9a4:4062:7980:1324])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428fa380sm2209020eec.12.2026.10.29.18.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 18:46:09 -0700 (PDT)
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
Subject: [PATCH v3 3/5] io_uring/uring_cmd: support dma-buf registered buffers
Date: Fri, 30 Oct 2026 07:15:38 +0530
Message-ID: <20261030014540.3065403-4-anuj1072538@gmail.com>
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

Let callers of io_uring_cmd_import_fixed() opt in to dma-buf registered
buffers with IO_URING_CMD_IMPORT_DMABUF, and attach the current map on
import.

The map has to be dropped at hardware completion rather than from
task_work. Add io_uring_cmd_hw_done() for drivers to call from end_io,
which drops the map and queues task_work, and warn if task_work is
queued with a map still attached.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring/cmd.h |  9 +++++++++
 io_uring/uring_cmd.c         | 28 ++++++++++++++++++++++++++--
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 23fb66a1e2c1..d4e17c2f59fd 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -12,6 +12,9 @@
 /* io_uring_cmd is being issued again */
 #define IORING_URING_CMD_REISSUE	(1U << 31)
 
+/* io_uring_cmd_import_fixed() flags */
+#define IO_URING_CMD_IMPORT_DMABUF	(1U << 0)
+
 struct io_uring_cmd {
 	struct file	*file;
 	const struct io_uring_sqe *sqe;
@@ -86,6 +89,8 @@ void __io_uring_cmd_done(struct io_uring_cmd *, unsigned issue_flags);
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 			    io_req_tw_func_t task_work_cb,
 			    unsigned flags);
+void io_uring_cmd_hw_done(struct io_uring_cmd *ioucmd,
+			  io_req_tw_func_t task_work_cb);
 
 /*
  * Note: the caller should never hard code @issue_flags and only use the
@@ -145,6 +150,10 @@ static inline void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 			    io_req_tw_func_t task_work_cb, unsigned flags)
 {
 }
+static inline void io_uring_cmd_hw_done(struct io_uring_cmd *ioucmd,
+					io_req_tw_func_t task_work_cb)
+{
+}
 static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index d77a94d19cb5..446bc8a363e6 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -10,6 +10,7 @@
 
 #include "io_uring.h"
 #include "alloc_cache.h"
+#include "dma-buf.h"
 #include "rsrc.h"
 #include "kbuf.h"
 #include "uring_cmd.h"
@@ -28,6 +29,7 @@ static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	struct io_async_cmd *ac = req->async_data;
 
+	io_detach_dmabuf_map(req);
 	if (issue_flags & IO_URING_F_UNLOCKED)
 		return;
 
@@ -132,12 +134,26 @@ void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 
 	if (WARN_ON_ONCE(req->flags & REQ_F_APOLL_MULTISHOT))
 		return;
+	/* the dma-buf map must be dropped first, see io_uring_cmd_hw_done() */
+	WARN_ON_ONCE(req->dmabuf_map);
 
 	req->io_task_work.func = task_work_cb;
 	__io_req_task_work_add(req, flags);
 }
 EXPORT_SYMBOL_GPL(__io_uring_cmd_do_in_task);
 
+/*
+ * Queue completion in task context after dropping references that must be
+ * released at hardware completion rather than from task_work.
+ */
+void io_uring_cmd_hw_done(struct io_uring_cmd *ioucmd,
+			  io_req_tw_func_t task_work_cb)
+{
+	io_detach_dmabuf_map(cmd_to_io_kiocb(ioucmd));
+	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, IOU_F_TWQ_LAZY_WAKE);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_hw_done);
+
 /*
  * Called by consumers of io_uring_cmd, if they originally returned
  * -EIOCBQUEUED upon receiving the command.
@@ -257,6 +273,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
 	if (ret == -EAGAIN) {
+		io_detach_dmabuf_map(req);
 		ioucmd->flags |= IORING_URING_CMD_REISSUE;
 		return ret;
 	}
@@ -276,13 +293,20 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      unsigned int import_flags)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	unsigned int flags = 0;
+	int ret;
 
 	if (WARN_ON_ONCE(!(ioucmd->flags & IORING_URING_CMD_FIXED)))
 		return -EINVAL;
-	if (WARN_ON_ONCE(import_flags))
+	if (WARN_ON_ONCE(import_flags & ~IO_URING_CMD_IMPORT_DMABUF))
 		return -EINVAL;
+	if (import_flags & IO_URING_CMD_IMPORT_DMABUF)
+		flags |= IO_REGBUF_IMPORT_ALLOW_DMABUF;
 
-	return io_import_reg_buf(req, iter, ubuf, len, rw, issue_flags, 0);
+	ret = io_import_reg_buf(req, iter, ubuf, len, rw, issue_flags, flags);
+	if (ret)
+		return ret;
+	return io_attach_dmabuf_map(req, iter, issue_flags);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
-- 
2.43.0

