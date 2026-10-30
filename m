Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793324751;
	b=Rv6x6mKNo+9VBQgW6Xsm0HQxVtfKt9GS/R2DhQTaecD+X5PXMHmhrGFyDmtuYuCCH137
	 /feQfQHtThOgIxOaDROGhZyBFePOqjCwHSWrsONJe6vL3LNpOmIJ/pG0WA6ldJRNzwVie
	 bKT9Jdwo9QEL6m8wXrh3W7UqyWIDXL4BGidOU6ucTu7J0G6kozyfbXq39cy5TKudULvwh
	 MV1C8QfPsxdgkiXuJpb+1USRt8OLCu3iXpfFYq2PrH00n5tkQlV9h1Cs1SAixZpVtpTeS
	 v/zxAX1RyIiH/12pw2+lkSM8AF28MdHOKTpXmbsDL/3updkV8j3oUEBcWl2Pr1agZ/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793324751;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8e/IpuSYW9d0QekEXFx6bT2Oe0C5XCSMgDyLhp7uw80=;
	b=px4sxezkUaTM70nk76SGA0gBhqIi4PU5oOKXTdFVoTty32bOHSkXEMzoNnXy+CfD3Ol4
	 amYRUxbYIlAu0YnPl7TOjzGt+3shtqZrvjtoBSl0MU92aq6Sw4AZWKFQKyq0C6NRqTEwu
	 dIbJV+OLBwgJmH1wzoYru5Ver16zcMsYoIiX8pEq2BIZe3vNj1ersH4Y/CP9G9QcYXrub
	 SgPxzmbd6CtxPKONmSiLiJN1bhc75YKt2HCpPtY9Q1YBMHSEMTAuIW2vyRSMW+RNT7hQc
	 cQLvVfhbjGafgxwcEg0UzP6X4khYKsqsftkypTylVE1bnuSBFhfbGIYxli7ip0ixUOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=grwei3CL;
	arc=none smtp.remote-ip=74.125.82.182
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA903606A31E
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 01:45:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA903606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=grwei3CL
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso444550eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 18:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793324750; x=1793929550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8e/IpuSYW9d0QekEXFx6bT2Oe0C5XCSMgDyLhp7uw80=;
        b=grwei3CLBhH0n+t8FMxoVn41EIUIORxUG2gg4NQl76HodYhPBrH0i3O0LFwy+YwR9F
         Y051WwR9tNWc/ViI9NCrkq0e+VhlF9WP+auwSRu3BpwQupNVW7sc9g0CmfuXfbHUWl0f
         vycTRltBoygYfYV7wjOQlqh2PB0iPhRLF3CLsuJgzgurCZQdfSMjmSalpoABRFupELBC
         H/i3fQFZAG+AkxZydEHe6Q1P0nv4v2WjaOap6wF7wuLTNgxa3DSNWV5Ur4+ctIYebVvj
         X9DJckYCVvSAmy8MMCGC1w6M9njEsUD7ESz1VtNyY149Q4CtSAAY0jbb7rjX9zPYx8Rw
         hm1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793324750; x=1793929550;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8e/IpuSYW9d0QekEXFx6bT2Oe0C5XCSMgDyLhp7uw80=;
        b=Efp5CIwxLxlFXQmD/LA3yaUePPPemqJSnOM7Qcum/qv+JBDiQaNKEXrdUdJemHM5FU
         901AMxrizMAqe5vOgm2JbdNcuuL1sV7LX2DYQ4WMAjRDxS5F8OzUfpgC6M+ECRPdlzuC
         6OB8M92pqa5hyCrz2OPqp9G5XPUTUgri0gyn2RDEUR14h4GmbdU9UdC9+4002EAg+c/i
         XmXy1XhHNeKP2BQHtXbMuMi+O/U5yt1b/aRiQ2yc2jMWRhSY1mdD6v1AnQzRyHx0RTTF
         wKXTBwcioV7/9im83VEFIp5lu56xHppvyrUizSomH5g0Ph0kuc2iwYtBoqPbTpSB0Jl4
         sGeQ==
X-Forwarded-Encrypted: i=1; AKwUvBxlHlBylxhOyjLaMWY2lIgo3vV3lFY/PqAfvcBLRhDkuGBKVGbBbrlnMR98v0CMXEY3lr9T8PFNBdQv@vger.kernel.org
X-Gm-Message-State: AFq9FYKyG+GSvfvVBCYwuLOZwQTXMv5zfSPhRSS4fGRJ2fK38rlcVd8x
	rpWsxbYoDIdGzsywLIzpXMjXdNX+ZOSSLW90NC9XF9wwUA1pHfmWLyg=
X-Gm-Gg: AYBFou1Pj2TGuFGH/v3pbBE3eyrWs+oWa9ilOpthlQNueJsb4DKhZq+W2BulwtacXkD
	Ofbp3gdiRya9GyIVaWcs/EcGcHSx7UfyXAoyizYV/XWfcTDaOxShRAHmtk6iF3POnPzs5luKl7D
	+cfx6pJgeXpb92NyHR+wB8dM7cnkmydQ29U8w9myUYppwTW7G96tAp058R7QXQ1O9wFOiqh8E4F
	mV/Uxd1mIW/MwM9q7TA3oLbrBm/lM5gjOtnluJEYpgFNbhm22li2yaVNc4gtnaMoZbbtb1Y39oT
	dAAKov5lr45BNJQIPG8PaZo8laql9RVZLfGcacufs1ux3XqKoOyBDW8YB6pPQcHv5ONLbExGAlh
	eIihUs7LnmHbwQdRf0Udk2g2TRAc8x4Gz7QKM1AndY/ilDf2PGjFNmQadM8A98BBfvquWZUX/qP
	yOz1M+8A2ff5E2hIr0BsjxkKdZwcswvHJqYvJm/KVGE40hPW84DH1cEa5EreHr9tvPzKe6l75Jd
	qovmdtKMaMF1g0NiNfvc+GMgcLouWg0jjMirAdiGI7o6R9dXFwDdade4wyW6MxMMMXxH6dT9DAo
	sWeyo8lVcITmExVFgBoSVtOQCbLra/R1xGf37c7txlx4gNkCT2GVb0BeDGGC5R5EmAmfAdbqxv0
	3gxuhTEboQba+fBWFviFCUyb399FTr+uxEKdD5Q==
X-Received: by 2002:a05:693c:8806:10b0:369:f97f:72c1 with SMTP id 5a478bee46e88-36a4241bbd5mr1678012eec.36.1793324749832;
        Thu, 29 Oct 2026 18:45:49 -0700 (PDT)
Received: from anuj-MacBookPro.. ([2406:7400:63:75fd:f9a4:4062:7980:1324])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428fa380sm2209020eec.12.2026.10.29.18.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 18:45:49 -0700 (PDT)
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
Subject: [PATCH v3 0/5] dma-buf backed NVMe passthrough I/O
Date: Fri, 30 Oct 2026 07:15:35 +0530
Message-ID: <20261030014540.3065403-1-anuj1072538@gmail.com>
X-Mailer: git-send-email 2.43.0
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

This series adds support for dma-buf registered buffers in NVMe
uring_cmd passthrough.

Patches 1-2 add import flags to the fixed buffer import helpers, so
uring_cmd users have to opt in to dma-buf. Patch 3 adds the io_uring
side, patch 4 lets the block layer map dma-buf iterators for
passthrough, and patch 5 enables it for the NVMe namespace character
device.

Tested with this liburing test:
https://github.com/anuj7781/liburing/tree/rw-dmabuf-pt

Changes since v2:
- return -EOPNOTSUPP when the controller has no dma-buf support (Pavel)

v2: https://lore.kernel.org/linux-block/20261022144501.2478417-1-anuj1072538@gmail.com/

Changes since v1:
- split into io_uring, block and nvme patches (Christoph)
- pass import flags to io_import_reg_buf() and
  io_uring_cmd_import_fixed(), and make callers opt in to dma-buf
  (Christoph, Pavel)
- add io_uring_cmd_hw_done(), so nvme no longer handles the dma-buf
  map (Pavel)
- warn if task_work is queued with a dma-buf map attached (Pavel)
- make the -EREMOTEIO conversion explicit and comment it (Christoph)
- refuse dma-bufs larger than 4GiB on the character device

v1: https://lore.kernel.org/linux-nvme/20261016103453.1129150-1-anuj1072538@gmail.com/

Anuj Gupta (5):
  io_uring/rsrc: pass import flags to io_import_reg_buf()
  io_uring/uring_cmd: add import flags to io_uring_cmd_import_fixed()
  io_uring/uring_cmd: support dma-buf registered buffers
  block: map dma-buf iterators in blk_rq_map_user_iov()
  nvme: support dma-buf registered buffers for passthrough

 block/blk-map.c              | 15 ++++++++++++++-
 drivers/nvme/host/core.c     | 16 ++++++++++++++++
 drivers/nvme/host/ioctl.c    |  5 +++--
 drivers/scsi/scsi_bsg.c      |  2 +-
 fs/fuse/dev_uring.c          |  2 +-
 include/linux/io_uring/cmd.h | 14 ++++++++++++--
 io_uring/net.c               |  6 +++---
 io_uring/rsrc.c              |  6 +++---
 io_uring/rsrc.h              | 13 +++----------
 io_uring/rw.c                |  5 +++--
 io_uring/uring_cmd.c         | 31 +++++++++++++++++++++++++++++--
 11 files changed, 88 insertions(+), 27 deletions(-)


base-commit: 70866cfa169d5ee149364267289e71d50f9a7ae9
-- 
2.43.0

