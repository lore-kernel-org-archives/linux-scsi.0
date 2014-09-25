From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85101] hpsa + P410 does not show connected HP SAS port
 expanders
Date: Thu, 25 Sep 2014 22:35:28 +0000
Message-ID: <bug-85101-11613-qsWZ42crbh@https.bugzilla.kernel.org/>
References: <bug-85101-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45813 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbaIYWfc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 18:35:32 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 55AC02034E
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2014 22:35:30 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 79120202F8
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2014 22:35:28 +0000 (UTC)
In-Reply-To: <bug-85101-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85101

--- Comment #7 from Robert Elliott <elliott@hp.com> ---
You need to specify a download microcode mode.  Using deferred activation, the
most modern approach:

1. sg_write_buffer --mode=dmc_offs_defer --bpw=4096 --in=xxx.bin /dev/sgXX
2. sg_write_buffer --mode=activate_mc /dev/sgXX

Older devices might only support mode 0x7.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
