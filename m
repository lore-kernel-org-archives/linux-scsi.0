From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after 2.6.20
Date: Tue,  7 Oct 2008 13:52:29 -0700 (PDT)
Message-ID: <20081007205229.932AC108047@picon.linux-foundation.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752941AbYJGUwb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2008 16:52:31 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m97KqTKh016037
	for <linux-scsi@vger.kernel.org>; Tue, 7 Oct 2008 13:52:30 -0700
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





------- Comment #12 from grin@grin.hu  2008-10-07 13:52 -------
Okay, but _which_ part you mean? One HBA? As I've mentioned the problem
happened on multiple machines, and they have dual HBAs. (Or can one bad HBA
mess up the others? How could be spotted which one is bad? Is there a way to
test this particular problem?) 

By the reply I guess they talk about the dumps, and #4 was the second card of
the machine in question. But originally this wasn't the server I had most
problem with, but that one locks usually up alright on newer kernels and reboot
clears the firmware dumps you mentioned. So if machine#3 have bad HBA#2, why
did machine #1 lock up every 30 minutes? Still not clear to me. 


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
