From: vikas.chaudhary@qlogic.com
Subject: [PATCH 00/13] qla4xxx: Updates for scsi "misc" branch
Date: Thu, 20 Sep 2012 07:35:00 -0400
Message-ID: <1348140913-11828-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:45702 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754042Ab2ITLxE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2012 07:53:04 -0400
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

Manish Dusane (2):
      qla4xxx: Added new mbox cmd to pass driver version to FW
      qla4xxx: Fix double clearing of risc_intr for ISP83XX

Nilesh Javali (1):
      qla4xxx: IDC implementation for Loopback

Poornima Vonti (2):
      qla4xxx: Fix double IDC locking in qla4_8xxx_error_recovery
      qla4xxx: Fail probe_adapter if IRQ allocation fails

Tej Parkash (1):
      qla4xxx: Disable generating pause frames for ISP83XX

Vikas Chaudhary (7):
      qla4xxx: Print correct IDC version
      qla4xxx: Clear interrupt while unloading driver for ISP83XX
      qla4xxx: Update idc reg in case of PCI AER
      qla4xxx: Prevent MSI/MSI-X falling back to INTx for ISP82XX
      qla4xxx: Fix panic while rmmod
      qla4xxx: update LICENSE.qla4xxx
      qla4xxx: Update driver version to 5.03.00-k1

