From: Christoph Hellwig <hch@lst.de>
Subject: integrate scsi_dh better into the scsi core
Date: Thu, 30 Apr 2015 19:32:22 +0200
Message-ID: <1430415151-30948-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54992 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbbD3Rdm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2015 13:33:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

This series ties scsi_dh deeper into the scsi core, and fixes all kinds
of issues in it, most importantly the race between using and detaching
device handlers.

