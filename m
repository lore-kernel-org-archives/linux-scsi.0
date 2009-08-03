From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13873] QLA2xxx driver causes kernel oops with a qla2200
Date: Mon, 3 Aug 2009 02:03:33 GMT
Message-ID: <200908030203.n7323X3E025830@demeter.kernel.org>
References: <bug-13873-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55790 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbZHCCDc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Aug 2009 22:03:32 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7323XlH025831
	for <linux-scsi@vger.kernel.org>; Mon, 3 Aug 2009 02:03:33 GMT
In-Reply-To: <bug-13873-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13873


Thomas <tageorgiou@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Severity|normal                      |high




--- Comment #3 from Thomas <tageorgiou@gmail.com>  2009-08-03 02:03:32 ---
After such kernel oops occur, io starts hanging to certain devices, preventing
multipath from working and software raid from assembling arrays.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
