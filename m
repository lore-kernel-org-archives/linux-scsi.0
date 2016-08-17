From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151661] Adaptec 3805 prints "AAC: Host adapter dead -1" every
 10 seconds but works fine anyway
Date: Wed, 17 Aug 2016 18:43:41 +0000
Message-ID: <bug-151661-11613-zTvx8mAS5w@https.bugzilla.kernel.org/>
References: <bug-151661-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35936 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbcHQSns (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Aug 2016 14:43:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 94C0E2013D
	for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2016 18:43:44 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 6674B2015A
	for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2016 18:43:41 +0000 (UTC)
In-Reply-To: <bug-151661-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151661

--- Comment #8 from David Gravereaux <davygrvy@pobox.com> ---
The 3405 in my lab computer exhibits the same symptoms. Ubuntu 16.04 LTS with
kernel 4.4.0-34-generic, also.

Both Adaptec 3805 and 3405 models

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
