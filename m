From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Fri, 02 Feb 2007 17:58:04 -0500
Message-ID: <45C3C1FC.8020500@rtr.ca>
References: <200701301947.08478.liml@rtr.ca> <1170206199.10890.13.camel@mulgrave.il.steeleye.com> <45C2474E.9030306@rtr.ca> <1170366920.3388.62.camel@mulgrave.il.steeleye.com> <45C32C7F.9050706@emc.com> <20070202145003.525bd682@localhost.localdomain> <45C3617B.2020400@rtr.ca> <20070202194956.GF16722@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([64.26.128.89]:1491 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946149AbXBBW6I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Feb 2007 17:58:08 -0500
In-Reply-To: <20070202194956.GF16722@waste.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Mackall <mpm@selenic.com>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Ric Wheeler <ric@emc.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Matt Mackall wrote:
> ..
> Also worth considering is that spending minutes trying to reread
> damaged sectors is likely to accelerate your death spiral. More data
> may be recoverable if you give up quickly in a first pass, then go
> back and manually retry damaged bits with smaller I/Os.

All good input.  But what was being debated here is not so much
the retrying of known-bad sectors, but rather what to do about
the kiBs or MiBs of sectors remaining in a merged request after
hitting a single bad sector mid-way.

Currently, SCSI just abandons the entire remaining workload.

Cheers
