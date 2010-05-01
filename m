From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13594] SMART responses for SATA disks on SAS get interpreted as
 errors
Date: Sat, 1 May 2010 04:45:18 GMT
Message-ID: <201005010445.o414jI6s026787@demeter.kernel.org>
References: <bug-13594-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34135 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab0EAEpU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 May 2010 00:45:20 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o414jIGi026788
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 1 May 2010 04:45:19 GMT
In-Reply-To: <bug-13594-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=13594


kdesai <kashyap.desai@lsi.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kashyap.desai@lsi.com

AndCycle <andcycle-bugzilla.kernel.org@andcycle.idv.tw> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |andcycle-bugzilla.kernel.or
                   |                            |g@andcycle.idv.tw

Don Bindner <don.bindner@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |don.bindner@gmail.com




--- Comment #10 from kdesai <kashyap.desai@lsi.com>  2010-04-05 07:49:42 ---
Claudio,

I tried doing similar stuffs at my setup and I was not able to see similar
issue as reported by you.

We need to know whether it is specific to SATA disk or generic issue.

Can you please provide me next possible details as mentioned below?

a) How about using different SATA disk instead of which you are using
currently. What is behavior in that case?
b) I did below steps to reproduce things. (Please correct me if anything
missing while mimicking your test case)
    mdadm --create --verbose /dev/md0 --level=raid1 --raid-devices=2 /dev/sdc
/dev/sdd
    "while true; do smartclt -a /dev/sdX; done;" 
I kept running it for 15 min, I could not see any issue in my setup.
Is this correct way of reproducing the issue?

My disk are Seagate ST320000641AS (2TB) FW version CC12.


I am suspecting this issue may be mapped to the end devices also. 
Need to clarify this doubt doing some other combinations of experiment. Can you
provide details on my queries to jump next steps of investigation?


--Kashyap

--- Comment #11 from AndCycle <andcycle-bugzilla.kernel.org@andcycle.idv.tw>  2010-04-27 22:29:53 ---
oops, someone just get a more detail view over this problem on LKML,
I am gonna trying this

Date    Mon, 26 Apr 2010 18:11:54 -0500
>From    Ryan Kuester <>
Subject    mptsas hangs caused by ATA pass-through explained

http://lkml.org/lkml/2010/4/26/335

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
