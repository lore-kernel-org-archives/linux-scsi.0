From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11990] Kernel hang in spin_unlock_irq from scsi_request_fn from do_IRQ
Date: Sat,  8 Nov 2008 19:51:24 -0800 (PST)
Message-ID: <20081109035124.62FD9108043@picon.linux-foundation.org>
References: <bug-11990-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753821AbYKIDv0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Nov 2008 22:51:26 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA93pOGd002030
	for <linux-scsi@vger.kernel.org>; Sat, 8 Nov 2008 19:51:25 -0800
In-Reply-To: <bug-11990-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11990


vandrove@vc.cvut.cz changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
OtherBugsDependingO|                            |11808
              nThis|                            |
         Regression|0                           |1




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
