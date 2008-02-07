From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9909] Unable to handle kernel NULL pointer dereference at 0000000000000010 (mptsas_probe_expander_phys+0x62/0x427)
Date: Thu,  7 Feb 2008 05:53:38 -0800 (PST)
Message-ID: <20080207135339.05B9E108010@picon.linux-foundation.org>
References: <bug-9909-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44062 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355AbYBGNxk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 08:53:40 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m17DrdZo016272
	for <linux-scsi@vger.kernel.org>; Thu, 7 Feb 2008 05:53:40 -0800
In-Reply-To: <bug-9909-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9909





------- Comment #1 from olel@ans.pl  2008-02-07 05:53 -------
Created an attachment (id=14732)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=14732&action=view)
Oops from 2.6.23


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
