From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 3/5] mpt fusion: Changes in mptscsih.c for logging support
Date: Tue, 24 Jul 2007 17:07:28 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70885411@NAMAIL4.ad.lsil.com>
References: <46A5D4D5.1090402@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42252 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbXGXXIm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 19:08:42 -0400
Content-class: urn:content-classes:message
In-Reply-To: <46A5D4D5.1090402@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Tuesday, July 24, 2007 4:31 AM, Boaz Harrosh wrote:
> 
> NACK
> This driver was already converted to accessors please
> don't use old (going a way soon) scsi_cmnd members
> directly
> 


Sathya - a little background on this.  I believe this all started with
the "Proposals to change the way all drivers work with SCSI commands"
email from James Bottomley back on May 11th.
here:  http://marc.info/?t=117890864300003&r=1&w=2.      The fusion
driver was ported by FUJITA Tomonori in this patch
http://marc.info/?l=linux-scsi&m=117896437623559&w=2.  So the
bottomline, is anywere we access the scsi_cmnd pointer in the debug
prints, needs to be ported using the new wrappers (in scsi_cmnd.h).
Can you please review and repost?

Thanks,
Eric



