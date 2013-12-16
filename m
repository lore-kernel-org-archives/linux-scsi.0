From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/24] qla4xxx: 5.04.00-k4: Updates for scsi "misc" branch
Date: Mon, 16 Dec 2013 06:49:30 -0500
Message-ID: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:55411 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754301Ab3LPMX0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to the scsi tree at your earliest convenience.
These patches are on top of other qla4xxx patch posted on list here:
http://marc.info/?l=linux-scsi&m=138511809612830&w=2

Nilesh Javali (5):
      qla4xxx: ISP8xxx: Correct retry of adapter initialization
      qla4xxx: Improve loopback failure messages
      qla4xxx: Rename ACB_STATE macros with IP_ADDRSTATE macros
      qla4xxx: Clear DDB index map upon connection close failure
      qla4xxx: Handle IPv6 AEN notifications

Tej Parkash (4):
      qla4xxx: Fixed AER reset sequence for ISP83xx/ISP84xx
      qla4xxx: Fix processing response queue during probe
      qla4xxx: Fix pending IO completion in reset path before initiating chip reset
      qla4xxx: Driver not able to collect minidump for ISP84xx

Vikas Chaudhary (15):
      qla4xxx: Print WARN_ONCE() if iSCSI function presence bit removed
      qla4xxx: Fix comments in code
      qla4xxx: Use IDC_CTRL bit1 directly instead of AF_83XX_NO_FWDUMP flag.
      qla4xxx: Correctly handle msleep_interruptible
      qla4xxx: Return correct error status from func qla4xxx_request_irqs()
      qla4xxx: Fix failure of IDC Time Extend mailbox command
      qla4xxx: Reduce rom-lock contention during reset recovery.
      qla4xxx: Fix failure of mbox 0x31
      qla4xxx: Remove unused code from qla4xxx_set_ifcb()
      qla4xxx: Updated print for device login, logout path
      qla4xxx: Update print statements in qla4xxx_mailbox_command()
      qla4xxx: Update print statements in func qla4xxx_eh_abort()
      qla4xxx: Update print statements in func qla4xxx_do_dpc()
      qla4xxx: Fix sparse warnings
      qla4xxx: Update driver version to 5.04.00-k4

Thanks,
Vikas.
