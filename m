From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 16:11:04 +0100
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20030922161104.A24155@infradead.org>
References: <20030922004943.E32009@one-eyed-alien.net> <Pine.LNX.4.44L0.0309221001090.1697-100000@ida.rowland.org> <20030922153123.A23388@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20030922153123.A23388@infradead.org>; from hch@infradead.org on Mon, Sep 22, 2003 at 03:31:24PM +0100
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Linus Torvalds <torvalds@osdl.org>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 22, 2003 at 03:31:24PM +0100, Christoph Hellwig wrote:
> Patch looks mostly fine to me, but please all flags should be unsigned instead
> of signed and scsi_devinfo.h needs some inclusion guards.

Actually I think it could be made much simpler by killing the per-template
bflags and just setting the scsi_device flags from slave_alloc or
slave_configure.  Could you cook up a patch like that?



-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
