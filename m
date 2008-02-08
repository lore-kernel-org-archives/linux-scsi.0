From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9769] CONFIG_SCSI_WAIT_SCAN configure error
Date: Thu,  7 Feb 2008 23:28:59 -0800 (PST)
Message-ID: <20080208072859.A360510806E@picon.linux-foundation.org>
References: <bug-9769-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34783 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932668AbYBHH3E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 02:29:04 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m187SxBY026966
	for <linux-scsi@vger.kernel.org>; Thu, 7 Feb 2008 23:29:00 -0800
In-Reply-To: <bug-9769-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9769


protasnb@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |protasnb@gmail.com,
                   |                            |jejb@hansenpartnership.com




------- Comment #1 from protasnb@gmail.com  2008-02-07 23:28 -------
This appears to be a dependency, but these are not dependent defines.
CONFIG_SCSI_SCAN_ASYNC defines the default scan type, which can be overridden
by the module parameter.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
