From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: Race to power off harming SATA SSDs
Date: Mon, 8 May 2017 13:06:17 +0200
Message-ID: <CAFLxGvzAmURHU_6K3gmBfOqHKgvQOkkO_+qgMKsmzhWZwwGnqw@mail.gmail.com>
References: <20170410232118.GA4816@khazad-dum.debian.net> <20170410235206.GA28603@wtj.duckdns.org>
 <20170507204007.GA25628@atrey.karlin.mff.cuni.cz> <1494228094.6528.14.camel@infradead.org>
 <20170508092846.GA11029@amd> <1494236048.6528.32.camel@infradead.org> <20170508104953.GA17773@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20170508104953.GA17773@amd>
Sender: linux-ide-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: David Woodhouse <dwmw2@infradead.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, May 8, 2017 at 12:49 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Aha, nice, so it looks like ubifs is a step back here.
>
> 'clean marker' is a good idea... empty pages have plenty of space.

If UBI (not UBIFS) faces an empty block, it also re-erases it.
The EC header is uses as clean marker.

> How do you handle the issue during regular write? Always ignore last
> successfully written block?

The last page of a block is inspected and allowed to be corrupted.

> Do you handle "paired pages" problem on MLC?

Nope, no MLC support in mainline so far.

-- 
Thanks,
//richard
