From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13594] SMART responses for SATA disks on SAS get interpreted as
 errors
Date: Mon, 22 Jun 2009 12:04:31 GMT
Message-ID: <200906221204.n5MC4Vo6017700@demeter.kernel.org>
References: <bug-13594-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34600 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZFVME2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2009 08:04:28 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5MC4Vd6017701
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2009 12:04:31 GMT
In-Reply-To: <bug-13594-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13594





--- Comment #7 from Matthew Wilcox <matthew@wil.cx>  2009-06-22 12:04:31 ---
On Sun, Jun 21, 2009 at 04:53:29PM -0400, Douglas Gilbert wrote:
> As for the hiccup, I have noticed that with SAS (SCSI)
> disks from Seagate there is a curious sound and a pause
> before the response to LOG SENSE SCSI command (the
> type the smartmontools uses on SCSI disks).
>
> Another annoyance is that the disk must be ready (i.e.
> spun up) before MODE SENSE and LOG SENSE work, haven't
> Seagate heard of flash :-)
> SCSI standards permit that (i.e. only
> a small number of commands have to work when the disk
> is not ready) but you would think accessing metadata
> given the disk has spun up once since power up could
> be accomplished from RAM or flash.

We've experienced similar problems at Intel with an LSI card and Intel
SSDs (SATA, not SAS).  This issue got pushed into the 'investigate later'
category, as we were able to just disable smartd.  I'll try and get some
more information on this later.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
