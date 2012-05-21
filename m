From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 10890] Heavy iSCSI traffic triggers memory allocation
 complaints and system lockup
Date: Mon, 21 May 2012 15:48:40 +0000 (UTC)
Message-ID: <20120521154840.51A4611FD17@bugzilla.kernel.org>
References: <bug-10890-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47636 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055Ab2EUPso (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 May 2012 11:48:44 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C57E1204DC
	for <linux-scsi@vger.kernel.org>; Mon, 21 May 2012 15:48:42 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id A36A2204CC
	for <linux-scsi@vger.kernel.org>; Mon, 21 May 2012 15:48:41 +0000 (UTC)
In-Reply-To: <bug-10890-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=10890


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
          Component|Other                       |Other
     Kernel Version|2.6.25.6                    |3.1.0
         AssignedTo|other_other@kernel-bugs.osd |scsi_drivers-other@kernel-b
                   |l.org                       |ugs.osdl.org
            Product|Other                       |SCSI Drivers
         Regression|---                         |No




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
