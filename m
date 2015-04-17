From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 0/7] be2iscsi driver update to 10.6.0.0
Date: Fri, 17 Apr 2015 14:58:35 +0530
Message-ID: <05e2a6e6-5c8c-40de-b4c7-b5bd73296db9@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:54789 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbbDPRKH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 13:10:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: John Soni Jose <sony.john-n@emulex.com>

 The patchset updates be2iscsi driver to 10.6.0.0 version.
 These patches are generated aganist scsi for-next branch

John Soni Jose (7):
  be2iscsi : Fix the retry count for boot targets
  be2iscsi : Fix the PCI request region reserving.
  be2iscsi : Fix memory leak in the unload path
  be2iscsi : Fix memory check before unmapping.
  be2iscsi : Update the copyright year
  be2iscsi: Logout of FW Boot Session
  be2iscsi : Bump the driver version

 drivers/scsi/be2iscsi/be.h       |    2 +-
 drivers/scsi/be2iscsi/be_cmds.c  |    6 ++-
 drivers/scsi/be2iscsi/be_cmds.h  |   14 ++++++-
 drivers/scsi/be2iscsi/be_iscsi.c |   14 ++++++-
 drivers/scsi/be2iscsi/be_iscsi.h |    2 +-
 drivers/scsi/be2iscsi/be_main.c  |   76 +++++++++++++++++++++++++++++---------
 drivers/scsi/be2iscsi/be_main.h  |   10 ++++-
 drivers/scsi/be2iscsi/be_mgmt.c  |   72 +++++++++++++++++++++++++++++++++++-
 drivers/scsi/be2iscsi/be_mgmt.h  |    5 ++-
 9 files changed, 175 insertions(+), 26 deletions(-)

-- 
1.7.9.5

