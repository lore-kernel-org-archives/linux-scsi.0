From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11990] Kernel hang in spin_unlock_irq from scsi_request_fn from do_IRQ
Date: Sun,  9 Nov 2008 11:01:06 -0800 (PST)
Message-ID: <20081109190106.51D77108048@picon.linux-foundation.org>
References: <bug-11990-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755548AbYKITBi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2008 14:01:38 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA9J16V0017237
	for <linux-scsi@vger.kernel.org>; Sun, 9 Nov 2008 11:01:07 -0800
In-Reply-To: <bug-11990-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11990


rjw@sisk.pl changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |DUPLICATE




------- Comment #3 from rjw@sisk.pl  2008-11-09 11:01 -------


*** This bug has been marked as a duplicate of bug 11898 ***


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
