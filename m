From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: Feiya 5-in-1 Card Reader
Date: Thu, 5 Sep 2002 01:46:53 +0200
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20020904234653.GB10227@win.tue.nl>
References: <UTC200209042256.g84Mu0w15389.aeb@smtp.cwi.nl> <20020904161042.O13478@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20020904161042.O13478@one-eyed-alien.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://www.geocrawler.com/redir-sf.php3?list=linux-usb-devel>
To: Andries.Brouwer@cwi.nl, greg@kroah.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 04, 2002 at 04:10:42PM -0700, Matthew Dharm wrote:

> I'm trying to find out why Windows doesn't choke on the strange
> READ_CAPACITY value.

That is an easy one.
It belongs to the recent partitioning discussion on l-k.

Windows knows the type of partition table, so reads the
partition table and the boot sector and the FAT and is happy.

Linux tries various things, depending on how you compiled your kernel,
and among other things also needs to examine the last sector.
So, only Linux will do bad things in case the capacity is off by one,
and only when your config includes partitioning types that use this
last sector.


Andries



-------------------------------------------------------
This sf.net email is sponsored by: OSDN - Tired of that same old
cell phone?  Get a new here for FREE!
https://www.inphonic.com/r.asp?r=sourceforge1&refcode1=vs3390
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
