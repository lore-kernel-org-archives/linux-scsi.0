From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Scst-devel] Fwd: Re:  linuxcon 2010...
Date: Wed, 18 Aug 2010 10:11:11 -0500
Message-ID: <1282144271.3035.31.camel@mulgrave.site>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab0HRPLS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2010 11:11:18 -0400
In-Reply-To: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chetan Loke <generationgnu@yahoo.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2010-08-18 at 07:58 -0700, Chetan Loke wrote:
> Hello James and others,
> 
> --- On Tue, 8/17/10, James Bottomley <James.Bottomley@suse.de> wrote:
> 
> > From: James Bottomley <James.Bottomley@suse.de>
> > Subject: Re: [Scst-devel] Fwd: Re:  linuxcon 2010...
> > To: "Vladislav Bolkhovitin" <vst@vlnb.net>
> > Cc: "scst-devel" <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
> > Date: Tuesday, August 17, 2010, 8:30 PM
> > On Mon, 2010-08-16 at 20:20 +0400,
> > Vladislav Bolkhovitin wrote:
> > > Hello James,
> > > 
> > > Could you comment rumors that decision about future
> > Linux SCSI target 
> > > subsystem is done as well as other related rumors:
> > 
> > If this is related to LSF, the notes on the I/O track are
> > here:
> > 
> > http://lwn.net/Articles/400491/
> 
> 
> During the open panel, my question was really specific - 
> 
> Q) What is the future of a SCSI-target subsystem in linux. Which 
>    target engine/subsystem can we expect?
> 
> Your answer) There is place for only 1 target-subsystem in the Linux
> scsi stack and in the LSF summit the decision was taken to merge LIO.
> Has that
> decision changed since the summit?

The decision hasn't been taken to merge LIO, but based on what happened
at the summit, I think it's the most viable candidate and will likely be
merged by 2.6.37

> As a scst-user what I would like to understand is, what was that
> decision based on? Because the LSF summit was 'small by invitation'
> only summit. The notes don't give us an insight on the selection
> criteria/merits etc.

The notes list 3, what's unclear about it?

> 
> > 
> > > 3. I have heard you said "Vlad wasn't comfortable in
> > handing up the 
> > > control to the maintainers ... (this is how kernel.org
> > works)." I have 
> > > no idea what you meant. I have never been asked about
> > anything like 
> > > that, so I couldn't say anyhow that I'm not
> > comfortable with anything. 
> > > Could you clarify that?
> > > 
> 
> 3) above is something that I emailed Vlad and the scst community based
> on our offline conversation after the open panel. If SCST really has
> licensing issues then I will personally stop using SCST. Since Vlad
> hasn't
> expressed any concerns on the above and neither have you commented on
> it, is it safe to assume that the licensing requirement is a
> non-issue?

No.

James


