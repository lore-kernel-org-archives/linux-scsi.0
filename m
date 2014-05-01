From: Christoph Hellwig <hch@lst.de>
Subject: scsi midlayer updates for 3.15 (resend)
Date: Thu,  1 May 2014 16:51:01 +0200
Message-ID: <1398955865-20629-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:40799 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaEAOsx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2014 10:48:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org

Various patches from the scsi multiqueue development that make sense on their
own.

Changes since the version from 5 weeks ago:

 - rebase on top of minor changes in 3.15-rc3
 - add a struct request forward declaration to avoid a warning in
   the OSD ULD.
 - add the reviewed-by tags from Nic and Mike from the last round.

