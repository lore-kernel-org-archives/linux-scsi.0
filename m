From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 2/6] block: push down BKL into .open and .release
Date: Sun, 4 Jul 2010 22:27:11 +0200
Message-ID: <AANLkTinduxuj8412d7eGK1qZGNHrIzCFOOrwXO5zBr5W@mail.gmail.com>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de>
	<1278193640-24223-3-git-send-email-arnd@arndb.de>
	<20100704080146.GA31828@merkur.ravnborg.org>
	<20100704103310.368dee05@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20100704103310.368dee05@infradead.org>
Sender: linux-m68k-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jul 4, 2010 at 19:33, Arjan van de Ven <arjan@infradead.org> wrote:
> On Sun, 4 Jul 2010 10:01:46 +0200
> Sam Ravnborg <sam@ravnborg.org> wrote:
>> Lot's of other places could benefit from improved goto error handling.
>> The driver maintainers should do this (if there is a maintainer).
>> I stopped with the small replacement patches.
>
> it's the floppy driver for amigas
> not sure if any of those are still alive at all running linux.....

Sure there are. Whether the floppy drives in them are still actively used is
another question. SSH and NFS over Ethernet are much more convenient ;-)

Last time I tried (hmm, this or previous century?), my floppy drive had problems
reading the floppy, probably my drive is dying. Oh well...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
