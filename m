From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Remove last page_address from dc395x.c
Date: Sat, 10 Jun 2006 16:05:02 -0500
Message-ID: <1149973502.3335.31.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.60.0606092216460.5256@poirot.grange>
	 <1149904465.3131.19.camel@laptopd505.fenrus.org>
	 <20060610095038.GA20526@infradead.org>
	 <Pine.LNX.4.60.0606101528170.3305@poirot.grange>
	 <20060610134042.GA7764@infradead.org>
	 <Pine.LNX.4.60.0606102248150.16586@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:60362 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751700AbWFJVFW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 17:05:22 -0400
In-Reply-To: <Pine.LNX.4.60.0606102248150.16586@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjan@infradead.org>, Jamie Lenehan <lenehan@twibble.org>, linux-scsi@vger.kernel.org

On Sat, 2006-06-10 at 22:56 +0200, Guennadi Liakhovetski wrote:
> Is the plan to completely remove non-sg commands from scsi? Then, I

yes, but we're not quite there yet.

>  guess, 
> at some point use_sg + void *request_buffer will be replaced with a 
> sg_count + struct scatterlist *request_gs. Would it be better to keep
> the 
> use_sg == 0 test in until then? Or shall I resubmit the patch without
> that 
> check or with a BUG_ON(!use_sg)?

I've put it in as is.

James


