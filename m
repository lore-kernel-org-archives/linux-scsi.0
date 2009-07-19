From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after
 2.6.20
Date: Sun, 19 Jul 2009 14:25:32 GMT
Message-ID: <200907191425.n6JEPWko012516@demeter.kernel.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59055 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbZGSOZc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2009 10:25:32 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n6JEPWFv012517
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jul 2009 14:25:32 GMT
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646


Somsak Sriprayoonsakul <somsaks@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |somsaks@gmail.com




--- Comment #27 from Somsak Sriprayoonsakul <somsaks@gmail.com>  2009-07-19 14:25:27 ---
Hi, we are having about the same problem with about the same log, and we found
something similar with workaround posted at

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/268242

Could this possibly be the same bug?

Anyway, we have add pci=nomsi as suggested in above bug report. Will report
here again if it help (or not).

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
