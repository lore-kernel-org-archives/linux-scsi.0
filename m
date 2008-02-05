From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Tue, 5 Feb 2008 23:19:14 +0900
Message-ID: <20080205231909I.tomof@acm.org>
References: <20080204224314.113afe7b@core>
	<47A74BAA.6080201@torque.net>
	<165ac690802041807r147531d8s6bb5f3a1f254bcbb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:60913 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbYBEOTr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Feb 2008 09:19:47 -0500
In-Reply-To: <165ac690802041807r147531d8s6bb5f3a1f254bcbb@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cweiss@gmail.com
Cc: dougg@torque.net, alan@lxorguk.ukuu.org.uk, michaelc@cs.wisc.edu, vst@vlnb.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, nab@linux-iscsi.org, James.Bottomley@hansenpartnership.com, scst-devel@lists.sourceforge.net, akpm@linux-foundation.org, torvalds@linux-foundation.org, fujita.tomonori@lab.ntt.co.jpfujita.tomonori@lab.ntt.co.jp

On Mon, 4 Feb 2008 20:07:01 -0600
"Chris Weiss" <cweiss@gmail.com> wrote:

> On Feb 4, 2008 11:30 AM, Douglas Gilbert <dougg@torque.net> wrote:
> > Alan Cox wrote:
> > >> better. So for example, I personally suspect that ATA-over-ethernet is way
> > >> better than some crazy SCSI-over-TCP crap, but I'm biased for simple and
> > >> low-level, and against those crazy SCSI people to begin with.
> > >
> > > Current ATAoE isn't. It can't support NCQ. A variant that did NCQ and IP
> > > would probably trash iSCSI for latency if nothing else.
> >
> > And a variant that doesn't do ATA or IP:
> > http://www.fcoe.com/
> >
> 
> however, and interestingly enough, the open-fcoe software target
> depends on scst (for now anyway)

STGT also supports software FCoE target driver though it's still
experimental stuff.

http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg12705.html

It works in user space like STGT's iSCSI (and iSER) target driver
(i.e. no kernel/user space interaction).
