From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 10057] New: gdth: unable to handle kernel NULL
 pointer dereference at virtual address 0000000c
Date: Thu, 21 Feb 2008 04:47:55 -0800
Message-ID: <20080221044755.45a522f0.akpm@linux-foundation.org>
References: <bug-10057-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50044 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513AbYBUMt3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Feb 2008 07:49:29 -0500
In-Reply-To: <bug-10057-10286@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, arne@meteo-graphics.de

On Thu, 21 Feb 2008 00:44:45 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=10057
> 
>            Summary: gdth: unable to handle kernel NULL  pointer dereference
>                     at virtual address 0000000c
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.24.2
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: drivers_other@kernel-bugs.osdl.org
>         ReportedBy: arne@meteo-graphics.de
> 
> 
> Latest working kernel version: 2.6.22.18
> Earliest failing kernel version: 2.6.24
> Distribution: Debian Etch, i386
> Hardware Environment: X6DAE-G2, 1x Xeon 2800, 2G, NVIDIA 5700 256MB PCI-X,
> Adaptec AHA-2940U/UW/D / AIC-7881U, GDT8586RZ with 4x250G RAID5 + 4x500G RAID5,
> 1x 80G IDE HDD, 1x IDE CD-ROM
> 
> Software Environment: -
> Problem Description: no scsi device available + system crash
> 
> Steps to reproduce: The module gets loaded on startup, but no raid scsi device
> is available. 
> Trying to access the controller stats or rebooting the system result in a
> system crash. 
> 
> ----------------------------
> # cat /proc/scsi/gdth/0
> Segmentation fault
> #
> (crash)
> ----------------------------
> 

This regression was filed under drivers_other so I guess linux-scsi didn't
get a copy.

I'll recategorise it.

Boaz, if you're actually gdth maintainer then you might care to raise a
patch against ./MAINTAINERS.

You don't appear to have a bugzilla account.
