From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented and
 there's not way to prevent the kernel from using the 2nd cdb byte for the LUN
Date: Wed, 06 Aug 2014 20:25:04 +0000
Message-ID: <bug-80711-11613-AvfCxlf8oW@https.bugzilla.kernel.org/>
References: <bug-80711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52164 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbaHFUZH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Aug 2014 16:25:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1C3F52018A
	for <linux-scsi@vger.kernel.org>; Wed,  6 Aug 2014 20:25:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 322E72017D
	for <linux-scsi@vger.kernel.org>; Wed,  6 Aug 2014 20:25:05 +0000 (UTC)
In-Reply-To: <bug-80711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=80711

--- Comment #6 from Alan Stern <stern@rowland.harvard.edu> ---
Please don't remove names from the CC: list; use Reply-To-All.  I had 
to go back and add all the names back in.

On Wed, 6 Aug 2014, Tiziano Bacocco wrote:

> Test with alcor based USB flash drives, linux 3.16 will remove the 3 msb of
> the CDB byte when using SG raw

Sure, but isn't that what you want it to do?  Doesn't the flash drive 
use those bits to hold the LUN number?

Alan Stern


> Il 06/ago/2014 22:02 "Alan Stern" <stern@rowland.harvard.edu> ha scritto:
>
> > On Wed, 6 Aug 2014, Christoph Hellwig wrote:
> >
> > > On Wed, Aug 06, 2014 at 03:29:47PM +0200, Douglas Gilbert wrote:
> > > > If not and since I'm told black lists and the like won't
> > > > work, my advice for the record is to use FreeBSD or Windows
> > > > for tools that need this capability.
> > >
> > > I doubt either of them forces users to hack up flags for these cases.
> >
> > Why was this change needed in the first place?  There's no explanation
> > in the patch itself.

-- 
You are receiving this mail because:
You are the assignee for the bug.
