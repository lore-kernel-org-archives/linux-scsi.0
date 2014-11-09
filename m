From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 0/2] virtio_scsi: support multi hw queue of blk-mq
Date: Mon, 10 Nov 2014 00:57:02 +0800
Message-ID: <1415552224-31145-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:51329 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaKIQ5V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2014 11:57:21 -0500
Received: by mail-pa0-f48.google.com with SMTP id ey11so6621056pad.7
        for <linux-scsi@vger.kernel.org>; Sun, 09 Nov 2014 08:57:20 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

Hi,

The 1st patch introduces 'force_blk_mq' so that one driver can
claim that it only supports blk-mq.

The 2nd patch implements multi hw queue support for virtio_scsi,
since it is very natural to map virtqueue to hw queue of blk-mq.

Thanks,
Ming Lei


