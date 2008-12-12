From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12195] "dd" make kernel panic
Date: Thu, 11 Dec 2008 18:27:04 -0800 (PST)
Message-ID: <20081212022704.5488C108042@picon.linux-foundation.org>
References: <bug-12195-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756274AbYLLC1H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 21:27:07 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBC2R41W007601
	for <linux-scsi@vger.kernel.org>; Thu, 11 Dec 2008 18:27:05 -0800
In-Reply-To: <bug-12195-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12195





------- Comment #6 from ming.m.lin@intel.com  2008-12-11 18:27 -------
2.6.28-rc8 also panic

addr2line -e vmlinux a0000001003971b0
linux-2.6.28-rc8/drivers/scsi/scsi_lib.c:1538

   1535 static void scsi_softirq_done(struct request *rq)
   1536 {
   1537         struct scsi_cmnd *cmd = rq->special;
   1538         unsigned long wait_for = (cmd->allowed + 1) * rq->timeout;
   1539         int disposition;



-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
