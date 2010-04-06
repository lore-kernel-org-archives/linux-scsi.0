From: Ravi Anand <ravi.anand@qlogic.com>
Subject: [PATCH 00/12] qla4xxx: Driver Fixes & Enablement of ISP82XX!!
Date: Tue, 6 Apr 2010 03:13:25 -0700
Message-ID: <20100406101325.GG22922@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:27515 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab0DFKPE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2010 06:15:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Here's another set of updated patches to address the comments from Mike.C 
& James. Additionally it enables the support for 10Gb iSCSI ISP82XX function.
It was generated against the latest scsi-misc tree. Please apply.

Here's the list of changes and output of diffstat ;

Ravi Anand (1):
      Adding MAINTAINERS for qla4xxx iSCSI driver.

Thanks to Randy for pointing that out in the following thread :
http://article.gmane.org/gmane.linux.scsi/57520/match=qla4xxx+randy+dunlap

Vikas Chaudhary (11):
      qla4xxx: wait for device to come online in reset_lun
      qla4xxx: added IPv6 support.
      qla4xxx: set device state as per Link UP and LINK DOWN
      qla4xxx: Code Clean up - remove "marker_needed"
      qla4xxx: Updated firmware ready timeout algorithm
      qla4xxx: fixed NULL pointer dereference in eh_device_reset
      qla4xxx: do not retry login to CHAP auth failed targets
      qla4xxx: added support for abort task management command
      qla4xxx: added srb reference counter
      qla4xxx: Added support for ISP82xx.
      qla4xxx: Update driver version to 5.02.00-k1


 MAINTAINERS                        |    8 +
 drivers/scsi/qla4xxx/Kconfig       |    4 +-
 drivers/scsi/qla4xxx/Makefile      |    2 +-
 drivers/scsi/qla4xxx/ql4_def.h     |  194 +++-
 drivers/scsi/qla4xxx/ql4_fw.h      |  190 +++-
 drivers/scsi/qla4xxx/ql4_glbl.h    |  123 ++-
 drivers/scsi/qla4xxx/ql4_init.c    |  529 ++++++--
 drivers/scsi/qla4xxx/ql4_inline.h  |    2 +-
 drivers/scsi/qla4xxx/ql4_iocb.c    |   92 ++-
 drivers/scsi/qla4xxx/ql4_isr.c     |  409 +++++-
 drivers/scsi/qla4xxx/ql4_mbx.c     |  524 ++++++--
 drivers/scsi/qla4xxx/ql4_nvram.c   |    2 +-
 drivers/scsi/qla4xxx/ql4_nvram.h   |    6 +-
 drivers/scsi/qla4xxx/ql4_nx.c      | 2555 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_nx.h      |  703 ++++++++++
 drivers/scsi/qla4xxx/ql4_os.c      | 1033 ++++++++++++----
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-
 17 files changed, 5757 insertions(+), 621 deletions(-)

Looking forward to feedback/comment.

Thanks
Ravi Anand
