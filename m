From: Pat LaVarre <p.lavarre@ieee.org>
Subject: [usb-storage] ziptool
Date: 14 Nov 2003 10:07:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068829678.5539.28.camel@patrh9>
References: <UTC200311140225.hAE2Pq515023.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:27776 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264548AbTKNRIh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 12:08:37 -0500
In-Reply-To: <UTC200311140225.hAE2Pq515023.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: andries.brouwer@cwi.nl
Cc: usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org, patmans@us.ibm.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org, james.bottomley@steeleye.com, mdharm-scsi@one-eyed-alien.net, ronald@kuetemeier.com, stern@rowland.harvard.edu

> Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage -
pass larger receive buffer
> ...
> > I ask just because you can't see the write-protect tab on a Zip disk
> > unless you use an electron microscope
> > so you might not know how to flip it.
> 
> You are not referring to things like "ziptool -ro" ?

Fruitful hint, thank you.  I find I now conjecture:

ziptool runs in Linux and makes an Iomega Zip disk writable or not.

ziptool wasn't known to me before now.  On first reading your concise
reply I actually confused `ziptool -ro` with the unrelated `cd .. ;  zip
-r gccscsi.zip gccscsi/`.

Since also I know Iomega Zip drives report PDT x00 HDD/Flash with RMB, I
agree Linux folk who possess Iomega Zip drives & disks could try testing
both rewritable and read-only disks in sd by way of ziptool.

I remain unlikely to try that approach soon myself, since I don't know
that I have any easy way of discovering what else ziptool does to Linux,
apart from actually toggling the write-protect tab inside an Iomega Zip
disk.

Pat LaVarre

P.S. I reach my conclusion in Three steps.

1)

I remember "Andries E. Brouwer" kindly does appear in:

http://www.google.com/search?q=link:members.aol.com/plscsi/

2)

I see I have no ziptool:

$ cat /etc/redhat-release
Red Hat Linux release 9 (Shrike)
$
$ man ziptool
No manual entry for ziptool
$
$ which ziptool
/usr/bin/which: no ziptool in (...)
$

3)

I see others do have ziptool:

http://www.google.com/search?q=ziptool

today yields:

http://freshmeat.net/projects/ziptool/?topic_id=136%2C861

"ZIPTool is a set of tools for controlling IOMega JAZ and ZIP drives
from Linux. It features locking and unlocking of media (with a
password), ejecting, spinning down drives, mounting, and unmounting.

Ignoring case, trailing blanks, leading blanks, and stuttered blanks, I
match such strings as "Iomega Zip" and "IOMEGA  " "ZIP 250         " to
the "IOMega ... ZIP" string I see here.


