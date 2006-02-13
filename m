From: "Brown, Len" <len.brown@intel.com>
Subject: RE: Linux 2.6.16-rc3
Date: Mon, 13 Feb 2006 02:07:50 -0500
Message-ID: <F7DC2337C7631D4386A2DF6E8FB22B30060BD1D1@hdsmsx401.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-acpi-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, "David S. Miller" <davem@davemloft.net>, Greg KH <greg@kroah.com>, linux-acpi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, "Yu, Luming" <luming.yu@intel.com>, Ben Castricum <lk@bencastricum.nl>, sanjoy@mrao.cam.ac.uk, Helge Hafting <helgehaf@aitel.hist.no>, "Carlo E. Prelz" <fluido@fluido.as>linux-usb-devel@lists.sourceforge.net, =?iso-8859-1?Q?Gerrit_Bruchh=E4user?= <gbruchhaeuser@gmx.de>, Nicolas.Mailhot@LaPoste.net, Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>, Patrizio Bassi <patrizio.bassi@gmail.com>, =?iso-8859-1?Q?Bj=F6rn_Nilsson?= <bni.swe@gmail.com>, Andrey Borzenkov <arvidjaar@mail.ru>, "P. Christeas" <p_christ@hol.gr>, ghrt <ghrt@dial.kappa.ro>, jinhong hu <jinhong.hu@gmail.com>, Andrew
List-Id: linux-scsi@vger.kernel.org

 
>- In http://bugzilla.kernel.org/show_bug.cgi?id=5989, Sanjoy 
>Mahajan has  another regression, but he's off collecting more info.

We're talking here about a system from 1999 where Windows 98
refuses to run in ACPI mode and instead runs in APM mode.
So I don't consider a regression on this box as "serious" --
I consider that it works in ACPI mode at all as "miraculous":-)

However, I do think the issue merits investigation in the event
that it has an effect on systems newer than 6 years old.

thanks,
-Len

