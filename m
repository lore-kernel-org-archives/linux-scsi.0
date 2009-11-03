From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14534] mvsas : repeatably disconnects all disks during RAID6
 resync
Date: Tue, 3 Nov 2009 09:41:05 GMT
Message-ID: <200911030941.nA39f5kh031506@demeter.kernel.org>
References: <bug-14534-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38768 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbZKCJk7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 04:40:59 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA39f5w8031507
	for <linux-scsi@vger.kernel.org>; Tue, 3 Nov 2009 09:41:05 GMT
In-Reply-To: <bug-14534-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14534


andy yan <ayan@marvell.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ayan@marvell.com




--- Comment #3 from andy yan <ayan@marvell.com>  2009-11-03 09:41:02 ---
I will commit a patch to update the mvsas code to latest version, this version
fixed some issue with disk IO.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
