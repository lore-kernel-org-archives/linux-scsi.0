From: giridhar.malavali@qlogic.com
Subject: [PATCH 00/17] qla2xxx: fixes for 2.6.34-rcX.
Date: Fri, 28 May 2010 15:08:14 -0700
Message-ID: <1275084511-95266-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52654 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751082Ab0E1WIc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2010 18:08:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

James,

Checkpatch script flagged an error for patch 11/17, which is because of code style. 
I have not fixed to be in sync with the existing code. Please let me know whether
this needs to be fixed. I will re-submit the patch. 

Andrew Vasquez (4):
  qla2xxx: Add portid to async-request messages.
  qla2xxx: Correct async-srb issues.
  qla2xxx: Make the FC port capability mutual exclusive.
  qla2xxx: For ISP 23xx, select user specified login timeout value if
    greater than minuimum value(4 secs).

Arun Easi (1):
  qla2xxx: T10 DIF enablement for 81XX

Giridhar Malavali (7):
  qla2xxx: Clear drive active CRB register when not in use.
  qla2xxx: Fix cpu-affinity usage for non-capable ISPs.
  qla2xxx: Correct use-after-free oops seen during EH-abort.
  qla2xxx: Limit rport-flaps during link-disruptions.
  qla2xxx: Enable CRB based doorbell posting for request queue as
    default for ISP 82xx.
  qla2xxx: Removed redundant check for ISP 84xx.
  qla2xxx: Updated version number to 8.03.03-k0.

Harish Zunjarrao (1):
  qla2xxx: Support for loading Unified ROM Image (URI) format firmware
    file.

Lalit Chandivade (2):
  qla2xxx: Do not enable VP in non fabric topology.
  qla2xxx: Fix flash write failure on ISP82xx.

Santosh Vernekar (1):
  qla2xxx: Handle outstanding mbx cmds on hung f/w scenarios.

Sarang Radke (1):
  qla2xxx: Add internal loopback support for ISP81xx.

 drivers/scsi/qla2xxx/qla_attr.c    |    4 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |  196 ++++++++++++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_bsg.h     |    7 +
 drivers/scsi/qla2xxx/qla_def.h     |    9 ++
 drivers/scsi/qla2xxx/qla_gbl.h     |    6 +-
 drivers/scsi/qla2xxx/qla_init.c    |   71 ++++++++----
 drivers/scsi/qla2xxx/qla_iocb.c    |    4 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   54 ++++++---
 drivers/scsi/qla2xxx/qla_mbx.c     |  152 ++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_mid.c     |    3 +-
 drivers/scsi/qla2xxx/qla_nx.c      |  228 +++++++++++++++++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_nx.h      |   38 ++++++-
 drivers/scsi/qla2xxx/qla_os.c      |   42 ++++++-
 drivers/scsi/qla2xxx/qla_version.h |    6 +-
 14 files changed, 708 insertions(+), 112 deletions(-)

