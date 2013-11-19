From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 49241] [PATCH]Unsafe dereference of pointer after allocing
 memory
Date: Tue, 19 Nov 2013 22:40:52 +0000
Message-ID: <bug-49241-11613-D2tMjaRFH5@https.bugzilla.kernel.org/>
References: <bug-49241-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59800 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab3KSWk4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Nov 2013 17:40:56 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0BE9C205D1
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2013 22:40:56 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 0BF53205BC
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2013 22:40:53 +0000 (UTC)
In-Reply-To: <bug-49241-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=49241

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
            Summary|Unsafe dereference of       |[PATCH]Unsafe dereference
                   |pointer after allocing      |of pointer after allocing
                   |memory                      |memory

-- 
You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.
