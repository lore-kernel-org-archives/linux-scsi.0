From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: 06 Apr 2003 10:39:02 -0500
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <1049643543.10758.4.camel@mulgrave>
References: <20030322233136.D17056@one-eyed-alien.net>
	<1048467235.1634.22.camel@mulgrave>
	<20030323173733.B24668@one-eyed-alien.net>
	<1048469946.1643.2.camel@mulgrave>
	<20030323230438.E24668@one-eyed-alien.net>
	<1048519237.1982.16.camel@mulgrave>
	<20030324093028.A1066@one-eyed-alien.net>
	<1049556643.1762.16.camel@mulgrave>
	<20030405112759.B4320@one-eyed-alien.net>
	<1049571946.2538.94.camel@mulgrave>
	<20030405162234.E4320@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20030405162234.E4320@one-eyed-alien.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2003-04-05 at 18:22, Matthew Dharm wrote:
> Out of curiosity, at what point is SCp->device->type a valid reference?  I
> would hope that none of those pointers would be NULL during a probe at init
> time.  I also hope that the type field contains the right data as soon as
> the INQUIRY data comes back... but does anyone actually know for certain?

sdev->device is never NULL for an executing command.  Type is filled in
after the first 36 byte inquiry goes to the device.

James




-------------------------------------------------------
This SF.net email is sponsored by: ValueWeb: 
Dedicated Hosting for just $79/mo with 500 GB of bandwidth! 
No other company gives more support or power for your dedicated server
http://click.atdmt.com/AFF/go/sdnxxaff00300020aff/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
