From: Christoph Hellwig <hch@infradead.org>
Subject: [ANNOUNCE] scsi patch queue tree updated
Date: Fri, 25 Jul 2014 14:19:07 -0700
Message-ID: <20140725211907.GA22025@infradead.org>
References: <20140718100230.GA23521@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33245 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759814AbaGYVTI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jul 2014 17:19:08 -0400
Content-Disposition: inline
In-Reply-To: <20140718100230.GA23521@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

I've pushed out new version of the for-3.17 core and drivers trees:

  git://git.infradead.org/users/hch/scsi-queue.git core-for-3.17
  git://git.infradead.org/users/hch/scsi-queue.git drivers-for-3.17

In the core tree the biggest update is the merge of the blk-mq
support, but various smaller updates also made it.  On the drivers
side I have only merged minor updates for the ufs and hyperv drivers.

We're fairly late in the cycle but I really would like to not miss the
scsi_debug and megaraid updates that have been out for a while but need
another review.
