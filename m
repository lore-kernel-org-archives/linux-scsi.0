From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 49461] scsi/bfa/bfad.c:1037: possible off by one in strncpy ?
Date: Thu, 25 Oct 2012 10:51:12 +0000 (UTC)
Message-ID: <20121025105112.2B45311FB59@bugzilla.kernel.org>
References: <bug-49461-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55682 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab2JYKvP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2012 06:51:15 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7BE23202D2
	for <linux-scsi@vger.kernel.org>; Thu, 25 Oct 2012 10:51:14 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 2F17A202C6
	for <linux-scsi@vger.kernel.org>; Thu, 25 Oct 2012 10:51:12 +0000 (UTC)
In-Reply-To: <bug-49461-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=49461


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
          Component|Other                       |SCSI
         AssignedTo|drivers_other@kernel-bugs.o |linux-scsi@vger.kernel.org
                   |sdl.org                     |
            Product|Drivers                     |IO/Storage




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
