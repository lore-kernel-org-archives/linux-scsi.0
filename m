From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Tue, 8 Jun 2010 08:43:00 GMT
Message-ID: <201006080843.o588h0hW022617@demeter.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57430 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab0FHInB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2010 04:43:01 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o588h0KY022618
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jun 2010 08:43:00 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #30 from kdesai <kashyap.desai@lsi.com>  2010-06-08 08:42:48 ---
(In reply to comment #29)
> (In reply to comment #28)
> 
> > linux 2.6.32 and the LSI official driver 4.22.00.00:
> 
> The official Linux driver seems to be 3.04.15 -
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/message/fusion/mptbase.h;hb=HEAD#l69
> 
> so my understanding is that you should probably be testing with this driver,
Yes. I would recommend use of 3.4.15 driver since it is a bug raised from
kernel.org. 

> rather than the 4.x LSI driver which hasn't made it into the Linux tree (yet). 
> The 4.x driver might be useful for providing additional data points.
> 
> Some official word from LSI on this would be useful.
> 
> Thanks,
> 
> Tim.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
