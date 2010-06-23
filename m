From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16275] Kernel panic when mounting filesystem
Date: Wed, 23 Jun 2010 07:20:22 GMT
Message-ID: <201006230720.o5N7KMFs000973@demeter.kernel.org>
References: <bug-16275-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42775 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab0FWHUY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2010 03:20:24 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o5N7KNUW000974
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2010 07:20:23 GMT
In-Reply-To: <bug-16275-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16275


Neil Brown <neilb@suse.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|MD                          |SCSI
         AssignedTo|neilb@suse.de               |linux-scsi@vger.kernel.org




--- Comment #2 from Neil Brown <neilb@suse.de>  2010-06-23 07:20:21 ---
The traceback in the attachments looks like this might be a SCSI problem.

Anyone able to look??
Thanks.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
