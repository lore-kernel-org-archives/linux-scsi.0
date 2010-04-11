From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15721] mptsas cannot dectect hotplugged harddisks occasionally
Date: Sun, 11 Apr 2010 00:51:58 GMT
Message-ID: <201004110051.o3B0pwSD004571@demeter.kernel.org>
References: <bug-15721-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41452 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab0DKAwI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2010 20:52:08 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3B0pxYv004573
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2010 00:51:59 GMT
In-Reply-To: <bug-15721-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15721





--- Comment #5 from dujun@perabytes.com  2010-04-11 00:50:53 ---
(From update of attachment 25912)
this doesn't proceed to test_unit_ready as the correct hotplug sequence but
directly to the mptsas_free_fw_event.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
