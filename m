From: Brian King <brking@us.ibm.com>
Subject: [PATCH] IBM Power RAID driver (ipr) 2.0.1
Date: Mon, 22 Mar 2004 13:59:46 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <405F45B2.2090206@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:53498 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S262370AbUCVT7z
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Mar 2004 14:59:55 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

James,

Here is the latest version of the LLD for the IBM Power RAID family of
adapters. This includes several IBM iSeries and pSeries SCSI adapters.
Please apply.

Changes since last submission include:

1. Added MODULE_VERSION
2. Properly set QAS bits in adapter configuration
3. Changed pci_map_single to use request_buffer rather than buffer
4. Fix to not call scsi_add_device/scsi_remove_device at module load time
    to prevent deadlock from occurring.
5. Use resource address instead of resource handle in configuration change
    processing. Fixes hot spare takeover bug.
6. Allow all disks to be automatically restarted by the midlayer.
7. Be less verbose for log_level < 2.


The driver can be found at:

http://www-124.ibm.com/storageio/ipr/patch-2.6.5-rc2-ipr-2.0.1.gz

The patch to provide pci-ids can be found here:

http://www-124.ibm.com/storageio/ipr/patch-2.6.3-ipr-pci-ids


Thanks


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

