From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9775] HOST_MSG_LOOP invalid SCB ff
Date: Sat, 16 Feb 2008 18:40:11 -0800 (PST)
Message-ID: <20080217024011.24E2010806C@picon.linux-foundation.org>
References: <bug-9775-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35835 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751846AbYBQCkQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Feb 2008 21:40:16 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m1H2eETO019573
	for <linux-scsi@vger.kernel.org>; Sat, 16 Feb 2008 18:40:15 -0800
In-Reply-To: <bug-9775-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9775


john@mib-infotech.co.nz changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |CLOSED
         Resolution|                            |CODE_FIX




------- Comment #11 from john@mib-infotech.co.nz  2008-02-16 18:40 -------
Thanks James,
I've spent an afternoon rebooting now and finally discovered  I had a faulty
external SSCI cable.

Initial tests suggest its ok.

However I remain perplexed. The problem initially manifested when I upgraded my
kernel, not when I diddled with my hardware.

This now seems to have fixed udev bug
http://bugs.gentoo.org/show_bug.cgi?id=200437

as well

how bizarre!

Thanks for your help everyone.

Regards
John


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
