From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/3] qla4xxx: Update for scsi-misc
Date: Tue, 6 Mar 2012 04:16:03 -0800
Message-ID: <1331036166-19496-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:42514 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030556Ab2CFM3t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Mar 2012 07:29:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to scsi-misc for inclusion in mainline.

Vikas Chaudhary (3):
      iscsi_transport: Added error status code for ping comp event
      qla4xxx: Removed packed attr from struct iscsi_chap_rec
      qla4xxx: Update driver version to 5.02.00-k16

 drivers/scsi/qla4xxx/ql4_isr.c     |    4 ++--
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-
 include/scsi/iscsi_if.h            |   19 +++++++++++++++++--

Thanks,
Vikas.

