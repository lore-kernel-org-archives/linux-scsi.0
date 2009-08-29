From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 8213] Race: a lock is expected before calling
 BusLogic_WriteOutgoingMailbox, but it is not held in some case and it is held
 in other cases
Date: Sat, 29 Aug 2009 09:29:57 GMT
Message-ID: <200908290929.n7T9TvY9003029@demeter.kernel.org>
References: <bug-8213-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57549 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZH2J3z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Aug 2009 05:29:55 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7T9Tv0s003042
	for <linux-scsi@vger.kernel.org>; Sat, 29 Aug 2009 09:29:57 GMT
In-Reply-To: <bug-8213-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=8213


Roland Kletzing <devzero@web.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |devzero@web.de




--- Comment #2 from Roland Kletzing <devzero@web.de>  2009-08-29 09:29:56 ---
Hello Lin, 

i`m curious how this report sits here unnoticed for so long. does that still
apply? 

WRT MAINTAINERS file, there seems no special maintainer for buslogic driver.
i`d bring that up on linux-scsi ML.

SCSI SUBSYSTEM
P:      James E.J. Bottomley
M:      James.Bottomley@HansenPartnership.com
L:      linux-scsi@vger.kernel.org
T:      git
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
T:      git
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
T:      git
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-pending-2.6.git
S:      Maintained
F:      drivers/scsi/
F:      include/scsi/

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
