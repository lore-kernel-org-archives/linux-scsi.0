From: wenxiong@vmlinux.vnet.ibm.com
Subject: [PATCH RESEND 0/7] New CCINs and several patches for new improvement
Date: Wed, 12 Mar 2014 16:08:45 -0500
Message-ID: <20140312210845.384489953@vmlinux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:60414 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752494AbaCLVMK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2014 17:12:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, bjking1@us.ibm.com

Hi James,

I re-submitted the following patches for ipr device driver. I have re-tested
these patches with our latest adapters.

These patches are:

(1)Remove extended delay bit on GSCSI reads/writes ops.
(2)Add new device id to support Z06 LTD new adapter.
(3)Handle early EEH.
Above 3 patches were submitted on 1/21.

(4)Get rid of superfluous call to pci_disable_msi/msix()
(5)Use pci_enable_msi_range()/pci_enable_msix_range()
Above 2 patches were submiited by Alexander Gordeev

(6)Format HACM overlay ID 0x21.
(7)Add new device id to support Grand Canyon adapters.
Above patches were submitted on 2/15/2014

Let me know if you have questions about this.

Thanks for your help!
Wendy
-- 
