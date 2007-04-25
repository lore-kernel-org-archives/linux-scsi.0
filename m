From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/16] lpfc 8.1.12 :  lpfc 8.1.12 patches
Date: Wed, 25 Apr 2007 09:51:10 -0400
Message-ID: <1177509070.23155.7.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51505 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031000AbXDYNvL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2007 09:51:11 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3PDpAH1006431
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2007 06:51:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update lpfc driver to revision 8.1.12

Changes:
 - Misc bug fixes and code cleanup
 - Modify ELS abort handling to prevent double completion
 - Rework offline path to solve HBA reset issues
 - Fix unlock inside list traversal.
 - Reorganize lpfc_nlp_list() and callers to prepare for nodelist simplification
 - Round 2 of Miscellaneous fixes:
 - Fixed recovery of rport after race with dev_loss_tmo
 - Improve diagnostic messages and change local loopback message to KERN_INFO
 - Improve handling of failed ELS aborts.
 - Reference count node structures for node lifetime management.
 - Collapse discovery lists to a single node list.
 - Don't process ERATT interrupts when issuing KILL_BOARD mbx command
 - Add support for async scanning
 - Added support for 8G speed and new HBAs.
 - Update copyright year to 2007
 - Change version number to 8.1.12

-- james s


