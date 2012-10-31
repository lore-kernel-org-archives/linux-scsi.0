From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48871] drivers/scsi/lpfc/lpfc_init.c: 2 * Buffer is accessed
 out of bounds
Date: Wed, 31 Oct 2012 20:38:56 +0000 (UTC)
Message-ID: <20121031203856.39F0511FB91@bugzilla.kernel.org>
References: <bug-48871-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54337 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932542Ab2JaUi7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Oct 2012 16:38:59 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9EAEF2059A
	for <linux-scsi@vger.kernel.org>; Wed, 31 Oct 2012 20:38:58 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id B1FF02059F
	for <linux-scsi@vger.kernel.org>; Wed, 31 Oct 2012 20:38:57 +0000 (UTC)
In-Reply-To: <bug-48871-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=48871


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
