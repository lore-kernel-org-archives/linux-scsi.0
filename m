From: Willem Riede <wrlk@riede.org>
Subject: Re: Fw: [Bugme-new] [Bug 2147] New: my scsi emulated cdrom is locked
Date: Thu, 19 Feb 2004 19:52:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040220005223.GW4957@serve.riede.org>
References: <20040219122414.73fd7c6c.akpm@osdl.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc13.comcast.net ([204.127.202.64]:36601 "EHLO
	sccrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S267615AbUBTAwY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2004 19:52:24 -0500
Content-Disposition: inline
In-Reply-To: <20040219122414.73fd7c6c.akpm@osdl.org> (from akpm@osdl.org on Thu, Feb 19, 2004 at 15:24:14 -0500)
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>

On 2004.02.19 15:24, Andrew Morton wrote:
> 
> Did ide-scsi break again?
> 
> Begin forwarded message:
> 
> Date: Thu, 19 Feb 2004 07:49:51 -0800
> From: bugme-daemon@osdl.org
> To: bugme-new@lists.osdl.org
> Subject: [Bugme-new] [Bug 2147] New: my scsi emulated cdrom is locked
> 
> 
> http://bugme.osdl.org/show_bug.cgi?id=2147
> 
>            Summary: my scsi emulated cdrom is locked
>     Kernel Version: 2.6.3 (final)
>             Status: NEW
>           Severity: high
>              Owner: io_other@kernel-bugs.osdl.org
>          Submitter: cerebro84@vodafone.it
> 
> Distribution: Mandrake 9.2 
> Hardware Environment: HL-DT-STDVD-ROM GDR8160B 
> Software Environment: KDE 3.2, K3B 
> Problem Description: I changed from kernel 2.6.2rc3 to 2.6.3final and I had 
> this problem: my cdrom reader stopped to work. Everytime I try to access it my 
> system freezes; I had to disable scsi emulation in order to let it work. 

Well, since ide-scsi.c didn't change between 2.6.2rc3 and 2.6.3 it cannot by
itself be the cause of this bug.

On the other hand, I wish it had changed; I have had a proposed update to 
ide-scsi's error handling out for review for some time, see
http://marc.theaimsgroup.com/?l=linux-kernel&m=107246268217888&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=107443923827330&w=2
http://marc.theaimsgroup.com/?l=linux-kernel&m=107558923328533&w=2

If there are no comments on it, perhaps it can be given some exposure (e.g. in
-mm patches) to get user feedback?

For the record, even with those changes, it is _not_ recommended to use scsi
emulation for cd type drives. They are supported directly by the ide subsystem.

Regards, Willem Riede.
