From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 10:23:15 -0700
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20030922102315.A1632@beaverton.ibm.com>
References: <20030922084930.A679@beaverton.ibm.com> <Pine.LNX.4.44.0309220900440.1753-100000@home.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0309220900440.1753-100000@home.osdl.org>; from torvalds@osdl.org on Mon, Sep 22, 2003 at 09:09:47AM -0700
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, Andries.Brouwer@cwi.nl
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 22, 2003 at 09:09:47AM -0700, Linus Torvalds wrote:

> 
> (Btw, where are the different mode sense pages documented?)
> 

The latest SCSI 3 draft standards are online as follows, the SCSI 2 specs
are also online at www.t10.org (.ORG!).

For block (applies to some USB mass storage) specific pages:

http://www.t10.org/ftp/t10/drafts/sbc/sbc-r08c.pdf

See page 105 section 7.1.3 of the above (table 73 the "Mode page codes").

General MODE SENSE stuff is in:

http://www.t10.org/ftp/t10/drafts/spc3/spc3r15.pdf

See page 151 section 6.9.1 for MODE SENSE, page 261 section 7.4.5 or so
for page codes applying to all devices.

-- Patrick Mansfield


-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
