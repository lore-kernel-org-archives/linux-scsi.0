From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_scan.c EVPD code
Date: Mon, 5 May 2003 09:26:14 -0700
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20030505092614.A7831@beaverton.ibm.com>
References: <UTC200304250047.h3P0lhl03517.aeb@smtp.cwi.nl> <3EB619A4.5090407@torque.net> <1052144231.1888.10.camel@mulgrave> <20030505155210.GB1567@beaverton.ibm.com> <1052151252.1888.15.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <1052151252.1888.15.camel@mulgrave>; from James.Bottomley@steeleye.com on Mon, May 05, 2003 at 11:14:10AM -0500
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, dougg@torque.net, Andries.Brouwer@cwi.nl, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

On Mon, May 05, 2003 at 11:14:10AM -0500, James Bottomley wrote:
> 
> I think the sysfs write API is sufficient, so it has to be a rw-r-r file
> to allow root to write it on hotplug.
> 

If it is only ever read and written from user space, why should it be
stored in the kernel? We can just put it in a flat file or other such
database, or run the program used to get the id in the first place.

-- Patrick Mansfield


-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
