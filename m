From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9909] Unable to handle kernel NULL pointer dereference at 0000000000000010 (mptsas_probe_expander_phys+0x62/0x427)
Date: Thu,  7 Feb 2008 10:34:31 -0800 (PST)
Message-ID: <20080207183431.0AA16108068@picon.linux-foundation.org>
References: <bug-9909-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43682 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933024AbYBGSei (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 13:34:38 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m17IYV6Z031164
	for <linux-scsi@vger.kernel.org>; Thu, 7 Feb 2008 10:34:37 -0800
In-Reply-To: <bug-9909-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9909


akpm@osdl.org changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|linux-scsi@vger.kernel.org  |Eric.Moore@lsil.com




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
You are the assignee for the bug, or are watching the assignee.
