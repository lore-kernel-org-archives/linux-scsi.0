From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: Numerous problems, partial success getting
 FujiFilm Finepix 3800 to work under 2.6.
Date: Tue, 20 Apr 2004 13:11:25 -0700
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20040420131125.785de204.zaitcev@redhat.com>
References: <40856AFF.7070002@nogin.org>
	<Pine.LNX.4.44L0.0404201527310.1247-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0404201527310.1247-100000@ida.rowland.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: aleksey@nogin.org, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 20 Apr 2004 15:41:07 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 20 Apr 2004, Aleksey Nogin wrote:

> > After a lot of messing up and some blind experimentations with 
> > unusual_devs.h I have been successful in making camera work, but _only_ 
> > when it is connected directly to the computer, not via a hub with other 
> > devices attached.
> 
> That doesn't make much sense.  Your original setup, with no unusual_devs.h 
> entry, should have worked the same regardless of whether there was an 
> external hub.

Actually it might make some sense. In 2.4 we had a problem recently
where the interrupt pipe running to the external hub was not
activated. Without it, hub's brain melts down.

This case is likely to be a different story, because the camera reported
the unit attention and it would not be able to do it if the hub went down,
but the point is it's nothing out of ordinary for devices to fail when
hooked to a hub.

-- Pete


-------------------------------------------------------
This SF.Net email is sponsored by: IBM Linux Tutorials
Free Linux tutorial presented by Daniel Robbins, President and CEO of
GenToo technologies. Learn everything from fundamentals to system
administration.http://ads.osdn.com/?ad_id=1470&alloc_id=3638&op=click
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
