From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 08:58:03 -0700
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20030922085803.A722@beaverton.ibm.com>
References: <20030922161104.A24155@infradead.org> <Pine.LNX.4.44L0.0309221147340.636-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0309221147340.636-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Mon, Sep 22, 2003 at 11:50:47AM -0400
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Linus Torvalds <torvalds@osdl.org>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 22, 2003 at 11:50:47AM -0400, Alan Stern wrote:

> Interestingly, my original patch was a lot like you describe.  It can be 
> found in
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=106340167723122&w=2
> 
> Patrick Mansfield later beefed it up to the version you were looking at.
> 
> I don't care which version of the patch gets accepted, so long as
> _something_ is done.  Patrick, what do you think?

I would rather we can modify the flags for any broken device and override
a host's setting for known functioning devices. But let's get some patch
applied.

If there is a problem (per Linus' post) in the USB transport this isn't a
real fix.

-- Patrick Mansfield


-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
