From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16021] mptsas target reset under heavy duty
Date: Mon, 24 May 2010 09:05:12 GMT
Message-ID: <201005240905.o4O95CMe017181@demeter.kernel.org>
References: <bug-16021-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36791 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab0EXJFN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2010 05:05:13 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4O95CfS017184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 24 May 2010 09:05:12 GMT
In-Reply-To: <bug-16021-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16021





--- Comment #1 from dujun@perabytes.com  2010-05-24 09:05:12 ---
https://bugzilla.kernel.org/show_bug.cgi?id=14831 
with patch from above bug report, it seems it solved the problem. However the
performance is much worse than before.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
