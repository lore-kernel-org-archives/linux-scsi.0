From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 7630] os_scsi_tapes_lock should not be acquired before calling new_tape_buffer
Date: Tue, 23 Sep 2008 09:53:41 -0700 (PDT)
Message-ID: <20080923165341.6880510805F@picon.linux-foundation.org>
References: <bug-7630-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbYIWQyK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2008 12:54:10 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8NGrfkp029397
	for <linux-scsi@vger.kernel.org>; Tue, 23 Sep 2008 09:53:42 -0700
In-Reply-To: <bug-7630-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=7630


alan@lxorguk.ukuu.org.uk changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |CLOSED
         Resolution|                            |CODE_FIX




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
