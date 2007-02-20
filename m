From: Sven Rudolph <Sven_Rudolph@drewag.de>
Subject: Re: any experience with PCI Express parallel scsi controllers?
Date: Tue, 20 Feb 2007 17:36:11 +0100
Message-ID: <xfkmz384whw.fsf@uxrs53.drewag.de>
References: <Pine.LNX.4.63.0702200959540.12650@gx620.engin.umich.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from miranda.drewag.de ([212.111.238.29]:53887 "EHLO
	miranda.drewag.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030292AbXBTRCO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Feb 2007 12:02:14 -0500
In-Reply-To: <Pine.LNX.4.63.0702200959540.12650@gx620.engin.umich.edu> (Christopher
 Allen Wing's message of "Tue, 20 Feb 2007 10:10:11 -0500 (EST)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christopher Allen Wing <wingc@engin.umich.edu>
Cc: linux-scsi@vger.kernel.org

Christopher Allen Wing <wingc@engin.umich.edu> writes:

> I'm trying to connect some older SCSI devices to new servers which
> only have PCI Express expansion slots.  Unfortunately it seems that
> there are very few parallel SCSI HBA cards available for PCI Express
> systems.  Most SCSI controller manufacturers are only selling PCI-X
> cards if you want parallel SCSI.
>
>
> Has anyone else been in this situation?  One product that we found is
> a board sold by HP (HP SC11Xe) based on a LSI Logic chipset.  This is
> a PCI Express controller with a single U320 parallel SCSI channel.  It
> is reasonably priced ($200); unfortunately, the documentation on HP's
> web site states that it will only work with tape devices.

I am quite sure that this is only a marketing (or technical support)
issue. Big vendors tend to strongly suggest hardware RAID controllers
for disks, which makes sense from a Windows point of view. (I have
Adaptec 29160LP Controllers bought from Fujitsu-Siemens; and FSC only
supports these controllers for Tape devices for this reason.) I see no
technical reason why the HP ones shouldn't work with disks.

A limitation compared to cards from LSI and Adaptec: HP supports
this card only for the listed HP servers.

Unfortunately LSI doesn't build/sell this card directly.

> Otherwise, Adaptec does not seem to sell any parallel SCSI cards for
> PCI Express;

A card called 29320LPE is expected in March; and a patch adding the
PCI-ID already appeared on this list. As the name indicates, this is
one Ultra 320 Channel, low profile PCI. I plan to wait for this card.

> There is also an ATTO Technology PCI Express card with
> parallel SCSI; it sells for around $500.

(...and provides two SCSI busses, so it is not that overpriced.) I
bought the UL5D Low-Profile and tested it. It needs a small patch
against the MPT-Fusion driver; the patch is provided on the Atto
Website in a login-protected area; and there is a licence-agreement
required (non-distribution and all that junk).

(In my non-lawyer-opinion this patch is a derived work and hence it
must be licensed under the GPL.)

If the patch where GPL, it could be integrated into the upstream
MPT-Fusion driver. (The patch itself worked fine.)

I asked Atto via E-Mail; but I didn't receive an answer. So I don't
use the Atto card (and do not buy new ones) until these cards are
supported by vanilla kernel.

(Atto nowadays promotes a binary-only driver instead of the small
patch, which is not acceptable for me either and seems to indicate
that their idea on doing business doesn't fit that well with Linux'
open-source approach.)

As said above, I am waiting for the Adaptec card...

	Sven


