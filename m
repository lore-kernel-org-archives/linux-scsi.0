From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12742] Spinning up disk is observed on standby paths until
 timeout, resulting in longer path restoration time.
Date: Mon, 6 Apr 2009 08:52:07 GMT
Message-ID: <200904060852.n368q7Xl014510@demeter.kernel.org>
References: <bug-12742-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58622 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbZDFIwJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 04:52:09 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n368q7dq014511
	for <linux-scsi@vger.kernel.org>; Mon, 6 Apr 2009 08:52:07 GMT
In-Reply-To: <bug-12742-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12742


Narayanan <narayanan.rengarajan@hp.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX
         Regression|---                         |No




--- Comment #2 from Narayanan <narayanan.rengarajan@hp.com>  2009-04-06 08:52:07 ---
code fix is available in 2.6.29-1

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
