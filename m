From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10057] gdth: unable to handle kernel NULL  pointer dereference at virtual address 0000000c
Date: Thu, 15 May 2008 11:55:19 -0700 (PDT)
Message-ID: <20080515185519.1AA2E108060@picon.linux-foundation.org>
References: <bug-10057-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752481AbYEOSzt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2008 14:55:49 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m4FItJH7010170
	for <linux-scsi@vger.kernel.org>; Thu, 15 May 2008 11:55:20 -0700
In-Reply-To: <bug-10057-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10057


devzero@web.de changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |devzero@web.de




------- Comment #5 from devzero@web.de  2008-05-15 11:55 -------
hi arne, 

there were some changes to gdth recently.

could you try 2.6.26rc2 or latest git ?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
