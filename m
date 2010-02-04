From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15227] sys-kernel/gentoo-sources-2.6.30-r4 - amlabel triggers
 opcode 0000 kernel bug
Date: Thu, 4 Feb 2010 20:34:13 GMT
Message-ID: <201002042034.o14KYDWi032036@demeter.kernel.org>
References: <bug-15227-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58676 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933345Ab0BDUeP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2010 15:34:15 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o14KYDTE032037
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 4 Feb 2010 20:34:13 GMT
In-Reply-To: <bug-15227-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15227


Andrew Morton <akpm@linux-foundation.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |akpm@linux-foundation.org,
                   |                            |kai.makisara@kolumbus.fi
          Component|Other                       |Other
         AssignedTo|other_other@kernel-bugs.osd |scsi_drivers-other@kernel-b
                   |l.org                       |ugs.osdl.org
            Product|Other                       |SCSI Drivers




--- Comment #1 from Andrew Morton <akpm@linux-foundation.org>  2010-02-04 20:34:12 ---
Looks like an st bug.  Reassigned to scsi, cc'ed Kai.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
