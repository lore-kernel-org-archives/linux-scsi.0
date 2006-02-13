From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Linux 2.6.16-rc3
Date: Mon, 13 Feb 2006 08:04:39 +0100
Message-ID: <1139814280.2997.1.camel@laptopd505.fenrus.org>
References: <Pine.LNX.4.64.0602121709240.3691@g5.osdl.org>
	 <20060212190520.244fcaec.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20060212190520.244fcaec.akpm@osdl.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, "Brown, Len" <len.brown@intel.com>, "David S. Miller" <davem@davemloft.net>, Greg KH <greg@kroah.com>, linux-acpi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, "Yu, Luming" <luming.yu@intel.com>, Ben Castricum <lk@bencastricum.nl>, sanjoy@mrao.cam.ac.uk, Helge Hafting <helgehaf@aitel.hist.no>, "Carlo E. Prelz" <fluido@fluido.as>, Gerrit =?ISO-8859-1?Q?Bruchh=E4user?= <gbruchhaeuser@gmx.de>, Nicolas.Mailhot@LaPoste.net, Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>, Patrizio Bassi <patrizio.bassi@gmail.com>, =?ISO-8859-1?Q?Bj=F6rn?= Nilsson <bni.swe@gmail.com>, Andrey Borzenkov <arvidjaar@mail.ru>, "P. Christeas" <p_christ@hol.gr>, ghrt <ghrt@dial.kappa.ro>, jinhong hu <jinhong.hu@gmail.com>, Andrew
List-Id: linux-scsi@vger.kernel.org

On Sun, 2006-02-12 at 19:05 -0800, Andrew Morton wrote:
> We still have some serious bugs, several of which are in 2.6.15 as well:
> 
> - The scsi_cmd leak, which I don't think is fixed.

didn't this got nailed down to a 2.6.15 specific queueing bug, fixed in
2.6.16-rc ?



