From: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH]: Re: qla1280.c broken on SGI visws, PCI coherency problem
Date: Mon, 12 Dec 2005 13:31:06 -0800
Message-ID: <200512121331.06467.jbarnes@virtuousgeek.org>
References: <4399D6EB.4080603@c-lab.de> <439DE50B.90007@sgi.com> <20051212212427.GA9139@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc14.comcast.net ([216.148.227.154]:16617 "EHLO
	rwcrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S932137AbVLLVbJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Dec 2005 16:31:09 -0500
In-Reply-To: <20051212212427.GA9139@infradead.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Reed <mdr@sgi.com>, Michael Joosten <michael.joosten@c-lab.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Monday, December 12, 2005 1:24 pm, Christoph Hellwig wrote:
> While we're at it, does anyone know whyt the ioread* interface doesn't
> provide the _relaxed version?  I'd really love to switch qla1280 over
> to it given that it needs to support both mmio and pio.

Back when ioread was being discussed on linux-arch, I remember Linus 
saying that perhaps *all* ioreads should be relaxed wrt. DMA (unlike the 
current mmio accessor functions), but I'm not sure if those are the 
semantics we finally settled on.  If not, an ioread*_relaxed would be 
nice to add for the platforms that can support it.

Jesse
