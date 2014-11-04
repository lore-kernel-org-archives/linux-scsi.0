From: Christoph Hellwig <hch@infradead.org>
Subject: [RFC] drop libsas task collector mode?
Date: Tue, 4 Nov 2014 10:58:21 -0800
Message-ID: <20141104185821.GA10475@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35413 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaKDS6V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 13:58:21 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Xiangliang Yu <yuxiangl@marvell.com>

The task collector mode in libsas implements internal queueing in
libsas, which is somethign we usualy try to avoid, and doesn't seem
to get much exposure as it's only supported as a non-default option
in two drivers.

If there's still interest in submitting multiple tasks in one go
I'd be happy to wire up the blk-mq last parameter with a flag in
the scsi command so that we could get a similar effect without all
the overhead, but I'd need to have a signed up tester for it.
