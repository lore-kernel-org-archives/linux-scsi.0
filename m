From: Andries.Brouwer@cwi.nl
Subject: Re: Re: inquiry in scsi_scan.c
Date: Mon, 6 Jan 2003 20:18:45 +0100 (MET)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <UTC200301061918.h06JIjB21034.aeb@smtp.cwi.nl>
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: luben@splentec.com, stern@rowland.harvard.edu
Cc: Andries.Brouwer@cwi.nl, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-kernel@one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

> In the case reported, the problem was

Ha, Alan - it is possible that the two of you are referring
to different things.

I mentioned two devices, both return 36 bytes when asked for
36 bytes, but the first has 0 in the additional length field
(thus reports length 5), the second has 32 in the additional
length field (thus reports length 37).
This second device, when asked for 37 bytes, still only returns 36.

Andries


-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
