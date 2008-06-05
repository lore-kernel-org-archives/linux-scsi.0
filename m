From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10861] 2.6.26-rc4-git2 - long pause during boot
Date: Thu,  5 Jun 2008 14:26:37 -0700 (PDT)
Message-ID: <20080605212637.66A0C108047@picon.linux-foundation.org>
References: <bug-10861-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752422AbYFEV1G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2008 17:27:06 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m55LQbbW017662
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jun 2008 14:26:38 -0700
In-Reply-To: <bug-10861-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10861





------- Comment #1 from rjw@sisk.pl  2008-06-05 14:26 -------
Caused by:

commit b0ed43360fdca227048d88a08290365cb681c1a8
Author: Hannes Reinecke <hare@suse.de>
Date:   Tue Mar 18 14:32:28 2008 +0100

    [SCSI] add scsi_host and scsi_target to scsi_bus

    Signed-off-by: Hannes Reinecke <hare@suse.de>
    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
