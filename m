From: Tejun Heo <htejun@gmail.com>
Subject: Re: linux-next: Tree for July 16 (crash on quad core AMD)
Date: Tue, 22 Jul 2008 00:35:02 +0900
Message-ID: <4884ACA6.9080509@gmail.com>
References: <20080716235011.ac9643aa.sfr@canb.auug.org.au>	<200807170053.36661.rjw@sisk.pl>	<1216249292.3358.66.camel@localhost.localdomain>	<200807170109.30655.rjw@sisk.pl>	<48808EE0.2060603@gmail.com>	<20080719004736.626ef169@mjolnir.drzeus.cx>	<48813C5F.70007@gmail.com>	<20080719033050.552f9b49@mjolnir.drzeus.cx>	<48814D81.8060001@gmail.com>	<20080719140717.7b296eae@mjolnir.drzeus.cx>	<4881F437.7000503@gmail.com>	<20080721004033.1fc66aa3@mjolnir.drzeus.cx>	<4883DA8C.5030306@gmail.com> <20080721133209.62e31bc8@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:52578 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbYGUPfW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jul 2008 11:35:22 -0400
Received: by ti-out-0910.google.com with SMTP id b6so852303tic.23
        for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2008 08:35:20 -0700 (PDT)
In-Reply-To: <20080721133209.62e31bc8@mjolnir.drzeus.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Testers List <kernel-testers@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>, linux-ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, Takashi Iwai <tiwai@suse.de>, tino.keitel@gmx.de

Pierre Ossman wrote:
> On Mon, 21 Jul 2008 09:38:36 +0900
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> I think it needs an ACK from Jens.  Jens?
> 
> He seems to be on vacation. I sent him a review request for my original
> code a couple of weeks ago, and I haven't heard anything. marc.info
> also doesn't show anything since the 3rd. Odds are he won't be back
> during the merge window. :/

Right, I have a patchset waiting for his review too.  Anyone knows when
he'll be back?

We can always back it out later but I don't think pushing stuff in w/o
maintainer's ack is a good idea.  :-(

-- 
tejun
