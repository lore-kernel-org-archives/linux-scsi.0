From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14214] BUG at drivers/scsi/scsi_lib.c:1108!
Date: Thu, 1 Oct 2009 10:32:17 GMT
Message-ID: <200910011032.n91AWHOl017134@demeter.kernel.org>
References: <bug-14214-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40339 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173AbZJAKcN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 06:32:13 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n91AWHUv017135
	for <linux-scsi@vger.kernel.org>; Thu, 1 Oct 2009 10:32:17 GMT
In-Reply-To: <bug-14214-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14214





--- Comment #9 from Jens Axboe <axboe@kernel.dk>  2009-10-01 10:32:15 ---
Plamen, not sure what you are trying to accomplish. As I mentioned earlier,
this looks like a bug that was fixed in md after your initial test point. The
commit in question is 1ef04fefe2241087d9db7e9615c3f11b516e36cf and I think it
was merged on the 23rd/24th. Your testing of 2.6.32-rc1 appears to confirm this
fact.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
