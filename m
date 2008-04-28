From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 10567] New: tape/by-id/ nodes not creating due
 to scsi_id not returning serial number, st nst
Date: Sun, 27 Apr 2008 18:44:04 -0700
Message-ID: <20080427184404.f0656d2c.akpm@linux-foundation.org>
References: <bug-10567-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752038AbYD1Bo0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2008 21:44:26 -0400
In-Reply-To: <bug-10567-10286@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bugme-daemon@bugzilla.kernel.org, john@mib-infotech.co.nz, Patrick Mansfield <patmans@us.ibm.com>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Sun, 27 Apr 2008 15:13:41 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=10567
> 
>            Summary: tape/by-id/ nodes not creating due to scsi_id not
>                     returning serial number, st nst
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.25 and earlier, vanilla and gentoo alike, X64
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: HotPlug
>         AssignedTo: greg@kroah.com
>         ReportedBy: john@mib-infotech.co.nz
> 
> 
> Latest working kernel version: unkn
> Earliest failing kernel version:  unkn , but atleast 2.6.22
> Distribution:  gentoo X64
> Hardware Environment: HP ML150, sym53c8xx card, LTO-2 external tape
> Software Environment: Gentoo, udev-120
> Problem Description:
> udev creates the tape/by-id/ nodes for st* device but fails with nst devices,
> (or vs versa)
> 
> (I WILL PUT THIS AS AN ATTACHMENT ALSO)
> 
> The scsi_id program is returning no serial numbers in some cases.

This appears to be a bug report against the userspace scsi_id command.

According to the manpage, Patrick is the lucky duck ;)
