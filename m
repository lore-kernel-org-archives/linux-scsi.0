From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14118] USB storage: "No sense [current]" when connecting
Date: Sat, 5 Sep 2009 20:53:47 GMT
Message-ID: <200909052053.n85KrkGO017880@demeter.kernel.org>
References: <bug-14118-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53083 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbZIEUxo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2009 16:53:44 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n85Krlvs017881
	for <linux-scsi@vger.kernel.org>; Sat, 5 Sep 2009 20:53:47 GMT
In-Reply-To: <bug-14118-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14118





--- Comment #7 from Andrew Morton <akpm@linux-foundation.org>  2009-09-05 20:53:45 ---
On Sat, 5 Sep 2009 16:40:06 -0400 (EDT) Alan Stern <stern@rowland.harvard.edu>
wrote:

> > > The second problem has nothing to do with USB; it is a bug in the SCSI
> > > layer.  If the module parameter doesn't fix everything, I suggest this
> > > bug report be reassigned to James Bottomley rather than Greg
> > > Kroah-Hartman and the component be changed from USB to SCSI.
> > 
> > Should I edit the bug myself? (If yes, what address do I reassign it to?)
> 
> Maybe we can prevail upon Andrew Morton to reassign it for you.

OK, I reassigned it to scsi, but I expect it would help the scsi guys
if someone could add a new summary of what they think the actual bug is.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
