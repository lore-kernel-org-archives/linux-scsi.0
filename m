From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3] Split SCSI header files
Date: Tue, 7 Apr 2015 14:32:21 +0200
Message-ID: <5523CE55.3090401@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0081.outbound.protection.outlook.com ([157.56.110.81]:29280
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753018AbbDGMc2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Apr 2015 08:32:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@odin.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

Move the constants and functions that are used by both initiator and 
target code to new header files such that the target code does no longer 
have to include initiator header files.

Changes in v3 of this series compared to v2:
- Renamed scsi_lib.h into scsi_common.h.
- Added a patch for replacing MAX_COMMAND_SIZE with BLK_MAX_CDB.
- Added a patch that minimizes the include directives in target code.

Changes in v2 of this series compared to v1:
- Dropped the scsi_lun.h header file and introduced scsi_lib.h.

The patches in this series are:
0001-Split-SCSI-header-files.patch
0002-Replace-MAX_COMMAND_SIZE-with-BLK_MAX_CDB.patch
0003-target-Correct-a-comment.patch
0004-target-Minimize-SCSI-header-include-directives.patch
