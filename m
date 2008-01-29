From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Tue, 29 Jan 2008 15:24:17 -0500
Message-ID: <1201638257.3069.42.camel@localhost.localdomain>
References: <200801291531.39825.oliver@neukum.org>
	 <20080129143109.GW15220@kernel.dk> <20080129183910.GI15220@kernel.dk>
	 <20080129191024.GO14375@one-eyed-alien.net>
	 <1201635195.3069.36.camel@localhost.localdomain>
	 <20080129193520.GQ15220@kernel.dk> <20080129194543.GR15220@kernel.dk>
	 <479F856C.4090900@panasas.com> <20080129200311.GV15220@kernel.dk>
	 <1201637090.3069.38.camel@localhost.localdomain>
	 <20080129200651.GW15220@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080129200651.GW15220-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Matthew Dharm <mdharm-kernel-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Oliver Neukum <oliver-GvhC2dPhHPQdnm+yROfE0A@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2008-01-29 at 21:06 +0100, Jens Axboe wrote:
> > I will ... but it will cause an explosion in the bidirectional tree
> > again.  I think the bidi updates also fix this.  However, give me time
> > to rebase and verify.
> 
> OK thanks, just wanted to make sure that we didn't both expect each
> other to handle it :-)

Yes, confirm that; I think this is already fixed in scsi-misc-2.6.
Could you pull from

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

and verify with your device?

Thanks,

James
