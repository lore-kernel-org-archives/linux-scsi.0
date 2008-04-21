From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10486] kernel 2.6.24  4G FC arrays don't work properly with qla2xxx driver
Date: Mon, 21 Apr 2008 12:47:56 -0700 (PDT)
Message-ID: <20080421194756.D032D10805F@picon.linux-foundation.org>
References: <bug-10486-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755075AbYDUTs0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2008 15:48:26 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m3LJluKn022897
	for <linux-scsi@vger.kernel.org>; Mon, 21 Apr 2008 12:47:57 -0700
In-Reply-To: <bug-10486-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10486





------- Comment #5 from andrew.vasquez@qlogic.com  2008-04-21 12:47 -------
Could you send the resultant kernel messages (from driver load to failure) 
with the driver loaded with the ql2xextended_error_logging module-parameter 
set to 1.

   $ insmod qla2xxx ql2xextended_error_logging=1


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
