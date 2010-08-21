From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Fwd: Re: [Scst-devel] linuxcon 2010...
Date: Sat, 21 Aug 2010 15:38:48 -0500
Message-ID: <1282423128.3015.35.camel@mulgrave.site>
References: <4C69653E.6050808@vlnb.net>
	 <1282077040.16098.47.camel@mulgrave.site>  <4C6C1DC1.8090208@vlnb.net>
	 <1282164188.10878.22.camel@mulgrave.site>  <4C702030.2070306@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43331 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab0HUUix (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2010 16:38:53 -0400
In-Reply-To: <4C702030.2070306@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, 2010-08-21 at 22:51 +0400, Vladislav Bolkhovitin wrote:
> James Bottomley, on 08/19/2010 12:43 AM wrote:
> >>>> 1. What don't you like in the transition path for users from STGT to
> >>>> SCST, which I proposed:
> >>>>
> >>>>     - The only people which would be affected by replacing of STGT by SCST
> >>>> would be users of ibmvstgt. Other STGT users would not notice it at all.
> >>>> Thus, we should update ibmvstgt for SCST. If ibmvstgt updated for SCST,
> >>>> the update for its users would be just writing of a simple scstadmin's
> >>>> config file.
> >>>>
> >>>>     - STGT doesn't have backend drivers, which SCST doesn't have, so
> >>>> there's nothing to worry here. At max, AIO support should be added to
> >>>> fileio_tgt.
> >>>>
> >>>>     - STGT user space targets can use SCST backend via scst_local module.
> >>>> Scst_local module is ready and work very well.
> >>>>
> >>>> The result would be very clear without any obsolete mess.
> >>>
> >>> So does that get us up to being a drop in replacement?  I think you're
> >>> saying that even with all of this, at least the VSCSI part will need
> >>> updating, so the answer seems to be "no".
> >>
> >> Sorry, I can't understand, "no" for which? For the whole transition
> >> path, or just until there is a patch for ibmvstgt to become ibmvscst?
> >
> > No to the question "does that get us up to being a drop in replacement
> > [for STGT]?"
> 
> I'm sorry again, I did my best, but still can't understand. What you 
> wrote looks for me too ambiguous. My English must be too bad..
> 
> Could elaborate more for what the "no" is, please? What don't you like 
> in the plan I suggested?

No it isn't a plan that gives us a drop in replacement for STGT.  I
didn't say migration path to random userspace target, I said reuse of
existing code.

James


