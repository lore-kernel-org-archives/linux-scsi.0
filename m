From: Brian King <brking@us.ibm.com>
Subject: [PATCH] IBM Power RAID driver (ipr) 2.0.2
Date: Thu, 08 Apr 2004 13:35:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40759B79.7050807@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:11472 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S262215AbUDHSfo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2004 14:35:44 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

James,

Here is the latest version of the LLD for the IBM Power RAID family of
adapters. This includes several IBM iSeries and pSeries SCSI adapters.
Please apply.

Changes since last submission include:

1. Stop modifying the mid-layer's timers.
2. If abort task times out, issue bus reset.
3. Use pci_dma_mapping_error instead of pci_dma_error.
4. Set .module in host template so module refcounting is accurate.
5. Setup rw_timeout in scsi_device struct for disk array devices
     - requires sd_timeout_mod patch below.

The driver can be found at:

http://www-124.ibm.com/storageio/ipr/patch-2.6.5-ipr-2.0.2.gz

The patch to provide pci-ids can be found here:

http://www-124.ibm.com/storageio/ipr/patch-2.6.3-ipr-pci-ids

The now required sd_timeout_mod patch can be found:

http://www-124.ibm.com/storageio/ipr/patch-2.6.5-sd_timeout_mod


Thanks


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center


