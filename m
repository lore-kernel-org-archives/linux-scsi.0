From: christophe.varoqui@free.fr
Subject: Re: [lvm] [christophe.varoqui@free.fr: dm multipath target]
Date: Tue, 19 Aug 2003 15:26:12 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061299572.3f4225742287c@impt1-2.free.fr>
References: <20030819073926.GA423@fib011235813.fsnet.co.uk> <20030819094838.F8428@sistina.com> <1061283871.3f41e81f8226b@impt3-2.free.fr> <20030819115110.I8420@sistina.com> <1061290087.3f4200678f811@impt2-2.free.fr> <20030819143552.K8420@sistina.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:36860 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S270688AbTHSNfI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2003 09:35:08 -0400
Received: from postfix4-2.free.fr (postfix4-2.free.fr [213.228.0.176])
	by zeus.kernel.org (8.11.6/8.11.6) with ESMTP id h7JDVE623391
	for <linux-scsi@vger.kernel.org>; Tue, 19 Aug 2003 06:31:14 -0700
In-Reply-To: <20030819143552.K8420@sistina.com>
List-Id: linux-scsi@vger.kernel.org
To: mauelshagen@sistina.com
Cc: mge@sistina.com, linux-scsi@vger.kernel.org

> > Yes, but does it mean _your_ multipath tools will need PV UUIDs ?
> 
> Yes.
> 
You realize that it make those tools unsuitable for general use : 
* one may not want to use the full lvm compound binary to set up multipaths
* one may not want to tag its devices to set up multipaths, where its not necessary

Shouldn't LVM2 just rely on an separate multipath management (dm-based). There
surely will be one such implementation. We users don't need fragmentation in
such a low-level area.

PS: I certainly do not disregard sistina's work on this front, and do not mean
to be disrepectful. Just trying to forward my admin point of view.

regards,
cvaroqui
