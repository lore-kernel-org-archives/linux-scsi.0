From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aic7xxx: move to dma_get_required_mask() and correct 39 bit assumptions
Date: Tue, 30 Aug 2005 17:58:31 +0100
Message-ID: <20050830165831.GA32049@infradead.org>
References: <1125420487.5037.27.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:13720 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932140AbVH3Q6e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 12:58:34 -0400
Content-Disposition: inline
In-Reply-To: <1125420487.5037.27.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Dave Jones <davej@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, luben_tuikov@adaptec.com

On Tue, Aug 30, 2005 at 11:48:07AM -0500, James Bottomley wrote:
> This patch moves aic7xxx over to the dma_get_required_mask() API and
> dumps its open coded memory check.

Can you put in that change for aic79xx aswell?

