From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Mon, 29 Jul 2013 11:27:46 +0000
Message-ID: <bug-60644-11613-lN9OWyze9h@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43798 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab3G2L1t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jul 2013 07:27:49 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7A84220243
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 11:27:48 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 6AAEF2021F
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 11:27:46 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

Sreekanth Reddy <sreekanth.reddy@lsi.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sreekanth.reddy@lsi.com

--- Comment #3 from Sreekanth Reddy <sreekanth.reddy@lsi.com> ---
Hi, 

Can you please provide the driver logs my setting the driver logging level to
0x3f8.

Here are the steps to set the mpt2sas driver logging level

a.While loading the driver 
        modprobe mpt2sas logging_level=0x3f8

b. If driver is in ramdisk, then in RHEL5/SLES/OEL5 OS, following line has to
be added in /etc/modprobe.conf and reboot the system
    options mpt2sas logging_level=0x3f8
                (Or)
Add below word at the end of kernel module parameters line in
/boot/grub/menu.lst or /boot/grub/grub.conf file and reboot the system
    mpt2sas.logging_level=0x3f8

c. During driver run time
         echo 0x3f8 > /sys/module/mpt2sas/parameters/logging_level

Also please provide us the IO rate at which you are faceing this problem.

Regards,
Sreekanth

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
