From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Tue, 8 Jun 2010 06:44:53 GMT
Message-ID: <201006080644.o586irFD023836@demeter.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45830 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab0FHGoy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2010 02:44:54 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o586irhb023837
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jun 2010 06:44:53 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #29 from Tim Small <tim@seoss.co.uk>  2010-06-08 06:44:45 ---
(In reply to comment #28)

> linux 2.6.32 and the LSI official driver 4.22.00.00:

The official Linux driver seems to be 3.04.15 -

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/message/fusion/mptbase.h;hb=HEAD#l69

so my understanding is that you should probably be testing with this driver,
rather than the 4.x LSI driver which hasn't made it into the Linux tree (yet). 
The 4.x driver might be useful for providing additional data points.

Some official word from LSI on this would be useful.

Thanks,

Tim.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
