From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47701] When too many disks fall out at the same time, RCU hangs
Date: Sun,  7 Oct 2012 14:20:46 +0000 (UTC)
Message-ID: <20121007142046.AB8E011FC3E@bugzilla.kernel.org>
References: <bug-47701-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55703 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab2JGOUw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Oct 2012 10:20:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 465C820275
	for <linux-scsi@vger.kernel.org>; Sun,  7 Oct 2012 14:20:51 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 5729520276
	for <linux-scsi@vger.kernel.org>; Sun,  7 Oct 2012 14:20:49 +0000 (UTC)
In-Reply-To: <bug-47701-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=47701


Brad Campbell <lists2009@fnarfbargle.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lists2009@fnarfbargle.com




--- Comment #3 from Brad Campbell <lists2009@fnarfbargle.com>  2012-10-07 14:20:46 ---
Apparently fixed as of 3.6.0-07201-ged5062d (current git as of 8 hours ago).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
