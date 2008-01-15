From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 9752] New: getting "FAULT code" message at
 startup in mpt fusion scsi driver
Date: Tue, 15 Jan 2008 12:37:15 -0800
Message-ID: <20080115123715.d7d8de7e.akpm@linux-foundation.org>
References: <bug-9752-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44314 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752190AbYAOUhd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jan 2008 15:37:33 -0500
In-Reply-To: <bug-9752-10286@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bugme-daemon@bugzilla.kernel.org, "Moore, Eric Dean" <Eric.Moore@lsil.com>, cfriesen@nortel.com

On Tue, 15 Jan 2008 06:30:11 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=9752
> 
>            Summary: getting "FAULT code" message at startup in mpt fusion
>                     scsi driver
>            Product: SCSI Drivers
>            Version: 2.5
>      KernelVersion: 2.6.14
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
>         ReportedBy: cfriesen@nortel.com
> 
> 
> Hardware Environment: 32-bit x86, dual Xeon
> Software Environment: nothing special
> Problem Description:
> 
> On blade startup we're seeing the following message:
> 
> Fusion MPT base driver 3.02.55
> Copyright (c) 1999-2005 LSI Logic Corporation
> Fusion MPT SAS Host driver 3.02.55
> mptbase: Initiating ioc0 bringup
> mptbase: ioc0: WARNING - IOC is in FAULT state!!!
>             FAULT code = 1804h
> mptbase: ioc0: ERROR - Failed to come READY after reset! IocState=0
> mptbase: ioc0 NOT READY WARNING!
> mptbase: WARNING - ioc0 did not initialize properly! (-1)
> mptsas: probe of 0000:05:01.0 failed with error -1
> 
> 
> I'm not very knowledgable with SCSI, so can someone tell me whether this is a
> disk fault or a host fault?  Even better, does anyone know what the specific
> fault code means or where I could look it up?
> 
> 
> -- 
> Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.
