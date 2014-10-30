From: Christoph Hellwig <hch@lst.de>
Subject: device handler cleanups V2
Date: Thu, 30 Oct 2014 10:19:08 +0100
Message-ID: <1414660754-8431-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50826 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537AbaJ3JTF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 05:19:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>
Cc: Sean Stewart <Sean.Stewart@netapp.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org

This series contains a couple easy cleanups for the device handler
infrastructure.  I think some more work could be done in the longer run,
e.g. by using a class_device interface to attach to the scsi_device,
similar to how the /dev/sg devices work.

Changes since V1:
 - fix ->attach for rdac, pointed out by Mike Christie

