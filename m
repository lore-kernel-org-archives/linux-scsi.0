From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 8579] 3w_9xxx: 32/64bit cleanness ?? : Mounting doesn't work on 3ware 9500S-4LP RAID-controller and RAID-10
Date: Tue, 24 Mar 2009 08:51:56 -0700 (PDT)
Message-ID: <20090324155156.79337108043@picon.linux-foundation.org>
References: <bug-8579-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753430AbZCXPxK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Mar 2009 11:53:10 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2OFqSPH022556
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2009 08:52:59 -0700
In-Reply-To: <bug-8579-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=8579


alan@lxorguk.ukuu.org.uk changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
             Status|NEW                         |REJECTED
         Resolution|                            |INSUFFICIENT_DATA




------- Comment #11 from alan@lxorguk.ukuu.org.uk  2009-03-24 08:51 -------
Closing stale bug as after this point various fixes were made and the sg list
accessors have completely changed by now


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
