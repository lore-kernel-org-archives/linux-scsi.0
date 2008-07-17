From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 0 of 6] SCSI Data Integrity Support
Date: Thu, 17 Jul 2008 04:28:29 -0400
Message-ID: <patchbomb.1216283309@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:35750 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbYGQIft (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2008 04:35:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org


These patches are against Linus' current git tree which now has all of
the block layer data integrity code + the preparatory SCSI bits.

Changes since last post:

 - Fixed a bug in error handling when HBA detected an integrity error.

 - Introduced prot_type in scsi_cmnd which informs the HBA of the
   target type.  This is necessary because the HBA needs to know which
   fields in the protection information to check and that depends on
   the target type.

-- 
Martin K. Petersen	Oracle Linux Engineering


