From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15721] mptsas cannot dectect hotplugged harddisks occasionally
Date: Tue, 13 Apr 2010 09:16:02 GMT
Message-ID: <201004130916.o3D9G2XI017317@demeter.kernel.org>
References: <bug-15721-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59425 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab0DMJQF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2010 05:16:05 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3D9G3Hu017318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2010 09:16:03 GMT
In-Reply-To: <bug-15721-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15721





--- Comment #6 from dujun@perabytes.com  2010-04-13 09:15:51 ---
Created an attachment (id=25987)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=25987)
fix sata hotplug problem from lsi

This patch is from lsi. It seems that it makes situation much better. If we
plug only one disk, it is always found now. (50 times testing passed
successfully). However, if we plug several disks together, there are still one
to three disks missing.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
