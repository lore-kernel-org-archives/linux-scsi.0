From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12481] mt takes two minutes to determine that the tape drive is empty
Date: Mon, 19 Jan 2009 11:10:34 -0800 (PST)
Message-ID: <20090119191034.85058108049@picon.linux-foundation.org>
References: <bug-12481-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753390AbZASTLG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2009 14:11:06 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0JJAYuk025744
	for <linux-scsi@vger.kernel.org>; Mon, 19 Jan 2009 11:10:35 -0800
In-Reply-To: <bug-12481-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12481





------- Comment #2 from kai.makisara@kolumbus.fi  2009-01-19 11:10 -------
This is an application bug: it opens the device without the O_NONBLOCK flag.
The driver waits up to two minutes for the drive to become ready. You probably
earlier had an mt that opens tape with O_NONBLOCK (from mt-st?).


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
