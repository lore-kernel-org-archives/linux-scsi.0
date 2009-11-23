From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14577] Data Corruption with Adaptec 52445, Firmware 5.2-0
 (17380)
Date: Mon, 23 Nov 2009 11:39:14 GMT
Message-ID: <200911231139.nANBdEUn011935@demeter.kernel.org>
References: <bug-14577-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:32899 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753AbZKWLjI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2009 06:39:08 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nANBdEgN011936
	for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2009 11:39:14 GMT
In-Reply-To: <bug-14577-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14577


lkolbe@techfak.uni-bielefeld.de changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




--- Comment #11 from lkolbe@techfak.uni-bielefeld.de  2009-11-23 11:39:11 ---
With rc7 _and_ new firmware 5.2-0 (17544) on the adaptec controller, this
problem doesn't occur anymore. Thanks for your patience.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
