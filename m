From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 0/4] be2iscsi driver update to 10.4.200.0
Date: Wed, 17 Dec 2014 08:03:09 +0530
Message-ID: <ea43e0f7-3e87-46f1-9644-dc6fd1905644@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:28216 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaLPKHI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Dec 2014 05:07:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: John Soni Jose <sony.john-n@emulex.com>

 The patchset updates be2iscsi driver  to 10.4.200.0.
 These patches are generated aganist the SCSI for-next branch.

John Soni Jose (4):
  be2iscsi : Fix the retry count for boot targets
  be2iscsi : Fix the PCI request region reserving. Reserve the device
    PCI I/O and Memory resources.
  be2iscsi : Fix memory leak in the unload path
  be2iscsi : Bump the driver version

 drivers/scsi/be2iscsi/be_cmds.c |    4 +++
 drivers/scsi/be2iscsi/be_main.c |   53 ++++++++++++++++++++++++++++++++------
 drivers/scsi/be2iscsi/be_main.h |    6 +++-
 3 files changed, 53 insertions(+), 10 deletions(-)

