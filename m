From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] 2.6 aacraid: rx check health function update
Date: Fri, 5 Nov 2004 14:16:53 +0100
Message-ID: <20041105131653.GF18527@suse.de>
References: <60807403EABEB443939A5A7AA8A7458B4DD8A7@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:61389 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262683AbUKENRe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2004 08:17:34 -0500
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B4DD8A7@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Nov 05 2004, Salyzyn, Mark wrote:
> The bad adapter health is the KERNEL_PANIC (Adapter Kernel Panic, an
> indication that a serious hardware problem has been detected inside the
> adapter), the allocation failure means we provide a less detailed
> indication of failure to the upper layers. If the allocation succeeds,
> then the result will indicate the `blink code' which our technical
> support departments can decode into a pinpoint of a subsystem failure.

Makes sense, in that case the patch is fine.

-- 
Jens Axboe

