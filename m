From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aacraid: expanded expose physical device code (new)
Date: Fri, 26 Jan 2007 18:08:23 +0000
Message-ID: <20070126180823.GA13768@infradead.org>
References: <1169832213.17872.7.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51273 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161120AbXAZSI0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jan 2007 13:08:26 -0500
Content-Disposition: inline
In-Reply-To: <1169832213.17872.7.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>, Christoph Hellwig <hch@infradead.org>

On Fri, Jan 26, 2007 at 09:23:32AM -0800, Mark Haverkamp wrote:
> Received from Mark Salyzyn,
> 
> Take the expose_physicals flag and allow the user to select default (physicals
> available via /dev/sg), exposed (physicals available via /dev/sd for
> experimental reasons) and hidden (physicals blocked from all access). This
> expands the functionality of the previous expose_physicals insmod parameter
> which was added to support some experimental configurations.
> 
> Signed-off-by Mark Haverkamp <markh@linux-foundation.org>
> ---
> The patch has been updated after talking with Mark about Christoph's
> comments on the previous version of the patch.
> 

Thanks, this version looks a lot better.
