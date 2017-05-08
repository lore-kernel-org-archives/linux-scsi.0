From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: Race to power off harming SATA SSDs
Date: Mon, 8 May 2017 13:55:29 +0200
Message-ID: <20170508135529.172b7009@bbrezillon>
References: <20170410232118.GA4816@khazad-dum.debian.net>
        <20170410235206.GA28603@wtj.duckdns.org>
        <20170507204007.GA25628@atrey.karlin.mff.cuni.cz>
        <1494228094.6528.14.camel@infradead.org>
        <20170508092846.GA11029@amd>
        <1494236048.6528.32.camel@infradead.org>
        <20170508104953.GA17773@amd>
        <CAFLxGvzAmURHU_6K3gmBfOqHKgvQOkkO_+qgMKsmzhWZwwGnqw@mail.gmail.com>
        <20170508134807.498b3ee7@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20170508134807.498b3ee7@bbrezillon>
Sender: linux-ide-owner@vger.kernel.org
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, David Woodhouse <dwmw2@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 8 May 2017 13:48:07 +0200
Boris Brezillon <boris.brezillon@free-electrons.com> wrote:

> On Mon, 8 May 2017 13:06:17 +0200
> Richard Weinberger <richard.weinberger@gmail.com> wrote:
> 
> > On Mon, May 8, 2017 at 12:49 PM, Pavel Machek <pavel@ucw.cz> wrote:  
> > > Aha, nice, so it looks like ubifs is a step back here.
> > >
> > > 'clean marker' is a good idea... empty pages have plenty of space.    
> > 
> > If UBI (not UBIFS) faces an empty block, it also re-erases it.  
> 
> Unfortunately, that's not the case, though UBI can easily be patched
> to do that (see below).

Sorry for the noise, I was wrong, UBI already re-erases empty blocks
[1].

[1]http://elixir.free-electrons.com/linux/latest/source/drivers/mtd/ubi/attach.c#L983
