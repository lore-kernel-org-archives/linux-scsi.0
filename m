From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] nuke some junk from the pcmcia scsi drivers
Date: Sat, 9 Aug 2003 05:31:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030809033152.GA23644@lst.de>
References: <20030808191050.GD17983@lst.de> <5.2.0.9.0.20030808161151.029e9e00@mail.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:45961 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S272223AbTHIDb6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2003 23:31:58 -0400
Content-Disposition: inline
In-Reply-To: <5.2.0.9.0.20030808161151.029e9e00@mail.speakeasy.net>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Woods <jdw@apple2.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Aug 08, 2003 at 04:18:11PM -0700, Jeff Woods wrote:
> I'm totally unfamiliar with the code involved, but it occurs to me that 
> there may be dependencies in the SCSI drivers for PCMCIA code due to 
> PCMCIA-based SCSI adapters (e.g., Adaptec 1480).  Someone may need to 
> confirm if the DEV_STALE_* references are there to handle PCMCIA-SCSI 
> adapters.

Umm, this code can't be triggered.  These bits aren't touched by
generic pcmcia code but only set by the individual drivers.

Btw, are you using 2.6?  There might be some other issue with pcmcia
scsi..
