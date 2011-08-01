From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/8] qla4xxx feature update
Date: Mon, 1 Aug 2011 03:26:11 -0700
Message-ID: <1312194379-9241-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:40057 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab1HAKfq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2011 06:35:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Following patches are made over scsi-misc and Mike Christie's patchset
posted here: http://marc.info/?l=linux-scsi&m=131161955801957&w=2

Harish Zunjarrao (3):
	qla4xxx: Code cleanup for read/update flash using BSG
	qla4xxx: Add get ACB state support using BSG
	qla4xxx: Add read/update NVRAM support for 40xx adapters using BSG

Vikas Chaudhary (5):
	scsi_transport_iscsi: Added support to update mtu
	qla4xxx: Added support to update mtu
	qla4xxx: Added vendor specific sysfs attributes
	scsi_transport_iscsi: Added support to update initiator iscsi port
	qla4xxx: added support to update initiator iscsi port

drivers/scsi/qla4xxx/ql4_attr.c     |   76 ++++++++
drivers/scsi/qla4xxx/ql4_bsg.c      |  331 +++++++++++++++++++++++++++--------
drivers/scsi/qla4xxx/ql4_bsg.h      |    3 +
drivers/scsi/qla4xxx/ql4_def.h      |   17 ++
drivers/scsi/qla4xxx/ql4_fw.h       |    5 +
drivers/scsi/qla4xxx/ql4_glbl.h     |    6 +
drivers/scsi/qla4xxx/ql4_init.c     |   21 +++
drivers/scsi/qla4xxx/ql4_mbx.c      |   79 +++++++++
drivers/scsi/qla4xxx/ql4_nx.c       |    5 +
drivers/scsi/qla4xxx/ql4_os.c       |   31 ++++
drivers/scsi/scsi_transport_iscsi.c |    8 +
include/scsi/iscsi_if.h             |    2 +


Thanks,
Vikas.

