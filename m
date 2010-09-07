From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Mon, 6 Sep 2010 23:26:52 -0700
Message-ID: <20100907062652.GA1680@core.coreip.homeip.net>
References: <1283459158.5598.143.camel@haakon2.linux-iscsi.org>
 <20100905201802.GC18411@core.coreip.homeip.net>
 <1283723447.556.133.camel@haakon2.linux-iscsi.org>
 <20100905234134.GA17212@core.coreip.homeip.net>
 <1283731194.556.147.camel@haakon2.linux-iscsi.org>
 <1283769578.15944.1293.camel@mulgrave.site>
 <4C85617E.2080603@vlnb.net>
 <1283810135.556.238.camel@haakon2.linux-iscsi.org>
 <20100907004424.GB21430@core.coreip.homeip.net>
 <AANLkTin9Hk8+oMdXfB4h_DhirRyPf00739g5BpKcUE_5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39510 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0IGG06 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2010 02:26:58 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTin9Hk8+oMdXfB4h_DhirRyPf00739g5BpKcUE_5@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Vladislav Bolkhovitin <vst@vlnb.net>, James Bottomley <James.Bottomley@suse.de>, Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Tue, Sep 07, 2010 at 08:08:37AM +0200, Bart Van Assche wrote:
> On Tue, Sep 7, 2010 at 2:44 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> >
> > [ ... ]
> >
> > Vlad appears to be asserting that SCST is more feature-complete that LIO
> > at this point. It also seems that LIO is somewhat younger than SCST. So
> > at this point it might be interesting to see:
> >
> > 1. What are the shortcomings of SCST design compared to LIO and why LIO
> > developers chose to come with their own solution instead of
> > collaborating with SCST folks?
> >
> > 2. What features are missing from SCST that are currently available in
> > LIO?
> >
> > Once this is sorted out and [most] everyone agrees that LIO is indeed
> > technically superior (even if maybe not as mature yet) solution, then it
> > would make sense to request SCST developers to go to file/line depth of
> > the review.
> 
> You seem to have missed the start of this thread. The design of SCST
> is significantly more advanced than that of LIO, and it has already
> been explained in this thread why
> (http://www.spinics.net/lists/linux-scsi/msg45856.html).
> 

The question was directed to LIO folks as they appear to disagree with
this statement.

-- 
Dmitry
