From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fusion dead code removal
Date: Fri, 24 Sep 2004 19:04:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040924170405.GA3807@lst.de>
References: <0E3FA95632D6D047BA649F95DAB60E57050F818B@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:37327 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268914AbUIXREP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2004 13:04:15 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57050F818B@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Thu, Sep 23, 2004 at 12:00:09PM -0400, Moore, Eric Dean wrote:
> Christoph - This attached patch is fine; we've validated it
> here at LSI Logic.   Its your original patch with the MPTSTM
> code backed out.  We will be investigating supporting the
> generic scsi target midlayer.

Well, that one isn't there yet.  I saw a promising implementation posted
to this list, but at that time is was 2.4-only.

