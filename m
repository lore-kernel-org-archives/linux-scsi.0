From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 19:46:05 +0100
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <1064256363.8895.11.camel@dhcp23.swansea.linux.org.uk>
References: <Pine.LNX.4.44.0309220900440.1753-100000@home.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44.0309220900440.1753-100000@home.osdl.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, Andries.Brouwer@cwi.nl
List-Id: linux-scsi@vger.kernel.org

On Llu, 2003-09-22 at 17:09, Linus Torvalds wrote:
>  - page len=1538 (pretty obviously crap)
>  - header len=8 (correct)
>  - block descriptor len=0 (correct)

1538 smells like they forgot to clear the top byte



-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
