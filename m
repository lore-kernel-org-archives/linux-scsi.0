From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Problem with an USB Stick and kernel 2.6.1
Date: Sun, 29 Feb 2004 22:25:52 -0500 (EST)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.44L0.0402292224250.21577-100000@netrider.rowland.org>
References: <20040229164048.GA1084@paradigm.rfc822.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20040229164048.GA1084@paradigm.rfc822.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Florian Lohoff <flo@rfc822.org>
Cc: Alexander Motzkau <a.motzkau@web.de>, Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Sun, 29 Feb 2004, Florian Lohoff wrote:

> 
> Hi,
> better late than never - Yes - this fixes the no sense problem for
> me. Patch still applied to 2.6.3 without offset and fixes the problem. 
> 
> Mainline please !

A change for this has been submitted, but it's different from the one 
you're talking about.  It should appear in 2.6.4.

Alan Stern



-------------------------------------------------------
SF.Net is sponsored by: Speed Start Your Linux Apps Now.
Build and deploy apps & Web services for Linux with
a free DVD software kit from IBM. Click Now!
http://ads.osdn.com/?ad_id=1356&alloc_id=3438&op=click
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
