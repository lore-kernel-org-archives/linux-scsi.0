From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12762] Disk errors loop forever in 2.6.29
Date: Mon, 23 Feb 2009 15:13:34 -0800 (PST)
Message-ID: <20090223231334.395B1108042@picon.linux-foundation.org>
References: <bug-12762-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbZBWXX0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2009 18:23:26 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1NNMuBk024539
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2009 15:22:57 -0800
In-Reply-To: <bug-12762-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12762





------- Comment #1 from rjw@sisk.pl  2009-02-23 15:13 -------
Caused by:

commit b60af5b0adf0da24c673598c8d3fb4d4189a15ce
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Mon Nov 3 15:56:47 2008 -0500

    [SCSI] simplify scsi_io_completion()

    Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

First-Bad-Commit : b60af5b0adf0da24c673598c8d3fb4d4189a15ce


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
