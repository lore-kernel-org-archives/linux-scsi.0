From: Christoph Hellwig <hch@lst.de>
Subject: two small bsg fixes V2
Date: Wed,  6 Sep 2017 15:44:14 +0200
Message-ID: <20170906134416.19980-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46325 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754220AbdIFNoV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Sep 2017 09:44:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

Two fixups for the recent bsg-lib fixes, should go into 4.13 stable as
well.
