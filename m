From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb-starge not working in the latest kernel 2.4
Date: Fri, 29 Aug 2003 11:12:24 -0400 (EDT)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.44L0.0308291110160.975-100000@ida.rowland.org>
References: <3F4F682F.3010707@pacbell.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <3F4F682F.3010707@pacbell.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: David Brownell <david-b@pacbell.net>
Cc: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>
List-Id: linux-scsi@vger.kernel.org

On Fri, 29 Aug 2003, David Brownell wrote:

> Alan Stern wrote:
> > It stopped working here.  The driver tried to send the next command but 
> > the drive never acknowledged receiving it.
> 
> It might also be useful to find just how many of those 126 KBytes
> were successfully transferred before the abort.

I think none of them were.  Or at least, no more than the first
scatter-gather block.  Under 2.4, usb-storage sends the s-g blocks one at
a time, by hand, and reports the completion of each one.  But the log 
didn't contain any such reports.

Alan Stern



-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
