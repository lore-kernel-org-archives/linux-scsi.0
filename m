From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/10] lpfc 8.2.4 : lpfc 8.2.4 patches
Date: Fri, 11 Jan 2008 01:52:28 -0500
Message-ID: <1200034348.27954.13.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51489 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYAKGwe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jan 2008 01:52:34 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m0B6qUxI021621
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jan 2008 22:52:32 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This set of patches updates the lpfc driver to revision 8.2.4

All bug fixes are targeted for 2.6.25. Patches cut against scsi-misc-2.6

- Miscellaneous Discovery/ELS Fixes
- Correct Abort handler logic.
- Add parameters to enable and disable heartbeat and hba resets
- Miscellaneous Fixes
- Make lpfc legacy I/O port free
- Made link speed and link topology modifiable via sysfs
- Make scatter gather Segment Count into a module parameter.
- Fix Drivers Unsolicited CT command handling - we did not handle multiframe
  sequences well.
- Fix error due to delay in replenishing buffers for unsolicited data.
- Enhance debugfs to dump HBA SLIM as well as Host SLIM
- Rework misplaced reference taking on node structure 
- Update lpfc driver version to 8.2.4

-- james s



