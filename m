From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.11-rc3-bk5, oops in scsi_try_bus_reset
Date: Thu, 17 Feb 2005 14:55:42 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0502171453170.1383-100000@ida.rowland.org>
References: <20050217183927.GA8073@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <20050217183927.GA8073@suse.de>
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Olaf Hering <olh@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Thu, 17 Feb 2005, Olaf Hering wrote:

>  On Mon, Feb 14, Alan Stern wrote:
> 
> > https://lists.one-eyed-alien.net/pipermail/usb-storage/2004-November/001201.html
> 
> Alan,
> 
> this patch seems to fix the crashes. Is it ready for production use, or
> should I wait for a differnt patch?

It hasn't been tested very much.  (Would you like to be a beta tester? :-)  
Right now I'm in the middle of cleaning it up and submitting it to Matt
Dharm for official inclusion.

Alan Stern



-------------------------------------------------------
SF email is sponsored by - The IT Product Guide
Read honest & candid reviews on hundreds of IT Products from real users.
Discover which products truly live up to the hype. Start reading now.
http://ads.osdn.com/?ad_id=6595&alloc_id=14396&op=click
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
