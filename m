From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 21372] NULL pointer deference at disk_replace_part_tbl+0x32
Date: Fri, 29 Oct 2010 14:38:10 GMT
Message-ID: <201010291438.o9TEcAY9011773@demeter2.kernel.org>
References: <bug-21372-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:56615 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab0J2OiM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2010 10:38:12 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9TEcBJn011774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2010 14:38:11 GMT
In-Reply-To: <bug-21372-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=21372


Jens Axboe <axboe@kernel.dk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |axboe@kernel.dk




--- Comment #2 from Jens Axboe <axboe@kernel.dk>  2010-10-29 14:38:09 ---
If this happened post 2.6.36, then it is indeed a known bug. So I'm a little
skeptic, are you sure this is 2.6.36 as released and not a -git somewhat passed
that? The version reads 2.6.36-wl+, so it's definitely not pristine 2.6.36.

So I'm pretty sure that this is the issue we fixed by reverting the io stat
change. If you update to a newer .36-git or go back to 2.6.36 as released, it
will work fine.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
