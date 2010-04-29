From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Thu, 29 Apr 2010 09:27:27 GMT
Message-ID: <201004290927.o3T9RRoK022352@demeter.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40848 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933190Ab0D3Rbo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2010 13:31:44 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3T9RRYT022353
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 29 Apr 2010 09:27:27 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #14 from amf <andy.fletcher@ukdedicated.com>  2010-04-29 09:27:19 ---
This isn't going to solve your MPTSAS problem, but may help you choose to move
on.

I've found LSI to be fairly unresponsive on this matter, and the same goes for
my vendor (Dell, who the moment you mention Linux just aren't interested).

LSI have now brought out their new range of 6Gb/sec based cards which use the
MPT2 system and I therefore doubt they will be progressing the development of
MPT any further.

The good news is that if you get hold of an MPT2 card (LSISAS2008 chipset) you
should (at least by my testing) be able to migrate your RAID to this card using
the BIOS. The MPT2 drivers seem a whole lot better (I understand they're a
complete re-write, which speaks volumes about how good the MPT driver was,
IMHO). I've not been able to break them so far.

Performance also seems to be quite improved.

HTH.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
