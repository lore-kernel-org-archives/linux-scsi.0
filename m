From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10846] Slow write on LSISAS1068E (SAS6/iR) on kernel >= 2.6.22
Date: Mon,  2 Jun 2008 14:09:28 -0700 (PDT)
Message-ID: <20080602210928.95F7811D107@picon.linux-foundation.org>
References: <bug-10846-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803AbYFBVJb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2008 17:09:31 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m52L9SXk019514
	for <linux-scsi@vger.kernel.org>; Mon, 2 Jun 2008 14:09:29 -0700
In-Reply-To: <bug-10846-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10846


devzero@web.de changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |devzero@web.de




------- Comment #2 from devzero@web.de  2008-06-02 14:09 -------
i also don`t see an issue here.

the first write may fit to ram completely and thus getting cached, and the
second looks like disk-speed.

does that go to the same path ?

try count=600000 or 6000000 instead of 60000 as data size for i/o tests should
be >>ramsize.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
