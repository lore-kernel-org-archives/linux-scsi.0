From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/14] lpfc 8.3.0 :  Update lpfc to rev 8.3.0
Date: Fri, 5 Dec 2008 09:44:28 -0500
Message-ID: <1228488268.3927.0.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46034 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbYLEOoF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 09:44:05 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mB5Ei5fj004343
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2008 06:44:05 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update lpfc driver to revision 8.3.0

Includes the following changes :
 - Rework RSCN netlink event to send entire RSCN payload
 - Add support for Power Management Suspend/Resume operations
 - Add kernel-doc function headers to lpfc_scsi.c
 - Fix system crash due to uninitialized node access
 - Fix multiple NPIV issues
 - Added 3 small features and improve PCI EEH support
 - Don't assume HBA supports Interrupt Enable Block
 - Fix several minor issues
 - Added active interrupt test for enabling MSI/MSI-X/INTx
 - Fix some memory handling issues
 - Add BlockGuard support (T10-DIF) Part 1
 - Add BlockGuard support (T10-DIF) Part 2
 - Hook lpfc's debugfs into Kconfig
 - Update driver version to 8.3.0

James, I'm hoping this can be queued up for 2.6.29 inclusion. Patches
are cut against scsi-misc-2.6

-- james s




