From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 31212] aacraid is generally unstable with newer kernels
Date: Wed, 16 Mar 2011 17:48:12 GMT
Message-ID: <201103161748.p2GHmC4f011566@demeter1.kernel.org>
References: <bug-31212-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:47920 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab1CPRsN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2011 13:48:13 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p2GHmC7w011568
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2011 17:48:12 GMT
In-Reply-To: <bug-31212-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=31212





--- Comment #3 from Ryan Underwood <nemesis@icequake.net>  2011-03-16 17:47:20 ---
Others seem to be having similar problems in last few years' kernels with no
clear resolution, see following links:

http://communities.vmware.com/thread/257273
http://lkml.org/lkml/2008/1/23/170
http://forum.proxmox.com/threads/3833-2.6.32-1-pve-aacraid-Host-adapter-reset-request.-SCSI-hang
http://lists.debian.org/debian-kernel/2009/05/msg00488.html
http://lists.debian.org/debian-user/2011/03/msg00553.html

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
