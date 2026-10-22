Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792680376;
	b=W0JZRjeqnqLeHxz1Zpg0je1JZxYhpV/Xy6z/5OO1q9u2tFQpJVRO/xmtXbv4CfKJJQZ+
	 4jFQniUIaeuotxZJlqv4Vme3Qym+OP5qMo8JVxhl5QFi4E47NcSZCy7tf2gvUiMzyMR/Z
	 bV5FY/elsFuX2iQTrBDsJTFJQXWchPE+X0Cm8rJWdTu0DHkE6t2MC02okMFc8lj4Bye6v
	 ZopGo2fbOvHCz1bqOf2ZSfPhjzRlhWq7NYnl4oCWgEV70ViuDGQhBI5xaOqtYkzwu+NFf
	 ORNWHpDOZauuly6Gqk5Jmtc5MymyGwTKDIttmgKOy+O2EnpCgYol/Jk+qJiNKIv3i7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792680376;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s4dfUUsZqZsY4HZ9PSieo9kggL9QkrHJ8v9DDPPYPu8=;
	b=xDvCSmXLy9/XCVYG2Qa529Ad225ZUUqftUNYx1fhbW1HR9J5NSc32QPkIJgjlz3hu3oc
	 8K1BpFoGsoYJMNUSKVQblm2Gb0MYbnwACaZNRkS2SB5MEFAGDj8Tv3oVBFeiaDVYTZY2M
	 X546404p1v5AXuyVQ9jQHfqAXEBVN0Fpmo7FboLOVaHFu6AOtnZgmTQXoLlqe8PDqiWcM
	 /FpxR+3+E6h4l8QFzrlb6LRLTttog+9MwJFt9GhUVjQ2gPgsL0qWFOQZ0Gagp4rExVQwo
	 GxFhlaIQmsLdcmbUxbrE3DCy9CYWkBfzC+30QfnKORDNT/qwYhO4hgx3VQItVtxN3rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PDdVar0f;
	arc=none smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC920606A319
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 14:46:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC920606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PDdVar0f
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-181516de561so576346c88.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 07:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792680375; x=1793285175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s4dfUUsZqZsY4HZ9PSieo9kggL9QkrHJ8v9DDPPYPu8=;
        b=PDdVar0f+IqyCzijV3ly85Rvj4H4o8+pnNtZ+MvkrHIo+jPOxo/iZjTa62TAbY+Rd9
         i8H9Np+PwV+kItzdmDLEbLRrmksMapiqTzgr7d/ffBvRYTPWJo5XDQmCgXWciBFJ57WG
         USSsn/9LBAUm/zVta1zqDHeaaIqaVXCCBvP/4X42msKftift/F8UMlfP2kZcBkVcW67D
         jwmD///1cP4FGHs4/g8fW2zTLECpp6kx3VnPkT1q9HM4PMHCXRHSMOyvpbfalcEsCDCo
         LE2PPobx62/+WTmZJNWRdkPqFx6O/Pg90CW2JbCY4C2/1dSzEG+D/aV1GYFCgIbZwznX
         bAXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792680375; x=1793285175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s4dfUUsZqZsY4HZ9PSieo9kggL9QkrHJ8v9DDPPYPu8=;
        b=R6AuJbaiZ2G1vHf3tic7Vw9bM89qiJ9NJuJLxBswPPoZroRLgdUQoflp8y7zT3Qmby
         7hququPg/eBp/OXEjcj0LpJEqt9Qvfx9skq98/9XUffAEEJNLYsAnhSFvekRLfnxuGwI
         hVKC7hAMi9UC5ZvnslvP1Z4GvR9RSg3wkD2wG1m1n5w1EsN25C4jhQEI22nRV487UOvA
         O3asUGAUk7oJb4+XbHxc2mAVWIyhASOBFaGqbJW9tq6A5rqUs+AzarKkrDQEcrsojOUj
         4s/xQkhY9x2ZIhA1jWFoz+RxDOv54c2VVdo3N3zfjKKRQ/f2Y28ioiirTkTOXqXFlQpd
         O8AA==
X-Forwarded-Encrypted: i=1; AKwUvBzaR+LTrlGtb2CxAGgdUjVX8syu/FAN7Y49IbIUpcDQTPK8bixEYsp5f6qdxp7br3nTSxpjCg2wNBgu@vger.kernel.org
X-Gm-Message-State: AFq9FYLFrNZ6+XDTXMOWPKLmfZE68DS8MO3CCLf/h1xMIPGhCctRhSrH
	SbP1rsEzIxIy6zHMdmW0W8y7sfWEcJTkBYs2N4Dnvpp+Fq9M/Nn9gcE=
X-Gm-Gg: AYBFou2thPpP7p/DQ0JRkFNnbEVemWqIrSvRbcNJ3RzCiWRkF/COklclIWi4YuAnllG
	liMhkKip9DLETPh4egFO3Klr/VexfT+h2FYX10GZqlhWD93sD6sPLM8pOCKbKV//4fAA+z+xvuw
	qXGzLm2O9pcyujV9FNX52ERVF9VUYF0Ch84LHWH5I5z70ZsTLUu8sp+sMOWNGAsesgeAuWaCDKU
	7qU26bdnPpXBvgM99H/fdNEcPTGKYd8hakiD18aZf8QY+qmhULuBsu94625zsL6j56s3nHbSlQb
	pmdNLTBi8lHSEdRPfARIqM2nNDJZCde1rHtq8FUK+nipXn5PZ/+yHv/yJTV1ABFRtuN4BGlhDyB
	FjcuKciHFOwt1C//XNhI+vbq2MGBeMyd+Mjp0Grl2PF6N/KCiqCKPqtSfmrYV6FHi9fhwwZ7H7S
	vMXzf0V6XUBE4buJtVw0eqU1rgwcZpsmTq3E6JC/jo4M86gEymXl1orrfQ9UMvQcPxAxV/XFDLo
	kOECSNW2DQVoR4YjEnv0Xd59AywGMtdKP/ia9jAnfMzbGjM1teHmPbPcw4aQo+q9b3cyidSax+1
	ePgagr8CGwapQqto5SiPKvlA4EXJu7gxQ/sfMO89vJ0=
X-Received: by 2002:a05:7023:a47:20b0:159:d448:dd1c with SMTP id a92af1059eb24-192f4dc4252mr3056915c88.19.1792680374872;
        Thu, 22 Oct 2026 07:46:14 -0700 (PDT)
Received: from anuj-MacBookPro.. ([2406:7400:63:e55a:5016:92c7:7a35:f3ff])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903a275026sm23625880c88.5.2026.10.22.07.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:46:14 -0700 (PDT)
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
Subject: [PATCH v2 5/5] nvme: support dma-buf registered buffers for passthrough
Date: Thu, 22 Oct 2026 20:14:56 +0530
Message-ID: <20261022144501.2478417-6-anuj1072538@gmail.com>
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

Allow registering a dma-buf against an NVMe namespace character device
and using it as the data buffer of fixed uring_cmd passthrough I/O.
Complete through io_uring_cmd_hw_done(), so the dma-buf map is released
at hardware completion.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/core.c  | 16 ++++++++++++++++
 drivers/nvme/host/ioctl.c |  5 +++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d81462e864a4..6157ff839929 100644
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
@@ -3982,6 +3983,20 @@ static int nvme_ns_chr_release(struct inode *inode, struct file *file)
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
+		return -EINVAL;
+	return ctrl->ops->init_dma_buf_io_ctx(ctrl, ctx);
+}
+
 static const struct file_operations nvme_ns_chr_fops = {
 	.owner		= THIS_MODULE,
 	.open		= nvme_ns_chr_open,
@@ -3990,6 +4005,7 @@ static const struct file_operations nvme_ns_chr_fops = {
 	.compat_ioctl	= compat_ptr_ioctl,
 	.uring_cmd	= nvme_ns_chr_uring_cmd,
 	.uring_cmd_iopoll = nvme_ns_chr_uring_cmd_iopoll,
+	.init_dma_buf_io_ctx = nvme_ns_chr_init_dma_buf_io_ctx,
 };
 
 static void nvme_add_ns_cdev(struct nvme_ns *ns)
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 612d3009dd29..645446acc10a 100644
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

