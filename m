From: Pat LaVarre <p.lavarre@ieee.org>
Subject: usb storage traces
Date: 22 Sep 2003 17:25:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064273117.4797.41.camel@patehci2>
References: <UTC200309222307.h8MN7xs00433.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:39919 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261905AbTIVXYj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 19:24:39 -0400
In-Reply-To: <UTC200309222307.h8MN7xs00433.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: linux-scsi@vger.kernel.org


> > Tell me we care to hear specifically what
> > some win sends to some of my usb hdd/rmb,
> > and I'll go collect a few sample usb bus
> > traces.
>
> From: Andries.Brouwer@cwi.nl
> Date: Tue, 23 Sep 2003 01:07:59 +0200 (MEST)	
>
> I'll collect and publish.
> (Change the subject line to "USB storage
> traces" or so.)
> Must have some old traces somewhere myself too.

Thank you.

I'm replying before you publish only to confirm we agree we wish to
survey both:
bInterfaceSubClass == x06 TransparentScsi
bInterfaceSubClass != x06 TransparentScsi

as suggested by:

USB Storage FAQ
Updated: May 20, 2003
http://www.microsoft.com/whdc/hwdev/bus/usb/usbfaq.mspx

---

Q: Which device classes does usbstor.sys understand?

In Windows XP, Windows 2000, and Windows Me, usbstor.sys makes only one
distinction:

bInterfaceSubClass == 06h
- OR -
bInterfaceSubClass != 06h

The value bInterfaceSubClass == 06h means that:
Command descriptor blocks (CDBs) should not be padded to 12 bytes.
Mode Sense / Mode Select commands should not be translated from 1AH /
15h to 5AH / 55h.

Subclass 0x06 should generally be used for flash memory devices.

The value bInterfaceSubClass != 06h means that:
CDBs should be padded to 12 bytes.
Mode Sense / Mode Select commands should be translated from 1AH / 15h to
5AH / 55h.

---

Pat LaVarre



