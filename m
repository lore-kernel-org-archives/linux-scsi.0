From: James.Smart@Emulex.Com
Subject: [PATCH 0/11]  lpfc 8.1.1 driver updates
Date: Mon, 28 Nov 2005 11:40:57 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C44@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:25589 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751287AbVK1QlI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 11:41:08 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id jASGf0s3014080
	for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2005 08:41:00 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com


This patchset updates the lpfc driver to revision 8.1.1, which includes
the following changes:

 - Miscellaneous Cleanups
 - Correct some 8bit to 16bit field conversions/comparisons
 - Fixes for short cable pulls
 - Adjust use of scsi_block_requests and interaction w/ FC transport
 - Remove locking wrappers around error handlers
 - Fixes to error handlers
 - Add support for more members of the Light Pulse 11xxx (4Gb) family
 - Bring model descriptions in sync with Emulex standard generic names.
 - Add polled-mode support
 - Added code to adjust lun queue depth to avoid target overloading.
 - Change version number to 8.1.1


-- james s
