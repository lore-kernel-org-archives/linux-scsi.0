From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: 4.4 regression/bisected: error message due to "block/sd: Fix
 device-imposed transfer length limits"
Date: Wed, 13 Jan 2016 14:15:12 +0100
Message-ID: <56964DE0.60407@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:60280 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730AbcAMNPS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2016 08:15:18 -0500
Received: from localhost
	by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <borntraeger@de.ibm.com>;
	Wed, 13 Jan 2016 13:15:17 -0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

Martin,

with 4.4 I get messages like

device-mapper: table: 253:4: adding target device sdq caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=0

when I use device mapper multipath on a scsi disk on a FlashSystem-9840 scsi disk.
The disk has a quite interesting layout (physical block size=4k, logical=512)

blockdev --getbsz /dev/sdq
4096
blockdev --getss /dev/sdq
512
blockdev --getpbsz /dev/sdq
4096

the disks seems to work ok, though.
Any ideas?

Christian

