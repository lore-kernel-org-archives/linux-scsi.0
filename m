From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43191] Syslog fills with messages about assuming drive cache
 when SD card not present
Date: Mon, 7 May 2012 14:32:15 GMT
Message-ID: <201205071432.q47EWFH8011354@bugzilla.kernel.org>
References: <bug-43191-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:41492 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab2EGOcQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2012 10:32:16 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q47EWFux011355
	for <linux-scsi@vger.kernel.org>; Mon, 7 May 2012 14:32:16 GMT
In-Reply-To: <bug-43191-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=43191


Daniel Mehrmann <daniel.mehrmann@gmx.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |daniel.mehrmann@gmx.de




--- Comment #6 from Daniel Mehrmann <daniel.mehrmann@gmx.de>  2012-05-07 14:32:14 ---
I can confirm it happens with my Netbook LG x110 as well.
I attach a boot.log

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
