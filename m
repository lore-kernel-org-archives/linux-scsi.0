From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 67091] scsi/be2iscsi/be_main.c:328: possible bad if expression
 ?
Date: Wed, 18 Dec 2013 14:24:38 +0000
Message-ID: <bug-67091-11613-8nIo1tBSXu@https.bugzilla.kernel.org/>
References: <bug-67091-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38536 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab3LROYt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Dec 2013 09:24:49 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EB367204D3
	for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2013 14:24:47 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4BA2A204E0
	for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2013 14:24:43 +0000 (UTC)
In-Reply-To: <bug-67091-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=67091

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
