From: Brian King <brking@us.ibm.com>
Subject: [PATCH] IBM Power RAID driver (ipr) 2.0.6
Date: Tue, 04 May 2004 12:52:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4097D863.8040505@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:59133 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264542AbUEDRwj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 May 2004 13:52:39 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

James,

Here is the latest version of the LLD for the IBM Power RAID family of
adapters. This includes several IBM iSeries and pSeries SCSI adapters.
Please apply.

Changes since last submission include:

1. Don't run BIST at module load time since it is unnecessary and it
    increases module load time dramatically.
2. Adapter dump fixes.
3. Add adapter type and microcode version to the dump.
4. Don't zero DMA address of hostrcb during adapter reset, which was causing
    a DMA to address 0.
5. Change to use the scsi_timeout_mod patch rather than the sd_timeout_mod patch


The driver can be found at:

http://www-124.ibm.com/storageio/ipr/patch-2.6.6-rc3-ipr-2.0.6.gz

The patch to provide pci-ids can be found here:

http://www-124.ibm.com/storageio/ipr/patch-2.6.3-ipr-pci-ids

The now required scsi_timeout_mod patch can be found:

http://www-124.ibm.com/storageio/ipr/patch-2.6.6-rc3-scsi_timeout_mod


Thanks


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

