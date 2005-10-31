From: Mark Haverkamp <markh@osdl.org>
Subject: Latest update to scsi-misc-2.6
Date: Mon, 31 Oct 2005 09:13:59 -0800
Message-ID: <1130778840.24530.20.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:51686 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932486AbVJaROD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 12:14:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

James,

I updated my local scsi-misc-2.6 tree today and had merge conflicts
somehow.  The tree had not been previously locally modified and was up
to date as of last week.  I used the cg-update command to perform the
update.  After receiving the changes it got a merge conflict:

Applying changes...
Merging fe607aa94f5d25ee84f9a9a4fdf2cce3765e12e4 -> d078650986b117520f2b10cb72c04bc1904e3ba7
        to a25bbd9e2f6c6907672301fe934a8f9989e60330...
... Auto-merging drivers/scsi/scsi_scan.c
merge: warning: conflicts during merge
... Auto-merging drivers/scsi/scsi_transport_fc.c
... Auto-merging include/scsi/scsi_device.h

        Conflicts during merge. Do cg-commit after resolving them.


Generally a cg-update works fine. I'm not sure that it makes sense to
have merge conflicts without local modifications. I can just delete the
tree and re-create it from scratch, but I though that I'd ask to see if
others have seen this.

Thanks,
Mark.

-- 
Mark Haverkamp <markh@osdl.org>

