From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Convert drivers/scsi/ch.c to use unlocked_ioctl
Date: Mon, 14 Jan 2008 07:18:54 -0700
Message-ID: <20080114141854.GJ18741@parisc-linux.org>
References: <1200317533-24643-1-git-send-email-mathieu.segaud@regala.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:34888 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYANOSz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 09:18:55 -0500
Content-Disposition: inline
In-Reply-To: <1200317533-24643-1-git-send-email-mathieu.segaud@regala.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mathieu Segaud <mathieu.segaud@regala.cx>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 02:32:13PM +0100, Mathieu Segaud wrote:
> +#include <linux/smp_lock.h>

You don't add any uses of lock_kernel() and there are none in the
driver currently.

> -	.owner        = THIS_MODULE,
> -	.open         = ch_open,
> -	.release      = ch_release,
> -	.ioctl        = ch_ioctl,
> +	.owner          = THIS_MODULE,
> +	.open           = ch_open,
> +	.release        = ch_release,
> +	.unlocked_ioctl = ch_ioctl,

If you're going to do the gratuitous reformatting, at least use tabs
instead of spaces.

Other than that, should be fine.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
