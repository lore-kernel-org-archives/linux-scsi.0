From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9872] Driver 'sd' needs updating - please use bus_type methods
Date: Thu,  5 Jun 2008 16:52:36 -0700 (PDT)
Message-ID: <20080605235236.BA76810805D@picon.linux-foundation.org>
References: <bug-9872-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751713AbYFEXwj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2008 19:52:39 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m55NqalS029007
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jun 2008 16:52:37 -0700
In-Reply-To: <bug-9872-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9872





------- Comment #4 from russell@rickstewart.com  2008-06-05 16:52 -------
(In reply to comment #3)
> Russel, did you get chance to test Kay's patch in #2?

    I did.  It worked.  I had to patch the files by hand because 
of some difference in version, I guess.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
