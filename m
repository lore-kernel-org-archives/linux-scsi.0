From: S Iremonger <exxsi@bath.ac.uk>
Subject: Re: linux 2.6 "seagate" scsi hardware driver ?incomplete?
Date: Tue, 1 Feb 2005 14:13:37 +0000 (GMT)
Message-ID: <Pine.GSO.4.53.0502011409260.5202@amos.bath.ac.uk>
References: <Pine.GSO.4.53.0502010159390.22349@amos.bath.ac.uk>
 <20050201140200.GB10088@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from coppi.bath.ac.uk ([138.38.32.23]:16929 "EHLO coppi.bath.ac.uk")
	by vger.kernel.org with ESMTP id S262018AbVBAONk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2005 09:13:40 -0500
In-Reply-To: <20050201140200.GB10088@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Tue, 1 Feb 2005, Matthew Wilcox wrote:
>Actually, it's worse than that:
>config SCSI_SEAGATE
>        tristate "Seagate ST-02 and Future Domain TMC-8xx SCSI support"
>        depends on X86 && ISA && SCSI && BROKEN
>The driver is marked as BROKEN so it's even a candidate for deletion unless a
>maintainer steps up to fix it.  Could you do that?

Unsure.
Where do I find documentation onw hat has changed in the SCSI
  architecture between 2.6 and 2.4 ?

In any case, I'm building the 2.6.10 with "seagate.ko" and will see
  if it does, actually, work ;-).
I know it works under 2.4.x .... It drives a scanner etc. off the
  50pin SCSI interface... except, via an external cable, and, the
  card with the matching sortof 25pin apple-wiring D connector is
  the TMC-855 thingie.  It's hardly a clever SCSI card, but it
  does the job and transfers data fast enough ;-).

It always /has/ worked, Im working why it is now apparently
  broken!

Is there a good way to find all related changes amongst the huge
  pile of changelog entries?

--S Iremonger <exxsi@bath.ac.uk>
