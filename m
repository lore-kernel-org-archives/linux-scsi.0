From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 0 of 6] SCSI Data Integrity Support
Date: Wed, 09 Jul 2008 22:48:02 -0400
Message-ID: <patchbomb.1215658082@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:58717 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbYGJCwB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2008 22:52:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org


Another post of my SCSI DIF changes.  These patches require the block
layer integrity infrastructure in Jens' tree as well as the patches
that James took already.

The complete patch series against 2.6.26rc9 is available here:

    http://oss.oracle.com/~mkp/patches/

Changes since last post:

 - Make the distinction between DIF and DIX clearer in the scsi_host
   settings.

 - Revamp DIF/DIX negotiation to support all combinations.

 - Error handling: Correctly handle failures detected by HBA and disk
   respectively.

 - Integrate protection scsi_data_buffer allocation with the command
   pools.

 - scsi_device_protection() accessor.

 - Remove unnecessary printks at disk init time.

-- 
Martin K. Petersen	Oracle Linux Engineering


