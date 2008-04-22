From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 6357] Megaraid driver is more recent for my hardware
Date: Mon, 21 Apr 2008 23:52:23 -0700 (PDT)
Message-ID: <20080422065223.D140B108061@picon.linux-foundation.org>
References: <bug-6357-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755116AbYDVGwz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2008 02:52:55 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m3M6qO3E025921
	for <linux-scsi@vger.kernel.org>; Mon, 21 Apr 2008 23:52:25 -0700
In-Reply-To: <bug-6357-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=6357





------- Comment #8 from protasnb@gmail.com  2008-04-21 23:52 -------
I can't really suggest you course of action with such an old distro; is there a
reason you're not upgrading to recent one?
I'd say anything newer than 2.6.18 should work just fine for megaraid. Maybe
you can attach your lspci -v just in case, to make sure the "old card" is
supported.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
