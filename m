From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 28/29] atari_NCR5380: Refactor Falcon special cases
Date: Mon, 6 Oct 2014 15:41:36 +0200
Message-ID: <201410061541.36522.linux@rainbow-software.org>
References: <20141002065628.256592712@telegraphics.com.au> <543260AB.3020307@suse.de> <alpine.LNX.2.00.1410062121430.27616@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:57768 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaJFNmV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2014 09:42:21 -0400
In-Reply-To: <alpine.LNX.2.00.1410062121430.27616@nippy.intranet>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

On Monday 06 October 2014, Finn Thain wrote:
> On Mon, 6 Oct 2014, Hannes Reinecke wrote:
> > On 10/02/2014 08:56 AM, Finn Thain wrote:
> > > Make the atari_NCR5380.c core driver usable by sun3_scsi, mac_scsi and
> > > others by moving some of the Falcon-specific code out of the core
> > > driver: !IS_A_TT, atari_read_overruns and falcon_dont_release. Replace
> > > these with hostdata variables and flags. FLAG_CHECK_LAST_BYTE_SENT is
> > > unused in atari_NCR5380.c so don't set it.
> >
> > Hmm. Shouldn't there be some more patches for sun3_scsi and mac_scsi to
> > actually make use of this?
>
> Yes, I think you are right, some of those patches should be included.
>
> I've done some testing of mac_scsi and dmx3191d using the atari_NCR5380.c
> core driver but this isn't working adequately yet. It's not yet a proof of
> concept.
>
> To convert sun3_scsi to use the atari_NCR5380 core driver is easier.
>
> If I had atari and sun3 hardware to test on, everything would be done in
> one patch set and I could test the end result rather than asking others to
> test it in stages on the appropriate hardware.
>
> Anyway, I will include more patches when I re-submit: not just the
> sun3_NCR5380.c removal (which is ugly but hopefully Sam can simplify it)
> but also some more work on atari_NCR5380.c (to minimise testing effort).
>
> > I'd _love_ to get rid of all of this NCR5380 code duplication ...
>
> My reading is that if mac_scsi can work with atari_NCR5380 then the same
> is very likely true for the ARM drivers (oak, cumana_1) and also dmx3191d.
>
> To merge atari_NCR5380.c with NCR5380.c would be much more difficult. If
> someone who has the hardware were to take an interest in the remaining
> drivers (just the ISA card drivers, dtc, pas16, g_NCR5380, t128), perhaps
> it would be feasible.

I have some NCR5380 ISA cards and did some fixes to the driver a couple of 
years ago.

-- 
Ondrej Zary
