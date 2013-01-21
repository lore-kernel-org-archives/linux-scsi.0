From: vikas.chaudhary@qlogic.com
Subject: [PATCH 00/10] qla4xxx: Updates for scsi "misc" branch
Date: Sun, 20 Jan 2013 23:50:55 -0500
Message-ID: <1358743865-435-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:17834 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750699Ab3AUFLj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jan 2013 00:11:39 -0500
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

Karen Higgins (2):
      qla4xxx: Remove unnecessary code from qla4xxx_init_local_data
      qla4xxx: Throttle active IOCBs to firmware limits

Manish Rangankar (2):
      qla4xxx: wait for boot target login response during probe.
      qla4xxx: Fix return code for qla4xxx_session_get_param.

Nilesh Javali (3):
      qla4xxx: Add spurious interrupt messages under debug level 2
      qla4xxx: Rename MBOX_ASTS_IDC_NOTIFY to MBOX_ASTS_IDC_REQUEST_NOTIFICATION
      qla4xxx: Quiesce driver activities while loopback

Poornima Vonti (1):
      qla4xxx: Re-register IRQ handler while retrying initialize of adapter

Vikas Chaudhary (2):
      qla4xxx: Added support for force firmware dump
      qla4xxx: Update driver version to 5.03.00-k4

