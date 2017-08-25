From: Christoph Hellwig <hch@lst.de>
Subject: [RFC] switch the SAS transport class to bsg-lib
Date: Fri, 25 Aug 2017 17:37:37 +0200
Message-ID: <20170825153741.5091-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42681 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933386AbdHYPhp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 11:37:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chaitra Basappa <chaitra.basappa@broadcom.com>, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bart.vanassche@wdc.com>

Hi Chaitra,

given that you have a SAS SMP passthrough test case and the code
seems currently broken can you please try the patches below that
rewrite the code?  Chances are it still doesn't work, but I could
help you to debug it.

The patches are against the latest block for-linus tree with
a bsg-lib fix, so in doubt just use my branch below:

    git://git.infradead.org/users/hch/block.git sas-bsg

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/sas-bsg
