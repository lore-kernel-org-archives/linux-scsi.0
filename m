From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH V2 0/7] be2iscsi driver update to 10.6.0.0
Date: Sat, 25 Apr 2015 08:16:41 +0530
Message-ID: <f80de952-8450-451e-a62f-ae6baf931c6e@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:16283 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbbDXKWP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2015 06:22:15 -0400
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
  be2iscsi : Logout of FW Boot Session
  be2iscsi : Bump the driver version

 drivers/scsi/be2iscsi/be.h       |    2 +-
 drivers/scsi/be2iscsi/be_cmds.c  |    6 ++-
 drivers/scsi/be2iscsi/be_cmds.h  |   14 ++++++-
 drivers/scsi/be2iscsi/be_iscsi.c |    2 +-
 drivers/scsi/be2iscsi/be_iscsi.h |    2 +-
 drivers/scsi/be2iscsi/be_main.c  |   78 +++++++++++++++++++++++++++++--------
 drivers/scsi/be2iscsi/be_main.h  |    8 +++-
 drivers/scsi/be2iscsi/be_mgmt.c  |   71 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/be2iscsi/be_mgmt.h  |    5 ++-
 9 files changed, 162 insertions(+), 26 deletions(-)

