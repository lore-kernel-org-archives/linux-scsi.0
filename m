From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Add suspend/resume support for aic7xxx/aic79xx
Date: Wed, 17 Oct 2007 16:46:29 +0200
Message-ID: <20071017144629.GA6201@kernel.dk>
References: <47161877.1090000@suse.de> <20071017143721.GS5043@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:14568 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754252AbXJQOq7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 10:46:59 -0400
Content-Disposition: inline
In-Reply-To: <20071017143721.GS5043@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Oct 17 2007, Jens Axboe wrote:
> On Wed, Oct 17 2007, Hannes Reinecke wrote:
> > Hi James,
> > 
> > due to popular demand I've clobbered together a patch for
> > suspend/resume support in aic79xx/aic7xxx.
> > 
> > Looks reasonable enough, boots, but now I'd need someone
> > to actually test it :-)
> > 
> > As usual, comments, results, fixes, etc. welcome.
> 
> As it so happens, I run aic7xxx on my desktop. I'll give it a spin.

I just successfully suspended to disk (easy) AND suspended to ram on my
quad core workstation! To be honest, I don't know if this worked before
as I have never tried. But the disk is alive and doing well, so the
patch can get my:

Tested-by: Jens Axboe <jens.axboe@oracle.com>

Unfortunately my video is crap after suspend to ram, so I'm typing this
ssh'ing into the machine. Perhaps some of the video options for s2ram
can help me out.

-- 
Jens Axboe

