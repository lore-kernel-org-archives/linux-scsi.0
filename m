From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14563] SCSI tape driver: Spurious EIO and kernel OOPS
Date: Mon, 9 Nov 2009 08:30:20 GMT
Message-ID: <200911090830.nA98UKha007892@demeter.kernel.org>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43854 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444AbZKIIaP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2009 03:30:15 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA98UKZg007893
	for <linux-scsi@vger.kernel.org>; Mon, 9 Nov 2009 08:30:20 GMT
In-Reply-To: <bug-14563-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14563





--- Comment #3 from Joachim Breuer <linux-kernel@jmbreuer.net>  2009-11-09 08:30:20 ---
Created an attachment (id=23705)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23705)
Hardware overview created using lshw under 2.6.27.10

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
