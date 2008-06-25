From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 00 of 10] SCSI Data Integrity Support
Date: Wed, 25 Jun 2008 11:22:39 -0400
Message-ID: <patchbomb.1214407359@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:41034 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758941AbYFYPZ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 11:25:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org


Another post of my SCSI DIF changes.  These patches require the block
layer integrity infrastructure in Jens' tree as well as the
scsi_data_buffer patch that's in scsi-misc already.

The complete patch series against 2.6.26rc8 is available here:

    http://oss.oracle.com/~mkp/patches/

There have been no functional changes since my last patch kit.
However, based upon feedback I have made a clearer boundary between
the scsi_host protection bits and the scsi_disk ditto.

I have also split up the changes into patches that are easier to
digest.

-- 
Martin K. Petersen	Oracle Linux Engineering


