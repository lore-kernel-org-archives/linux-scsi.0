From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] aacraid bad queuecommand return
Date: Fri, 19 Nov 2004 13:41:27 +0100
Message-ID: <20041119124126.GD26240@suse.de>
References: <60807403EABEB443939A5A7AA8A7458B6947FE@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:21419 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261370AbUKSMl5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 07:41:57 -0500
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B6947FE@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Fri, Nov 19 2004, Salyzyn, Mark wrote:
> In the patch I supplied, I dropped the result setting and aac_io_done
> and let the midlayer retry on the none-zero return.
> 
> Which is more efficient?

It doesn't really matter - this path should basically never be hit
(or you would have seen a report, it would hang the scsi layer), so
efficiency isn't really an issue. So just do whatever you see fit,
either way will work fine. I like the scsi_done approach best, because
it allows you to flag more fine grained errors.

-- 
Jens Axboe

