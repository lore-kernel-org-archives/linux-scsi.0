From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Date: Tue, 23 Nov 2010 01:25:23 -0800 (PST)
Message-ID: <589506.10541.qm@web31809.mail.mud.yahoo.com>
References: <20101123050048.GL20296@one-eyed-alien.net>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101123050048.GL20296@one-eyed-alien.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org

--- On Mon, 11/22/10, Matthew Dharm <mdharm-kernel@one-eyed-alien.net> wrote:

> As long as you are not changing the command stream that the
> devices see, I
> think this is a reasonable risk to take.

No, not at all.

> What are the consequences if the device returns what appear
> to be a Caching
> Mode Page, but it is actually filled with garbage or
> otherwise inaccurate
> data?

Data corruption would be no different than when determining whether the media is write protected or determining other parameters. A similar question would be "What would the consequences be if the device misreported the media write-protect bit?" I suppose such a device would be quite broken and inoperative.

   Luben
