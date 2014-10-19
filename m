From: Christoph Hellwig <hch@lst.de>
Subject: hyperv storvsc cleanup / optimization
Date: Sun, 19 Oct 2014 17:18:14 +0200
Message-ID: <1413731895-6967-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:40638 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaJSPPl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Oct 2014 11:15:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-scsi@vger.kernel.org

Hi KY,

can you throw the patch below into your testing rig?  It converts
the storvsc driver to use our new cmd_size field, and thus avoids
all the slab/mepool infrastructure for private data in the driver.

