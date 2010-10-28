From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 21172] OOPS in disk_replace_part_tbl.
Date: Thu, 28 Oct 2010 18:25:26 GMT
Message-ID: <201010281825.o9SIPQ50029435@demeter2.kernel.org>
References: <bug-21172-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:33969 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933945Ab0J1SZ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 14:25:27 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9SIPQvk029436
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2010 18:25:26 GMT
In-Reply-To: <bug-21172-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=21172


Greg Kroah-Hartman <greg@kroah.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|USB                         |SCSI
         AssignedTo|greg@kroah.com              |linux-scsi@vger.kernel.org
            Product|Drivers                     |IO/Storage




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
