From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42918] fcoe: Enabling VN2VN mode triggers a circular locking
 complaint
Date: Wed, 13 Jun 2012 15:17:24 +0000 (UTC)
Message-ID: <20120613151724.6350B12060C@bugzilla.kernel.org>
References: <bug-42918-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52109 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab2FMPR1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jun 2012 11:17:27 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5BCE6203BF
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2012 15:17:26 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 69942203B0
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2012 15:17:24 +0000 (UTC)
In-Reply-To: <bug-42918-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42918


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |CODE_FIX




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
