From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 30762] Oops when plugging in an usb stick
Date: Wed, 9 Mar 2011 08:07:15 GMT
Message-ID: <201103090807.p2987FWY032298@demeter2.kernel.org>
References: <bug-30762-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:60150 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab1CIIHQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2011 03:07:16 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p2987FD7032299
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2011 08:07:15 GMT
In-Reply-To: <bug-30762-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=30762





--- Comment #2 from Taras Shpot <mrshpot@gmail.com>  2011-03-09 08:07:13 ---
Please close this bug.
The Oops was caused by a stale initrd. 
After rebuilding the initrd, the problem went away.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
