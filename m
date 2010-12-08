From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Date: Wed, 8 Dec 2010 10:16:46 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1012081010470.1885-100000@iolanthe.rowland.org>
References: <1291784742.24312.40.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1291784742.24312.40.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Greg KH <greg@kroah.com>, Luben Tuikov <ltuikov@yahoo.com>, Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 7 Dec 2010, James Bottomley wrote:

> Well, not other than I've already said:  I think it looks OK, so I
> marked it for my merge window queue.  I'd still rather like USB people
> to confirm that the original reason why this was done (to prevent device
> crashes on the mode sense) is no longer an issue

The original reason for adding the skip_ms_page_8 flag still applies.  
To assume it is no longer an issue would not be safe -- there's no 
reason to believe that the buggy devices it was meant for have all been 
retired.

>  ... but it's only USB
> stuff, so suppose I'm OK with finding out in the field.

With USB there's often no other choice.

Alan Stern
