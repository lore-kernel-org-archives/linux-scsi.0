From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11817] SCSI: timing out command for dvd drive
Date: Fri, 24 Oct 2008 05:58:55 -0700 (PDT)
Message-ID: <20081024125855.B95EA108043@picon.linux-foundation.org>
References: <bug-11817-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751548AbYJXM65 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Oct 2008 08:58:57 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9OCwt62018476
	for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2008 05:58:56 -0700
In-Reply-To: <bug-11817-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11817





------- Comment #1 from bugzilla-kernel@jensthebrain.de  2008-10-24 05:58 -------
Created an attachment (id=18425)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=18425&action=view)
2.6.28-rc1 config

It also happens without "Asynchronous SCSI scanning".


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
