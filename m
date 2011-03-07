From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 27882] target code causes memory corruption
Date: Mon, 7 Mar 2011 16:44:14 GMT
Message-ID: <201103071644.p27GiEHI022555@demeter2.kernel.org>
References: <bug-27882-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:47510 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab1CGQoO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2011 11:44:14 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p27GiEwU022557
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 7 Mar 2011 16:44:14 GMT
In-Reply-To: <bug-27882-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=27882


Fubo Chen <fubo.chen@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




--- Comment #1 from Fubo Chen <fubo.chen@gmail.com>  2011-03-07 16:44:12 ---
Fixed by 1f6fe7cba1c0a817a8712d7fdd0ec1b4ddd4ea2f (2.6.38-rc6).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
