From: Sanjoy Mahajan <sanjoy@mrao.cam.ac.uk>
Subject: Re: Linux 2.6.16-rc3
Date: Mon, 13 Feb 2006 03:28:34 +0000
Message-ID: <E1F8UOA-00085s-00@skye.ra.phy.cam.ac.uk>
References: <20060212190520.244fcaec.akpm@osdl.org>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: Your message of "Sun, 12 Feb 2006 19:05:20 PST."
             <20060212190520.244fcaec.akpm@osdl.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, "Brown, Len" <len.brown@intel.com>, "David S. Miller" <davem@davemloft.net>, Greg KH <greg@kroah.com>, linux-acpi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, "Yu, Luming" <luming.yu@intel.com>, Ben Castricum <lk@bencastricum.nl>, Helge Hafting <helgehaf@aitel.hist.no>, "Carlo E. Prelz" <fluido@fluido.as>, Gerrit =?ISO-8859-1?B?QnJ1Y2ho5HVzZXI=?= <gbruchhaeuser@gmx.de>, Nicolas.Mailhot@LaPoste.net, Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>, Patrizio Bassi <patrizio.bassi@gmail.com>, =?ISO-8859-1?B?Qmr2cm4=?= Nilsson <bni.swe@gmail.com>, Andrey Borzenkov <arvidjaar@mail.ru>, "P. Christeas" <p_christ@hol.gr>, ghrt <ghrt@dial.kappa.ro>, jinhong hu <jinhong.hu@gmail.com>, Andrew Vasquez <andrew.vas>
List-Id: linux-scsi@vger.kernel.org

> In http://bugzilla.kernel.org/show_bug.cgi?id=5989, Sanjoy Mahajan has
> another regression, but he's off collecting more info.

I'm nearly done with bisecting (spent a day on a wild bisect goose
chase due to being careless) and I'm 95% sure the problem is
introduced by:

commit b8e4d89357fc434618a59c1047cac72641191805
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Jan 27 16:43:00 2006 -0500

    [ACPI] ACPICA 20060127

But I will know for sure shortly.

-Sanjoy

`Never underestimate the evil of which men of power are capable.'
         --Bertrand Russell, _War Crimes in Vietnam_, chapter 1.
