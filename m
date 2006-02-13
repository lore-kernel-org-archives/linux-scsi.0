From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Linux 2.6.16-rc3
Date: Sun, 12 Feb 2006 22:40:29 -0600
Message-ID: <1139805630.5153.0.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.64.0602121709240.3691@g5.osdl.org>
	 <20060212190520.244fcaec.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:25526 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751610AbWBMEki (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Feb 2006 23:40:38 -0500
In-Reply-To: <20060212190520.244fcaec.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@suse.de>, "Brown, Len" <len.brown@intel.com>, "David S. Miller" <davem@davemloft.net>, Greg KH <greg@kroah.com>, linux-acpi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, "Yu, Luming" <luming.yu@intel.com>, Ben Castricum <lk@bencastricum.nl>, sanjoy@mrao.cam.ac.uk, Helge Hafting <helgehaf@aitel.hist.no>, "Carlo E. Prelz" <fluido@fluido.as>, Gerrit =?ISO-8859-1?Q?Bruchh=E4user?= <gbruchhaeuser@gmx.de>, Nicolas.Mailhot@LaPoste.net, Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>, Patrizio Bassi <patrizio.bassi@gmail.com>, =?ISO-8859-1?Q?Bj=F6rn?= Nilsson <bni.swe@gmail.com>, Andrey Borzenkov <arvidjaar@mail.ru>, "P. Christeas" <p_christ@hol.gr>, ghrt <ghrt@dial.kappa.ro>, jinhong hu <jinhong.hu@gmail.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vge

On Sun, 2006-02-12 at 19:05 -0800, Andrew Morton wrote:
> - The scsi_cmd leak, which I don't think is fixed.

Erm, you mean the leak caused by flush barriers?  That was verified as
fixed (albeit accidentally) in 2.6.16-rc1.

James


