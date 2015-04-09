From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 00/14] qla2xxx: Patches for scsi "misc" branch.
Date: Thu, 9 Apr 2015 14:59:54 -0400
Message-ID: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:52087 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933363AbbDITlh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2015 15:41:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches to the scsi tree at your earliest
convenience for inclusion in the next mainline merge window.

Thanks,
Himanshu

Andrew Vasquez (1):
  qla2xxx: Add serdes read/write support for ISP27XX

Chad Dupuis (1):
  qla2xxx: Increase the wait time for firmware to be ready for P3P.

Himanshu Madhani (8):
  qla2xxx: Fix warnings reported by static checker.
  qla2xxx: Fix crash due to wrong casting of reg for ISP27XX.
  qla2xxx: Add message for sucessful FW dump collected for ISP27XX.
  qla2xxx: Add udev notification to save fw dump for ISP27XX
  qla2xxx: Add debugging info for MBX timeout.
  qla2xxx: Disable Interrupt handshake for ISP27XX.
  qla2xxx: Prevent multiple firmware dump collection for ISP27XX.
  qla2xxx: Update driver version to 8.07.00.18-k

Nigel Kirkland (1):
  qla2xxx: Fix beacon blink for ISP27XX.

Sawan Chandak (3):
  qla2xxx: Add support to load firmware from file for ISP 26XX/27XX.
  qla2xxx: Fix virtual port configuration, when switch port is
    disabled/enabled.
  qla2xxx: Restore physical port WWPN only, when port down detected for
    FA-WWPN port.

 drivers/scsi/qla2xxx/Kconfig       |    3 +
 drivers/scsi/qla2xxx/qla_dbg.c     |    6 +-
 drivers/scsi/qla2xxx/qla_def.h     |   16 +++++---
 drivers/scsi/qla2xxx/qla_init.c    |   75 ++++++++++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_isr.c     |   17 +++++++-
 drivers/scsi/qla2xxx/qla_mbx.c     |   31 ++++++++++++--
 drivers/scsi/qla2xxx/qla_mid.c     |   22 +++++++----
 drivers/scsi/qla2xxx/qla_os.c      |    3 +
 drivers/scsi/qla2xxx/qla_sup.c     |   11 +++--
 drivers/scsi/qla2xxx/qla_tmpl.c    |   15 +++++++-
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 11 files changed, 158 insertions(+), 43 deletions(-)

-- 
1.7.7

