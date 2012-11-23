From: vikas.chaudhary@qlogic.com
Subject: [PATCH 0/5] qla4xxx: Updates for scsi "misc" branch
Date: Fri, 23 Nov 2012 06:58:37 -0500
Message-ID: <1353671922-19090-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:7839 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753452Ab2KWMRM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Nov 2012 07:17:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to the scsi tree at your earliest
convenience.

Thanks,
Vikas.

Harish Zunjarrao (1):
      qla4xxx: Allow reset in link down case

Manish Rangankar (2):
      qla4xxx: Fix memory corruption issue in qla4xxx_get_ep_fwdb.
      scsi_transport_iscsi: export iscsi class session's target_id in sysfs.

Vikas Chaudhary (2):
      qla4xxx: Fix MBOX intr switching from polling to intr mode for ISP83XX
      qla4xxx: Update driver version to 5.03.00-k2

