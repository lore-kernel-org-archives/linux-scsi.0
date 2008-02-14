From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: FW: [Bug 9859] hp smart array E200i kernel panic upon boot
Date: Thu, 14 Feb 2008 19:30:12 +0000
Message-ID: <DEE40752C8AF224BB890E455C7B8E0FE04243ECFB2@G6W0268.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:29666 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758588AbYBNTa5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2008 14:30:57 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Ross Fomerand <ross@upocnetworks.com>, Fabio Coatti <fabio.coatti@staff.dada.net>, "spam@jwdt.org" <spam@jwdt.org>


> -----Original Message-----
> From: bugme-daemon@bugzilla.kernel.org
> [mailto:bugme-daemon@bugzilla.kernel.org]
> Sent: Thursday, February 14, 2008 8:16 AM
> To: Miller, Mike (OS Dev)
> Subject: [Bug 9859] hp smart array E200i kernel panic upon boot
>
> http://bugzilla.kernel.org/show_bug.cgi?id=9859
>
>
> spam@jwdt.org changed:
>
>            What    |Removed                     |Added
> --------------------------------------------------------------
> --------------
>                  CC|                            |spam@jwdt.org
>
>
>
>
> ------- Comment #14 from spam@jwdt.org  2008-02-14 06:16
> ------- I'm facing a problem that seems related also using
> gentoo on a x86_64 configuration (Dual Opteron 270 on Tyan
> K8SE) I'm booting from a 3ware 9500s controller.
> Everything went find with 2.6.23 but stating from 2.6.24 i
> get the same kernel panic message: Unable to mount root fs on
> unknown-block(0,0) The sd messages for sda and sdb that
> appear under 2.6.23 do no longer appear with 2.6.24 though
> the 3ware driver reports it's loaded
>

Andrew,
The latest reports being added to the bug point to something other than cciss. This user is reporting the same problem on a white box with a 3ware SAS card. I've recreated the problem in my lab with a DL385 Opteron server. I've confirmed the 2.6.24.x kernels do not fail on Intel based platforms.
The question is what changed in the kernel to to break AMD platforms. I'll keep looking and post any updates.

-- mikem

>
> --
> Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: ------- You are
> the assignee for the bug, or are watching the assignee.
>
