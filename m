From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] cciss:fix regression firmware not displayed in
 procfs (again and again)
Date: Tue, 21 Oct 2008 15:44:08 -0700
Message-ID: <20081021154408.ed96c9b3.akpm@linux-foundation.org>
References: <20081021212322.GA6421@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751195AbYJUWpH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 18:45:07 -0400
In-Reply-To: <20081021212322.GA6421@roadking.ldev.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, adobriyan@gmail.com

On Tue, 21 Oct 2008 16:23:22 -0500
Mike Miller <mike.miller@hp.com> wrote:

> Patch 2 of 2

What happened with "1 of 2"?

> Sorry for the delay. I've been out of the office and the network has been
> down since before lunch CDT. This regression was introduced by commit
> 6ae5ce8e8d4de666f31286808d2285aa6a50fa40.
> This patch fixes a regression where the controller firmware version is not
> displayed in procfs. The previous patch would be called anytime something
> changed. This will get called only once for each controller.
> 
> In this patch I again initialize *inq_buff to NULL per Tomo's comments. I
> also use a goto clean 4 instead of returning -ENOMEM if the kzalloc fails.
> 
> I hope this finally meets everyones expectations.
> 
> Please consider this for inclusion.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>

So this fix is needed in 2.6.27.x, yes?
