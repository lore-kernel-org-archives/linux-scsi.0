From: Ketan Mukadam <ketan.mukadam@avagotech.com>
Subject: [PATCH 0/2] be2iscsi : Revert ownership and update MAINTAINER
Date: Sat,  4 Jul 2015 04:12:08 +0530
Message-ID: <1435963328-29071-1-git-send-email-ketan.mukadam@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:55858 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754515AbbGCGQc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2015 02:16:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Ketan Mukadam <ketan.mukadam@avagotech.com>

Revert the ownership to Emulex and update the MAINTAINER for be2iscsi

Ketan Mukadam (2):
  MAINTAINERS: Update MAINTAINER list
  be2iscsi: Revert ownership to Emulex

 MAINTAINERS                      | 4 ++--
 drivers/scsi/be2iscsi/Kconfig    | 4 ++--
 drivers/scsi/be2iscsi/Makefile   | 2 +-
 drivers/scsi/be2iscsi/be.h       | 4 ++--
 drivers/scsi/be2iscsi/be_cmds.c  | 4 ++--
 drivers/scsi/be2iscsi/be_cmds.h  | 4 ++--
 drivers/scsi/be2iscsi/be_iscsi.c | 4 ++--
 drivers/scsi/be2iscsi/be_main.c  | 8 ++++----
 drivers/scsi/be2iscsi/be_main.h  | 6 +++---
 drivers/scsi/be2iscsi/be_mgmt.c  | 4 ++--
 drivers/scsi/be2iscsi/be_mgmt.h  | 4 ++--
 11 files changed, 24 insertions(+), 24 deletions(-)

-- 
1.8.3.1

