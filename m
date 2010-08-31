From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after
 2.6.20
Date: Tue, 31 Aug 2010 06:22:06 GMT
Message-ID: <201008310622.o7V6M6lB016727@demeter1.kernel.org>
References: <bug-11646-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47582 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab0HaGWH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2010 02:22:07 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o7V6M6sn016728
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 31 Aug 2010 06:22:06 GMT
In-Reply-To: <bug-11646-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=11646





--- Comment #35 from Ninad <nindate@gmail.com>  2010-08-31 06:21:54 ---
Dear Bernd Zeimetz,

Has there been a resolution yet on this issue?
When you said "pci=nomsi seems to work" - has the problem got resolved for you
using pci-nomsi?
I am using Oracle VM 2.2.1 and although we do not see the Mailbox command
timeout message, infact we have not got many messages at all in the
/var/log/messages - but we have observed IO getting stalled to few or most of
our LUNs configured as ocfs2 filesystems.
The port do not show as down (from the SAN logs we have checked) and the LUNs
getting stalled for a server - there is no problem from other servers to write
to that LUNs (as they are shared to other servers being ocfs2).

But for some reason - I am getting a feeling that our problem could well be the
reason of what you are facing, hence request some feedback from you.

Thanks,
Ninad

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
