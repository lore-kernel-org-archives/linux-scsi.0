From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Subject: RE: usb-starge not working in the latest kernel 2.4
Date: Mon, 1 Sep 2003 20:05:50 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200309011106.UAA15973@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="shift_jis"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from inet-tsb.toshiba.co.jp ([202.33.96.40]:56753 "EHLO
	inet-tsb.toshiba.co.jp") by vger.kernel.org with ESMTP
	id S262822AbTIALHb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Sep 2003 07:07:31 -0400
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>, Alan Stern <stern@rowland.harvard.edu>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

Hi Dave,

Thanks!!

Haruo>usb-storage: Command READ_10 (10 bytes)
Haruo>usb-storage: 28 00 00 02 e5 24 00 00 3f 00 00 00
Haruo>usb-storage: Bulk command S 0x43425355 T 0x7862f8 Trg 0 LUN 
Haruo> 0 L 129024 F 128 CL 12
Haruo>usb-storage: command_abort() called

Alan> It stopped working here.  The driver tried to send the next 
Alan> command but the drive never acknowledged receiving it.

Dave> It might also be useful to find just how many of those 126 KBytes
Dave> were successfully transferred before the abort.

How can it check?

Dave> Also:  is this one of those cases where 2.6 works and 2.4 doesn't?
Dave> The i/o patterns are very different ...
 
Is it the meaning that operation changes with  i/o patterns?
--
Haruo
