From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 7900] New: Kernel OOPS when using tape drive
 (compiler bug?)
Date: Mon, 29 Jan 2007 18:05:35 -0800
Message-ID: <20070129180535.85950b67.akpm@osdl.org>
References: <200701300139.l0U1dP09019983@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38001 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbXA3CFt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jan 2007 21:05:49 -0500
In-Reply-To: <200701300139.l0U1dP09019983@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>, michal@logix.cz

On Mon, 29 Jan 2007 17:39:25 -0800
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=7900
> 
>            Summary: Kernel OOPS when using tape drive (compiler bug?)
>     Kernel Version: 2.6.20-rc5
>             Status: NEW
>           Severity: high
>              Owner: io_scsi@kernel-bugs.osdl.org
>          Submitter: michal@logix.cz
> 
> 
> Most recent kernel where this bug did *NOT* occur:
> Distribution: OpenSUSE 10.2 x86
> Hardware Environment: 
> SCSI controller "LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual
> Ultra320 SCSI (rev 07)", tape streamer Datastor LTO1 (don't know the exact model)
> 
> Software Environment: OpenSUSE 10.2 x86, mondoarchive, mondorescue
> 
> Problem Description:
> Attempt to restore data from a tape drive results in the following Oops and
> subsequent functinality loss of the strreamer. Writing to the tape, however,
> worked fine. Or at least mondoarchive haven't complained.
> 
> Following kernel Oops happens on both self-compiled vanilla 2.6.20-rc5 and
> original Suse kernel 2.6.18.2-34-default, both are compiled with GCC 4.1.2. As
> soon as I recompiled 2.6.20-rc5 with the exactly same config on an older Suse
> with GCC 3.3.3 it fixed the problem.
> 
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.
