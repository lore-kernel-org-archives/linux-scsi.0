From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 22092] Kernel v2.6.36 trouble on USB disconnect
Date: Mon, 20 Dec 2010 04:45:40 GMT
Message-ID: <201012200445.oBK4jepQ009309@demeter1.kernel.org>
References: <bug-22092-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:34825 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab0LTEpl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Dec 2010 23:45:41 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oBK4jfCb009310
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2010 04:45:41 GMT
In-Reply-To: <bug-22092-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=22092





--- Comment #5 from Alan Stern <stern@rowland.harvard.edu>  2010-12-20 04:45:39 ---
On Sun, 19 Dec 2010 bugzilla-daemon@bugzilla.kernel.org wrote:

> --- Comment #4 from Rafael J. Wysocki <rjw@sisk.pl>  2010-12-19 14:48:12 ---
> Closing as a duplicate.
> 
> *** This bug has been marked as a duplicate of bug 24722 ***

Are you sure about this?  The error messages don't look at all similar.  
The error for bug #24722 is a WARN_ONCE in ehci_endpoint_reset(),
whereas the error in this bug report is some unspecified problem in
disk_replace_part_tbl().

Alan Stern

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
