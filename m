From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/9] I/O path micro-optimizations and per-command private data support
Date: Thu, 20 Feb 2014 14:20:52 -0800
Message-ID: <20140220222052.717958451@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58125 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaBTWX5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 17:23:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org

This is a resend of the easily acceptable subset of the previously sent
patches. The first two patches avoid taking the host_lock needlessly for
fast path operations, patches 3 to 5 avoid useless manipulations of the
device reference count, and the remaining ones allow a driver specifying
an extra command size so drivers don't have to allocate memory for driver
specific data additionally, as well as converting virtio-scsi to use this
feature.

Changes from the first version are limited to reordering the patch series,
fixing patch subjects and attribution and adding some boilerplate commands
back.
