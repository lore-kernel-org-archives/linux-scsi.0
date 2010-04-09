From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15341] Load goes up very high when we traverse the large tree
Date: Fri, 9 Apr 2010 19:31:12 GMT
Message-ID: <201004091931.o39JVCBp008822@demeter.kernel.org>
References: <bug-15341-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37464 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab0DITbO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2010 15:31:14 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o39JVDq7008830
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 9 Apr 2010 19:31:13 GMT
In-Reply-To: <bug-15341-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15341





--- Comment #17 from Frederic MASSOT <frederic@juliana-multimedia.com>  2010-04-09 19:30:59 ---
Hi,

The kernel 2.6.33 seemed to be better than the 2.6.32 until I reboot with a
fsck.

The verification of 80GB took over 2 hours, unbelievable. With kernel 2.6.31
and earlier it did not take more than 10 or 15 minutes.

Regards.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
