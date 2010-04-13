From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14579] Devices disappear; on bus reset machine hangs; on I/O
 machine hangs
Date: Tue, 13 Apr 2010 09:25:29 GMT
Message-ID: <201004130925.o3D9PT4R020169@demeter.kernel.org>
References: <bug-14579-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34957 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab0DMJZb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2010 05:25:31 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3D9PTQq020170
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2010 09:25:29 GMT
In-Reply-To: <bug-14579-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14579





--- Comment #8 from lkolbe@techfak.uni-bielefeld.de  2010-04-13 09:25:22 ---
fyi: Supermicro's X7DWN+ mainboard needs a BIOS-Update (at least version 1.2b,
no changelog available though) to cope with multiple SAS-controllers under
linux. In the end, Kashyap Desai was right when he suspected it had something
to do with IRQ-routing.

Seagates' firmware problems (timeouts) with Adaptecs RAID-Controller didn't
help with this either, as every few days more than two disks at a time were
thrown out of the array resulting in loss of said array. Supposedly, the newest
firmware 'DN06' for the Barracuda.ES2 drives fix these problems, but our
distributor was so kind to replace all our Seagate drives with Hitachis.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
