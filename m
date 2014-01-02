From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Thu, 02 Jan 2014 14:40:44 +0000
Message-ID: <bug-60644-11613-anrRlIFuwb@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56820 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbaABOkt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jan 2014 09:40:49 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E9DF520172
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2014 14:40:46 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id BB43020160
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2014 14:40:45 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

Tommy Apel <tommyapeldk@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tommyapeldk@gmail.com

--- Comment #36 from Tommy Apel <tommyapeldk@gmail.com> ---
Hello all,

I'm currently hitting this problem consistently with kernel 3.10.25 during
MDRAID6 resync, one thing that I found that will stop this from happening is to
disable SERR and PERR in BIOS, I don't know if that helps.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
