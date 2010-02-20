From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15362] MPT Fusion SCSI drives no longer appear - suspect PCI
 bus scan bug
Date: Sat, 20 Feb 2010 15:22:15 GMT
Message-ID: <201002201522.o1KFMFis032457@demeter.kernel.org>
References: <bug-15362-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42042 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab0BTPWQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2010 10:22:16 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1KFMFd8032458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 20 Feb 2010 15:22:16 GMT
In-Reply-To: <bug-15362-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15362


Matthew Wilcox <matthew@wil.cx> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |matthew@wil.cx
          Component|SCSI                        |PCI
         AssignedTo|linux-scsi@vger.kernel.org  |drivers_pci@kernel-bugs.osd
                   |                            |l.org
            Product|IO/Storage                  |Drivers




--- Comment #6 from Matthew Wilcox <matthew@wil.cx>  2010-02-20 15:22:09 ---
OK, this is clearly a PCI issue, nothing to do with SCSI.

It looks like everything outside domain 0 is now not found.  This seems to be
due to the MMCONFIG access option not being used.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
