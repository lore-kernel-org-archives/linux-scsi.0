From: Matthew Wilcox <matthew@wil.cx>
Subject: advansys update 2007-07-27
Date: Fri, 27 Jul 2007 07:40:38 -0600
Message-ID: <20070727134038.GC21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56775 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbXG0Nkk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 09:40:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


OK, here's a list of the changes I've made since yesterday.  I'll try
to get git-send-email to cooperate with me this time to not break the
threading.  Patches also available from
http://www.kernel.org/pub/linux/kernel/people/willy/advansys-2007-07-27/

 - move hunk to change the parameter name of advansys_release into
   "Large uninteresting patch" where it belongs
 - Combine "restructure error handling in advansys_board_found",
   "split advansys_init_wide_chip() out of advansys_board_found()"
   and the part of "Move to scsi hotplug initialisation model" that
   deals with moving the memory freeing on error around into one patch
   "Make advansys_board_found a little more readable"
 - turn share_irq into a flag instead of a boolean
 - Merge "remove detect_called" patch into "scsi hotplug initialisation"
 - convert to new SCSI API before converting to new PCI API
 - return error from pci_enable_device to caller of advansys_pci_probe
 - tab-align advansys_pci_driver
 - Move creation of advansys_remove from EISA patch to PCI patch
 - Check for EISA kzalloc failure
 - kfree EISA data in advansys_eisa_remove
 - tab-align advansys_eisa_driver
 - change order of calls to pci_request_region and pci_enable_device
 - Add patch to delete ASC_IOADR_* defines
 - Add patch to move docs to Documentation/scsi/advansys.txt
 - Add patch to improve the interrupt handler
 - Add patch to kill asc_host array

Not done:
 - setting drvdata to NULL on exit
 - not calling pci_unregister_driver if pci_register_driver failed
 - (ditto eisa)

Any other comments not addressed here I overlooked, or were debated
and proved to not be an issue, or are obsolete given some of the other
changes.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
