From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] RFC: libsas queuecommand fixups
Date: Mon, 22 Aug 2011 10:45:26 -0400
Message-ID: <20110822144526.GB5705@infradead.org>
References: <20110711184922.859239377@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37743
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543Ab1HVOp1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2011 10:45:27 -0400
Content-Disposition: inline
In-Reply-To: <20110711184922.859239377@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org

ping?

On Mon, Jul 11, 2011 at 02:49:22PM -0400, Christoph Hellwig wrote:
> Fix up some lose ends in sas_queuecommand that I noticed during the isci
> review.  The first two are pretty straight forward, but the third is a bit
> more nasty and needs some serious review and testing.  Note that I could
> only compile-test the bunch as I don't actually have a SAS controller
> using libsas.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
