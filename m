From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17551] mpt2sas -- spurious hotplug event causes drive to drop
 out of JBOD array
Date: Sun, 5 Sep 2010 16:55:25 GMT
Message-ID: <201009051655.o85GtPdh029098@demeter1.kernel.org>
References: <bug-17551-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34485 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab0IEQz0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Sep 2010 12:55:26 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o85GtP5D029099
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 5 Sep 2010 16:55:25 GMT
In-Reply-To: <bug-17551-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=17551





--- Comment #10 from starlight@binnacle.cx  2010-09-05 16:55:19 ---
Arrgh!  It appears the the this drive has a bad firmware that hangs and freezes
along with excessively parking the heads.  Even better, Seagate has not
released a fix.  Second server with bad Seagate firmware--defintaely sticking
with Western Digital going forward.

http://forums.seagate.com/t5/Momentus-XT-Momentus-and/Momentus-ST9500420AS-Firmware-Update/td-p/33862

Hopefully the disabling of APM will avoid the firmware bug.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
