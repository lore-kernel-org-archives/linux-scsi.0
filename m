From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [linux-usb-devel] Re: Linux 2.6.16-rc3
Date: Sun, 19 Feb 2006 07:51:17 -0600
Message-ID: <1140357077.3103.0.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.44L0.0602181515350.4115-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:63130 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932442AbWBSNwP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Feb 2006 08:52:15 -0500
In-Reply-To: <Pine.LNX.4.44L0.0602181515350.4115-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@suse.de>, Russell King <rmk+lkml@arm.linux.org.uk>, Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org, "Brown, Len" <len.brown@intel.com>, "David S. Miller" <davem@davemloft.net>, linux-acpi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, "Yu, Luming" <luming.yu@intel.com>, Ben Castricum <lk@bencastricum.nl>, sanjoy@mrao.cam.ac.uk, Helge Hafting <helgehaf@aitel.hist.no>, "Carlo E. Prelz" <fluido@fluido.as>, Gerrit Bruchh?user <gbruchhaeuser@gmx.de>, Nicolas.Mailhot@LaPoste.net, Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>, Patrizio Bassi <patrizio.bassi@gmail.com>, Bj?rn Nilsson <bni.swe@gmail.com>, Andrey Borzenkov <arvidjaar@mail.ru>, "P. Christeas" <p_christ@hol.gr>, ghrt <ghrt@dial.kappa.ro>, jinhong hu <jinhong.hu@gmail.com>, Andrew Vasquez <andre>

On Sat, 2006-02-18 at 15:16 -0500, Alan Stern wrote:
> The test should be in_atomic(), not in_interrupt().

There's a long prior discussion of why it has to be in_interrupt()

James


