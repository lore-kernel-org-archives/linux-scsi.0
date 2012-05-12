From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32362] ATA Passthrough generates incorrect LBA addresses with
 OS ASYNC activity, Image of Bus-trace attached
Date: Sat, 12 May 2012 14:49:08 +0000 (UTC)
Message-ID: <20120512144908.1068411FCE1@bugzilla.kernel.org>
References: <bug-32362-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50778 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab2ELOtL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 May 2012 10:49:11 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DEDE92039A
	for <linux-scsi@vger.kernel.org>; Sat, 12 May 2012 14:49:10 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 129812038D
	for <linux-scsi@vger.kernel.org>; Sat, 12 May 2012 14:49:08 +0000 (UTC)
In-Reply-To: <bug-32362-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=32362


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
          Component|Other                       |Serial ATA
         AssignedTo|scsi_drivers-other@kernel-b |jgarzik@pobox.com
                   |ugs.osdl.org                |
            Product|SCSI Drivers                |IO/Storage




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
