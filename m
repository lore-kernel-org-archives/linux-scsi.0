From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15493] [cppcheck] found a memory leak in
 linux-2.6/drivers/scsi/aacraid/commctrl.c
Date: Thu,  5 Jul 2012 16:04:12 +0000 (UTC)
Message-ID: <20120705160412.BE13F11FA64@bugzilla.kernel.org>
References: <bug-15493-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52192 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409Ab2GEQEQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jul 2012 12:04:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A8FE02014E
	for <linux-scsi@vger.kernel.org>; Thu,  5 Jul 2012 16:04:15 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 76B3F2027F
	for <linux-scsi@vger.kernel.org>; Thu,  5 Jul 2012 16:04:13 +0000 (UTC)
In-Reply-To: <bug-15493-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15493


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
