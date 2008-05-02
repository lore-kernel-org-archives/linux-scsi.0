From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2.6.25.1] Add scsi_execute_async_fifo()
Date: Fri, 2 May 2008 11:55:25 -0400
Message-ID: <20080502155525.GA16353@infradead.org>
References: <200805021638.42972.bart.vanassche@gmail.com> <20080502153306.GB7376@infradead.org> <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32959 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964909AbYEBPz2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 11:55:28 -0400
Content-Disposition: inline
In-Reply-To: <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel@lists.sourceforge.net

On Fri, May 02, 2008 at 05:53:22PM +0200, Bart Van Assche wrote:
> Regarding out-of-tree modules: this is just a preparatory step before
> submitting SCST for inclusion in the mainstream kernel.

And what crackpipe did you smoke to thing we'd put duplicated target
framework in?

> Regarding scsi_execute_async(): I didn't know that this API is on its
> way out. What will it be replaced by, and when ?

blk_execute_rq/blk_execute_rq_nowait plus the block level helpers built
ontop to build requests.

> 
> Bart.
---end quoted text---
