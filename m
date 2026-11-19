Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795088952;
	b=yFlc55D8mapaCl/7oQMJWIOGTmiMCHIaj2yp3+siw6WV2hveYjxjXbH08JKuFEpwlwRv
	 TRZ9eqAp2QlYdpuFg0Zcw5g5IpDDnzaZo2OY0BScRfweM0UCq0Cw5502pcJpsYT5Uwmsd
	 bdgPGPUYYvIFA+/92UxC9fMO/ZQJnRAaBf+RHoE2JtiJKenatwZCSy+lD/XS8ZT5caq+T
	 NwJX7hbYXxd1fhzvHt7q7mcln2k0qeEnZuNQfKn5H8t565tnxriYsv4fs18V0eAaYioPq
	 i9fmZNkGEMzA1Fkk1yyip1RrK2220yfbvdsKFNcn+NfbNqzf2jh6K6y/EWkGQCGMMsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795088952;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=EEhqQJl2DOMK6XN35xbcvQJ1E6dGdpSC5qkWopiFypc=;
	b=vBQzxCFmTEh+2SNOBUaQqFFr5STaQhDFrmzliuMbVfNdDiQEhmhl66fBsXrnwMXxRYZy
	 ux1R4VPCskg/HP7Wg52mfifqFrfpARlVYkUiCPKWetzy2F1dt2rhBdnkXGgUPang/qVz1
	 eV7lW1mmQIUlpsZx/D4BdE6wHmPsfXKI9AI10XKx/xOgjpbFTxrSKHjPyi4w0r8TmzRxh
	 toKRQvoVyZ+LbxjdFiR4dOo18NrBQC6Oh28xWKQIzQ+G3xCbukejH9ZvgkDmqAo/DUQqz
	 XYYrWvYyGEoe4lJwoVCRZiwNYJ6YBe2Tr6kJi1Vec4P+PeVV8jBUOISBX50+BZKap7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=R6IZJ+wL;
	arc=none smtp.remote-ip=203.254.224.34
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF68606A324
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 11:49:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFF68606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=R6IZJ+wL
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261119114908epoutp043f3ebeaed7436b6fd08025035552ed70~pb_NgpxI32601226012epoutp04l
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 11:49:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261119114908epoutp043f3ebeaed7436b6fd08025035552ed70~pb_NgpxI32601226012epoutp04l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795088948;
	bh=EEhqQJl2DOMK6XN35xbcvQJ1E6dGdpSC5qkWopiFypc=;
	h=From:To:Cc:Subject:Date:References:From;
	b=R6IZJ+wLsy++8q5ytxwzGze3q39el3wg0Nr2h9v/fprTUgxMRgu6E2fZTR18BBREG
	 8fqaT/WlSwMZKnQ+MFbAr2Mem7BO0ei3HTfjJQarK5jKwsCOJ91gQF1n/FE05M3l9o
	 EE9uzsjAQCyRKywmBQTn7a5JW9qVNZGDGXwpt+9I=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20261119114908epcas5p4506629e64a22ab7aff6b6948e633b6e4~pb_M5sMrc1084110841epcas5p4H;
	Thu, 19 Nov 2026 11:49:08 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.89]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jVcFH1zwbz2SSKX; Thu, 19 Nov
	2026 11:49:07 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20261119095715epcas5p19d165f3a1af661c55d6ea73ee51c705c~pachLkNb61576715767epcas5p11;
	Thu, 19 Nov 2026 09:57:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261119095713epsmtip175a5fe725074edc1a55a4f100dab3a67~pacfG9qT82197221972epsmtip1E;
	Thu, 19 Nov 2026 09:57:13 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com, kbusch@kernel.org, hch@lst.de,
	sagi@grimberg.me, James.Bottomley@HansenPartnership.com, mkp@kernel.org,
	bernd@bsbernd.com, joannelkoong@gmail.com, miklos@szeredi.hu
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	fuse-devel@lists.linux.dev, joshi.k@samsung.com, anuj20.g@samsung.com
Subject: [PATCH v4 0/5] dma-buf backed NVMe passthrough I/O
Date: Thu, 19 Nov 2026 15:26:10 +0530
Message-Id: <20261119095615.1840522-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
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
X-CMS-MailID: 20261119095715epcas5p19d165f3a1af661c55d6ea73ee51c705c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261119095715epcas5p19d165f3a1af661c55d6ea73ee51c705c
References: <CGME20261119095715epcas5p19d165f3a1af661c55d6ea73ee51c705c@epcas5p1.samsung.com>

This series adds support for dma-buf registered buffers in NVMe
uring_cmd passthrough.

Patches 1-2 add import flags to the fixed buffer import helpers, so
uring_cmd users have to opt in to dma-buf. Patch 3 adds the io_uring
side, patch 4 lets the block layer map dma-buf iterators for
passthrough, and patch 5 enables it for the NVMe namespace character
device.

Tested with this liburing test:
https://github.com/anuj7781/liburing/tree/rw-dmabuf-pt

Changes since v3:
- rebase on current for-next; no functional changes

v3: https://lore.kernel.org/linux-block/20261030014540.3065403-1-anuj1072538@gmail.com/

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

-- 
2.25.1

