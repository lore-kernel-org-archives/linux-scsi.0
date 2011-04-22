From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 33802] list_del corruption in sd driver since 2.6.39-rc4
Date: Fri, 22 Apr 2011 09:25:43 GMT
Message-ID: <201104220925.p3M9Phuo024208@demeter2.kernel.org>
References: <bug-33802-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:51895 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab1DVJZo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2011 05:25:44 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p3M9PhVN024209
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2011 09:25:43 GMT
In-Reply-To: <bug-33802-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=33802





--- Comment #2 from Stefan Richter <stefanr@s5r6.in-berlin.de>  2011-04-22 09:25:42 ---
PS,
in my case the bug happened not during boot but during power-up of a monitor
with built-in USB card reader.  Such a power-up happened circa 10 times in that
2.6.39-rc3 session --- plus a few other plug-in events of USB and FireWire
disks --- without the bug hitting.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
