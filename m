From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 59301] mpt2sas0 fails after short time of work
Date: Wed,  3 Jul 2013 00:36:39 +0000 (UTC)
Message-ID: <20130703003639.EF6D311FA5F@bugzilla.kernel.org>
References: <bug-59301-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57044 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab3GCAgm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jul 2013 20:36:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 77DA320138
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jul 2013 00:36:41 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id F189D20134
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jul 2013 00:36:39 +0000 (UTC)
In-Reply-To: <bug-59301-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=59301





--- Comment #3 from Marian Marinov <mm@yuhu.biz>  2013-07-03 00:36:39 ---
[root@BlackPearl ~]# uname -a
Linux BlackPearl.yuhu.biz 2.6.32-358.11.1.el6.i686 #1 SMP Wed Jun 12 01:01:27
UTC 2013 i686 i686 i386 GNU/Linux
[root@BlackPearl ~]# cat /etc/redhat-release 
CentOS release 6.4 (Final)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
