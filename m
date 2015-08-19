From: John Soni Jose <sony.john@avagotech.com>
Subject: [PATCH 0/2] be2iscsi driver update to 10.6.0.1
Date: Thu, 20 Aug 2015 04:44:29 +0530
Message-ID: <1440026071-27748-1-git-send-email-sony.john@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:50757 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753261AbbHSGtL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Aug 2015 02:49:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: John Soni Jose <sony.john@avagotech.com>

This patch is generated against the for-next branch.

John Soni Jose (1):
  be2iscsi: Bump the driver version

John Soni Jose (1):
  be2iscsi: Fix updating the next pointer during WRB posting

 drivers/scsi/be2iscsi/be_main.c |   62 +++++++++++++++++++++++++++++---------
 drivers/scsi/be2iscsi/be_main.h |    7 ++--
 drivers/scsi/be2iscsi/be_mgmt.c |   24 ++++++++++++--
 drivers/scsi/be2iscsi/be_mgmt.h |    7 +++-
 4 files changed, 76 insertions(+), 24 deletions(-)

