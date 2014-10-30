From: Christoph Hellwig <hch@lst.de>
Subject: misc scsi ioctl updates V2
Date: Thu, 30 Oct 2014 10:27:03 +0100
Message-ID: <1414661229-15199-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50933 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaJ3J0x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 05:26:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

This series (against the core-for-3.19 branch) deals with various
issues realated to scsi-ioctls, mostly with the SG_SCSI_RESET ioctl.

Changes since V1:
  - fix scsi_ioctl_reset return value, pointed out by Bart Van Assche

