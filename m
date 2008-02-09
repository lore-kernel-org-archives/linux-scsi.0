From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9775] HOST_MSG_LOOP invalid SCB ff
Date: Fri,  8 Feb 2008 18:54:20 -0800 (PST)
Message-ID: <20080209025420.B444511D109@picon.linux-foundation.org>
References: <bug-9775-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37609 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942AbYBIC5W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 21:57:22 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m192sevF023710
	for <linux-scsi@vger.kernel.org>; Fri, 8 Feb 2008 18:55:41 -0800
In-Reply-To: <bug-9775-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9775





------- Comment #9 from john@mib-infotech.co.nz  2008-02-08 18:54 -------
Wrap around doesn't help..

I've also the the 'old' AIC78XX driver.
That driver hangs even with no devices attached.

So now what?

--john


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
