From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] refactor tmscsim inititalization code
Date: Tue, 14 Sep 2004 21:05:12 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040914190512.GA16845@lst.de>
References: <20040904130235.GA20552@lst.de> <Pine.LNX.4.60.0409071812550.21209@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:24969 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S269658AbUINTFR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 15:05:17 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0409071812550.21209@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Tue, Sep 07, 2004 at 06:29:41PM +0200, Guennadi Liakhovetski wrote:
> A couple more things:
> 
> Your note on possible problems when using several AM53C974A-based HBA in
> one machine - how do other drivers resolve this problem, if those 
> adapters need different configuration?

module_param_array allows to specify paramters for multiple hosts.
You'll have to set an aribtrary limit (#define) for the number of hosts
you accept parameters for - but in general a driver should work for the
common case without parameters anyway.

