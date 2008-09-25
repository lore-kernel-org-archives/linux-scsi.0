From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11645] qla2xxx.ko can't load firmware binary code
Date: Thu, 25 Sep 2008 07:58:30 -0700 (PDT)
Message-ID: <20080925145830.C9DA611D10A@picon.linux-foundation.org>
References: <bug-11645-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753411AbYIYO7A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2008 10:59:00 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8PEwUUv017835
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2008 07:58:31 -0700
In-Reply-To: <bug-11645-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11645





------- Comment #5 from seokmann.ju@qlogic.com  2008-09-25 07:58 -------
OK. Then, could you try with upstream kernel 2.6.26.5?
My point is that, for same driver on the same base kernel version with
different flavor - one from the community and the other one from Debian, the
former one  works but, the latter one doesn't.
I consider it should be related kernel components on the kernel which you are
using, at least in my opinion, it should point out where the problem resides if
the problem disappear with the upstream kernel on your H/W platform.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
