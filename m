From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10396] BUG: soft lockup - CPU#0 stuck for 61s! [modprobe:2096]
Date: Sat,  5 Apr 2008 09:49:22 -0700 (PDT)
Message-ID: <20080405164922.582EA108060@picon.linux-foundation.org>
References: <bug-10396-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752528AbYDEQtx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Apr 2008 12:49:53 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m35GnMps013277
	for <linux-scsi@vger.kernel.org>; Sat, 5 Apr 2008 09:49:23 -0700
In-Reply-To: <bug-10396-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10396


linux@tjworld.net changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|AACRAID                     |Config-Interrupts
            Product|SCSI Drivers                |ACPI




------- Comment #5 from linux@tjworld.net  2008-04-05 09:49 -------
I'm attempting to re-assign this bug to ACPI > Config-Interrupts


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
