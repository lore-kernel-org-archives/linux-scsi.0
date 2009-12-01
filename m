From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 0/1] libosd bug fixing
Date: Tue, 01 Dec 2009 17:30:04 +0200
Message-ID: <4B15367C.9040405@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:46394 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751898AbZLAP36 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2009 10:29:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Vineet Agarwal <checkout.vineet@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>


James hi.

Users have found an annoying bug in latest osd/exofs code. Actually this
deficiency exists for a long time, but only most recent exofs code has
exposed it.

Please include the fix to the patches queued for 2.6.33. No need for it
to go into stable as current users will not hit it.

[PATCH 1/1] libosd: Fix blk_put_request locking again

Vineet Please test this new patch, the previous fix was crap

Thanks
Boaz

