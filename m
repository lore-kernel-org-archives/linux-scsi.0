From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 0/3] differentiate between I/O errors
Date: Fri, 14 Jan 2011 10:58:53 -0500
Message-ID: <1295020736-27699-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab1ANP7Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jan 2011 10:59:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, agk@redhat.com, jaxboe@fusionio.com, Hannes Reinecke <hare@suse.de>, michaelc@cs.wisc.edu, Mike Snitzer <snitzer@redhat.com>

Refreshed against 2.6.38 merge window commit (52cfd503ad717).
Added Hannes' Acked-by to patch 2 and 3.  Removed RFC tag from all
patches now that we have consensus.

James, it would be outstanding if we could get this squeezed in to the
2.6.38 merge.  But if not, at least getting it staged in your tree for
2.6.39 merge would be great.

The non-scsi changes _could_ go through block and DM trees
respectively but I figured it easiest to keep the patchset together in
one tree (biggest change being SCSI it seemed to make sense to push
the changes through your tree).
sense).

Please advise, thanks.
Mike

Hannes Reinecke (1):
  scsi: Detailed I/O errors

Mike Snitzer (2):
  dm mpath: propagate target errors immediately
  block: improve detail in I/O error messages

 block/blk-core.c          |   20 +++++++++++++++++---
 drivers/md/dm-mpath.c     |   11 +----------
 drivers/scsi/scsi_error.c |   24 +++++++++++++++++-------
 drivers/scsi/scsi_lib.c   |   24 ++++++++++++++++++++++--
 include/scsi/scsi.h       |    3 +++
 5 files changed, 60 insertions(+), 22 deletions(-)
-- 
1.7.3.4

