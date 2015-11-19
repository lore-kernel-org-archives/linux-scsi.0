From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [BISECTED] v4.4-rc1 SCSI disk init crash
Date: Thu, 19 Nov 2015 23:19:00 +0200
Message-ID: <20151119211900.GG18138@blackmetal.musicnaut.iki.fi>
References: <20151119192135.GD18138@blackmetal.musicnaut.iki.fi>
 <564E28DE.6010200@sandisk.com>
 <1447963712.2234.31.camel@HansenPartnership.com>
 <20151119202953.GE18138@blackmetal.musicnaut.iki.fi>
 <564E394A.7060705@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:60282 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbbKSVTo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2015 16:19:44 -0500
Content-Disposition: inline
In-Reply-To: <564E394A.7060705@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hi,

On Thu, Nov 19, 2015 at 01:04:10PM -0800, Bart Van Assche wrote:
> On 11/19/2015 12:30 PM, Aaro Koskinen wrote:
> >FYI, this sequence is 100% reproducible on my setup. The disk is in
> >Macally USB enclosure. On cold-boot it will stay on "Spinning up disk"
> >phase until I manually press the ON button. And that's when the disconnect
> >message appears, don't know why...
> 
> Hello Aaro,
> 
> Can you check whether reverting only patch "block: don't release bdi while
> request_queue has live references" (commit
> b02176f30cd30acccd3b633ab7d9aed8b5da52ff) also makes the OCTEON router boot
> again ?

No, it crashes pretty much in the same way.

A.
