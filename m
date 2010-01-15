From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15007] SCSI host adapter's scatter-gather list size Issue
Date: Fri, 15 Jan 2010 12:23:16 GMT
Message-ID: <201001151223.o0FCNGa8002934@demeter.kernel.org>
References: <bug-15007-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48699 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175Ab0AOMXQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2010 07:23:16 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0FCNGDM002935
	for <linux-scsi@vger.kernel.org>; Fri, 15 Jan 2010 12:23:16 GMT
In-Reply-To: <bug-15007-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15007





--- Comment #7 from nick cheng <nick.cheng@areca.com.tw>  2010-01-15 12:23:13 ---
Hi,
I got one more question.
What does sg_tablesize in scsi_host_template mean?
It means the max sg entry number which the HW can handle once?
I collect the sg table size from upper layer while I do mkfs.ext3.
The maximum number is circa one eighth of sg_tablesize.
Thanks for your reply in advance.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
