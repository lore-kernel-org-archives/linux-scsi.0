From: Christoph Hellwig <hch@lst.de>
Subject: [TOPIC] scsi-queue tree past and future
Date: Thu, 5 Mar 2015 14:31:18 +0100
Message-ID: <20150305133118.GA16575@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52250 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320AbbCENbU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2015 08:31:20 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf@lists.linux-foundation.org, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

For about 8 month I've merged almost every scsi commit through the
scsi-queue staging tree, and it seems to have worked out well enough.

I've been too busy for the next cycle, so 4.1 will probably have to live
without it.  I'd like to get feedback on how the tree worked for contributors
and driver maintainers, and brainstorm how to move forward with it, preferably
some form of real team maintainance that avoids single points of failure.
