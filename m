From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 70751] mpt2sas: system disks dropped when execute SMART tests
Date: Sat, 10 May 2014 00:08:02 +0000
Message-ID: <bug-70751-11613-PpSS9PluNM@https.bugzilla.kernel.org/>
References: <bug-70751-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55295 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaEJAIG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 May 2014 20:08:06 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E0A63201DD
	for <linux-scsi@vger.kernel.org>; Sat, 10 May 2014 00:08:04 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 375722018E
	for <linux-scsi@vger.kernel.org>; Sat, 10 May 2014 00:08:03 +0000 (UTC)
In-Reply-To: <bug-70751-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=70751

Mitchell Taylor <mitchtaydev@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mitchtaydev@gmail.com

--- Comment #3 from Mitchell Taylor <mitchtaydev@gmail.com> ---
I think I'm encountering this problem also.
I recently built a new server with an LSI 9240-8i flashed with IT
(initiator-target) firmware for HDD passthrough.
The kernel runs this with the mpt2sas driver and often whenever the S.M.A.R.T.
tests kick off; either short or long; one or maybe more of the disks get
dropped.

I am currently using the HBA to pass through 8 WD RE4 drives to the OS for
Linux Software RAID in RAID6 which obviously causes the array to degrade. In
one instance a total of 4 drives were dropped at the start of a short test
causing it to FAIL.

The operating system is Debian Squeeze running kernel version:

Linux behemoth 2.6.32-5-amd64 #1 SMP Wed Apr 9 19:24:34 UTC 2014 x86_64
GNU/Linux

and modinfo:

filename:      
/lib/modules/2.6.32-5-amd64/kernel/drivers/scsi/mpt2sas/mpt2sas.ko
version:        02.100.03.00
license:        GPL
description:    LSI MPT Fusion SAS 2.0 Device Driver
author:         LSI Corporation <DL-MPTFusionLinux@lsi.com>
srcversion:     E7ED0E0268B434FD561F7B1

I will upload the dmesg information from a recent failure also.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
