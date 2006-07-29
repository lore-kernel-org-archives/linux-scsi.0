From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: cd burning with plextor drives.
Date: Sat, 29 Jul 2006 08:40:19 -0500
Message-ID: <1154180419.9447.61.camel@mulgrave.il.steeleye.com>
References: <20060729045249.GA23398@redhat.com>
	 <20060729111240.GG13095@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:20640 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932138AbWG2Nkf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jul 2006 09:40:35 -0400
In-Reply-To: <20060729111240.GG13095@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org, torvalds@osdl.org

On Sat, 2006-07-29 at 13:12 +0200, Jens Axboe wrote:
> > I'm not that familiar with this code, but would adding exceptions
> > on a per-vendor basis in sg_allow_access() be the way forward here?
> > 
> > If not, what is the right answer ?
> 
> I'd greatly prefer just ripping the entire command access table out, it
> was a mistake to begin with and still just a horrible solution.
> 
> In fact, I think we should decide soon what to do about it. At the
> storage summit, there was general consensus on just killing it as well.

I concur.  If we're going to allow users access to burn CDs, it's
impossible to police them with certainty as this case indicates.  If we
allow vendor specific commands down, there are bound to be some that
format the drive or destroy the firmware ...

So I think ripping the table out and acknowledging we have no security
is better than giving the illusion of having it.

James


