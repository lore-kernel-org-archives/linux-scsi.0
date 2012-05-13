From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43213] sata_svw failed to kdump with pending IOs
Date: Sun, 13 May 2012 14:26:35 +0000 (UTC)
Message-ID: <20120513142635.2D73811F973@bugzilla.kernel.org>
References: <bug-43213-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53535 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab2EMO0j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 May 2012 10:26:39 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 33D082038C
	for <linux-scsi@vger.kernel.org>; Sun, 13 May 2012 14:26:38 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 3B11D203E9
	for <linux-scsi@vger.kernel.org>; Sun, 13 May 2012 14:26:35 +0000 (UTC)
In-Reply-To: <bug-43213-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=43213


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
