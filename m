From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14118] USB storage: "No sense [current]" when connecting
Date: Mon, 28 Sep 2009 18:01:18 GMT
Message-ID: <200909281801.n8SI1IFp019863@demeter.kernel.org>
References: <bug-14118-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42964 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbZI1SBO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2009 14:01:14 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8SI1IGd019864
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2009 18:01:18 GMT
In-Reply-To: <bug-14118-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14118





--- Comment #9 from Alan Stern <stern@rowland.harvard.edu>  2009-09-28 18:01:16 ---
Created an attachment (id=23196)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23196)
Patch to handle errors with no sense

Try this patch.  It should fix the problem of the unending retries.  There will
still be errors, but each one will be retried only a small number of times.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
