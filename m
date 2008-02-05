From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Tue, 5 Feb 2008 22:38:00 +0900
Message-ID: <20080205223607E.tomof@acm.org>
References: <alpine.LFD.1.00.0802041620110.3237@woody.linux-foundation.org>
	<C3CDA7EE.5784%matteo@rmnet.it>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:55959 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867AbYBENis (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Feb 2008 08:38:48 -0500
In-Reply-To: <C3CDA7EE.5784%matteo@rmnet.it>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matteo@rmnet.it
Cc: torvalds@linux-foundation.org, mpm@selenic.com, michaelc@cs.wisc.edu, vst@vlnb.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, nab@linux-iscsi.org, James.Bottomley@HansenPartnership.com, scst-devel@lists.sourceforge.net, akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp, alan@lxorguk.ukuu.org.ukfujita.tomonori@lab.ntt.co.jp

On Tue, 05 Feb 2008 05:43:10 +0100
Matteo Tescione <matteo@rmnet.it> wrote:

> Hi all,
> And sorry for intrusion, i am not a developer but i work everyday with iscsi
> and i found it fantastic.
> Altough Aoe, Fcoe and so on could be better, we have to look in real world
> implementations what is needed *now*, and if we look at vmware world,
> virtual iron, microsoft clustering etc, the answer is iSCSI.
> And now, SCST is the best open-source iSCSI target. So, from an end-user
> point of view, what are the really problems to not integrate scst in the
> mainstream kernel?

Currently, the best open-source iSCSI target implemenation in Linux is
Nicholas's LIO, I guess.
