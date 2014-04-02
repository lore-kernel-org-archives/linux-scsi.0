From: Christoph Hellwig <hch@lst.de>
Subject: blk-mq updates, V3
Date: Wed,  2 Apr 2014 16:57:09 +0200
Message-ID: <1396450634-32021-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51044 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbaDBOzE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2014 10:55:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

The first two patches are unchanged from the last two iterations of
the series.

Patches 3 and 4 are new: 3 is a preparation for 4 and other future work,
and patch 4 makes sure that drivers don't have to implement special
workarounds for the magic flush request.  Patch 5 is an updated version
of the earlier init/exit_request versions which should make everyone
happy now as there are no special NULL hardware contexts or negative
request numbers due to patch 4 sorting out the flush_rq mess.

