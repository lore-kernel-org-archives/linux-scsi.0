From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] tmscsim: Store pDCB in device->hostdata
Date: Mon, 31 May 2004 10:22:10 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040531092210.GA5556@infradead.org>
References: <20040523103729.GA23804@infradead.org> <Pine.LNX.4.44.0405302256520.14244-200000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:210 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S264550AbUEaJWO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 May 2004 05:22:14 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0405302256520.14244-200000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Sun, May 30, 2004 at 11:01:31PM +0200, Guennadi Liakhovetski wrote:
> On Sun, 23 May 2004, Christoph Hellwig wrote:
> 
> > The other thing is that most calls to dc390_findDCB could probably be
> > replaced with stroing the pDCB in scsi_device->hostdata on slave_alloc,
> > but that could aswell be done in an incremental patch.
> 
> Done in the attached patch. Tested as usual and a bit harder.
> 
> BTW, just managed to re-organise my test-system to allow modular tmscsim.
> Tested - works too.

Patch looks good to me.
