From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 8728] New: SCSI CDROM support cause hardlock
 on bootup
Date: Mon, 9 Jul 2007 09:53:23 -0700
Message-ID: <20070709095323.5f3d7b43.akpm@linux-foundation.org>
References: <bug-8728-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56257 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754160AbXGIQx7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2007 12:53:59 -0400
In-Reply-To: <bug-8728-10286@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: k-r.ernst@my-mail.ch, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@kernel-bugs.osdl.org>

On Mon,  9 Jul 2007 09:30:57 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8728
> 
>            Summary: SCSI CDROM support cause hardlock on bootup
>            Product: SCSI Drivers
>            Version: 2.5
>      KernelVersion: 2.6.22
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
>         ReportedBy: k-r.ernst@my-mail.ch
> 
> 
> Most recent kernel where this bug did not occur: don't know, but it occured in
> 2.6.21 too
> Distribution: Gentoo
> Hardware Environment:
> TSSTcorp DVD-ROM SH-D162C
> connected to: Integrated Technology Express, Inc. ITE 8211F Single Channel UDMA
> 133 (rev 11)
> Problem Description:
> scsi cdrom support deactivated:
> normal booting, dvd-drive doesn't work
> scsi cdrom support enabled:
> (lots of output)
> (lots of output)
> scsi 5:0:0:0: CD-ROM            TSSTcorp DVD-ROM SH-D162C TS02 PQ: 0 ANSI: 5
> ... (hardlock)
> (see dmesg)
> 
