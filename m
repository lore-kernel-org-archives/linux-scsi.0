Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793324766;
	b=uSJngwi9h6yM/MDKO2/hrL9Xp7X2LrsrxqHg0t0yQcweFC1TJyBHpEzo8POBbHHOSODM
	 v+v8FGx+Ph7SCIF3Fetpu8jTy2Ekr7I7enhYR/P+fSrrlDEH0F49fOqPZKmnX8G1eNPJT
	 +YytpXXcLKhMobV+L1JV0Z3PNNQ+9+Rm5QefvRto4JIAr3W9sSlTkxNmigfS8qsPoJDHo
	 xp7jzbyVbl6kwckZ61GqPhMkqjA0XlExqe1E3rxFlKMD/7JPWWKc1Bo8+Ev79MmnQuYxX
	 11IHbJGrV7mswezkGWZoP3IiJXolWr1zpyGuoQoO8Fe1vcjJaahFIFVoCcDMJz5ADlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793324766;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VA9n7u5udKY5o86NILqNHNelhcHr5Omn4I4tRtC62Fg=;
	b=yOoUPJMBGOWRdi+gR+RIMFWQMODoZsWxHQAyrAdW4JZSW/rMrzHTJsPHYvtcbIkXpgT7
	 rd9manqa2ou/qgrtVXztoVbaSJ0rM3diYqtQYRq/0dbCT9NxNlBe3EGG/PsnqJaZl2fmc
	 5dDIGjUYNbJG+EONRboXeJTeyd4SUDX9Ylj6JF60CcVIlOubKth5bki0SUI/iK57eJqLy
	 PspPChNFtHhI7SXYp1DXTFuy2lQSgigpLsZhOg8xTb4KfCnI2iH9IoZf6c6EG4o1owIJ6
	 MclNqKJ6NblpiOTeyakxbJqHoEe0GUDlgva8dH9Tou+ASDkHSnKfW4LHNbUcCcdwKMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dT+Ame6b;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99342606A32C
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 01:46:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99342606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dT+Ame6b
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-35b2c599f43so513536eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 18:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793324765; x=1793929565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VA9n7u5udKY5o86NILqNHNelhcHr5Omn4I4tRtC62Fg=;
        b=dT+Ame6bjXArbCSUBed/L9j6jCpuv/OaqpN5MuAuoGHMlbSKSMh528Sh8soF9Ydr48
         MkoxgqTxfnHJ3B5pQYTBh+BDX9iG39G012E3p4FkLN5bboFAEgDRBWev5SRey+CuABW/
         3inQvh50kpx0X8W/SsoycEo4dDJum2afuUbbwjoPR2gmCVnUE4JUxtORJ9Pfv08QvXw0
         rPDTKMCtZ+rpRaT2RDTVxeex9nliS9QhwPjXvQDy0Bb9a7yqAfek5QdahGAgJRo3QFTA
         TxC6CcvoCG4eUEYMDKS44Iytl7R340nl2bLyLq9NEOUUAmTolKgOoW1O7WVl7sqKuvyo
         VRpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793324765; x=1793929565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VA9n7u5udKY5o86NILqNHNelhcHr5Omn4I4tRtC62Fg=;
        b=IzxmzrAr38cPUk9e2YcNyG/Fb0kNY6b9afVTVcLaieyQ8nx1ar+VAUrzXinshs7HRT
         9EAjwfaAWwKqhXpFZYX+ligm3muyY2My1i+HsnSKebYcDwi8kR/QsQxaIS++Bot0v859
         3K8YpYxTf3sMpPWwuhyPEaBHavGp3C08ZFl2ZeMnrogyqAM1D/P3nP0wJzQyFpM6pwDq
         az6emycGKRLjPAhjNlWmv6IuIssgJCd8VQWwRzmH/Av8eq9FKRXVT7iURchUipEzcC2i
         +yKZJTaUipSOBSeCiH2q3pVUyokLxM/ARVD63j8NzJwin5lM1UwUKlfb8uVjfUvnER3L
         /2cg==
X-Forwarded-Encrypted: i=1; AKwUvBzVRvc4uyKZsugkv5pLNHLfcx5cBVndIXF/lwLDH/KQbPnPgTRuedqcyZ8OtsxF+K3pnO8HQO7yGz+f@vger.kernel.org
X-Gm-Message-State: AFq9FYIZWI9mHpeeeTWqJP+7z+0/Ief54SQ4rWXTOvp7gtGk9SZi10h1
	SK7nKddzKladakPkrbb3UHr9PwLwPmhos0lW7hRI2Aa6oThtGFMcBzM=
X-Gm-Gg: AYBFou0vjPWWKTvG3k8z1MAlKWmHMpapYvZ3b9Gv+E7rM0F42EIdzDGXg2O7HAZINKv
	Up3xsP2+BnEKsCq3iV027UzUaT7cpLOqUYlqt/RO36k9oBJmpZHzrsg0r1SJ4CvTP95+06qRD81
	T+jx7P4Yy7mdRbI7OAaHya1/l3pNngCGW78G1lWDsH1hv5yWU8OZRtPj5/tgIubz5adidfkA3oh
	TMva1ep5hjfpJvQv7LVf6Q2JaDOeYGiAr5KitrDVLlhO6F84ljVKvl6zwGCyPi23mCLdpDO97ms
	1m5BtuY7Ug6ijjbsrPu+j2TtaJ5wRINozprrNZWl6wpIvFDHDMMkqOHn3Je64QrH+Amf6sLRGBf
	VR74w/5ziG2gZebW/VvaI2oCqPkQUzvnLDX44TbDzW7eZDSDY+kSwRt7jt/HeQXreh4qN7yiLns
	4VY7Y9oaYxs1YTH8m1q6ijsaCACrP/ulO6/lSeNLFnELf0WI1meu0oJMmAXdhTwZG7PGilLr/RI
	ciXTsRHkmBmg0x6zImcZdGl2UgXGhy9ihQcNlgwOxvDu6huK6vJI5IfpSiqceoElkN8Jy+HryDe
	xdSP9zgYcqInexT/g6QRubHzpRkEt7DUTZvc4pKGRPiasrnMjxlRQzU4wnF/ijixtiOnxuUAkB7
	lk6OmExrCFDgIJg5v
X-Received: by 2002:a05:7300:e918:b0:35c:de00:93d3 with SMTP id 5a478bee46e88-36a4247d812mr1334717eec.40.1793324764241;
        Thu, 29 Oct 2026 18:46:04 -0700 (PDT)
Received: from anuj-MacBookPro.. ([2406:7400:63:75fd:f9a4:4062:7980:1324])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428fa380sm2209020eec.12.2026.10.29.18.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 18:46:03 -0700 (PDT)
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
Subject: [PATCH v3 2/5] io_uring/uring_cmd: add import flags to io_uring_cmd_import_fixed()
Date: Fri, 30 Oct 2026 07:15:37 +0530
Message-ID: <20261030014540.3065403-3-anuj1072538@gmail.com>
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

Add an import flags argument to io_uring_cmd_import_fixed(), so callers
can opt in to buffer types they support. No flags are defined yet, and
all callers pass 0.

No functional change.

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/nvme/host/ioctl.c    | 2 +-
 drivers/scsi/scsi_bsg.c      | 2 +-
 fs/fuse/dev_uring.c          | 2 +-
 include/linux/io_uring/cmd.h | 5 +++--
 io_uring/uring_cmd.c         | 5 ++++-
 5 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index a87c9ca9d06c..d342ccad067a 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -533,7 +533,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 					ddir, &iter, issue_flags);
 		else
 			ret = io_uring_cmd_import_fixed(d.addr, d.data_len,
-					ddir, &iter, ioucmd, issue_flags);
+					ddir, &iter, ioucmd, issue_flags, 0);
 		if (ret < 0)
 			return ret;
 
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index 5eec248a77a6..e53b417c27b9 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -87,7 +87,7 @@ static int scsi_bsg_map_user_buffer(struct request *req,
 	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
 		ret = io_uring_cmd_import_fixed(buf_addr, buf_len,
 						is_write ? WRITE : READ,
-						&iter, ioucmd, issue_flags);
+						&iter, ioucmd, issue_flags, 0);
 		if (ret < 0)
 			return ret;
 		ret = blk_rq_map_user_iov(req->q, req, NULL, &iter, gfp_mask);
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index c6dd420c4034..5cc206abccc0 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -727,7 +727,7 @@ static int fuse_uring_import_payload(struct fuse_ring_ent *ent, int dir,
 
 	if (bufpool_registered(ent->queue))
 		err = io_uring_cmd_import_fixed((u64)(uintptr_t)base, len, dir,
-						iter, ent->cmd, issue_flags);
+						iter, ent->cmd, issue_flags, 0);
 	else
 		err = import_ubuf(dir, base, len, iter);
 
diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index e18d4af62e1a..23fb66a1e2c1 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -64,7 +64,8 @@ static inline void io_uring_cmd_set_res32(struct io_uring_cmd *cmd, s32 ret, u64
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter,
 			      struct io_uring_cmd *ioucmd,
-			      unsigned int issue_flags);
+			      unsigned int issue_flags,
+			      unsigned int import_flags);
 int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 				  const struct iovec __user *uvec,
 				  size_t uvec_segs,
@@ -124,7 +125,7 @@ int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
 static inline int
 io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			  struct iov_iter *iter, struct io_uring_cmd *ioucmd,
-			  unsigned int issue_flags)
+			  unsigned int issue_flags, unsigned int import_flags)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 4dac3ba162ae..d77a94d19cb5 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -272,12 +272,15 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter,
 			      struct io_uring_cmd *ioucmd,
-			      unsigned int issue_flags)
+			      unsigned int issue_flags,
+			      unsigned int import_flags)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
 	if (WARN_ON_ONCE(!(ioucmd->flags & IORING_URING_CMD_FIXED)))
 		return -EINVAL;
+	if (WARN_ON_ONCE(import_flags))
+		return -EINVAL;
 
 	return io_import_reg_buf(req, iter, ubuf, len, rw, issue_flags, 0);
 }
-- 
2.43.0

