From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11817] SCSI: timing out command for dvd drive
Date: Fri, 24 Oct 2008 09:28:40 -0700 (PDT)
Message-ID: <20081024162840.B0169108042@picon.linux-foundation.org>
References: <bug-11817-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752238AbYJXQ3L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Oct 2008 12:29:11 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9OGSeYE030706
	for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2008 09:28:41 -0700
In-Reply-To: <bug-11817-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11817





------- Comment #5 from khali@linux-fr.org  2008-10-24 09:28 -------
James, you are correct, this is the same problem. Applying the patch at
http://lkml.org/lkml/2008/10/24/102
made my system boot again. Thanks!


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
