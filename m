From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16547] mptscsih: ioc0: attempting task abort, raid array LUNs
 not detected properly on some boots
Date: Sat, 12 May 2012 00:05:55 +0000 (UTC)
Message-ID: <20120512000555.2C3EE11FCE2@bugzilla.kernel.org>
References: <bug-16547-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47772 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759948Ab2ELAGA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 May 2012 20:06:00 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0D59720254
	for <linux-scsi@vger.kernel.org>; Sat, 12 May 2012 00:05:59 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 305452026B
	for <linux-scsi@vger.kernel.org>; Sat, 12 May 2012 00:05:55 +0000 (UTC)
In-Reply-To: <bug-16547-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16547


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
     Kernel Version|2.6.32-bpo.5-amd64 (Debian  |2.6.32-bpo.5-amd64
                   |2.6.32-15~bpo50+1)          |
                   |(norbert@tretkowski.de)     |
                   |(gcc version 4.3.2 (Debian  |
                   |4.3.2-1.1) ) #1 SMP Fri Jun |
                   |11 08:42:31 UTC 2010        |




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug.
You are watching the assignee of the bug.
