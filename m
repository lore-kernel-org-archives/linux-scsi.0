From: Madhu Iyengar <madhu.iyengar@qlogic.com>
Subject: RE: [PATCH 3/3] qla2xxx: Run queuecommand outside the host_lock
Date: Fri, 8 Apr 2011 16:07:04 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8728A8CAF0A@AVEXMB1.qlogic.org>
References: <20110401202209.GN4183@linux.intel.com>
 <5E4F49720D0BAD499EE1F01232234BA8728A7B1A4F@AVEXMB1.qlogic.org>
 <20110402033123.GB7286@parisc-linux.org>
 <5E4F49720D0BAD499EE1F01232234BA8728A7B1AD6@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:53271
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753317Ab1DHXHV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2011 19:07:21 -0400
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA8728A7B1AD6@AVEXMB1.qlogic.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Madhu Iyengar <madhu.iyengar@qlogic.com>, Matthew Wilcox <matthew@wil.cx>
Cc: Matthew Wilcox <willy@linux.intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> -----Original Message-----
> From: Madhu Iyengar
> Sent: Saturday, April 02, 2011 7:22 AM
> To: Matthew Wilcox
> Cc: Matthew Wilcox; linux-scsi@vger.kernel.org; Madhu Iyengar
> Subject: RE: [PATCH 3/3] qla2xxx: Run queuecommand outside the host_lock
>
>
>
> > -----Original Message-----
> > From: Matthew Wilcox [mailto:matthew@wil.cx]
> > Sent: Friday, April 01, 2011 8:31 PM
> > To: Madhu Iyengar
> > Cc: Matthew Wilcox; linux-scsi@vger.kernel.org
> > Subject: Re: [PATCH 3/3] qla2xxx: Run queuecommand outside the host_lock
> >
> > On Fri, Apr 01, 2011 at 02:33:08PM -0700, Madhu Iyengar wrote:
> > > Mathew,
> > >
> > > We submitted the host_lock related changes earlier, and the changes
> were
> > accepted and went into the 2.6.38-rc6 (or round-about that timeframe)
> > upstream kernel.
> > >
> > > Here's the patch in that sequence we submitted earlier (which is now
> in
> > the upstream/scsi stream):
> > > http://marc.info/?l=linux-scsi&m=129850384318495&w=2
> >
> > Ah, cool.  You missed a step though:
> >
> >     scsi_qla_host_t *vha = shost_priv(cmd->device->host);
> >
> > That can just be:
> >
> >     scsi_qla_host_t *vha = shost_priv(host);
> >
>
> Thanks for pointing it out (:-). We'll correct that when we submit our
> next patch set.
>

Matthew, By the way, forgot to ask. Shall I take the liberty in adding an "Acked-by" or "Reviewed-by" from you when I submit a patch with the above change? Please let me know, which one. Thanks in advance.

Here's the title of the patch, unless you prefer a different one:
qla2xxx: Minor change in queuecommand function.

> > --
> > Matthew Wilcox                              Intel Open Source Technology Centre
> > "Bill, look, we understand that you're interested in selling us this
> > operating system, but compare it to ours.  We can't possibly take such
> > a retrograde step."


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

