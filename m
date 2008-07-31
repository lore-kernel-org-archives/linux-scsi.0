From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11194] megaraid_mbox kernel panic during st driver initialization
Date: Thu, 31 Jul 2008 10:48:22 -0700 (PDT)
Message-ID: <20080731174822.9672F108035@picon.linux-foundation.org>
References: <bug-11194-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753143AbYGaRsn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2008 13:48:43 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m6VHmMuY009779
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2008 10:48:23 -0700
In-Reply-To: <bug-11194-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11194





------- Comment #1 from anonymous@kernel-bugs.osdl.org  2008-07-31 10:48 -------
Reply-To: akpm@linux-foundation.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

This bugzilla report appears to not have been sent out to the scsi list.

On Thu, 31 Jul 2008 07:15:37 -0700 (PDT) bugme-daemon@bugzilla.kernel.org
wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11194
> 
>            Summary: megraid_mbox kernel panic during st driver
>                     initialization
>            Product: IO/Storage
>            Version: 2.5
>      KernelVersion: 2.6.25
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: cshore@fionavar.ca
> 
> 
> Latest working kernel version: 2.6.24
> 
> Earliest failing kernel version: 2.6.26

The kernel versions are ambiguous.

Which is the earliest failing kernel version?

> Distribution: Debian Lenny (-testing + -unstable + kernel trunk for debian)
> 
> Hardware Environment: ASUS P4B 2.0 GHz P4 Motherboard, Dell PERC3/DC (like AMI
> MegraRAID Elite 1600) LVD Ultra3 SCSI Adaptor with four 80 GB drives on Channel
> 0 and a SCSI-U2 Seagate DDS-4 tape drive on Channel 1
> Software Environment:  Debian Lenny (up-to-date), with some unstable and tested
> with the testing kernel (.25) and the trunk kernel (.26)
> 
> Problem Description: The kernel panics (claiming it's in the megaraid_mbox
> driver) during boot when the st driver would normally report 
> 
> st0: Block limits 1 - 16777215 bytes.
> 
> This is after the logical disk has been found and all filesystems mounted, so
> the RAID part of the driver is probably fine.
> 
> 
> The point at which 
> 
> st 0:1:6:0: Attached scsi tape st0
> st 0:1:6:0: st0: try direct i/o: yes (alignment 512 B)
> 
> appears with .24 is passed before the panic, but I haven't actually seen those
> messages as they scroll by too quickly.
> 
> Steps to reproduce:
> 
> 1) Install debian lenny with a .24 kernel (I'm not sure how you would do that
> now that .24 is no longer the testing kernel); maybe beta2 would still let you.
> 2) Install -testing kernel (.25)
> 3) Attempt to boot using the new kernel
> 4) Kernel panics, system is unusable
> 


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
