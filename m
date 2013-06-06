From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 59301] mpt2sas0 fails after short time of work
Date: Thu,  6 Jun 2013 10:08:07 +0000 (UTC)
Message-ID: <20130606100807.041D911FB30@bugzilla.kernel.org>
References: <bug-59301-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57142 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690Ab3FFKIO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jun 2013 06:08:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CAB26207C8
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jun 2013 10:08:08 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id C0EF0207BC
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jun 2013 10:08:07 +0000 (UTC)
In-Reply-To: <bug-59301-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=59301


Anton Pomozov <pomozoff@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|3.5.0-32-generic ubuntu     |3.5.0




--- Comment #1 from Anton Pomozov <pomozoff@gmail.com>  2013-06-06 10:08:06 ---
$ uname -a
Linux devserv2 3.5.0-32-generic #53~precise1-Ubuntu SMP Wed May 29 20:33:37 UTC
2013 x86_64 x86_64 x86_64 GNU/Linux

$ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=12.04
DISTRIB_CODENAME=precise
DISTRIB_DESCRIPTION="Ubuntu 12.04.2 LTS"

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
