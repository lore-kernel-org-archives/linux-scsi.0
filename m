From: Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Tue, 29 Jan 2008 21:13:29 +0100
Message-ID: <20080129201328.GZ15220@kernel.dk>
References: <20080129141108.GV15220@kernel.dk> <200801291531.39825.oliver@neukum.org> <20080129143109.GW15220@kernel.dk> <20080129183910.GI15220@kernel.dk> <20080129191024.GO14375@one-eyed-alien.net> <1201635195.3069.36.camel@localhost.localdomain> <20080129193520.GQ15220@kernel.dk> <20080129194543.GR15220@kernel.dk> <479F856C.4090900@panasas.com> <479F880F.20709@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <479F880F.20709-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Matthew Dharm <mdharm-kernel-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Oliver Neukum <oliver-GvhC2dPhHPQdnm+yROfE0A@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 29 2008, Boaz Harrosh wrote:
> >>
> > Ok this is not in Linus tree is it? Hence I did not have that failure.
> > 
> > Boaz
> > 
> > 
> 
> actually James bidi tree has a fix for this in the scsi_data_buffer patch.
> 
> what you sent is not enough there are other places. look at this patch I
> sent to the list.
> 
> http://www.spinics.net/lists/linux-scsi/msg21938.html

Hard to compare, since its on different bases.

> Could we take the 2 SG patches and submit them through the scsi
> bidi tree? It is much more natural to have them in one tree as one
> patchset then try coordinate with git-merge. Actually if you look at it,
> the biggest change is to SCSI. So I think it is more natural this way

What 2 sg patches do you mean?

-- 
Jens Axboe
