From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25602] [regression] 2.6.37-rc5: scsi_eh_11 CPU loop
Date: Fri, 24 Dec 2010 14:01:50 GMT
Message-ID: <201012241401.oBOE1oJh029255@demeter1.kernel.org>
References: <bug-25602-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:51982 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab0LXOBu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Dec 2010 09:01:50 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oBOE1oXL029256
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 24 Dec 2010 14:01:50 GMT
In-Reply-To: <bug-25602-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=25602


Maciej Rutecki <maciej.rutecki@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Blocks|                            |21782




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
