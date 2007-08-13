From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] [418/2many] MAINTAINERS - SCSI CDROM DRIVER
Date: Mon, 13 Aug 2007 12:32:55 +0200
Message-ID: <20070813103254.GO23758@kernel.dk>
References: <46bffba3.92NZRByJnVYnqXQs%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:29823 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760859AbXHMKc7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 06:32:59 -0400
Content-Disposition: inline
In-Reply-To: <46bffba3.92NZRByJnVYnqXQs%joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

On Sun, Aug 12 2007, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c08c8af..d7a1c74 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3981,6 +3981,7 @@ M:	axboe@kernel.dk
>  L:	linux-scsi@vger.kernel.org
>  W:	http://www.kernel.dk
>  S:	Maintained
> +F:	drivers/scsi/sr.*

Not correct, it should be sr*

And could you please just put these patches online somewhere, posting
hundreds of them individually (and non threaded!) is pretty much pain
:-)

-- 
Jens Axboe

