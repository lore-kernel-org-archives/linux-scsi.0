From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 49241] [PATCH]Unsafe dereference of pointer after allocing
 memory
Date: Wed, 20 Nov 2013 13:50:53 +0000
Message-ID: <bug-49241-11613-AmvnluJ6lE@https.bugzilla.kernel.org/>
References: <bug-49241-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40865 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab3KTNvB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Nov 2013 08:51:01 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7E8E720728
	for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2013 13:51:00 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 1AA1720738
	for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2013 13:50:58 +0000 (UTC)
In-Reply-To: <bug-49241-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=49241

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |ASSIGNED

-- 
You are receiving this mail because:
You are on the CC list for the bug.
