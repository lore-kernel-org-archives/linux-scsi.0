From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15722] unreliable IO for ata disks under heavy io load
Date: Fri, 9 Apr 2010 20:57:13 GMT
Message-ID: <201004092057.o39KvDfW001514@demeter.kernel.org>
References: <bug-15722-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44239 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab0DIU5O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2010 16:57:14 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o39KvDJC001523
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 9 Apr 2010 20:57:13 GMT
In-Reply-To: <bug-15722-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15722


dujun@perabytes.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |INVALID
           Severity|high                        |low

Andrew Morton <akpm@linux-foundation.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |akpm@linux-foundation.org
          Component|Other                       |Serial ATA
         AssignedTo|scsi_drivers-other@kernel-b |jgarzik@pobox.com
                   |ugs.osdl.org                |
            Product|SCSI Drivers                |IO/Storage




--- Comment #1 from dujun@perabytes.com  2010-04-09 09:15:33 ---
This should not be related with mptsas driver. We tested the same scenario with
lsi 36x expander and could not reproduce the same problem. It seems that the
problem is related to the original lsi 24x expander. Maybe the expander
firmware problem.

--- Comment #2 from Andrew Morton <akpm@linux-foundation.org>  2010-04-09 20:57:05 ---
I think this is more likely to be a libata problem than a scsi problem?

I recategorised it that way, thanks.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
