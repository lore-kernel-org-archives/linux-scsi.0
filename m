From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Tue, 17 Nov 2009 10:57:52 GMT
Message-ID: <200911171057.nAHAvqoK012888@demeter.kernel.org>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42373 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbZKQK5q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2009 05:57:46 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAHAvqj7012889
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2009 10:57:52 GMT
In-Reply-To: <bug-14563-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14563





--- Comment #10 from Joachim Breuer <linux-kernel@jmbreuer.net>  2009-11-17 10:57:52 ---
Created an attachment (id=23815)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23815)
Console output with st DEBUG enabled, 2.6.30.3, fixed tape block size 512k

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
