Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792680343;
	b=4Ie+TlWNBrRetRl0je3kGjEn8dK38j3iA6WM7aW5wG+tuMz4LO/0p6F11kcE7pCUO/LX
	 NX+bD38HE5+Bu57i5NZnEeeSdjTqpwNko3krMSKkar940qwv2BYIEKewK1HUg+II4EStG
	 gTNT0zvOyaqjYaUEZgsJfpjiURpjf/D2SUC40ZCXGD5V2uiDSQyAk8z0XecA32cGMrh3L
	 ZsVkY1a/M/g7w5IhuKd1Re5zpGTBkVxaKKQhY9iOMBU/f5dWVGwC8R/E4nk1FuODL/810
	 FNUpAiR44nugEunDd7o7GJ5VnZNBaTOUwZ3MQRZYNKYtqHV9EcE9fBPJDOkT9fMzo7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792680343;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YHBFmHAZzkTNwhPEuQe/n0EZjSl7NRJ9RBTHgn7pG6g=;
	b=vb5K4gidjtorNlZ9HxlojEUgM4M27rbrD670qgbtnAugtTmNUGLBP9Ld0SxvSVU5gQqT
	 qGx4LW8L8QL20GbHEHJoKi9TlJf1awf+mRx52r22YonpZfk1y9uBXqdbpBaDQ3RM0BoUn
	 sB4g0J3yCCQvF1F1ZBU77OrYhCtrUWZlsZX5OE/o5KqZgzXP6RJFvuoLWaneOQdTYQGTk
	 iN8EYTCqioaRIGLgqF5C4zO81XodHCZL9BMYVTdV7giJkbdJgBuftlFZBcBuzH2DqKO9H
	 ifrMu1Jr5PGhkYNmrDMiE4LsICueTQTSGVA0vlaSZk6CoglaHyQGDjYVkADOMda47+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=MX4aGq+Z;
	arc=none smtp.remote-ip=74.125.82.41
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5959B606A322
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 14:45:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5959B606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=MX4aGq+Z
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-157fe9d771bso2498672c88.0
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 07:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792680342; x=1793285142; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YHBFmHAZzkTNwhPEuQe/n0EZjSl7NRJ9RBTHgn7pG6g=;
        b=MX4aGq+Z76FGWDcCUV1LNuRvEgXiZkCR1eq0l3RwGH0V2h9pF4ulMUXNn5dSFjqW0h
         dvaIMrGEeu5BEQb/j8zn0XhshvClFROYk4h2ZW28nTXT48T5ArQH931fqAHdUOAFM4p9
         Cxr5jFg2zRStIh6zh8a6kI/jpDiYNmLNO+1TsZEfy0BZYRKJtdTTP1DjjfMTd3K1k/ym
         h4t75bJSWIoverA7ahvnVUnActI9LRbH2i9b/Tndc2tMA83g8lseNO+qnb6lWec7zavH
         S6zcElnkrdUhivd4xhakT/4gvt5ladPKD61Xb1wbseoIaQnK0I72aOoiQF/xw1Ia9BFC
         6fqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792680342; x=1793285142;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YHBFmHAZzkTNwhPEuQe/n0EZjSl7NRJ9RBTHgn7pG6g=;
        b=rXHkURbTabWyGVfmC39x5UlnA/NzmHyiTcIP/MgewDBLFaMPvnIdlt9uMCEcxq/gjd
         GiPYpRF85nPiI9vJ/ZVFA6HD/AE372o7S+QNOM5fN9HKFtztkrJPAQ1JQEIXH+pN5aC7
         ZXQ50bLQJVz3RsqG1Loa9Y6Mc5HRPSqq24ViTsqmXPYWlC+7h8EZ2CZhKvMzCTm1Alah
         f5O8OeHjo413gcpVq8B3fk4r2UREwumoExkBmSZl0LWZQzwcQq+QvP2AUe+Qu8bP3eKI
         KY4B9yEqmFZhNct8LdlrPAA4ldpAKRkRKOGuoDV6FYan0SzIcbuGlyGLPklOr/Ht/adO
         pbZQ==
X-Forwarded-Encrypted: i=1; AKwUvBzMGqT7Simw0DJMiPiRny1KE/XuExrA7hjsdoajP8pqrTktt07KNKXVt2iBjaV4uG6Q78E6ZQmpa8kW@vger.kernel.org
X-Gm-Message-State: AFq9FYKPcT0wUiVjC5IIOh9ucEMg7VkLJLjjMQjA129uZ4F0jQo5mY/I
	1TUwFWo5MA9tWhZmYBc+SU3LMOIffUWdEIERbgMU84npMgfhUCs+pFU=
X-Gm-Gg: AYBFou1pC7Hey7n++GkTznqj8pElD5AIouVmy8HGKcI6I8BJktvpcgBKNrb8aJQAX8e
	wzlQbt7sXTZZV3hGBysY+7Hebhm5wXg9UsHOzkUpa8lJvHLxqHLH9b75Vwb6k1fmNUR98jkqvli
	9MYYk93s7C5bSOlpS8mWUG7/6CPMybMCBzNHhUCaw5ZyLTXYa2MzT1fzHfrDFPnWbqqIu7T/knq
	BIMngHcjwSSeedx11fZpXbU/SrYM4OYF7H/oy7SqLomXqksRhN8j7Jn9x3HuAma3fdGoSzqrxte
	mu9jzGjz6myGgkAxyX1FSl5XU+ttD8NKgj3u8QLwviy5xN0lG6a2hgtGyfBQCDN+wmCT/RyEgDT
	IyQ2/lZ+gYnN+i/nsmp0PHjydKgNsk3VEN39KyNn3LOyug+CkSvGoz3art5DBCKG5BB51yFVsvk
	jnXYx2TZw385jKNsdqCbAjzs+0gFwckQV9I61EF6RYtj9kEeiGOvJmQ5GExJNkBFWmJII02NESK
	cngJQD9MXwRSv4LgQHXLpLIahGChGTt0+uhSRu2pkUz50o0xlqwxOjha410JCWojA8asal4+7CC
	2XH9WVC4nfYdZ4rAtLkZZElLvzPGfY3gUL8E/Y6U+t0=
X-Received: by 2002:a05:7022:286:20b0:191:17d6:ccdf with SMTP id a92af1059eb24-19117d6ccf9mr5773178c88.8.1792680342117;
        Thu, 22 Oct 2026 07:45:42 -0700 (PDT)
Received: from anuj-MacBookPro.. ([2406:7400:63:e55a:5016:92c7:7a35:f3ff])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903a275026sm23625880c88.5.2026.10.22.07.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:45:41 -0700 (PDT)
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
Subject: [PATCH v2 0/5] dma-buf backed NVMe passthrough I/O
Date: Thu, 22 Oct 2026 20:14:51 +0530
Message-ID: <20261022144501.2478417-1-anuj1072538@gmail.com>
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

It depends on this fix:
https://lore.kernel.org/io-uring/20261022132027.2293931-1-anuj1072538@gmail.com/

Patches 1-2 add import flags to the fixed buffer import helpers, so
uring_cmd users have to opt in to dma-buf. Patch 3 adds the io_uring
side, patch 4 lets the block layer map dma-buf iterators for
passthrough, and patch 5 enables it for the NVMe namespace character
device.

Tested with this liburing test:
https://github.com/anuj7781/liburing/tree/rw-dmabuf-pt

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


base-commit: fd13f31ac62abac4df2166bb0a6fbff53b288e0c
prerequisite-patch-id: 6ad52e1ffc603df71c6855926838f2df402c3ed1
-- 
2.43.0
