From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 6722] second device open() (by periodic hal polling loop!) kills ongoing transfer (CD burner underruns, HDD hard resets)
Date: Tue, 25 Mar 2008 20:15:23 -0700 (PDT)
Message-ID: <20080326031524.0054C108039@picon.linux-foundation.org>
References: <bug-6722-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622AbYCZDP6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Mar 2008 23:15:58 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2Q3FOmZ025259
	for <linux-scsi@vger.kernel.org>; Tue, 25 Mar 2008 20:15:25 -0700
In-Reply-To: <bug-6722-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=6722


protasnb@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |protasnb@gmail.com




------- Comment #6 from protasnb@gmail.com  2008-03-25 20:15 -------
Any status update on this problem please? Has it been resolved?
Thanks.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
