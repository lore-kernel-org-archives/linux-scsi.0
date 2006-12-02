From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/9] lpfc 8.1.11 :  lpfc 8.1.11 patches
Date: Sat, 02 Dec 2006 13:40:43 -0500
Message-ID: <1165084843.27443.31.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:58071 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1759469AbWLBQHK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Dec 2006 11:07:10 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id kB2G71av009324
	for <linux-scsi@vger.kernel.org>; Sat, 2 Dec 2006 08:07:09 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.1.11.

The patches address the following items:
 - Discovery Fixes
 - Fix lpfc_multi_ring_support.
 - Fix Memory leaks
 - Adjust LOG_FCP logging to be more meaningful.
 - Add MSI (Message Signalled Interrupts) support
 - Removed decoding of PCI Subsystem Id.
 - Add soft_wwnn sysfs attribute, rename soft_wwn_enable
 - Misc Fixes
 - Change version number to 8.1.11


-- james s




