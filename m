From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH V2 0/4] be2iscsi driver update to 10.4.200.0
Date: Sat, 20 Dec 2014 06:21:30 +0530
Message-ID: <541d1cac-0bad-4732-bb8c-e44780278acd@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:57923 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaLSIZS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Dec 2014 03:25:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: John Soni Jose <sony.john-n@emulex.com>


  The patchset updates be2iscsi driver  to 10.4.200.0.
  These patches are generated aganist the SCSI for-next branch.

  The changes suggested by Mike C is also done in this patch-set.
  Please ingnore the earlier sent patches.

John Soni Jose (4):
  be2iscsi : Fix the retry count for boot targets
  be2iscsi : Fix the PCI request region reserving.
  be2iscsi : Fix memory leak in the unload path
  be2iscsi : Bump the driver version

 drivers/scsi/be2iscsi/be_cmds.c |    4 +++
 drivers/scsi/be2iscsi/be_main.c |   53 ++++++++++++++++++++++++++++++++------
 drivers/scsi/be2iscsi/be_main.h |    6 +++-
 3 files changed, 53 insertions(+), 10 deletions(-)

