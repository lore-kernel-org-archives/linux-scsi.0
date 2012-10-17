From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48871] drivers/scsi/lpfc/lpfc_init.c: 2 * Buffer is accessed
 out of bounds
Date: Wed, 17 Oct 2012 10:26:35 +0000 (UTC)
Message-ID: <20121017102635.A6DB211FC6B@bugzilla.kernel.org>
References: <bug-48871-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45637 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022Ab2JQK0j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2012 06:26:39 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3BD5D201DF
	for <linux-scsi@vger.kernel.org>; Wed, 17 Oct 2012 10:26:38 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 3FBE1201E3
	for <linux-scsi@vger.kernel.org>; Wed, 17 Oct 2012 10:26:36 +0000 (UTC)
In-Reply-To: <bug-48871-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=48871


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
          Component|Other                       |Other
         AssignedTo|drivers_other@kernel-bugs.o |scsi_drivers-other@kernel-b
                   |sdl.org                     |ugs.osdl.org
            Product|Drivers                     |SCSI Drivers




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
