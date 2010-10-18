From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20712] mpt2sas and SATA drives
Date: Mon, 18 Oct 2010 19:58:21 GMT
Message-ID: <201010181958.o9IJwLE2014695@demeter2.kernel.org>
References: <bug-20712-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:37692 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab0JRT6X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2010 15:58:23 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9IJwMcD014697
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2010 19:58:22 GMT
In-Reply-To: <bug-20712-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=20712





--- Comment #2 from David Zeuthen <zeuthen@gmail.com>  2010-10-18 19:58:19 ---
(In reply to comment #1)
> timeout=2000,

Btw, bumping the timeout doesn't fix the problem (bumping the timeout from
2000ms would probably be a good idea regardless). We could retry sending the
command.. but my understanding is that we shouldn't have to do this, right?
Thanks for any insight.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
