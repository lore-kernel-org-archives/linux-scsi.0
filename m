From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16539] end_request: I/O error, dev sr1, sector 0; quiet_error:
 40 callbacks suppressed
Date: Thu, 26 Aug 2010 21:56:55 GMT
Message-ID: <201008262156.o7QLutdE017280@demeter1.kernel.org>
References: <bug-16539-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52035 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab0HZV45 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Aug 2010 17:56:57 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o7QLuurI017284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 26 Aug 2010 21:56:56 GMT
In-Reply-To: <bug-16539-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16539


Andrew Morton <akpm@linux-foundation.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |akpm@linux-foundation.org,
                   |                            |axboe@kernel.dk,
                   |                            |tj@kernel.org
          Component|Other                       |SCSI
         AssignedTo|io_other@kernel-bugs.osdl.o |linux-scsi@vger.kernel.org
                   |rg                          |




--- Comment #3 from Andrew Morton <akpm@linux-foundation.org>  2010-08-26 21:56:51 ---
(recategorised as scsi)

[    3.468174] sr1: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda
tray
[    3.468305] sr 4:0:0:0: Attached scsi CD-ROM sr1
[    3.468381] sr 4:0:0:0: Attached scsi generic sg2 type 5
[    8.126108] EXT4-fs (sda5): mounted filesystem with ordered data mode
[   15.752273] udev: starting version 151
[   15.770035] Adding 3574424k swap on /dev/sda7.  Priority:-1 extents:1
across:3574424k 
[   16.055126] sony-laptop: Sony Notebook Control Driver v0.6.
[   16.090212] sr 4:0:0:0: [sr1] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[   16.090217] sr 4:0:0:0: [sr1] Sense Key : Illegal Request [current] 
[   16.090222] sr 4:0:0:0: [sr1] Add. Sense: Illegal mode for this track
[   16.090229] sr 4:0:0:0: [sr1] CDB: Read(10): 28 00 00 00 00 00 00 00 01 00
[   16.090239] end_request: I/O error, dev sr1, sector 0
[   16.090245] Buffer I/O error on device sr1, logical block 0

hm, who maintains drivers/scsi/sr.c?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
