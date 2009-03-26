From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive
 gives EBUSY
Date: Thu, 26 Mar 2009 19:35:28 GMT
Message-ID: <200903261935.n2QJZSYe021530@demeter.kernel.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37805 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649AbZCZTfa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2009 15:35:30 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n2QJZSns021531
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2009 19:35:28 GMT
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX
         Regression|---                         |No




--- Comment #24 from Alan <alan@lxorguk.ukuu.org.uk>  2009-03-26 19:35:26 ---
5c16034d73da2c1b663aa25dedadbc533b3d811c

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
