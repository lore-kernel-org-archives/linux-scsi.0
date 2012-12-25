From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 31212] aacraid is generally unstable with newer kernels
Date: Tue, 25 Dec 2012 09:44:48 +0000 (UTC)
Message-ID: <20121225094448.32D2811FE9A@bugzilla.kernel.org>
References: <bug-31212-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49297 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab2LYJou (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Dec 2012 04:44:50 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 808052019D
	for <linux-scsi@vger.kernel.org>; Tue, 25 Dec 2012 09:44:49 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 9EA6F2019A
	for <linux-scsi@vger.kernel.org>; Tue, 25 Dec 2012 09:44:48 +0000 (UTC)
In-Reply-To: <bug-31212-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=31212


Dmitry Korzhevin <dkorzhevin@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dkorzhevin@gmail.com




--- Comment #12 from Dmitry Korzhevin <dkorzhevin@gmail.com>  2012-12-25 09:44:47 ---
Hi, our company have same problems with aacraid.

We using Debian 6.0.6 x86_64 wih proxmox-ve kernel:

Linux 2.6.32-17-pve #1 SMP Wed Nov 28 07:15:55 CET 2012 x86_64 GNU/Linux

modinfo aacraid:

filename:      
/lib/modules/2.6.32-17-pve/kernel/drivers/scsi/aacraid/aacraid.ko
version:        1.1-7[28000]-ms
license:        GPL
description:    Dell PERC2, 2/Si, 3/Si, 3/Di, Adaptec Advanced Raid Products,
HP NetRAID-4M, IBM ServeRAID & ICP SCSI driver
author:         Red Hat Inc and Adaptec
srcversion:     DAE1E62971BE24D8A2CE61F
vermagic:       2.6.32-17-pve SMP mod_unload modversions

Also, i will attach lspci info.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
