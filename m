From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9133] aacraid driver fails with Dell PowerEdge Expandable RAID Controller 3/Di
Date: Thu, 26 Jun 2008 07:29:13 -0700 (PDT)
Message-ID: <20080626142913.7AF1310800B@picon.linux-foundation.org>
References: <bug-9133-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859AbYFZO3o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2008 10:29:44 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m5QETDRO002559
	for <linux-scsi@vger.kernel.org>; Thu, 26 Jun 2008 07:29:14 -0700
In-Reply-To: <bug-9133-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9133





------- Comment #8 from hkmaly@gmail.com  2008-06-26 07:29 -------
I also encountered this issue (with kernel 2.6.24, previous kernel was 2.6.15
but I suppose the problem was triggered by upgrading memory from 4GB to 6GB) on
PowerEdge 2650 (with Dell PowerEdge Expandable RAID Controller 3/Di).

I can confirm that firmware/BIOS update (from version 2.8.0.6092 to 2.8.1.7692)
solved it.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
