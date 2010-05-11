From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 1/7] qla4xxx: add application support
Date: Tue, 11 May 2010 13:23:39 +0530
Message-ID: <20100511075338.GA30442@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:23596
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1755202Ab0EKH5k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 May 2010 03:57:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com

James/Mike,

Here's the list of RFC patches to enable application support for qla4xxx driver :

Vikas Chaudhary (7)
	iscsi_transport: add new up event for AEN.
	iscsi_transport: Added new iscsi_host_param for iSCSI transport
	iscsi_transport: added new iscsi_param to display target alias is sysfs
	qla4xxx: added Add host attributes to export host information to sysfs.
	qla4xxx: ping support via BSG interface
	iscsi_transport: ping support via BSG
	qla4xxx: added BSG support

drivers/scsi/qla4xxx/Makefile       |    2 +-
drivers/scsi/qla4xxx/ql4_attr.c     |  168 +++++++++++++++
drivers/scsi/qla4xxx/ql4_def.h      |   48 +++++-
drivers/scsi/qla4xxx/ql4_glbl.h     |   27 +++-
drivers/scsi/qla4xxx/ql4_init.c     |    8 +-
drivers/scsi/qla4xxx/ql4_isr.c      |    4 +
drivers/scsi/qla4xxx/ql4_mbx.c      |  381 ++++++++++++++++++++++++++++++++++-
drivers/scsi/qla4xxx/ql4_os.c       |  276 ++++++++++++++++++++++++-
drivers/scsi/scsi_transport_iscsi.c |   14 +-
include/scsi/iscsi_if.h             |   11 +
include/scsi/scsi_bsg_iscsi.h       |   11 +

Looking forward for your feedback and comments.

Thanks,
Vikas.
