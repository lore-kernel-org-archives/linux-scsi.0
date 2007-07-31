From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/8] lpfc 8.2.2 : lpfc 8.2.2 patches
Date: Tue, 31 Jul 2007 21:27:11 +0000 (UTC)
Message-ID: <1186067373.14374.12.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50128 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759342AbXGaV0u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 17:26:50 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l6VLQnic028958
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2007 14:26:49 -0700 (PDT)
Date: Thu, 02 Aug 2007 11:09:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This set of patches updates the lpfc driver to revision 8.2.2.

It is mainly bug fixes, further splitting of parameters between physical
port and virtual port, and expanded debug logging.

The patches contain the following:
 - Error messages and debugfs updates
 - Fix locking around HBA's port_list
 - Attribute and Parameter splits for vport and physical port
 - Rework the lpfc_printf_log() macro so that logging is enabled on a
   per-vport basis. 
 - Miscellaneous management and logging mods:
 - Miscellaneous Bug Fixes
 - Style cleanups
 - Change version number to 8.2.2

-- james s



