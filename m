From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] clean up some more tmscsim scan logic
Date: Tue, 17 Aug 2004 22:21:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040817202109.GA20290@lst.de>
References: <20040817163323.GA16799@lst.de> <Pine.LNX.4.60.0408172217230.5224@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:56448 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268407AbUHQUVU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 16:21:20 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0408172217230.5224@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Tue, Aug 17, 2004 at 10:17:55PM +0200, Guennadi Liakhovetski wrote:
> On Tue, 17 Aug 2004, Christoph Hellwig wrote:
> 
> >- cleanup checks in ->queuecommand, we only get here either for
> >  inquiry or a found device now
> >- DCBmap in the acb is gone, was only used for debug prints after
> >  the prevous changes
> >- kill some more debugging keyed of by ->scan_devices
> 
> James, please, apply.

Warning, without the proc_info removal patch it won't compile.  The
fix is trivial though, all reference to DCBmap in ->proc_info need
to be removed.

