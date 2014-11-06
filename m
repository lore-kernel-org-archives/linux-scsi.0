From: Christoph Hellwig <hch@lst.de>
Subject: I/O path cleanup V2
Date: Thu,  6 Nov 2014 08:40:24 +0100
Message-ID: <1415259630-20784-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51533 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaKFHk1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 02:40:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>

This series cleans up a couple of lose ends I noticed during the scsi-mq
work, but which weren't important enough to address during the last cycle.

These are also available at:

   git://git.infradead.org/users/hch/scsi.git scsi-io-path-cleanups

Changes since V1:
 - rebased to core-for-3.19
 - addressed review comments from Bart Van Assche <bvanassche@acm.org>
 - dropped the last two patches for now.  There is too much churn in
   this area at the moment.

