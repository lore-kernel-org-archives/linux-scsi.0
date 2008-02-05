From: "Chris Weiss" <cweiss@gmail.com>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Mon, 4 Feb 2008 20:07:01 -0600
Message-ID: <165ac690802041807r147531d8s6bb5f3a1f254bcbb@mail.gmail.com>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <47A73C86.3060604@vlnb.net>
	 <1202144767.3096.38.camel@localhost.localdomain>
	 <47A7488B.4080000@vlnb.net>
	 <1202145901.3096.49.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
	 <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
	 <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
	 <20080204224314.113afe7b@core> <47A74BAA.6080201@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:46588 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYBECHD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 21:07:03 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3242987wah.23
        for <linux-scsi@vger.kernel.org>; Mon, 04 Feb 2008 18:07:02 -0800 (PST)
In-Reply-To: <47A74BAA.6080201@torque.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Mike Christie <michaelc@cs.wisc.edu>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Feb 4, 2008 11:30 AM, Douglas Gilbert <dougg@torque.net> wrote:
> Alan Cox wrote:
> >> better. So for example, I personally suspect that ATA-over-ethernet is way
> >> better than some crazy SCSI-over-TCP crap, but I'm biased for simple and
> >> low-level, and against those crazy SCSI people to begin with.
> >
> > Current ATAoE isn't. It can't support NCQ. A variant that did NCQ and IP
> > would probably trash iSCSI for latency if nothing else.
>
> And a variant that doesn't do ATA or IP:
> http://www.fcoe.com/
>

however, and interestingly enough, the open-fcoe software target
depends on scst (for now anyway)
