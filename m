From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13022] comparison of distinct pointer types lacks a cast
Date: Wed, 30 May 2012 15:18:24 +0000 (UTC)
Message-ID: <20120530151824.F2F1611FD1D@bugzilla.kernel.org>
References: <bug-13022-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38226 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab2E3PS1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2012 11:18:27 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CBF4420420
	for <linux-scsi@vger.kernel.org>; Wed, 30 May 2012 15:18:26 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id D32722041E
	for <linux-scsi@vger.kernel.org>; Wed, 30 May 2012 15:18:25 +0000 (UTC)
In-Reply-To: <bug-13022-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=13022


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |OBSOLETE




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
