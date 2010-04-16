From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 9123] 2.6.23-rcX SG_GET_SCSI_ID regression?
Date: Fri, 16 Apr 2010 06:19:04 GMT
Message-ID: <201004160619.o3G6J448020336@demeter.kernel.org>
References: <bug-9123-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38544 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab0DPGTI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Apr 2010 02:19:08 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3G6J4DI020337
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 16 Apr 2010 06:19:04 GMT
In-Reply-To: <bug-9123-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=9123


Florian Mickler <fmickler@gmx.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bugzilla@jako.ping.de,
                   |                            |fmickler@gmx.de




--- Comment #1 from Florian Mickler <fmickler@gmx.de>  2010-04-16 06:18:54 ---
that change probably wasn't intentional. There was some flux in the scsi
scanning code at that time. 

if it isn't fixed already and you can reproduce it (3 years ago?) , please
reopen this bug. 

i checked, and there were some fixes related to scsi scanning and also some
reverts of some bad conversions from/to the "new" scsi hotplug model... 

i close it as unreproducible.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
