From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/17] scsi: add support for per-host cmd pools
Date: Fri, 7 Feb 2014 04:44:53 -0800
Message-ID: <20140207124453.GB30510@infradead.org>
References: <20140205123930.150608699@bombadil.infradead.org>
 <20140205124019.946278511@bombadil.infradead.org>
 <52F4A3B5.6010203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33585 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbaBGMo5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 07:44:57 -0500
Content-Disposition: inline
In-Reply-To: <52F4A3B5.6010203@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On Fri, Feb 07, 2014 at 10:13:25AM +0100, Paolo Bonzini wrote:
> Il 05/02/2014 13:39, Christoph Hellwig ha scritto:
> >+	pool = scsi_find_host_cmd_pool(shost);
> 
> Should you have a WARN_ON somewhere if shost->hostt->cmd_size &&
> shost->unchecked_isa_dma?

Seems like we could support passing SLAB_CACHE_DMA and __GFP_DMA
easily even for the per-template pool, I'll look into that.

