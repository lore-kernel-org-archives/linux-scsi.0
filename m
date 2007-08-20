From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 8908] New: 3ware 9650SE -8LPML not recognized
 by 3w-9xxx driver
Date: Sun, 19 Aug 2007 23:10:00 -0700
Message-ID: <20070819231000.cc5eff11.akpm@linux-foundation.org>
References: <bug-8908-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52137 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751108AbXHTGK0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Aug 2007 02:10:26 -0400
In-Reply-To: <bug-8908-10286@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bugme-daemon@bugzilla.kernel.org, Adam Radford <linuxraid@amcc.com>, svedox@t-online.de

On Sun, 19 Aug 2007 11:51:38 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8908
> 
>            Summary: 3ware 9650SE -8LPML not recognized by 3w-9xxx driver
>            Product: IO/Storage
>            Version: 2.5
>      KernelVersion: 2.6.20.1
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: Serial ATA
>         AssignedTo: jgarzik@pobox.com
>         ReportedBy: svedox@t-online.de
> 
> 
> Most recent kernel where this bug did not occur:
> Distribution: Debian Lenny/Sid
> Hardware Environment: Intel Pentium D 820, Intel Mainboard with 955X Controller
> on board
> Software Environment: Linux/Debian
> Problem Description: The 3w-9xxx kernel driver for 3ware 9xxx SATA RAID
> Controller series did not recognize the 3ware 9650SE-8LPML SATA RAID
> Controller. I tryed also with original driver from 3ware itself, but this also
> didn't work, because of changes in module interface. If you need tester for
> this controller, i can do it for you.
> 
> Steps to reproduce: Get the mentioned card, install it in your compouter, and
> attach some sata hd's to it. Compile kernel with 3w-9xxx SATA RAID driver(SCSI
> section) and install it. Include HD's into your fstab.conf. Reboot and watch
> boot messages. You will see, that HD's, that are attached to the 3ware
> Controller are not found. After boot, put lspci into your linux console. lspci
> shows, here is an unrecognized 3ware Controller card.
> 
