From: Andries.Brouwer@cwi.nl
Subject: Re: [usb-storage] Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Tue, 22 Apr 2003 03:09:23 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200304220109.h3M19NX09680.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:22660 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S262722AbTDVA5k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2003 20:57:40 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, mdharm-scsi@one-eyed-alien.net
Cc: greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, torvalds@transmeta.com, usb-storage@one-eyed-alien.net

I have not been following this USB and SCSI stuff very carefully,
but some time ago I tried a large number of strange USB devices,
and of course some failed, and I changed the SCSI stuff a little
so that everything worked. I think Linus took these patches,
which means that on my sample of devices 2.5 works.

Is the present discussion about 2.4, or is it about 2.5,
and in case it is the latter, can anybody describe what
devices fail, and in what way?

Andries
