From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/6] first batch of SCSI data path micro-optimizations
Date: Thu, 06 Feb 2014 10:43:06 -0800
Message-ID: <20140206184306.997538898@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58559 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533AbaBFSoR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 13:44:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

This series contains a few optimizations for the SCSI data I/O path.
These are the patches acceptable to James as-is from the previous series.
No separate benchmarking has been performed for these patches.

This work was sponsored by the ION division of Fusion IO.
