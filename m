From: Andries.Brouwer@cwi.nl
Subject: Re: Re: inquiry in scsi_scan.c
Date: Tue, 7 Jan 2003 17:37:15 +0100 (MET)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <UTC200301071637.h07GbFK20677.aeb@smtp.cwi.nl>
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: dledford@redhat.com, stern@rowland.harvard.edu
Cc: Andries.Brouwer@cwi.nl, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, luben@splentec.com
List-Id: linux-scsi@vger.kernel.org

> US_FL_DONT_FIX_INQUIRY_LENGTH

Oh, people, please.
There is no problem. So it is a waste of time trying to solve
this non-problem.

If the device transmits 36 bytes, then we have 36 bytes.
What are these bytes used for? To get a vendor name.
A SCSI standard lawyer might wish to distinguish the case
where 8 blacks or NULs is padding, from the case where
these 8 blanks or NULs is the actual vendor name, but
this distinction does not matter at all for our purposes.

Andries


-------------------------------------------------------
This SF.NET email is sponsored by:
SourceForge Enterprise Edition + IBM + LinuxWorld = Something 2 See!
http://www.vasoftware.com
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
