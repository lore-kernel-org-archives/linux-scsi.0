From: Andries.Brouwer@cwi.nl
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Tue, 22 Apr 2003 21:50:51 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200304221950.h3MJopK22337.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:712 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S263804AbTDVTjN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2003 15:39:13 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, James.Bottomley@steeleye.com
Cc: afafc@rnl.ist.utl.pt, alan@lxorguk.ukuu.org.uk, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net, mike@hingston.demon.co.uk, steliam@popies.net, stern@rowland.harvard.edu, torvalds@transmeta.com, usb-storage@one-eyed-alien.net

> we will drop through to the 255 byte request quickly which,
> on the 2.4 evidence, should work.

Yes, on the devices of these three people.
But not on many other devices.

Andries
