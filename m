From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 19642] 2.6.36-rc6 BUG at drivers/scsi/scsi_lib.c:1113
Date: Sun, 3 Oct 2010 21:32:14 GMT
Message-ID: <201010032132.o93LWEsl020378@demeter1.kernel.org>
References: <bug-19642-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41779 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab0JCVcP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Oct 2010 17:32:15 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o93LWEUx020379
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 3 Oct 2010 21:32:14 GMT
In-Reply-To: <bug-19642-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=19642


Alasdair G Kergon <agk@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |agk@redhat.com
          Component|SCSI                        |MD
         AssignedTo|linux-scsi@vger.kernel.org  |io_md@kernel-bugs.osdl.org




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
