From: Andrew Schulman <andrex@alumni.utexas.net>
Subject: Re: dc395x: can't write to tape
Date: Wed, 12 Jan 2005 03:58:20 -0500
Message-ID: <200501120358.20963.andrex@alumni.utexas.net>
References: <200501060518.25782.andrex@alumni.utexas.net> <200501111019.06281.andrex@alumni.utexas.net> <Pine.LNX.4.60.0501112252560.11812@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:25237 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S261302AbVALI6X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2005 03:58:23 -0500
In-Reply-To: <Pine.LNX.4.60.0501112252560.11812@poirot.grange>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org, Jamie Lenehan <lenehan@twibble.org>

> > Okay, I finally got to this.  Rebooted with mem=900M.  Unfortunately tar
> > fails as before:
> >
> > tar: /dev/st0: Wrote only 0 of 10240 bytes
> > tar: Error is not recoverable: exiting now
>
> I didn't expect disabling highmem to fix _this_ error. But do you still
> see the "dc395x: sg_update_list: sg_to_virt failed" message with 900M?
> Perhaps, the most interesting test would be with my patch...

OK.  Yes, with mem=900M, the 'sg_to_virt failed' messages all went away.  Will 
test the patch when I can.

> ...well, could you just keep the log for now, maybe we'll have a look at
> it later, I'd just first try to fix the highmem problem, before trying to
> figure out what's going on with your tape drive. BTW, when it worked, you
> already had 1G RAM in the PC, right?

Right.
