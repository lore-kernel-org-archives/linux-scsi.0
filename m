From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Mon, 11 Jan 2010 11:59:42 GMT
Message-ID: <201001111159.o0BBxg6c024153@demeter.kernel.org>
References: <bug-14831-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47982 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0AKL7n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2010 06:59:43 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0BBxhah024158
	for <linux-scsi@vger.kernel.org>; Mon, 11 Jan 2010 11:59:43 GMT
In-Reply-To: <bug-14831-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #8 from amf <andy.fletcher@ukdedicated.com>  2010-01-11 11:59:39 ---
We see this on numerous Dell hosts running the SAS6iR based on the LSISAS1068E
chip. Running the stock RHEL5 driver.

It's simple to reproduce with SMART commands, but we actually see huge issues
with drives dropping off cards even during heavy I/O and no SMART commands
involved at all. It seems to be all the worse when the disk reallocates a bad
sector. The disks are Dell-supplied and therefore 'enterprise' models capable
of TLER type behaviour.

I believe the SMART command method makes it easier to reproduce what may be a
problem not specifically related to SMART, but that's just my own feeling.

HTH.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
