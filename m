From: madhu.iyengar@qlogic.com
Subject: [PATCH 0/5] qla2xxx: Patches for 2.6.37-rcX
Date: Tue, 23 Nov 2010 16:52:45 -0800
Message-ID: <1290559970-12123-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:59506 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754624Ab0KXBFs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2010 20:05:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

From: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

James,

Please apply these patches. These fix and/or correct critical issues
(including panics) found during recent testing.

Thanks.

Andrew Vasquez (1):
  qla2xxx: Correct issue where NPIV-config data was not being allocated
    for 82xx parts.

Madhuranath Iyengar (1):
  qla2xxx: Update version number to 8.03.05-k0.

Mike Hernandez (2):
  qla2xxx: Populate Command Type 6 LUN field properly.
  qla2xxx: Change MSI initialization from using incorrect request_irq
    parameter.

Saurav Kashyap (1):
  qla2xxx: Properly set the return value in qla2xxx_eh_abort function.

 drivers/scsi/qla2xxx/qla_def.h     |    1 -
 drivers/scsi/qla2xxx/qla_iocb.c    |    1 +
 drivers/scsi/qla2xxx/qla_isr.c     |    5 +++--
 drivers/scsi/qla2xxx/qla_nx.c      |    1 +
 drivers/scsi/qla2xxx/qla_os.c      |    3 ++-
 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 6 files changed, 9 insertions(+), 6 deletions(-)

