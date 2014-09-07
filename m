From: Christoph Hellwig <hch@lst.de>
Subject: I/O path cleanup
Date: Sun,  7 Sep 2014 09:31:01 -0700
Message-ID: <1410107469-896-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35025 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaIGQ2v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2014 12:28:51 -0400
Received: from [50.247.105.171] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XQfKb-0006Sf-Vf
	for linux-scsi@vger.kernel.org; Sun, 07 Sep 2014 16:28:50 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This series cleans up a couple of lose ends I noticed during the scsi-mq
work, but which weren't important enough to address during the last cycle.

