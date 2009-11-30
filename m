From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 0/8] bfa: update bfa driver to version 2.1.2.1 (resubmit)
Date: Sun, 29 Nov 2009 17:37:38 -0800
Message-ID: <1259545058-4358-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:36866 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbZK3Bhd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2009 20:37:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

Hi James,

I went through our internal code checkin logs and bug tracker records for 2.1
driver, and here is a summary of the changes:

 - Update driver to version 2.1.2.1
 - Fixed various IOC down issues in driver and firmware.
 - IOC state machine fixes.
 - Fixed issues in IOC auto recovery.
 - Hardware/firmware related fixes.
 - FC state machine fixes.
 - Added more stats for FC and fixed issues in FCOE stats collection
 - Vport fixes.
 - Added new portlog entries for events and enhanced bfa loging.
 - Renamed port data structures to avoid confusion between driver and firmware.
 - code reorganizations and cleanups.

2.1 driver is our latest major release. The development and testing cycle has
spanned for several months, and there have been numerous checkins for both bug
fixes and cleanups. Clearly splitting them is very difficult and also
error-prone. For this reason, I still include all the changes we have made to
2.1 in one patch set instead of splitting them into multiple ones.

Going forward, the upstream driver will be in sync with our latest internal
development, so we wil be able to submit patches that are specific
to bug fixe or code cleanup.

As you suggested, this patch set is based off a combination of scsi-misc-2.6
and Linus's upstream tree, and it is intended to be include in 2.6.33 merger
window.

Thanks

Jing

Signed-off-by: Jing Huang <huangj@brocade.com>
