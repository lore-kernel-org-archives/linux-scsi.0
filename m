From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into the kernel
Date: Fri, 30 Sep 2005 18:10:02 -0400
Message-ID: <87f94c370509301510nba59ac2m59f507f70de6e46b@mail.gmail.com>
References: <Pine.LNX.4.10.10509300015100.27623-100000@master.linux-ide.org>
	 <433D8542.1010601@adaptec.com>
	 <A0262C6F-6B0E-4790-BA42-FAFD6F026E0A@mac.com>
	 <433D8D1F.1030005@adaptec.com>
	 <0F03AA4B-D2D1-4C57-B81B-FC95CB863A98@mac.com>
Reply-To: Greg Freemyer <greg.freemyer@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030470AbVI3WKH@vger.kernel.org>
In-Reply-To: <0F03AA4B-D2D1-4C57-B81B-FC95CB863A98@mac.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Andre Hedrick <andre@linux-ide.org>, "David S. Miller" <davem@davemloft.net>, jgarzik@pobox.com, willy@w.ods.org, patmans@us.ibm.com, ltuikov@yahoo.com, linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>
List-Id: linux-scsi@vger.kernel.org

> >>> The way we do this is we slowly, without disruption to older
> >>> drivers introduce, in parallel, emerge a new, simpler, slimmer,
> >>> faster SCSI Core, whereby we accommodate new infrastructures,
> >>> yet, have 100% backward compatibility, via the current older SCSI
> >>> Core. After all, both would be a bunch of functions in a bunch of
> >>> files.
> >>
> >> Except this introduces bloat and multiplies maintainer load.  Fix the
> >> existing one.  If it breaks other in-core drivers, fix those to
> >
> > Well, not necessarily.  It would be more painful and more
> > maintainer load if we did what you suggest.  The overhead would be
> > enormous.
>
> So you're saying fixing the current SCSI subsystem once *now* costs
> more than applying all *future* SCSI fixes to _two_ SCSI subsystems,
> handling bug reports for _two_ SCSI subsystems, etc.
>

Luben has more than once called for adding a small number of
additional calls to the existing SCSI core.  These calls would
implement the new (reduced) functionallity.  The old calls would
continue to support the full SPI functionallity.  No existing  LLDD
would need modification.

Then, over time, more radical restructuring could be done that pulls
SPI out of SCSI core.

I believe this proposal is what he was talking about, not the brand
new simplified SCSI core that has been discussed recently in this
thread.

Greg
--
Greg Freemyer
The Norcross Group
Forensics for the 21st Century
