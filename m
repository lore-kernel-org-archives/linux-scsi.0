From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12222] kernel BUG at drivers/pci/intel-iommu.c:1373!
Date: Sun, 14 Dec 2008 10:21:14 -0800 (PST)
Message-ID: <20081214182114.F3922108047@picon.linux-foundation.org>
References: <bug-12222-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751097AbYLNSVQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Dec 2008 13:21:16 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBEILFCP010415
	for <linux-scsi@vger.kernel.org>; Sun, 14 Dec 2008 10:21:16 -0800
In-Reply-To: <bug-12222-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12222





------- Comment #2 from anonymous@kernel-bugs.osdl.org  2008-12-14 10:21 -------
Reply-To: fujita.tomonori@lab.ntt.co.jp

On Sun, 14 Dec 2008 09:35:38 -0800 (PST)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=12222
> 
>            Summary: kernel BUG at drivers/pci/intel-iommu.c:1373!
>            Product: IO/Storage
>            Version: 2.5
>      KernelVersion: 2.6.26-gentoo-r4
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: john.blbec@centrum.cz
>                 CC: anil.s.keshavamurthy@intel.com
> 
> 
> Latest working kernel version: unknown

Probably, this is a VT-d bug. I saw the same bug report before:

http://lkml.org/lkml/2008/9/8/138

it's worth trying the latest kernel but I guess that the problem still
exists.

As Mark suggested, it's also worth trying 'intel_iommu=strict' kernel
boot option, I think. If it doesn't work, you can use a workaround to
disable VT-d with 'intel_iommu=off' kernel boot option.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
