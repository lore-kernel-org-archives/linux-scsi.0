Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072816;
	b=XaKovGhtlJEjfU+UPCtdToCKtV4DNSRKDLYVSKeZvwpQ32yrq6Y0i+4yFQXmUEuIR0y/
	 oyyXbDiT43OTCI3j2v2Iz0awGfooSBz5sVn57B3kVXhZFHwtGIiR1XOFUAk3iJcnxU2mc
	 M9SulJNxescPvTY+QDLcOG9v4sYQ65U5eiwRKsmEW+u7Ay+DQSB0GNV9LANt2eE+JKkdM
	 72ocbNFjs7VKSQep584mthxmTDEM51kngMFtGDTJAR/L2m46krFLWpVlrhXvsEZr9YQxP
	 If2W9kUoLqyJUD2R8xlg6O6Xjb7oeK+oojIFO9CZr+P8WEicpTywtf1jCXIQji7CZNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072816;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=eucQ6Ju1i1wHJJ/LYDIwVDs7V/Ckr0cpLTN6p+bVCak=;
	b=W52+gUfnFOQp6hIE7tun1MzR/5KV2544J+kLpgOxprJe31/YYxoptG6QPlotoPBY5qPg
	 efNJDyQjdzL8YtgcAtN1nQsVb3TRB3tCT4aoGE1z+aEJkSRfvIp+ZyiIqKTSwX8bHU5fo
	 UhpEGL12rsz64xVZimE0+N+fS5eSY2ABtL8O5CeSpC13Y9Aq6ZcvRHbd3i+iZ4gwA+PQq
	 widkopUBAYu+YOUNtxZZvRdGhZL60JABYPqmjX+i5TmS8+iLwir1dOP96Pt6u7kKuHuVI
	 T5NRxhkEQMrenLoALxSW3X35o1fr6vRHOswMtaxNxrYzis4EtjKNTg2QJkGkTiDgIJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="TG1V6/y5";
	arc=none smtp.remote-ip=209.85.215.226
Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC807606A324
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:20:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC807606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=TG1V6/y5
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cdba1bbde0bso927695a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:20:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072815; x=1795677615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eucQ6Ju1i1wHJJ/LYDIwVDs7V/Ckr0cpLTN6p+bVCak=;
        b=H5LDoQyDZ8/RLrG/jCCULfu3x4/OMc30sfXWrmvzA0ngrG9DINaR2r8agdq9JNolOz
         C1cgZNRrbYvWpzKj8ERhk8UnBMQM4A4caJMQMKKgJGCbF+hWAeM5rLehOlMjejJqUetn
         XesRQFkR0St2P4O70t+u0Ak+Qm3o3Rsj9yHEsWEKV9tp0HZooVFjgsO76iz4XmB0vAU1
         FMZNzWhG3HhRsi5FB1WG/VvbgpLmMMUImHY21gq365SX7Vl+IRNyHLSXNc4MtWyyGD02
         Lcz7WzS0kaxXzK486o67VLvkimpV4bDEiYdU0znALfky2XLpMOz7h67rueV4emhyDxWz
         kvyQ==
X-Gm-Message-State: APuU4Z9VET9/k/jw+m4dpWC1N/cSXbv7eva+ZT5N0p/ElXIQdmseTf5Y
	XNpKyGTEoxUTEIpmYVru2FpS1luW5Scdcx/umYBkZEkzJkIY8FTnkqp2UiS0ypS2OHf/xBIF5i7
	Yh166c232tPiq2o9w6/Tt8HVdClINi0fvzF+e31NlxN2AhzVVEZEyIPtJHR1lIx+ccFs6DX5zGa
	B0KLGTW0vHUqyjmhwOwUSFSW7NLwy6HhgcMx2j1eo9LBifeHKSu3j85bIJTLNYF/alm/nSN+9nk
	GfovD5xmJuESmdF
X-Gm-Gg: AZFdTZddp/KdMVxr5ByPPOKcINzYJmwrZzQmeUcYI/mxbM9rwheqqfv1oeb7Xu6bOJP
	su+swwr3c+xlWFFo+FaVjj2bIMZcFQwPmuVD4chk8927n24ELej034BcGIU+FO4xC5LVfjfnDn9
	3eASegqHODLr6j79UwpzU6dzVduc0CT62lbUx2PunAgrO0fZhlLqipDhcrJnhl+cySMLzwdLEWD
	GGep35a8IyGyhcCL8DUcBwpGBXFMrXUZoXu5ygktsophiHwXzEhgIlW9PiRW+KweRaO/JK4b/e8
	RgJpcrxyV6hBj+xr3ZOyJ/JgSi0ZQT7pGJxxZc7/Y4K+Cq+Nw/PIVhrAp6h+D/r8Z2gJnLMVig/
	cHpoV8km4eiuzH/NmFQP+KEtM3UHkkJat8b37PYrAA/zySQzGjlmR1Alc6taM4SfQJK7ejprGmO
	yOauSoQoOa1ypUS4YJYHuooCQvFvbySz9R3QE=
X-Received: by 2002:a17:90b:3f0b:b0:3b1:2d60:66cc with SMTP id 98e67ed59e1d1-3b3d06412f4mr4986933a91.8.1795072815204;
        Wed, 18 Nov 2026 23:20:15 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b4062eb7cdsm473219a91.8.2026.11.18.23.20.14
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:20:15 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3acc98e3b3cso1481089a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072813; x=1795677613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eucQ6Ju1i1wHJJ/LYDIwVDs7V/Ckr0cpLTN6p+bVCak=;
        b=TG1V6/y5npwF0ikXD+7M7xx4zsBoVxWxlR0rBrhTyss4xQ6mkGLwYyzTTpp2PhUifO
         QYnJtR/EETYmKsJN/p1cXUxVx67F1Xs3HKz6VdBeqWtM3KTqStVYXgotcePoX8syGeKX
         i1UFhoRZSZJWXaXry0CuTEKYndbd30ylUNx3k=
X-Received: by 2002:a17:90b:3e82:b0:3b1:2810:dfdb with SMTP id 98e67ed59e1d1-3b3d07a85c3mr5405112a91.48.1795072813271;
        Wed, 18 Nov 2026 23:20:13 -0800 (PST)
X-Received: by 2002:a17:90b:3e82:b0:3b1:2810:dfdb with SMTP id 98e67ed59e1d1-3b3d07a85c3mr5405073a91.48.1795072812559;
        Wed, 18 Nov 2026 23:20:12 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:20:11 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 19/20] scsi: mpi3mr: Fix byte order of the BSG status reply
Date: Thu, 19 Nov 2026 12:41:31 +0530
Message-ID: <20261119071133.127282-20-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
References: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The status reply returned for a BSG MPT command stores the IOC status and
log info in little endian fields without converting them from CPU byte
order, so a big endian host returns swapped values to the application.

Convert both values to little endian.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825210411.301535-1-chandrakanth.patil@broadcom.com?part=2
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 3359393dff5c..3937647778e9 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2935,8 +2935,10 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 				MPI3MR_BSG_MPI_REPLY_BUFTYPE_STATUS;
 			status_desc = (struct mpi3_status_reply_descriptor *)
 			    bsg_reply_buf->reply_buf;
-			status_desc->ioc_status = mrioc->bsg_cmds.ioc_status;
-			status_desc->ioc_log_info = mrioc->bsg_cmds.ioc_loginfo;
+			status_desc->ioc_status =
+			    cpu_to_le16(mrioc->bsg_cmds.ioc_status);
+			status_desc->ioc_log_info =
+			    cpu_to_le32(mrioc->bsg_cmds.ioc_loginfo);
 		}
 		tmplen = min(drv_buf_iter->kern_buf_len,
 			drv_buf_iter->bsg_buf_len);
-- 
2.47.3

