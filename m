From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented and
 there's not way to prevent the kernel from using the 2nd cdb byte for the LUN
Date: Wed, 06 Aug 2014 20:09:46 +0000
Message-ID: <bug-80711-11613-spgXNeqgI3@https.bugzilla.kernel.org/>
References: <bug-80711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51466 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbaHFUJv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Aug 2014 16:09:51 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C187D20170
	for <linux-scsi@vger.kernel.org>; Wed,  6 Aug 2014 20:09:49 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E9D482017D
	for <linux-scsi@vger.kernel.org>; Wed,  6 Aug 2014 20:09:47 +0000 (UTC)
In-Reply-To: <bug-80711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=80711

--- Comment #5 from Alan Stern <stern@rowland.harvard.edu> ---
On Wed, 6 Aug 2014, Christoph Hellwig wrote:

> On Wed, Aug 06, 2014 at 03:29:47PM +0200, Douglas Gilbert wrote:
> > If not and since I'm told black lists and the like won't
> > work, my advice for the record is to use FreeBSD or Windows
> > for tools that need this capability.
> 
> I doubt either of them forces users to hack up flags for these cases.

Why was this change needed in the first place?  There's no explanation 
in the patch itself.

> At least for windows I suspect it just never sends the LUN encoded
> in the CDB and treats USB devices special instead of our insistance
> on pretending they are SCSI-2.

We no longer pretend that USB mass-storage devices have any particular 
SCSI level.  See commit 09b6b51b0b6c.

> Maybe some of the USB people have on the wire traces or access to
> device or windows documentation on this?

Most likely it varies with the version of Windows and the INQUIRY data
returned by the device.

I can obtain hardware traces for the kinds of devices and computers 
lying around here.  But what sort of combinations should I test?

Alan Stern

-- 
You are receiving this mail because:
You are the assignee for the bug.
