From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] SCSI midlayer power management
Date: Thu, 12 Aug 2004 09:45:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040812164557.GA16852@beaverton.ibm.com>
References: <4119611D.60401@optonline.net> <20040811080935.GA26098@elf.ucw.cz> <411A1B72.1010302@optonline.net> <1092231462.2087.3.camel@mulgrave> <1092267400.2136.24.camel@gaston> <1092314892.1755.5.camel@mulgrave> <411B736C.7030103@optonline.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:33701 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S268609AbUHLQqV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2004 12:46:21 -0400
Content-Disposition: inline
In-Reply-To: <411B736C.7030103@optonline.net>
List-Id: linux-scsi@vger.kernel.org
To: Nathan Bryant <nbryant@optonline.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Pavel Machek <pavel@ucw.cz>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>

On Thu, Aug 12, 2004 at 09:41:00AM -0400, Nathan Bryant wrote:
> James Bottomley wrote:
> 
> >Why?  We don't do a bus reset on boot, why should we need to do one on
> >resume?  For FC, the equivalent, a LIP Reset can be rather nasty on a
> >SAN and should be avoided.
> > 
> >
> that can be host specific. aic7xxx does a bus reset on boot, so i 
> preserved this on resume.

It can be changed via the "no_reset" option, that should probably be
honored for resume.

> don't know why they do it, but they do.

I used to use no_reset, as well as bios no reset (or is it no spin up?) to
decrease boot time, until a crash hung the bus and the system could not
boot. I suppose letting the bios reset would have gotten around the
problem, I can't remember.

-- Patrick Mansfield
