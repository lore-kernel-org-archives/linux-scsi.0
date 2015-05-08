From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v4 0/5] Split SCSI header files
Date: Fri, 8 May 2015 10:06:17 +0200
Message-ID: <554C6E79.7020501@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0053.outbound.protection.outlook.com ([157.56.111.53]:17504
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750994AbbEHIGZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 May 2015 04:06:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@odin.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

Move the constants and functions that are used by both initiator and 
target code to new header files such that the target code does no longer 
have to include initiator header files.

Changes in v4 of this series compared to v3:
- Split the first patch of this series into two patches as proposed
   by Christoph.

Changes in v3 of this series compared to v2:
- Renamed scsi_lib.h into scsi_common.h.
- Added a patch for replacing MAX_COMMAND_SIZE with BLK_MAX_CDB.
- Added a patch that minimizes the include directives in target code.

Changes in v2 of this series compared to v1:
- Dropped the scsi_lun.h header file and introduced scsi_lib.h.

The patches in this series are:
0001-Split-SCSI-header-files.patch
0002-Move-code-that-is-used-both-by-initiator-and-target-.patch
0003-Replace-MAX_COMMAND_SIZE-with-BLK_MAX_CDB.patch
0004-target-Correct-a-comment.patch
0005-target-Minimize-SCSI-header-include-directives.patch
