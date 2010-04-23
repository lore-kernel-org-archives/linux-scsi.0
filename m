From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15721] mptsas cannot dectect hotplugged harddisks occasionally
Date: Fri, 23 Apr 2010 08:34:08 GMT
Message-ID: <201004230834.o3N8Y8K7018858@demeter.kernel.org>
References: <bug-15721-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35965 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab0DWIeJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Apr 2010 04:34:09 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3N8Y8NQ018859
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2010 08:34:08 GMT
In-Reply-To: <bug-15721-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15721


kdesai <kashyap.desai@lsi.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kashyap.desai@lsi.com




--- Comment #8 from kdesai <kashyap.desai@lsi.com>  2010-04-23 08:33:58 ---
(In reply to comment #6)
> Created an attachment (id=25987)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=25987) [details]
> fix sata hotplug problem from lsi
> 
> This patch is from lsi. It seems that it makes situation much better. If we
> plug only one disk, it is always found now. (50 times testing passed
> successfully). However, if we plug several disks together, there are still one
> to three disks missing.
LSI has plan to post this patch soon. we are doing more testing on this patch.
We are not seeing this issue(multiple SATA drivers hotplug) in our LAB. If you
can provide me logs with and without debug level = 0x100000 I can provide my
analysis. 
"echo 0x100000 > /sys/modules/mptbase/parameters/mpt_debug_level"

Thanks, Kashyap

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
