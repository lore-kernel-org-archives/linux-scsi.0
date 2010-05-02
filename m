From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 10/21] m68k/scsi: a2091 - Kill ugly DMA() macro
Date: Sun, 02 May 2010 16:05:49 -0400
Message-ID: <1272830750.23834.43.camel@mulgrave.site>
References: <1270371651-2584-2-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-5-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-6-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-7-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-8-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-9-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-10-git-send-email-geert@linux-m68k.org>
	 <1270371651-2584-11-git-send-email-geert@linux-m68k.org>
	 <20100405062529.GA28950@infradead.org>
	 <s2o10f740e81004051242r27951fcftefe2ca3d1425ff66@mail.gmail.com>
	 <i2h10f740e81004230137oc7c5f464w164786cd7f13f589@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <i2h10f740e81004230137oc7c5f464w164786cd7f13f589@mail.gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2010-04-23 at 10:37 +0200, Geert Uytterhoeven wrote:
> On Mon, Apr 5, 2010 at 21:42, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Mon, Apr 5, 2010 at 08:25, Christoph Hellwig <hch@infradead.org> wrote:
> >> Instead of abusing the ScsiHost base field I'd prefer if you stick
> >
> > I wouldn't call it abuse: it's a (MM)IO base address anyway.
> > But I see that field was indeed marked `legacy crap' in an otherwise
> > innocent looking
> > commit to split the SCSI include files... by you ;-)
> >
> >> a properly typed pointer into the device specific host data.
> >
> > You mean shost_priv()? That field already contains a pointer to the
> > struct WD33C93_hostdata.
> >
> > But I'll create a new a2091_hostdata struct that contains both the
> > WD33C93_hostdata and the a2091_scsiregs pointer (and do the same
> > for gvp11.c and a3000.c). It's a bit similar to what sgiwd93.c does, albeit that
> > one also uses the legacy base field.
> 
> As I want to avoid introducing bugs by respinning the complicated
> parts (the zorro
> driver and platform driver conversion patches), I made this change on
> top of the 2
> whole patch series.
> 
> A2091 part:

I've applied up to 10/21 which should make it easier, but this patch
refuses to apply:

patch: **** malformed patch at line 230: struct scsi_cmnd *SCpnt,

could you respin the remaining patches so they'll actually apply?

Thanks,

James
