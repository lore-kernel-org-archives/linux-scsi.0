From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: [PATCH 0/7] qla4xxx: add application support
Date: Tue, 11 May 2010 01:07:56 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA870D35B7B71@AVEXMB1.qlogic.org>
References: <20100511075338.GA30442@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:10920 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab0EKIH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 May 2010 04:07:58 -0400
In-Reply-To: <20100511075338.GA30442@sles11sp1b1.qlogic.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, "james.bottomley@suse.de" <james.bottomley@suse.de>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-s>
Cc: Ravi Anand <ravi.anand@qlogic.com>

Correction in subject line

>-----Original Message-----
>From: Vikas Chaudhary [mailto:vikas.chaudhary@qlogic.com]
>Sent: Tuesday, May 11, 2010 12:54 AM
>To: james.bottomley@suse.de; michaelc@cs.wisc.edu; linux-
>scsi@vger.kernel.org
>Cc: Ravi Anand; Vikas Chaudhary
>Subject: [PATCH 0/7] qla4xxx: add application support
>
>James/Mike,
>
>Here's the list of RFC patches to enable application support for qla4xxx
>driver :
>
>Vikas Chaudhary (7)
>	iscsi_transport: add new up event for AEN.
>	iscsi_transport: Added new iscsi_host_param for iSCSI transport
>	iscsi_transport: added new iscsi_param to display target alias is
>sysfs
>	qla4xxx: added Add host attributes to export host information to
>sysfs.
>	qla4xxx: ping support via BSG interface
>	iscsi_transport: ping support via BSG
>	qla4xxx: added BSG support
>
>drivers/scsi/qla4xxx/Makefile       |    2 +-
>drivers/scsi/qla4xxx/ql4_attr.c     |  168 +++++++++++++++
>drivers/scsi/qla4xxx/ql4_def.h      |   48 +++++-
>drivers/scsi/qla4xxx/ql4_glbl.h     |   27 +++-
>drivers/scsi/qla4xxx/ql4_init.c     |    8 +-
>drivers/scsi/qla4xxx/ql4_isr.c      |    4 +
>drivers/scsi/qla4xxx/ql4_mbx.c      |  381
>++++++++++++++++++++++++++++++++++-
>drivers/scsi/qla4xxx/ql4_os.c       |  276 ++++++++++++++++++++++++-
>drivers/scsi/scsi_transport_iscsi.c |   14 +-
>include/scsi/iscsi_if.h             |   11 +
>include/scsi/scsi_bsg_iscsi.h       |   11 +
>
>Looking forward for your feedback and comments.
>
>Thanks,
>Vikas.
