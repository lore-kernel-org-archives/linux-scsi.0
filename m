From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 49241] [PATCH]Unsafe dereference of pointer after allocing
 memory
Date: Fri, 27 Dec 2013 18:14:22 +0000
Message-ID: <bug-49241-11613-OuB0alLIft@https.bugzilla.kernel.org/>
References: <bug-49241-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60653 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab3L0SOZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Dec 2013 13:14:25 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DD76A2015A
	for <linux-scsi@vger.kernel.org>; Fri, 27 Dec 2013 18:14:23 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 23B4820161
	for <linux-scsi@vger.kernel.org>; Fri, 27 Dec 2013 18:14:23 +0000 (UTC)
In-Reply-To: <bug-49241-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=49241

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|ASSIGNED                    |RESOLVED
         Resolution|---                         |CODE_FIX

-- 
You are receiving this mail because:
You are on the CC list for the bug.
