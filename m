From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13783] udev causes high cpu usage
Date: Fri, 31 Jul 2009 15:44:47 GMT
Message-ID: <200907311544.n6VFil5E022991@demeter.kernel.org>
References: <bug-13783-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50157 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZGaPor (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2009 11:44:47 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n6VFilJw022992
	for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2009 15:44:47 GMT
In-Reply-To: <bug-13783-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13783


Andreas Fackler <AndreasFackler@web.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
  Attachment #22553|0                           |1
        is obsolete|                            |




--- Comment #15 from Andreas Fackler <AndreasFackler@web.de>  2009-07-31 15:44:46 ---
Created an attachment (id=22554)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=22554)
strace -p 10678

Ah, right, I'm sorry! Here's a few seconds of "strace -p 10678", where 10678
was the pid of hald-addon-storage.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
