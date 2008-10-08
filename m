From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC] Normalizing byteorder/unaligned access API
Date: Wed, 8 Oct 2008 09:15:53 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0810080913150.19202@anakin>
References: <1223416391.8195.22.camel@brick> <1223417543.7484.7.camel@localhost.localdomain>
 <1223419166.8195.37.camel@brick> <20081007233315.GM25780@parisc-linux.org>
 <1223422788.8195.45.camel@brick>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754526AbYJHHQH@vger.kernel.org>
In-Reply-To: <1223422788.8195.45.camel@brick>
Sender: linux-kernel-owner@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 7 Oct 2008, Harvey Harrison wrote:
> On Tue, 2008-10-07 at 17:33 -0600, Matthew Wilcox wrote:
> > On Tue, Oct 07, 2008 at 03:39:25PM -0700, Harvey Harrison wrote:
> > > As an example, in the write command handling in achba.c, a patch similar to the following
> > > (assumes the existence of a __be24 type somewhere):
> > 
> > What type could be defined to be '__be24'?  Would
> > 
> > typedef struct {
> > 	unsigned char data[3];
> > } __be24;
> 
> __packed

I don't think __packed would help here, as alignment(struct) ==
max(alignment(struct member)) == alignment(char).

Don't you want the __packed on the structure that embeds the __be24?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
