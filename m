From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 69871] drivers/scsi/bfa/bfad_bsg.c:110: possible bad array
 index ?
Date: Tue, 04 Feb 2014 10:54:59 +0000
Message-ID: <bug-69871-11613-QcNALGlz39@https.bugzilla.kernel.org/>
References: <bug-69871-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43732 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaBDKzD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Feb 2014 05:55:03 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C8E35201BA
	for <linux-scsi@vger.kernel.org>; Tue,  4 Feb 2014 10:55:01 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 2924F2017B
	for <linux-scsi@vger.kernel.org>; Tue,  4 Feb 2014 10:55:00 +0000 (UTC)
In-Reply-To: <bug-69871-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=69871

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
          Component|Other                       |Other
           Assignee|drivers_other@kernel-bugs.o |scsi_drivers-other@kernel-b
                   |sdl.org                     |ugs.osdl.org
            Product|Drivers                     |SCSI Drivers

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
