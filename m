From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 21372] NULL pointer deference at disk_replace_part_tbl+0x32
Date: Thu, 28 Oct 2010 17:35:56 GMT
Message-ID: <201010281735.o9SHZuss006794@demeter2.kernel.org>
References: <bug-21372-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:35123 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab0J1Rf7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 13:35:59 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9SHZuSx006795
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2010 17:35:56 GMT
In-Reply-To: <bug-21372-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=21372


Greg Kroah-Hartman <greg@kroah.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |greg@kroah.com
          Component|USB                         |SCSI
         AssignedTo|greg@kroah.com              |linux-scsi@vger.kernel.org
            Product|Drivers                     |IO/Storage




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
