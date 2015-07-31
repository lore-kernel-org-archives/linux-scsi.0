From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/2] scsi_trace updates for ZBC
Date: Fri, 31 Jul 2015 15:20:32 +0200
Message-ID: <1438348834-108152-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbbGaNUg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2015 09:20:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here are two small patches for updating scsi_trace to handle ZBC IN
and ZBC OUT correctly. They are based on my earlier patchset
libata: ZAC host-aware device support

As usual, comments and reviews are welcome.

Hannes Reinecke (2):
  scsi-trace: remove service action definitions
  scsi-trace: define ZBC_IN and ZBC_OUT

 drivers/scsi/scsi_trace.c   | 87 +++++++++++++++++++++++++++++++++++++++++++++
 include/trace/events/scsi.h |  6 ++--
 2 files changed, 89 insertions(+), 4 deletions(-)

-- 
1.8.5.2

