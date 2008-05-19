From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10057] gdth: unable to handle kernel NULL  pointer dereference at virtual address 0000000c
Date: Mon, 19 May 2008 08:01:28 -0700 (PDT)
Message-ID: <20080519150129.03801108063@picon.linux-foundation.org>
References: <bug-10057-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111AbYESPBb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2008 11:01:31 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m4JF1T6E024839
	for <linux-scsi@vger.kernel.org>; Mon, 19 May 2008 08:01:30 -0700
In-Reply-To: <bug-10057-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10057





------- Comment #6 from arne@meteo-graphics.de  2008-05-19 08:01 -------
I tried the 2.6.26rc2 and it seems to be fixed. The devices and the stats are
accessible.

Thank you!


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
