From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11589] Mass-storage USB Device does not show up when CONFIG_SCSI_MULTI_LUN is set
Date: Thu, 18 Sep 2008 19:12:42 -0700 (PDT)
Message-ID: <20080919021242.C266E108059@picon.linux-foundation.org>
References: <bug-11589-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755944AbYISCMo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Sep 2008 22:12:44 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8J2CgHw002512
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2008 19:12:44 -0700
In-Reply-To: <bug-11589-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11589





------- Comment #3 from anonymous@kernel-bugs.osdl.org  2008-09-18 19:12 -------
Reply-To: akpm@linux-foundation.org

On Thu, 18 Sep 2008 18:22:23 -0700 (PDT) bugme-daemon@bugzilla.kernel.org
wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11589
> 
>            Summary: Mass-storage USB Device does not show up when
>                     CONFIG_SCSI_MULTI_LUN is set
>            Product: SCSI Drivers
>            Version: 2.5
>      KernelVersion: 2.6.26.5
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
>         ReportedBy: nico@lifeisabug.com
> 
> 
> Latest working kernel version: I *guess* all before 2.6.26
> Earliest failing kernel version: Not sure. See above
> Distribution: Gentoo Linux
> Hardware Environment: Mobo: Abit IC7-G
> Software Environment:
> Problem Description:
> 
> The problem is about my mobile phone (Sony Ericsson K810i) which normally shows
> up as two devices (phones internal memory and the memory card in it) when
> plugging it to USB. Just like any USB Memory stick.
> 
> The phones internal memory is fine, it shows up as /dev/sdc1 with multi_lun
> enabled or disabled and it does not show any warnings, thats how the memory
> card in the phone used to work too. I don't know with what kernel version this
> started, but let me explain it:
> 
> When CONFIG_SCSI_MULTI_LUN is set, the memory card does not show up as it
> should, I only see /dev/sdd but not /dev/sdd1 - it's unable to mount it that
> way.
> When CONFIG_SCSI_MULTI_LUN is not set, it does show up as /dev/sdd1 but gives
> me loads of warnings like "attempt to access beyond end of device", see dmesg
> for that. This way it is mountable and works fine except the warnings.
> 
> Steps to reproduce: Plug Sony Ericsson K810i to USB and set it to file transfer
> mode.
> 

Another of those might-be-usb, might-be-scsi bugs.  Apparently a
regression, too.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
