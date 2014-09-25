From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 00/35] qla2xxx: Patches for 3.18 scsi "misc" branch.
Date: Thu, 25 Sep 2014 05:16:31 -0400
Message-ID: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:1937 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752993AbaIYJvV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James, Christoph,

Please apply the following patches to the scsi tree, misc branch  at your
earliest convenience. This patch set is rebased on drivers-for-3.18 branch of
git://git.infradead.org/users/hch/scsi-queue.git.

Thanks,
~Saurav

Alex Vechersky (1):
  qla2xxx: Add missing ISP27xx checks to optrom code.

Arun Easi (1):
  qla2xxx: Unload of qla2xxx driver crashes the machine.

Chad Dupuis (6):
  qla2xxx: Enable fast flash access for ISP83xx.
  qla2xxx: Force use of mailbox interface for flash access commands for
    ISP27xx.
  qla2xxx: Honor FCP_RSP retry delay timer field.
  qla2xxx: Mark port lost when we receive an RSCN for it.
  qla2xxx: Disable PCI device in shutdown handler.
  qla2xxx: Fail adapter initialization on load ram failure.

Himanshu Madhani (6):
  qla2xxx: Add FDMI-2 functionality.
  qla2xxx: Fix driver version string message.
  qla2xxx: Allow user to change ql2xfdmienable value.
  qla2xxx: Enable diagnostic port using NVRAM parameters.
  qla2xxx: Disable laser for ISP2031 while unloading driver.
  qla2xxx: Restore WWPN in case of Loop Dead.

Jan Kulich (1):
  qla2xxx: ISPFx00 unexpected resets during adapter boot sequence.

Joe Carnuccio (15):
  qla2xxx: ISP27xx add tests for incomplete template.
  qla2xxx: ISP27xx optimize fwdump entry table lookup.
  qla2xxx: ISP27xx fwdump template remove high frequency debug logs.
  qla2xxx: ISP27xx fwdump template fix insertbuf() routine.
  qla2xxx: Add ISP27xx fwdump template entry T275 (insert buffer).
  qla2xxx: Add endianizer to max_payload_size modifier.
  qla2xxx: ISP25xx multiqueue shadow register crash fix.
  qla2xxx: ISP27xx fwdump template error print simplification.
  qla2xxx: Fix potential return count bug in qla2xxx_get_vpd_field().
  qla2xxx: ISPFX00 avoid writing semaphore register in request_irqs().
  qla2xxx: Incorrect debug level on mailbox command print 0x1111.
  qla2xxx: Incorrect linked list semantic in qlafx00_get_fcport().
  qla2xxx: Add FA-WWN functionality.
  qla2xxx: Add diagnostic port functionality.
  qla2xxx: Fix sparse warning in qla_iocb.c file.

Nigel Kirkland (1):
  qla2xxx: Free sysfs attributes for ISP27xx.

Quinn Tran (1):
  qla2xxx: Declaration error cause stack corruption.

Saurav Kashyap (1):
  qla2xxx: Update the driver version to 8.07.00.16-k.

Sawan Chandak (2):
  qla2xxx: Add fix in driver unload for pending activity.
  qla2xxx: Move warning message to debug level.

 drivers/scsi/qla2xxx/qla_attr.c    |   16 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |    2 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |   26 +-
 drivers/scsi/qla2xxx/qla_def.h     |  167 ++++++-
 drivers/scsi/qla2xxx/qla_fw.h      |    8 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |    4 +-
 drivers/scsi/qla2xxx/qla_gs.c      |  943 +++++++++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_init.c    |   37 +-
 drivers/scsi/qla2xxx/qla_inline.h  |    8 +
 drivers/scsi/qla2xxx/qla_iocb.c    |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   52 ++-
 drivers/scsi/qla2xxx/qla_mbx.c     |   41 ++-
 drivers/scsi/qla2xxx/qla_mid.c     |    2 +
 drivers/scsi/qla2xxx/qla_mr.c      |   14 +-
 drivers/scsi/qla2xxx/qla_nx.c      |    2 +-
 drivers/scsi/qla2xxx/qla_os.c      |   68 +++-
 drivers/scsi/qla2xxx/qla_sup.c     |    7 +-
 drivers/scsi/qla2xxx/qla_tmpl.c    |  106 ++---
 drivers/scsi/qla2xxx/qla_tmpl.h    |    8 +
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 20 files changed, 1241 insertions(+), 274 deletions(-)

-- 
1.7.7

