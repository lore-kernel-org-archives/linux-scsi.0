From: Andries.Brouwer@cwi.nl
Subject: IDs
Date: Tue, 7 Jan 2003 01:00:47 +0100 (MET)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <UTC200301070000.h0700lx20735.aeb@smtp.cwi.nl>
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

> Instead of truncating the id, we need a new scsi_uid field allocated
> to whatever size required.

> And, a descriptive string put in the name, rather than the id, such as:
> scsi disk

[I changed the Subject line "Re: inquiry in scsi_scan.c" since people
are still discussing devices with a buggy INQUIRY response;
maybe unnecessarily - all details are well understood, and
patches fixing all problems have been posted, but in any case
it is best to separate both threads.]

Maybe I should ask you to explain more in detail what purpose
you have in mind. If I read your code and hear you talking
it sounds like you would like to have a string identifying
the device. But in many cases no such string exists.

Moreover, what precisely is "the device"?
If I have a Compact Flash card reader and read CF cards,
is the device the reader? Or the card? Or the combination?
If I have an Imation FlashGo! reader, and insert a SmartMedia
adapter, and read a SmartMedia card, is the device the reader,
the reader plus adapter, the card?

If the device is the reader, then it will have a different size,
partitioning and contents each time we see it.
If the device is the card, then we need a different driver
each time we see it.

What do you want to recognize with this ID, and why?


Andries


-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
