From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 0/2] dm: Add no_abort_q feature flag to dm-mpath
Date: Mon,  3 May 2010 21:01:29 -0700
Message-ID: <1272945691-31649-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53544 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab0EDECC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 00:02:02 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e2.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o443oI24027465
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:50:18 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o44420to1396898
	for <linux-scsi@vger.kernel.org>; Tue, 4 May 2010 00:02:00 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o44420lE032503
	for <linux-scsi@vger.kernel.org>; Tue, 4 May 2010 00:02:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org

This patch series contains two patches.

1.) The first patch adds a feature flags bit field to the multipath
structure for selected features.

2.) The second patch allows a user to set a feature flag for a dm-mpath
device of "no_abort_q" to indicate that deactivate_path should not call
blk_abort_queue. I tried to select a short feature name to feature output
listed with multipath -l would not be too long "features='2 queue_if_no_path
no_abort_q'

Mike Anderson (2):
  dm: Add feature flags to dm-mpath
  dm: Add feature flag to control call to blk_abort_queue

 drivers/md/dm-mpath.c |   27 +++++++++++++++++++++++++--
 1 files changed, 25 insertions(+), 2 deletions(-)

