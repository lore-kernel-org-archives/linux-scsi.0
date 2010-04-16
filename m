From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 9123] 2.6.23-rcX SG_GET_SCSI_ID regression?
Date: Fri, 16 Apr 2010 15:37:04 GMT
Message-ID: <201004161537.o3GFb4jh031144@demeter.kernel.org>
References: <bug-9123-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44379 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab0DPPhF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Apr 2010 11:37:05 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3GFb4KT031145
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 16 Apr 2010 15:37:04 GMT
In-Reply-To: <bug-9123-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=9123


Randy Dunlap <randy.dunlap@oracle.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |randy.dunlap@oracle.com
         Resolution|                            |UNREPRODUCIBLE




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
