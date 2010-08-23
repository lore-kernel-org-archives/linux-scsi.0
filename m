From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Mon, 23 Aug 2010 15:21:01 -0500
Message-ID: <1282594861.11194.60.camel@mulgrave.site>
References: <4C69653E.6050808@vlnb.net>
	 <1282077040.16098.47.camel@mulgrave.site> <4C6C1DC1.8090208@vlnb.net>
	 <1282164188.10878.22.camel@mulgrave.site> <4C702030.2070306@vlnb.net>
	 <1282423128.3015.35.camel@mulgrave.site>
	 <AANLkTin9STqUz440fCOEWW=YmedVQtQWU2JLO2wZCt5j@mail.gmail.com>
	 <1282582740.11194.17.camel@mulgrave.site>
	 <AANLkTinkYCPA-ZdWFhdriCyrK7J8Okj5HWqg7JsGZ7ry@mail.gmail.com>
	 <1282586336.11194.30.camel@mulgrave.site>
	 <AANLkTinTg3oHmc6N-zu_Czg7s5dPwvxwgLa-eBuHwSBe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53939 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab0HWUVG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2010 16:21:06 -0400
In-Reply-To: <AANLkTinTg3oHmc6N-zu_Czg7s5dPwvxwgLa-eBuHwSBe@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Gennadiy Nerubayev <parakie@gmail.com>, Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 2010-08-23 at 22:11 +0200, Bart Van Assche wrote:
> On Mon, Aug 23, 2010 at 7:58 PM, James Bottomley
> <James.Bottomley@suse.de> wrote:
> > On Mon, 2010-08-23 at 19:44 +0200, Bart Van Assche wrote:
> >> On Mon, Aug 23, 2010 at 6:59 PM, James Bottomley
> >> <James.Bottomley@suse.de> wrote:
> >> >
> >> > My basic conclusion was that there's no incredible discriminator between
> >> > LIO and STGT (although there are reams written on which performs better
> >> > in which circumsances, is useful for clustering, supports ALUA, etc.
> >> > each with partisans for the features).  If the two communities can't
> >> > work together (as seems to be the case) and I have to choose one, I'll
> >> > go by what helps me which, as I've said before, are:
> >> >
> >> >     1. That it would be a drop in replacement for STGT (our current
> >> >        in-kernel target mode driver), since he only wanted a single
> >> >        SCSI target infrastructure.
> >> >
> >> >     2. That it used a modern sysfs based control and configuration
> >> >        plane.
> >> >
> >> >     3. That the code was reviewed as clean enough for inclusion.
> 
> Let us return to the three acceptance criteria. At this time none of
> the existing kernel-based target frameworks support ibmvstgt and hence
> none of them satisfy criterion [1]. Yet these criteria have been used
> to decide that one kernel-based target framework will be accepted and
> that the other will not be accepted. I'm afraid that I missed
> something ?
> 
> Also, you write that you, as a kernel maintainer, might become in a
> position that you have to choose a target framework. I would
> appreciate it if you would take the time to reread the document
> Documentation/ManagementStyle. This document was written by Linus
> Torvalds and explains that a kernel maintainer should try to avoid
> having to take such decisions. The whole first chapter of that
> document is devoted to this subject.

I have avoided this decision for several years in the vain hope that
some accommodation could be found.  However, since I foresee a mergeable
patch in my inbox in the very near future, it's shortly becoming
unavoidable.

James


> I regret that you got involved personally in this discussion. It would
> have been a lot easier for everyone if you would have been able to
> keep a neutral position.
> 
> Bart.


