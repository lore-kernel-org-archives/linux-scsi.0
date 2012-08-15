From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: PROBLEM: lpfc module kernel panics when SCSI devices disconnect
  (resend with no HTML)
Date: Wed, 15 Aug 2012 08:55:34 +0100
Message-ID: <1345017334.2976.7.camel@dabdike.int.hansenpartnership.com>
References: <dd3b439a5e780d407bef5c500f5ff665@www.nowhere.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39474 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479Ab2HOHzh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2012 03:55:37 -0400
In-Reply-To: <dd3b439a5e780d407bef5c500f5ff665@www.nowhere.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Keith Lawson <keith@nowhere.ca>
Cc: linux-scsi@vger.kernel.org, james.smart@emulex.com

On Tue, 2012-08-14 at 14:19 -0400, Keith Lawson wrote:
> I believe we're encountering a bug in the lpfc module with our SLES
> 11 
> SP1 systems running on HP blades in a C7000 enclosure connected to a
> SAN 
> and virtual tape library. Please find my bug report below. We've had
> HP 
> engaged for this issue for approximately 7 weeks now and aren't any 
> closer to solving the problem so I'm hoping you can help.
> 
> [1.] One line summary of the problem:
> lpfc module kernel panics when SCSI devices disconnect from host.
> 
> [2.] Full description of the problem/report:
> We have several BL460c blades in a C7000 enclosure connected to an HP 
> EVA 8400 and an HP VLS 6840 tape library over fiber channel. Due to
> an 
> know issue on the VLS our backup administrator has to reset the tape 
> library weekly which causes the virtual tape devices on the servers
> to 
> be removed and this is causing a kernel panic almost every time that 
> happens. Kdumps indicated that the panic is happening inside the lpfc 
> kernel module. The module also seems to be sensitive to I/O timeouts
> on 
> the EVA but we can't reliably reproduce panics due to disk related 
> problems.
> 
> [3.] Keywords (i.e., modules, networking, kernel):
> lpfc module, SCSI,HP EVA 8400,HP VLS6840, HP C7000 enclosure, HP 
> ProLiant BL460c blade
> 
> [4.] Kernel information
> SLES11 SP1 2.6.32.59-0.3-default
> 
> [4.1.] Kernel version (from /proc/version):
> Linux version 2.6.32.59-0.3-default (geeko@buildhost) (gcc version 
> 4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux) ) #1 SMP
> 2012-04-27 
> 11:14:44 +0200
> 
We can't really help you with a distro kernel. This list deals with the
current Linux kernel, which is about three years ahead of the one you
have. SUSE should be the first line of support.  However, you'll have to
be very lucky to get anyone to diagnose this if you don't actually
attach the kernel log of the panic.  I'd open a bug with SUSE and attach
the panic log.

James


