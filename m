From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Proposals to change the way all drivers work with SCSI commands
Date: Fri, 11 May 2007 15:15:37 -0400
Message-ID: <4644C0D9.70006@garzik.org>
References: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:41337 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966241AbXEKTPk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 May 2007 15:15:40 -0400
In-Reply-To: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> Right at the moment, we're planning to clean up the way SCSI drivers
> process commands.  The proposals are essentially:
> 
>      1. Get rid of the now unnecessary map_single path (every command is
>         either zero transfer or scatter/gather)
>      2. use accessors to manipulate the SG lists (mainly so that we can
>         alter the implementation without affecting the drivers)
> 
> It strikes me that in all of this, we could also consider doing the DMA
> mapping inside the mid layer (instead of in every driver).  This is
> essentially what libata is already doing ... leading to confusion in
> SCSI drivers that use libata for SATA.

My eyes are crossed :)  How does doing DMA mapping in the mid layer lead 
to confusion in SCSI drivers that use libata for SATA?  Are you talking 
about aic94xx and ipr only, or other drivers?

	Jeff



