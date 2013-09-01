From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Sun, 01 Sep 2013 00:17:42 +0000
Message-ID: <bug-60758-11613-MXrG5AvOcD@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47474 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab3IAARp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 Aug 2013 20:17:45 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 760D6202A1
	for <linux-scsi@vger.kernel.org>; Sun,  1 Sep 2013 00:17:44 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 6511E20265
	for <linux-scsi@vger.kernel.org>; Sun,  1 Sep 2013 00:17:42 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

--- Comment #16 from Alan Bartlett <ajb@elrepo.org> ---
For completeness (so that we cover 'every angle') I have built a version of our
kernel-ml-3.10.10 package (64-bit) with CONFIG_SCSI_SCAN_ASYNC=y, as Jeff has
suggested. It is available to download from --

http://elrepo.org/people/ajb/tmp/

However I do not expect that will make any difference.

-- 
You are receiving this mail because:
You are the assignee for the bug.
