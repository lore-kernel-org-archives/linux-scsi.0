From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH] [2.6.23.13] udev hangs
	USB-storage	(HP r707 camera)
Date: Tue, 22 Jan 2008 23:55:56 -0700
Message-ID: <20080123065556.GB20348@colo.lackof.org>
References: <20080119174556.GE11553@colo.lackof.org>
	<47929B9F.8080607@s5r6.in-berlin.de>
	<20080120022829.GG11553@colo.lackof.org>
	<1200797791.11214.3.camel@localhost.localdomain>
	<20080120031008.GI11553@colo.lackof.org>
	<1200802265.11214.8.camel@localhost.localdomain>
	<20080120052553.GA5452@colo.lackof.org> <4796D02D.8000108@ipom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <4796D02D.8000108@ipom.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Phil Dibowitz <phil@ipom.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 22, 2008 at 09:27:09PM -0800, Phil Dibowitz wrote:
...
> Patch looks fine to me. Let me get my tree in order (sorry, been really
> swamped lately so I haven't updated in a while), make sure this diff's
> nicely against the latest rc's,

It's not. It's against 2.6.23. But I expect it to apply with fuzz
at the worst case.

>  and I'll pass it on up. .24 is already
> (essentially) done, so I'll get it to Greg in the next day or so and it
> should make it into .25.

thanks!

> 
> Sorry for the delay, and thanks Alan for pinging me on this.
> 
> As for Grant - more information on "Protocol" vs "Subclass" can be found on
> my unusual_devs page here:
> 
>   http://www.phildev.net/linux/usb-unusualdevs-notes.html

In general, a very helpful document! Thanks!

"useProtocol - These are listed in protocols.h with explinations. One example:

    * US_SC_DEVICE - use whatever the device claims
    * see drivers/usb/storage/protocol.h for a full list and comments "

Some issues/comments:
o I don't see any sort of list in protocol.h. And the comments in
  protocol.h don't discuss useProtocol or which protocols.
  Maybe "the list" moved to include/linux/usb_usual.h?

o US_SC_* and US_PR_* constants both seem like good candidates for enum
 (to make sure the right "type" get used with the right field.)

cheers,
grant

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
