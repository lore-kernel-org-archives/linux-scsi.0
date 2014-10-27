From: Christoph Hellwig <hch@lst.de>
Subject: misc scsi ioctl updates
Date: Mon, 27 Oct 2014 18:59:00 +0100
Message-ID: <1414432746-12888-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48694 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbaJ0QxE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2014 12:53:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

This series (against the core-for-3.19 branch) deals with various
issues realated to scsi-ioctls, mostly with the SG_SCSI_RESET ioctl.

