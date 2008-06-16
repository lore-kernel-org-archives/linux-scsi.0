From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 10915] New: echo min_power >
 /sys/class/scsi_host/host0/active_mode causes problem
Date: Sun, 15 Jun 2008 18:01:46 -0700
Message-ID: <20080615180146.8abb9450.akpm@linux-foundation.org>
References: <bug-10915-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851AbYFPBCS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Jun 2008 21:02:18 -0400
In-Reply-To: <bug-10915-10286@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bugme-daemon@bugzilla.kernel.org, cijoml@volny.cz

On Sun, 15 Jun 2008 01:52:26 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=10915
> 
>            Summary: echo min_power > /sys/class/scsi_host/host0/active_mode
>                     causes problem
>            Product: File System
>            Version: 2.5
>      KernelVersion: 2.6.25.6
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SysFS
>         AssignedTo: greg@kroah.com
>         ReportedBy: cijoml@volny.cz
> 
> 
> Latest working kernel version: unknown
> Earliest failing kernel version: unknown
> Distribution: Debian testing
> Hardware Environment: HP Compaq 6910p
> Software Environment: Debian testing, sysfs
> Problem Description:
> 
> In accident I proceed
> echo min_power > /sys/class/scsi_host/host0/active_mode
> 
> which causes HIGH cpu load, echo wasn't killable so reboot was only solution :(
> 
> Steps to reproduce:
> proceed command

For reasons which escape me, there is no description text in bugzilla
for this report, yet the reporter entered some.

Anyway.  Could someone please refile this under scsi?  Or fix the bug ;)


