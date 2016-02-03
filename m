From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH 0/6] ibmvscsi: code cleanup
Date: Wed,  3 Feb 2016 17:28:28 -0600
Message-ID: <1454542114-1797-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:39866 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933276AbcBCX3J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2016 18:29:09 -0500
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
	Wed, 3 Feb 2016 16:29:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, hare@suse.de, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

Fixed up a couple spots that were out of line with the PAPR in regards
to its defined VSCSI protocol. Did away with some magic numbers directly
in the code. Fixed a minor endian issue.

Tyrel Datwyler (6):
  ibmvscsi: Correct values for several viosrp_crq_format enums
  ibmvscsi: Add and use enums for valid CRQ header values
  ibmvscsi: Replace magic values in set_adpater_info() with defines
  ibmvscsi: Use of_root to access OF device tree root node
  ibmvscsi: Remove unsupported host config MAD and sysfs interface
  ibmvscsi: Add endian conversions to sysfs attribute show functions

 drivers/scsi/ibmvscsi/ibmvscsi.c | 117 +++++++--------------------------------
 drivers/scsi/ibmvscsi/viosrp.h   |  20 ++++---
 2 files changed, 30 insertions(+), 107 deletions(-)

-- 
2.5.0

