From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Sun, 22 Aug 2010 15:29:13 -0500
Message-ID: <1282508953.3042.102.camel@mulgrave.site>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
	 <1282144271.3035.31.camel@mulgrave.site>
	 <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>
	 <1282148296.3035.49.camel@mulgrave.site> <4C6C1D70.7020502@vlnb.net>
	 <41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>
	 <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>
	 <1282256949.30453.278.camel@haakon2.linux-iscsi.org>
	 <4C701E08.2020005@vlnb.net> <1282423398.3015.39.camel@mulgrave.site>
	 <AANLkTikcReFsYMhs1RkCHoRkL1+Q9WuptHj1xbx49YsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab0HVU3T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Aug 2010 16:29:19 -0400
In-Reply-To: <AANLkTikcReFsYMhs1RkCHoRkL1+Q9WuptHj1xbx49YsA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org

On Sun, 2010-08-22 at 09:39 +0200, Bart Van Assche wrote:
> On Sat, Aug 21, 2010 at 10:43 PM, James Bottomley
> <James.Bottomley@suse.de> wrote:
> > On Sat, 2010-08-21 at 22:42 +0400, Vladislav Bolkhovitin wrote:
> >> [ ... ]
> >>
> >> You forgot to mention one small thing. You are going to (re)use current
> >> STGT interface for user space backend, which in 5 years of being
> >> mainline has not gained any noticeable interest, because it is
> >> fundamentally slow.
> >
> > That's not exactly what the results of a speed comparison one of your
> > people did said, now is it?  The results were actually not much
> > difference on line speeds up to GigE.
> >
> > [ ... ]
> 
> I assume that you are referring to this message:
> http://lkml.org/lkml/2008/1/29/387 ? You might have missed the reply
> that was posted by Roland Dreier, a highly regarded kernel maintainer
> and InfiniBand expert (http://lkml.org/lkml/2008/1/29/402):
> 
> "Maybe I'm all wet, but I think iSER vs. SRP should be roughly
> comparable.  The exact formatting of various messages etc. is
> different but the data path using RDMA is pretty much identical.  So
> the big difference between STGT iSER and SCST SRP hints at some big
> difference in the efficiency of the two implementations."

So the phrase "up to GigE" was deliberately in the above to exclude the
disputed infiniband results.  I'm not really interested in re-opening
the arguments over how to interpret those results.  The fact that SCST
and STGT were on par up to 1GbE is enough to refute the contention that
STGT is "fundamentally slow".

James 

> Furthermore, I would like to clarify that Vlad hasn't asked me to
> start working on the SCST project but that I selected the SCST project
> myself after an extensive stability and performance comparison of four
> existing open source storage target projects.
> 
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


