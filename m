From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 44111] pata_via: crash with VT6415 controller
Date: Sun,  1 Jul 2012 23:39:02 +0000 (UTC)
Message-ID: <20120701233902.706D811FA36@bugzilla.kernel.org>
References: <bug-44111-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60003 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab2GAXjH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Jul 2012 19:39:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AADCB20223
	for <linux-scsi@vger.kernel.org>; Sun,  1 Jul 2012 23:39:05 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 14DB4201EE
	for <linux-scsi@vger.kernel.org>; Sun,  1 Jul 2012 23:39:04 +0000 (UTC)
In-Reply-To: <bug-44111-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=44111


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |ASSIGNED
          Component|Other                       |Serial ATA
         AssignedTo|scsi_drivers-other@kernel-b |jgarzik@pobox.com
                   |ugs.osdl.org                |
            Product|SCSI Drivers                |IO/Storage




--- Comment #3 from Alan <alan@lxorguk.ukuu.org.uk>  2012-07-01 23:39:02 ---
Unless you can find an old release that did work (if one ever did) it'll be
very hard to do much about. No docs.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
