From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 106841] ses: do not output error for simple subenclosure
 (handle Short Enclosure Status diagnostic page)
Date: Sat, 27 Feb 2016 01:13:31 +0000
Message-ID: <bug-106841-11613-AAp8ExMfib@https.bugzilla.kernel.org/>
References: <bug-106841-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59968 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbcB0BNf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Feb 2016 20:13:35 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 650BC203DA
	for <linux-scsi@vger.kernel.org>; Sat, 27 Feb 2016 01:13:34 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 7A6542040F
	for <linux-scsi@vger.kernel.org>; Sat, 27 Feb 2016 01:13:32 +0000 (UTC)
In-Reply-To: <bug-106841-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=106841

Tom Yan <tom.ty89@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|do not output error for     |ses: do not output error
                   |simple subenclosure (handle |for simple subenclosure
                   |Short Enclosure Status      |(handle Short Enclosure
                   |diagnostic page)            |Status diagnostic page)

-- 
You are receiving this mail because:
You are the assignee for the bug.
