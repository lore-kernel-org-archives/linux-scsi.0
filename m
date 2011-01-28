From: madhu.iyengar@qlogic.com
Subject: [PATCH 0/3] qla2xxx: Patches for 2.6.38-rcx
Date: Fri, 28 Jan 2011 15:17:54 -0800
Message-ID: <1296256677-11572-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:59071 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752706Ab1A1XeD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 18:34:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

From: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

James,

Please apply these patches. Thanks.

Andrew Vasquez (1):
  qla2xxx: Remove check to return DID_NO_CONNECT when FC device is
    lost.

Madhuranath Iyengar (2):
  qla2xxx: Change from irq to irqsave with host_lock
  qla2xxx: Update version number to 8.03.06-k0.

 drivers/scsi/qla2xxx/qla_attr.c    |    5 +++--
 drivers/scsi/qla2xxx/qla_init.c    |   10 ++++++----
 drivers/scsi/qla2xxx/qla_os.c      |    6 +++---
 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 4 files changed, 14 insertions(+), 11 deletions(-)

