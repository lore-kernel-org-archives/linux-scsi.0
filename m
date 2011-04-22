From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 33802] list_del corruption in sd driver since 2.6.39-rc4
Date: Fri, 22 Apr 2011 09:14:44 GMT
Message-ID: <201104220914.p3M9EiHn003749@demeter1.kernel.org>
References: <bug-33802-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:54652 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab1DVJOq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2011 05:14:46 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p3M9EiWI003750
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2011 09:14:44 GMT
In-Reply-To: <bug-33802-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=33802


Stefan Richter <stefanr@s5r6.in-berlin.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |stefanr@s5r6.in-berlin.de




--- Comment #1 from Stefan Richter <stefanr@s5r6.in-berlin.de>  2011-04-22 09:14:37 ---
I saw this already with 2.6.39-rc3 (which was the first 2.6.39-rc that I tried
after 2.6.38, to which I have reverted for now).

Reported in "2.6.39-rc3: usb-storage hotplug kref corruption/ list corruption"
at linux-scsi + linux-usb on April 14:
http://thread.gmane.org/gmane.linux.usb.general/45456

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
