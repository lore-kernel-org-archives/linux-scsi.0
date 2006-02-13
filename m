From: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: Linux 2.6.16-rc3
Date: Sun, 12 Feb 2006 22:22:55 -0500
Message-ID: <1139800975.7916.7.camel@lade.trondhjem.org>
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

> - Benjamin LaHaise <bcrl@kvack.org> had an NFS problem ("NFS processes
>   gettting stuck in D with currrent git").

...but which was apparently not repeatable:

        As of this afternoon's tree
        (6150c32589d1976ca8a5c987df951088c05a7542)  after the more
        recent set of nfs patches, it seems to be behaving itself.  Will
        keep sysrq enabled to see if it hits again, though.

I've had no news from Ben since then...

Cheers,
  Trond

