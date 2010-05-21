From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16010] Mptlinux update problem but need
Date: Fri, 21 May 2010 09:33:35 GMT
Message-ID: <201005210933.o4L9XZ6B011420@demeter.kernel.org>
References: <bug-16010-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35715 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab0EUJdg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2010 05:33:36 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4L9XZwq011421
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 21 May 2010 09:33:35 GMT
In-Reply-To: <bug-16010-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16010


dujun@perabytes.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dujun@perabytes.com




--- Comment #1 from dujun@perabytes.com  2010-05-21 09:33:32 ---
you could fix it by change the data_len to _data_len. pls refer to the "struct
request" in the 2.6.32 kernel header.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
