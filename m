From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11529] aacraid - WARNING: at lib/scatterlist.c
Date: Wed, 10 Sep 2008 10:35:29 -0700 (PDT)
Message-ID: <20080910173529.0F40E108057@picon.linux-foundation.org>
References: <bug-11529-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425AbYIJRfz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2008 13:35:55 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8AHZTli013259
	for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2008 10:35:30 -0700
In-Reply-To: <bug-11529-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11529


winfried@tilanus.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




------- Comment #4 from winfried@tilanus.com  2008-09-10 10:35 -------
Thanks, this patch did the trick, no warnings any more.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
