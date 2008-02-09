From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Fri, 8 Feb 2008 23:44:10 -0800 (PST)
Message-ID: <152035.25571.qm@web31805.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31805.mail.mud.yahoo.com ([68.142.207.68]:45191 "HELO
	web31805.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751909AbYBIHoL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2008 02:44:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Vladislav Bolkhovitin <vst@vlnb.net>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ming Zhang <blackmagic02881@gmail.com>

--- On Fri, 2/8/08, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> > Is there an open iSCSI Target implementation which
> does NOT
> > issue commands to sub-target devices via the SCSI
> mid-layer, but
> > bypasses it completely?
> > 
> >    Luben
> > 
> 
> Hi Luben,
> 
> I am guessing you mean futher down the stack, which I
> don't know this to

Yes, that's what I meant.

> be the case.  Going futher up the layers is the design of
> v2.9 LIO-SE.
> There is a diagram explaining the basic concepts from a
> 10,000 foot
> level.
> 
> http://linux-iscsi.org/builds/user/nab/storage-engine-concept.pdf

Thanks!

   Luben
