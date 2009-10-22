From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13783] udev causes high cpu usage
Date: Thu, 22 Oct 2009 07:00:34 GMT
Message-ID: <200910220700.n9M70YZe014980@demeter.kernel.org>
References: <bug-13783-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46415 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbZJVHAa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Oct 2009 03:00:30 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9M70Y6o014982
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2009 07:00:34 GMT
In-Reply-To: <bug-13783-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13783


jt512@jt512.dyndns.org changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jt512@jt512.dyndns.org




--- Comment #20 from jt512@jt512.dyndns.org  2009-10-22 07:00:28 ---
Has this problem been fixed in version 147?  I had this problem in versions 145
and 146 in Arch64, but I just installed udev-147~-6, which someone has ported
from ubuntu to Arch, and the problem is gone.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
