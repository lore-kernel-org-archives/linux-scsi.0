From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 58081] aacraid aac_rx_intr_message triggers BUG: spinlock
 lockup, async_umap_flush_lock in 3.4, 3.7, 3.8, 3.9
Date: Wed, 13 Nov 2013 20:33:24 +0000
Message-ID: <bug-58081-11613-q8QuI6OPAp@https.bugzilla.kernel.org/>
References: <bug-58081-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46211 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab3KMUdb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Nov 2013 15:33:31 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3DD7220831
	for <linux-scsi@vger.kernel.org>; Wed, 13 Nov 2013 20:33:30 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9B2702082E
	for <linux-scsi@vger.kernel.org>; Wed, 13 Nov 2013 20:33:24 +0000 (UTC)
In-Reply-To: <bug-58081-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=58081

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
          Component|Other                       |SCSI
           Assignee|other_other@kernel-bugs.osd |linux-scsi@vger.kernel.org
                   |l.org                       |
            Product|Other                       |IO/Storage

-- 
You are receiving this mail because:
You are the assignee for the bug.
