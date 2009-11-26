From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Thin provisioning fixes (take 3)
Date: Thu, 26 Nov 2009 12:00:38 -0500
Message-ID: <1259254843-8326-1-git-send-email-martin.petersen__41412.6374912032$1259255040$gmane$org@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:47943 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760882AbZKZRDC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2009 12:03:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, hch@infradead.org, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.orgl

Changes since last kit:

 - Patch 1 (block): Wire up an ioctl that reports whether the
   block device zeroes after discard

 - Patch 2 (sd): Tweak max_discard_sectors reporting

 - Patch 3 (scsi, new): Retry temporary TP write errors

 - Patch 4 (libata): No change

 - Patch 5 (libata): Switch to a bytes-in, bytes-out convention
   for ata_set_lba_range_entries() to make things more clear

I think we need a bit R&D wrt. discard coalescing and I doubt
we'll have that ready for the merge window.  So I suggest we
stick with the current loop-over-max-discard-sectors approach for
2.6.32.

-- 
Martin K. Petersen      Oracle Linux Engineering


