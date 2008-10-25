From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11817] SCSI: timing out command for dvd drive
Date: Sat, 25 Oct 2008 04:01:50 -0700 (PDT)
Message-ID: <20081025110150.BD83F108047@picon.linux-foundation.org>
References: <bug-11817-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153AbYJYLCS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Oct 2008 07:02:18 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9PB1opX016156
	for <linux-scsi@vger.kernel.org>; Sat, 25 Oct 2008 04:01:51 -0700
In-Reply-To: <bug-11817-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11817


bugzilla-kernel@jensthebrain.de changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |CLOSED
         Resolution|                            |PATCH_ALREADY_AVAILABLE




------- Comment #8 from bugzilla-kernel@jensthebrain.de  2008-10-25 04:01 -------
(In reply to comment #5)
> James, you are correct, this is the same problem. Applying the patch at
> http://lkml.org/lkml/2008/10/24/102
> made my system boot again. Thanks!

same here. I close this bug - it's already included in the latest snapshot
(Commit: e013e13bf605b9e6b702adffbe2853cfc60e7806)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
