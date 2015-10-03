From: Christoph Hellwig <hch@lst.de>
Subject: 3w-9xxxx dma unmap fix
Date: Sat,  3 Oct 2015 19:16:06 +0200
Message-ID: <1443892567-9562-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43658 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbbJCRTy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Oct 2015 13:19:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: atoth@atoth.sote.hu, aradford@gmail.com, linux-scsi@vger.kernel.org

This is the properly documented and signed off version of the 3w-9xxx
fix.  From code inspection it seems like the two other 3ware drivers
aren't affected as they never bounce buffer commands.

