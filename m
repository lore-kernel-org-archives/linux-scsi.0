From: Christoph Hellwig <hch@lst.de>
Subject: queue_type fixups
Date: Mon, 24 Nov 2014 15:36:17 +0100
Message-ID: <1416839781-26988-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46863 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbaKXOgc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 09:36:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>

These are a few patches that follow up my previous cleanups for the
queue depth and type handling.

The first patch removes the now pointless write support for the queue_type
sysfs attribute.  The second changes the queue full tracking code to
never drop out of tagged mode, as we can't recover from that, and the
last two are random cleanups.

