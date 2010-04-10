From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15722] unreliable IO for ata disks under heavy io load
Date: Sat, 10 Apr 2010 00:50:35 GMT
Message-ID: <201004100050.o3A0oZZV006694@demeter.kernel.org>
References: <bug-15722-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59498 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab0DJAug (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2010 20:50:36 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3A0oZH2006695
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2010 00:50:35 GMT
In-Reply-To: <bug-15722-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15722


Andrew Morton <akpm@linux-foundation.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|Serial ATA                  |Other
         AssignedTo|jgarzik@pobox.com           |scsi_drivers-other@kernel-b
                   |                            |ugs.osdl.org
            Product|IO/Storage                  |SCSI Drivers




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
