From: Andries.Brouwer@cwi.nl
Subject: Re: IDs
Date: Tue, 7 Jan 2003 19:54:11 +0100 (MET)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <UTC200301071854.h07IsBH22403.aeb@smtp.cwi.nl>
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Andries.Brouwer@cwi.nl, patmans@us.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-kernel@one-eyed-alien.net, zwane@holomorphy.com
List-Id: linux-scsi@vger.kernel.org

>> The id is not suitable as a user space name. Moreover,
>> it is a heuristic only, and user space needs unambiguous names.

> If we had a complete white/black list of devices with/without a unique id,
> there would be no ambiguity.

You mean for the devices on the white list.
But most devices will not be on the white list.

Our perceptions differ, I think. My impression is that chaos
is the norm, and well-behaved devices are the exception.
I find very good behaviour in fixed hard disks.
Stuff by Maxtor, Seagate, IBM, etc - a very small collection
of very experienced manufacturers with high quality products.
SCSI CDROM drives or tape drives or scanners are messier.
USB storage devices are much messier - very basic parts of the
protocol are regularly broken.
So to me the approach of an id together with a blacklist
seems unworkable.

As you say - we can make a best effort and get a string that
with some luck identifies the device uniquely. But no guarantees
given.

Maybe that again means that the S/Z distinction can be dropped.

Andries


-------------------------------------------------------
This SF.NET email is sponsored by:
SourceForge Enterprise Edition + IBM + LinuxWorld = Something 2 See!
http://www.vasoftware.com
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
