From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 7177] Mylex DAC960 driver is not working with Kernel newer than 2.6.11 !
Date: Sun, 30 Mar 2008 00:08:58 -0700 (PDT)
Message-ID: <20080330070858.D58F7108039@picon.linux-foundation.org>
References: <bug-7177-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751192AbYC3HJ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2008 03:09:29 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2U78w74022523
	for <linux-scsi@vger.kernel.org>; Sun, 30 Mar 2008 00:09:00 -0700
In-Reply-To: <bug-7177-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=7177


protasnb@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |protasnb@gmail.com
         Regression|0                           |1




------- Comment #17 from protasnb@gmail.com  2008-03-30 00:08 -------
The bug should be reassigned to ACPI, if Boris and Adam could provide dmesg,
/proc/interrupts to start with, from 2.6.8 and a failed kernel.
Closing the bug for now. Please reopen if you have further updates.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
