From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Linux 2.6.16-rc3
Date: Tue, 14 Feb 2006 10:34:43 -0600
Message-ID: <1139934883.14115.4.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.64.0602121709240.3691@g5.osdl.org>
	 <20060212190520.244fcaec.akpm@osdl.org>  <20060213203800.GC22441@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20060213203800.GC22441@kroah.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@suse.de>, "Brown, Len" <len.brown@intel.com>, "David S. Miller" <davem@davemloft.net>, linux-acpi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, "Yu, Luming" <luming.yu@intel.com>, Ben Castricum <lk@bencastricum.nl>, sanjoy@mrao.cam.ac.uk, Helge Hafting <helgehaf@aitel.hist.no>, "Carlo E. Prelz" <fluido@fluido.as>, Gerrit Bruchh?user <gbruchhaeuser@gmx.de>, Nicolas.Mailhot@LaPoste.net, Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>, Patrizio Bassi <patrizio.bassi@gmail.com>, Bj?rn Nilsson <bni.swe@gmail.com>, Andrey Borzenkov <arvidjaar@mail.ru>, "P. Christeas" <p_christ@hol.gr>, ghrt <ghrt@dial.kappa.ro>, jinhong hu <jinhong.hu@gmail.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2006-02-13 at 12:38 -0800, Greg KH wrote:
> > - Nasty warnings from scsi about kobject-layer things being called
> from
> >   irq context.  James has a push-it-to-process-context patch which
> sadly
> >   assumes kmalloc() is immortal, but no other fix seems to have
> offered
> >   itself.
> 
> This has been the case for a long time.  I don't really think there is
> a
> rush to get this fixed, but I really like James's proposed patch.
> It's
> up to him if he feels it is ready for 2.6.16 or not.

Well, I can't solve the problem that it requires memory allocation from
IRQ context to operate.  Based on that, it's an unsafe interface.  I'm
going to put it inside SCSI for 2.6.16, since it's better than what we
have now, but I don't think we can export it globally.

James


