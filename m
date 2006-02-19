From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [linux-usb-devel] Re: Linux 2.6.16-rc3
Date: Sun, 19 Feb 2006 08:30:58 -0600
Message-ID: <1140359458.3103.11.camel@mulgrave.il.steeleye.com>
References: <1139934883.14115.4.camel@mulgrave.il.steeleye.com>
	 <1140054960.3037.5.camel@mulgrave.il.steeleye.com>
	 <20060216171200.GD29443@flint.arm.linux.org.uk>
	 <1140112653.3178.9.camel@mulgrave.il.steeleye.com>
	 <20060216180939.GF29443@flint.arm.linux.org.uk>
	 <1140113671.3178.16.camel@mulgrave.il.steeleye.com>
	 <20060216181803.GG29443@flint.arm.linux.org.uk>
	 <1140116969.3178.24.camel@mulgrave.il.steeleye.com>
	 <20060216200138.GA4203@suse.de>
	 <1140223363.3231.9.camel@mulgrave.il.steeleye.com>
	 <20060218100344.GA8532@procyon.home>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20060218100344.GA8532@procyon.home>
Sender: linux-acpi-owner@vger.kernel.org
To: Sergey Vlasov <vsu@altlinux.ru>
Cc: Jens Axboe <axboe@suse.de>, Russell King <rmk+lkml@arm.linux.org.uk>, Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org, "Brown, Len" <len.brown@intel.com>, "David S. Miller" <davem@davemloft.net>, linux-acpi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, "Yu, Luming" <luming.yu@intel.com>, Ben Castricum <lk@bencastricum.nl>, sanjoy@mrao.cam.ac.uk, Helge Hafting <helgehaf@aitel.hist.no>, "Carlo E. Prelz" <fluido@fluido.as>, Gerrit Bruchh?user <gbruchhaeuser@gmx.de>, Nicolas.Mailhot@LaPoste.net, Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>, Patrizio Bassi <patrizio.bassi@gmail.com>, Bj?rn Nilsson <bni.swe@gmail.com>, Andrey Borzenkov <arvidjaar@mail.ru>, "P. Christeas" <p_christ@hol.gr>, ghrt <ghrt@dial.kappa.ro>, jinhong hu <jinhong.hu@gmail.com>, Andrew Vasquez <andre>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2006-02-18 at 13:03 +0300, Sergey Vlasov wrote:
> After removing kfree(), which was here in the initial implementation,
> this function became a thunk which does nothing useful - we can just
> stick fn and data directly into work_struct.

Yes, thanks ... although I think there's still value to wrappering
work_struct (a bit like kref wrappers atomic_t).

James


