Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792680356;
	b=fBLNqTwcu+MtpkhCURBiyiC40E/BPv0YCppoXHVqxh44PXF2wJkyI14gjkKo4Z82W6AS
	 A+5kuwxDxElLiaLDB7ju70fUMbdI2p0mqJ0gwqyKUu/VG7c9Jk0JvUn8nOgDGo4B7Iw2k
	 uHbS5uWanLxn/uahX7zyV4evladzQRTvXhcY2onEomPSCzhu5AG8IjamLDPlkh9+x4hBY
	 9Sbrm666lieuwDOVq2wn3nKZPr27KruwQu24jR6eH/pKtI5eMzPFuWk+BFQ0XxB9qDXy6
	 1dG40Q99KnMNZwsS5h+oXiM+hLO0pFMvlfYTaAjvgaFQ5tG95pz5StLzcibHnlRRbxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792680356;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zxlzuK4b3EjXwKJngq0cBhTK9G6JWxv2Wu97XDb3XjU=;
	b=RVFlyJR9Tw0ukWrb0F8KA1Va6WV2HbWiotMdJ9J9gopeCvyfWraoLDM9pifBDRI9A4Ze
	 bBbp4vEJsdJ4vtoKJtDKP/tOsIY2eyr+LlBR+ivSPbNgFkxtYK3gSPCd7YxgVpug142tb
	 BVPlZ4l9Jjbi00HcniX4fYid0FGfu7KScGBYGOiFfJrxrP68XOokyWGYBcnC2O4fT2bY4
	 cgvFZmVvOW/SFMEhTF60uTjE0fFnR9BX7TQlMCVrQ9A1jdhZvMqu3M9JanuvQrQa6YS5x
	 SDeyT7HKBZu48/I6OqFWK3xjvGLCCoPCiXwkXXUySmhv+cknb1YhEuVoxgswKKOwStQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=clhQ+aBH;
	arc=none smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9176E606A332
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 14:45:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9176E606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=clhQ+aBH
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-35d0be18c71so1091772eec.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 07:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792680356; x=1793285156; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zxlzuK4b3EjXwKJngq0cBhTK9G6JWxv2Wu97XDb3XjU=;
        b=clhQ+aBHEl1TQ/FS6en8DI3L4SmUryHS6HNBc/jx5g2EbXrPkvKXxv1TAE6pbA+J+W
         9GeJOQVvfbgqaruY4nuUZMXoucY1S0JbtuLN/6p6/c4Nbx4Lhor5l8t/JhJn7W4gKapj
         b+k/Llp7XkWfme0uUEX3XpimKzAmh8nxwDdj8tlJ2ypIN7IcXa6yVZ3mboPkRrqoKL5N
         L3ea6vdCZ/fh4OM4eJwJFRd71d1XOLXgb/5Hf4Jtzo6k2HalPfxtaJ3//0ZptBkRT7O+
         mvzF30a5sW0oXXc5hNV1m1WbDu1LEfEZjDW9uWzoxs6LiSsPGQSMbjy53c3TRROQuJjK
         vlrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792680356; x=1793285156;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zxlzuK4b3EjXwKJngq0cBhTK9G6JWxv2Wu97XDb3XjU=;
        b=PKDe5K965dFveql8CG4yireQpoguZWsXd5JY9/ee1WV3MJaI7GOuV09uKwbwvANT7l
         iytpS+PCMckn/EE1avcMdJqNkziBzkqybLU6PXidF9PEotNOiMy8HpwR6+LaoAGbB6Xk
         2BotOoKU69aKlJu66OS5AW90h/O67W9Gz1OtlJn4V2OJEdMe7ZQe9AlVokk4qaPsKt9i
         MFsK7UUH/hPx/EuxMWlXCzRNi+rNphAvHOnVOI6+2Qwaa4yQf76aOi5Cftk+TcAo6KT0
         /ixxJ3Zvq0y7VMWOt8fraWbtDRqKipQOv1L0NWpmqJxEP4jQKG+MX09ZuAN8yokeAADR
         jjmQ==
X-Forwarded-Encrypted: i=1; AKwUvByxEMNsNNkhKCXDERxtVuR0f0YAGm0jFsAKbyRKLVOCtbTFJFAj5uEbTYbG3Bx0iBHxpWt54PzKYcy5@vger.kernel.org
X-Gm-Message-State: AFq9FYJUMxXmkVysMJBFQ9c9kZHVDvZXjIBKL8F0DLZNDSGpruDw089k
	0d0U66rk3vK9ORMrVdy6YjdE4wgkB0WvWkXIuu5Aww3owq+ypL+FCKc=
X-Gm-Gg: AYBFou0YazJrXRucFLUy5IIa/1B028XZRC5PLRDenH6St86V3rz7N0SdbIx6Pubdg/L
	robOkuoYieUbHH8kA4Mz3jP3dHCec5dAMzP5lcp0TbETWUvhxWCs40hd22AZ2D5RyKkfwSM6HiM
	Dh6RdFMDiugxexV53gvuDDF89/tZVLvhsUKtqMwnMLB5Z2hE5j+ehDJly3vgtaAyp+BYy+lSs6P
	FyIrSWvutudG4qtM7/m+HT2R0oPF5FyLKYpzOzuW94YJRgwOIR2F8DQzPwiewI9WEaJ/dySSwPX
	XG5+0+js0DbJzcd/GPRx1IkleMElprBYa6CAOGDXelVpwBWy8jbwrNv24pdbHTain9XzbkG3kBe
	czcA3+pq77tReIgVhyxURM1+Fpt8/oPvoA/8/iG+pQ17YUdkqnzWGvfhN05sOt6jzVGoBzq6l7F
	FGNj8ekfomI4onfQApxBj2WxYnwyKh7B/RgG3Raa3yXzo2MZHYsDqmPl/sSJw6DTKQw+EsOrEW9
	JSvT1jMLvmOpKw00ECBN9pDA+Emoyqgyot2LezNL1ig0p2WOchBXngeeJw/dlNrFTYEz7dSdHfH
	yhrHhXOHGmxNUFd0hf232qQzMM+u9uyY+EFsrM+eGmE=
X-Received: by 2002:a05:701b:4241:20b0:15d:d7a2:3a88 with SMTP id a92af1059eb24-192f03cb835mr3210408c88.18.1792680355569;
        Thu, 22 Oct 2026 07:45:55 -0700 (PDT)
Received: from anuj-MacBookPro.. ([2406:7400:63:e55a:5016:92c7:7a35:f3ff])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903a275026sm23625880c88.5.2026.10.22.07.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:45:54 -0700 (PDT)
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
Subject: [PATCH v2 2/5] io_uring/uring_cmd: add import flags to io_uring_cmd_import_fixed()
Date: Thu, 22 Oct 2026 20:14:53 +0530
Message-ID: <20261022144501.2478417-3-anuj1072538@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261022144501.2478417-1-anuj1072538@gmail.com>
References: <20261022144501.2478417-1-anuj1072538@gmail.com>
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
---
 drivers/nvme/host/ioctl.c    | 2 +-
 drivers/scsi/scsi_bsg.c      | 2 +-
 fs/fuse/dev_uring.c          | 2 +-
 include/linux/io_uring/cmd.h | 5 +++--
 io_uring/uring_cmd.c         | 5 ++++-
 5 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 3aa5d2f2dfbb..612d3009dd29 100644
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
index 45c9c845f5d0..c2bc9dd242ec 100644
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

