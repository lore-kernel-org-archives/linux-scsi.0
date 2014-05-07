From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH] iscsi_ibft: search for broadcom specific ibft sign
Date: Wed, 7 May 2014 16:15:24 -0400
Message-ID: <20140507201524.GA26303@fenchurch.internal.datastacks.com>
References: <1399453220-21663-1-git-send-email-vikas.chaudhary@qlogic.com>
 <20140507134757.GC12826@phenom.dumpdata.com>
 <1399489950.2227.63.camel@dabdike.int.hansenpartnership.com>
 <20140507192158.GA17806@phenom.dumpdata.com>
 <536A8E67.7030805@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaEGURM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2014 16:17:12 -0400
Content-Disposition: inline
In-Reply-To: <536A8E67.7030805@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@qlogic.com" <giridhar.malavali@qlogic.com>, "konrad@kernel.org" <konrad@kernel.org>, "vikas.chaudhary@qlogic.com" <vikas.chaudhary@qlogic.com>, "iscsi-driver@qlogic.com" <iscsi-driver@qlogic.com>

On Wed, May 07, 2014 at 02:49:59PM -0500, Mike Christie wrote:
> On 05/07/2014 02:21 PM, Konrad Rzeszutek Wilk wrote:
> > On Wed, May 07, 2014 at 07:12:31PM +0000, James Bottomley wrote:
> >> On Wed, 2014-05-07 at 09:47 -0400, Konrad Rzeszutek Wilk wrote:
> >>> On Wed, May 07, 2014 at 05:00:20AM -0400, vikas.chaudhary@qlogic.com wrote:
> >>>> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> >>>>
> >>>> Broadcom iscsi offload firmware uses a non standard ibft sign of "BIFT".
> >>>
> >>> Why? If it uses the standard iBFT format why does it use
> >>> a non-standard signature?
> >>
> >> This is useful as an academic exercise (and perhaps even a reminder to
> >> broadcom not to do it again) but I don't think we can make it a show
> >> stopper.  The boards have shipped with the non-standard signature, so we
> >> have to work with them.
> > 
> > I agree as the train has left, but this got me thinking about these
> > questions that I hope Qlogic folks could answer:
> > 
> >  - Mention what else is different - perhaps there are other entries that
> >    are a bit different? Or maybe the are some non-standard ones added on?
> > 
> >  - How has this been tested? As in had all the fields been tested (so CHAP
> >    on/off, extra ports, etc).
> > 
> 
> This supports the same stuff as was added in the original commit for
> that string:
> 
> 140363500ddadad0c09cb512cc0c96a4d3efa053
> 
> It just was not carried over in the acpi specific table in commit
> 935a9fee51c945b8942be2d7b4bae069167b4886.

Okay, but that patch leaves the scanning for it pre-ACPI intact.  So
is what you're effectively saying is that they've changed to using ACPI
to identify it, as opposed to scanning through RAM, but kept the
nonstandard table name while doing that?  That is, "BIFT" is really
showing up as the ACPI table name?

-- 
        Peter
