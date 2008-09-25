From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after 2.6.20
Date: Thu, 25 Sep 2008 08:00:51 -0700 (PDT)
Message-ID: <20080925150051.9B2DF11D107@picon.linux-foundation.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778AbYIYPBW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2008 11:01:22 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8PF0pbS018041
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2008 08:00:52 -0700
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646


grin@grin.hu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |grin@grin.hu




------- Comment #2 from grin@grin.hu  2008-09-25 08:00 -------
Many updates: unfortunately I realised. 

2.6.26.5: yes, it is broken as well. I have no knowledge of released 2.6.27.
:-)

Messages: alright, I'll attach some, but please realise that when the IO is
blocked there is no log. :-) I have some screenshots of the crashes, but most
of them not even relevant, only showing that processes stuck in D state for
much too long.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
