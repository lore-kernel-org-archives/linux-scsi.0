Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793324784;
	b=t2WG8BtWdHig9jfyEw3igPImM98L8Cxp8goQf1HmqUZ3rIjvToLZSPB9g4hO+z4TCzwp
	 /ljx6qls20LYxIPzzJf3OOSzjGcwbvmMPY+te6cxCOr4O3RIRmsruAfg8zCvdtLh4Iir/
	 ng99/T6OiuMyD/Kla2/Q5kzMFL4MWjULJHvuvJwQSRkTUIJAsKeYR5NcKF5C12J10ksB7
	 G9NHIZc0/U24fufZGfa1b26zDiTf1AZynGh/hDKplj6WtQa1+wm06Vrayi+zseRgmhO/8
	 HR0NcLqkMEY2mywDX3CiLOerX2UIyRHlUPBamFfhwCmJpUxQkmJ3tHo+BC3VOXOlNVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793324784;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SF9HmYpsqJyt4I9c/G5LCdmVYCdb7Ms79eOZlmLUUW8=;
	b=1hSYv+p81JFWXSgQCk7uVci/zugbGIYtfrmc1ElYMDU+wu4UAvxPWvYw4YQOVChKe9bm
	 UPDyH8cvNZs+4V/5qSynOvSdRn/0iwbtc6cgC9GCQwHCkRJIBUn5sJ14IRm3Life0ZiWM
	 KUE76HxftaEVVTIXPjStbuEOPb3gsQ1Gs+DvKNmSB2nvTiXfRn2MemDKEIlpgHaEDLZQZ
	 VX82GTB86ZmeJyYPMqrnu6cgj3MDhEaog6CJNRp9NayADd2nU7ByUTGMhYPeo6R0PN7KO
	 DnJSQd92BS0AdXOPUeekA5nRtFB4CUEPk/Y1W5ASUU2mANfI7GSFOakgbcvnscAty0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PpJtXuLt;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235FA606A31E
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 01:46:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 235FA606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PpJtXuLt
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-35c76e9614aso410068eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 18:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793324783; x=1793929583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SF9HmYpsqJyt4I9c/G5LCdmVYCdb7Ms79eOZlmLUUW8=;
        b=PpJtXuLtrGLkKx/N+0tCyrbbBKOE3Ru4G2tPkL4Fy/TPNm4MMuVamdfqFeVKhzvHWO
         5zfkyPcNvjkQtGRsngYTN6tj3jKX81nYAB+L+v9JxG8WAiT7ZuuwCIbLK0DE/NzVTNxH
         V8ykoYQuKsXyu+oItMTU/fELmq1xlU4XJ/zFaX3n4njziJO2qNyw3ajd65YpBpJm89Vf
         ZaoFn+57s5tllrgiqGn6h12jGywcjhnlBubvgxi01+Bq3Diqbl9yqhJZ9hY7jGFKVv/c
         PWPgkNT9CA6OIkaB/dygJNRqdJ0VTetO2JbWNcMad2XdBtFait71EyzgVQzvNqAZib2Y
         YqCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793324783; x=1793929583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SF9HmYpsqJyt4I9c/G5LCdmVYCdb7Ms79eOZlmLUUW8=;
        b=X+KC24av+vNhMozqjzi2Qd2ZLNC44tbMnHnEoODHGnczuMvcwt4wIfagNHzrphVa9d
         1UyeOLaIbTxU1SqrrpXW9UC5/kqY7JPrIZklIPDfuDgv1sN6kDO088FiZpqm1hnxThcN
         fZvELn1biZOt2hvaJ3GcCFxgw6VLqQadM4TWDp27PXr95p5yMltxnLLgzBOjj+Oa2tIH
         GFdUB4Udcodx+3XDVnOP8VfIsh6jtHwOipZrjjol1uuOPkakzyoTmr6fF3li1pGAdvrU
         P+BoWpyKA2CZitti12juSK2MFZmWCtIwprepyYPoJoReU9Xyby/d489wXKfP7Cp2pgaS
         6gaQ==
X-Forwarded-Encrypted: i=1; AKwUvBz9KWj6b1ZpOF+xCjSDmsJuZ3bAfd+1x/fMuwCRQQf7ysRQvogieYl9qFdyCk/e/z4KDqSVWArF9afT@vger.kernel.org
X-Gm-Message-State: AFq9FYIMaVFxCWGy2drQk752cDo2kMqRlcO5EM4Imqu8EX6g9aP6kTts
	1GOsrH84nqceYSsDpKWoH/5G1CybKRlXYCbrpSoiy8Yu0ndhNFGWhuw=
X-Gm-Gg: AYBFou1WA+AmGM1BqqVh4lczOjIXAIySBgVlvX2yceMWV7D+jebW/ONQWtsKtp2fUvZ
	zAbQfIT12fV3Xm9FYtvnelL57sSthUbNJQHrt/ZjpWlkaiPLPFvt9AVcC669JLsjkecmad18Vuz
	VTAiHiWgT203SSVnofOgV0UnsFv32oXQTdbEHP7kCiQ6MoOJNo9KCJJEQB5jfYBdOi1VEcls6QX
	r00mTMXVkMSqGhPFBvvxV9V0goRIdNt+vj7vS08tGkeh7xX8maly1wpm5yZiLIaAMA9AtufYFnH
	8k+Ppc286HOQtp3aBA5GldR5OvUR/wlcwoXWJLJX43ew5plcc4Q4XZPsT7LH8Y2q3iTt2l4giul
	HozzBfHz2nSm2amkEoqEezIiJySRAOLmGp2+mlMdrUGWteoVHGqVVtQuNUd8rnd7tFL2nN/YrMV
	B/3Q6ELyp8aukxMCIkKgYrSLewmRF2g2Wda+/DnHJGQF6m+LTUFSx66DUeLbWjBWYnzVEvF3NcB
	FJQ8ylJrfJO5sUdP0g88vZeKszYjRjAo0j9pZb42oLm//BWLjplD1OT2QJIqTsRQInr5dSOKKAQ
	f1PgQwOimArx03YrLNeuWJQMS2i7i97v2R4I1PTVZwrTogHfY9kMHH/T1mDxe5r5AZu8OnAWmhg
	5zTEXR3hRC2JY7SM8
X-Received: by 2002:a05:693c:69d2:b0:368:9553:f2da with SMTP id 5a478bee46e88-36a423f5c39mr1635691eec.31.1793324783143;
        Thu, 29 Oct 2026 18:46:23 -0700 (PDT)
Received: from anuj-MacBookPro.. ([2406:7400:63:75fd:f9a4:4062:7980:1324])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428fa380sm2209020eec.12.2026.10.29.18.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 18:46:22 -0700 (PDT)
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
Subject: [PATCH v3 5/5] nvme: support dma-buf registered buffers for passthrough
Date: Fri, 30 Oct 2026 07:15:40 +0530
Message-ID: <20261030014540.3065403-6-anuj1072538@gmail.com>
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

Allow registering a dma-buf against an NVMe namespace character device
and using it as the data buffer of fixed uring_cmd passthrough I/O.
Complete through io_uring_cmd_hw_done(), so the dma-buf map is released
at hardware completion.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/nvme/host/core.c  | 16 ++++++++++++++++
 drivers/nvme/host/ioctl.c |  5 +++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index a7a4d09644c1..33dbaa319bb9 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -8,6 +8,7 @@
 #include <linux/blkdev.h>
 #include <linux/blk-mq.h>
 #include <linux/blk-integrity.h>
+#include <linux/dma-buf-io.h>
 #include <linux/compat.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -4008,6 +4009,20 @@ static int nvme_ns_chr_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int nvme_ns_chr_init_dma_buf_io_ctx(struct file *file,
+					   struct dma_buf_io_ctx *ctx)
+{
+	struct nvme_ns *ns =
+		container_of(file_inode(file)->i_cdev, struct nvme_ns, cdev);
+	struct nvme_ctrl *ctrl = ns->ctrl;
+
+	if (ctx->dmabuf->size > UINT_MAX)
+		return -EINVAL;
+	if (!ctrl->ops->init_dma_buf_io_ctx)
+		return -EOPNOTSUPP;
+	return ctrl->ops->init_dma_buf_io_ctx(ctrl, ctx);
+}
+
 static const struct file_operations nvme_ns_chr_fops = {
 	.owner		= THIS_MODULE,
 	.open		= nvme_ns_chr_open,
@@ -4016,6 +4031,7 @@ static const struct file_operations nvme_ns_chr_fops = {
 	.compat_ioctl	= compat_ptr_ioctl,
 	.uring_cmd	= nvme_ns_chr_uring_cmd,
 	.uring_cmd_iopoll = nvme_ns_chr_uring_cmd_iopoll,
+	.init_dma_buf_io_ctx = nvme_ns_chr_init_dma_buf_io_ctx,
 };
 
 static void nvme_add_ns_cdev(struct nvme_ns *ns)
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index d342ccad067a..3f240c9a537f 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -472,7 +472,7 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 			blk_rq_unmap_user(pdu->bio);
 		__io_uring_cmd_done(ioucmd, 0);
 	} else {
-		io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_cb);
+		io_uring_cmd_hw_done(ioucmd, nvme_uring_task_cb);
 	}
 	return RQ_END_IO_FREE;
 }
@@ -533,7 +533,8 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 					ddir, &iter, issue_flags);
 		else
 			ret = io_uring_cmd_import_fixed(d.addr, d.data_len,
-					ddir, &iter, ioucmd, issue_flags, 0);
+					ddir, &iter, ioucmd, issue_flags,
+					IO_URING_CMD_IMPORT_DMABUF);
 		if (ret < 0)
 			return ret;
 
-- 
2.43.0

