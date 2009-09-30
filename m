From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14242] MPT SAS Fails on heavy operations
Date: Wed, 30 Sep 2009 22:49:59 GMT
Message-ID: <200909302249.n8UMnxLZ012822@demeter.kernel.org>
References: <bug-14242-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50449 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbZI3Wtz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2009 18:49:55 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8UMnxpn012823
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2009 22:49:59 GMT
In-Reply-To: <bug-14242-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14242


Andrew Morton <akpm@linux-foundation.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |akpm@linux-foundation.org,
                   |                            |Eric.Moore@lsil.com
          Component|Other                       |Other
         AssignedTo|io_other@kernel-bugs.osdl.o |scsi_drivers-other@kernel-b
                   |rg                          |ugs.osdl.org
            Product|IO/Storage                  |SCSI Drivers




--- Comment #1 from Andrew Morton <akpm@linux-foundation.org>  2009-09-30 22:49:58 ---
Reassigned to scsi, cc'ed Eric.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
