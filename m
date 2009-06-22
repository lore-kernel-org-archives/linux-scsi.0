From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Bug 13594] SMART responses for SATA disks on SAS get
	interpreted as errors
Date: Mon, 22 Jun 2009 06:04:28 -0600
Message-ID: <20090622120428.GS19977@parisc-linux.org>
References: <bug-13594-11613@http.bugzilla.kernel.org/> <200906211907.n5LJ7D51030300@demeter.kernel.org> <4A3E9DC9.3000007@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:32880 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZFVMEZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2009 08:04:25 -0400
Content-Disposition: inline
In-Reply-To: <4A3E9DC9.3000007@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Sun, Jun 21, 2009 at 04:53:29PM -0400, Douglas Gilbert wrote:
> As for the hiccup, I have noticed that with SAS (SCSI)
> disks from Seagate there is a curious sound and a pause
> before the response to LOG SENSE SCSI command (the
> type the smartmontools uses on SCSI disks).
>
> Another annoyance is that the disk must be ready (i.e.
> spun up) before MODE SENSE and LOG SENSE work, haven't
> Seagate heard of flash :-)
> SCSI standards permit that (i.e. only
> a small number of commands have to work when the disk
> is not ready) but you would think accessing metadata
> given the disk has spun up once since power up could
> be accomplished from RAM or flash.

We've experienced similar problems at Intel with an LSI card and Intel
SSDs (SATA, not SAS).  This issue got pushed into the 'investigate later'
category, as we were able to just disable smartd.  I'll try and get some
more information on this later.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
