From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Fwd: Re: [Scst-devel] linuxcon 2010...
Date: Wed, 18 Aug 2010 15:43:08 -0500
Message-ID: <1282164188.10878.22.camel@mulgrave.site>
References: <4C69653E.6050808@vlnb.net>
	 <1282077040.16098.47.camel@mulgrave.site>  <4C6C1DC1.8090208@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C6C1DC1.8090208@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-08-18 at 21:52 +0400, Vladislav Bolkhovitin wrote:
> James Bottomley, on 08/18/2010 12:30 AM wrote:
> >> 1. What don't you like in the transition path for users from STGT to
> >> SCST, which I proposed:
> >>
> >>    - The only people which would be affected by replacing of STGT by SCST
> >> would be users of ibmvstgt. Other STGT users would not notice it at all.
> >> Thus, we should update ibmvstgt for SCST. If ibmvstgt updated for SCST,
> >> the update for its users would be just writing of a simple scstadmin's
> >> config file.
> >>
> >>    - STGT doesn't have backend drivers, which SCST doesn't have, so
> >> there's nothing to worry here. At max, AIO support should be added to
> >> fileio_tgt.
> >>
> >>    - STGT user space targets can use SCST backend via scst_local module.
> >> Scst_local module is ready and work very well.
> >>
> >> The result would be very clear without any obsolete mess.
> >
> > So does that get us up to being a drop in replacement?  I think you're
> > saying that even with all of this, at least the VSCSI part will need
> > updating, so the answer seems to be "no".
>
> Sorry, I can't understand, "no" for which? For the whole transition 
> path, or just until there is a patch for ibmvstgt to become ibmvscst?

No to the question "does that get us up to being a drop in replacement
[for STGT]?"

> >> 4. Have you changed your opinion that a driver level multipath is
> >> forbidden in Linux and now you think that an iSCSI target with MC/S
> >> support is acceptable?
> >
> > no; I still think MCS is a pointless duplication of multipath that only
> > works for iSCSI.
> 
> Then, does it mean that similarly as it was with open-iscsi, which had 
> to remove MC/S support to be able to be accepted into the mainline, an 
> iSCSI target can't go into mainline if it has MC/S?

To be honest, I don't care about targets.  I only care that the
initiators do the right thing.

James
