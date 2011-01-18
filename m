From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH v4 0/3] differentiate between I/O errors
Date: Tue, 18 Jan 2011 10:13:10 +0100
Message-ID: <cover.1295340405.git.hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:59480 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab1ARJNO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 04:13:14 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 8E8B79428F
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jan 2011 10:13:13 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, jaxboe@fusionio.com, michaelc@cs.wisc.edu, agk@redhat.com, Hannes Reinecke <hare@suse.de>

Changes in v4:
Included new error -EBADE to signal nexus errors.

The diffstat:

Hannes Reinecke (1):
  scsi: Detailed I/O errors

Mike Snitzer (2):
  dm mpath: propagate target errors immediately
  block: improve detail in I/O error messages

 block/blk-core.c          |   23 ++++++++++++++++++++---
 drivers/md/dm-mpath.c     |   22 ++++++++++------------
 drivers/scsi/scsi_error.c |   24 +++++++++++++++++-------
 drivers/scsi/scsi_lib.c   |   28 ++++++++++++++++++++++++++--
 include/scsi/scsi.h       |    5 +++++
 5 files changed, 78 insertions(+), 24 deletions(-)

