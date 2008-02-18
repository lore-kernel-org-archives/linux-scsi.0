From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9769] CONFIG_SCSI_WAIT_SCAN configure error
Date: Mon, 18 Feb 2008 06:19:50 -0800 (PST)
Message-ID: <20080218141950.7E1F210806A@picon.linux-foundation.org>
References: <bug-9769-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55061 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981AbYBROTx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 09:19:53 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m1IEJpFd012077
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2008 06:19:52 -0800
In-Reply-To: <bug-9769-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9769


matthew@wil.cx changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |matthew@wil.cx
             Status|REOPENED                    |REJECTED
         Resolution|                            |INVALID




------- Comment #5 from matthew@wil.cx  2008-02-18 06:19 -------
Sorry, it is an invalid bug.  This has been discussed a few times on
linux-scsi.  If you have any SCSI driver built as a module, you (or the distro
you are running) may need it.  We can't tell in Kconfig -- and you might choose
to build another driver as a module later.  Or out of tree.

If you're sure you don't need it, then don't run 'make modules_install'.  It's
about 2500 bytes ... why waste so much energy being angry?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
