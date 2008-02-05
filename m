From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Tue, 5 Feb 2008 22:38:02 +0900
Message-ID: <20080205223740L.tomof@acm.org>
References: <e2e108260801300029r1a949353k73b30f1f28db0bc9@mail.gmail.com>
	<1201710175.3292.16.camel@localhost.localdomain>
	<47A80CB9.9000805@wpkg.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:55875 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbYBENiV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Feb 2008 08:38:21 -0500
In-Reply-To: <47A80CB9.9000805@wpkg.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mangoo@wpkg.org
Cc: James.Bottomley@HansenPartnership.com, bart.vanassche@gmail.com, vst@vlnb.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, scst-devel@lists.sourceforge.net, akpm@linux-foundation.org, torvalds@linux-foundation.orgfujita.tomonori@lab.ntt.co.jp

On Tue, 05 Feb 2008 08:14:01 +0100
Tomasz Chmielewski <mangoo@wpkg.org> wrote:

> James Bottomley schrieb:
> 
> > These are both features being independently worked on, are they not?
> > Even if they weren't, the combination of the size of SCST in kernel plus
> > the problem of having to find a migration path for the current STGT
> > users still looks to me to involve the greater amount of work.
> 
> I don't want to be mean, but does anyone actually use STGT in
> production? Seriously?
> 
> In the latest development version of STGT, it's only possible to stop
> the tgtd target daemon using KILL / 9 signal - which also means all
> iSCSI initiator connections are corrupted when tgtd target daemon is
> started again (kernel upgrade, target daemon upgrade, server reboot etc.).

I don't know what "iSCSI initiator connections are corrupted"
mean. But if you reboot a server, how can an iSCSI target
implementation keep iSCSI tcp connections?


> Imagine you have to reboot all your NFS clients when you reboot your NFS
> server. Not only that - your data is probably corrupted, or at least the
> filesystem deserves checking...
