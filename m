From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] cciss: fix sysfs broken symlink regression
Date: Mon, 27 Oct 2008 14:29:54 -0700
Message-ID: <20081027142954.d63b4590.akpm@linux-foundation.org>
References: <20081027210136.GA9438@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136AbYJ0VaI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2008 17:30:08 -0400
In-Reply-To: <20081027210136.GA9438@roadking.ldev.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 27 Oct 2008 16:01:36 -0500
Mike Miller <mike.miller@hp.com> wrote:

> Patch 1 of 2
> 
> Regression introduced by commit 6ae5ce8e8d4de666f31286808d2285aa6a50fa40.
> This patch fixes a broken symlink in sysfs that was introduced by the above
> commit also called "cciss: remove redundant code." We broke it in 2.6.27-rc
> on or about 20080804. Some installers are broken if this symlink does not
> exist and they may not detect the logical drives configured on the
> controller.
> It does not require being backported into 2.6.26.x or earlier kernels.

OK, thanks, I tagged it for 2.6.27.x.

> Please consider this for inclusion.
> 
> Andrew, do I need to resubmit 2 of 2? Or is that one still in your queue?
> 

What's 2 of 2?

cciss patches which I presently have queued are:

cciss-fix-regression-firmware-not-displayed-in-procfs-again-and-again.patch
cciss-new-hardware-support.patch
cciss-fix-sysfs-broken-symlink-regression.patch

