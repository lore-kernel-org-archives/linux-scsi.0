From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH  00/14] qla2xxx: Patches for scsi "misc" branch.
Date: Tue, 4 Aug 2015 13:37:50 -0400
Message-ID: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:19969 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753353AbbHDSXw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2015 14:23:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James, Christoph,

Please apply the following patches to the scsi tree, misc branch at your
earliest convenience.

Thanks,
-Himanshu

Arun Easi (1):
  qla2xxx: Fix missing device login retries.

Chad Dupuis (3):
  qla2xxx: Do not reset adapter if SRB handle is in range.
  qla2xxx: Do not reset ISP for error entry with an out of range
    handle.
  qla2xxx: Remove decrement of sp reference count in abort handler.

Himanshu Madhani (2):
  qla2xxx: do not clear slot in outstanding cmd array
  qla2xxx: Update driver version to 8.07.00.26-k

Hiral Patel (1):
  qla2xxx: Do not crash system for sp ref count zero

Joe Carnuccio (4):
  qla2xxx: Add serdes register read/write support for ISP25xx.
  qla2xxx: Handle AEN8014 incoming port logout.
  qla2xxx: Use ssdid to gate semaphore manipulation.
  qla2xxx: Pause risc before manipulating risc semaphore.

Saurav Kashyap (1):
  qla2xxx: Add adapter checks for FAWWN functionality.

Sawan Chandak (2):
  qla2xxx: Add support to show MPI and PEP FW version for ISP27xx.
  qla2xxx: Add pci device id 0x2261.

 drivers/scsi/qla2xxx/qla_attr.c    |   19 ++++++++++-
 drivers/scsi/qla2xxx/qla_dbg.c     |    4 +-
 drivers/scsi/qla2xxx/qla_def.h     |    9 ++++-
 drivers/scsi/qla2xxx/qla_init.c    |    7 +++-
 drivers/scsi/qla2xxx/qla_isr.c     |   63 +++++++++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_mbx.c     |   49 ++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_os.c      |   35 ++++++++++----------
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 8 files changed, 127 insertions(+), 61 deletions(-)

-- 
1.7.7

