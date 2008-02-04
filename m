From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9880] dma_free_coherent in arcmsr when calling areca tools
Date: Sun,  3 Feb 2008 19:00:37 -0800 (PST)
Message-ID: <20080204030037.6C061108018@picon.linux-foundation.org>
References: <bug-9880-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46967 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752837AbYBDDAj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Feb 2008 22:00:39 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m1430b4A016352
	for <linux-scsi@vger.kernel.org>; Sun, 3 Feb 2008 19:00:38 -0800
In-Reply-To: <bug-9880-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9880


greg@kroah.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|greg@kroah.com              |scsi_drivers-other@kernel-
                   |                            |bugs.osdl.org
          Component|PCI                         |Other
            Product|Drivers                     |SCSI Drivers




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
