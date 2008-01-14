From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Convert drivers/scsi/ch.c to use unlocked_ioctl
Date: Mon, 14 Jan 2008 07:37:30 -0700
Message-ID: <20080114143730.GK18741@parisc-linux.org>
References: <1200321077-26916-1-git-send-email-mathieu.segaud@regala.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40929 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbYANOhf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 09:37:35 -0500
Content-Disposition: inline
In-Reply-To: <1200321077-26916-1-git-send-email-mathieu.segaud@regala.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mathieu Segaud <mathieu.segaud@regala.cx>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 03:31:17PM +0100, Mathieu Segaud wrote:
> +	.owner			= THIS_MODULE,
> +	.open			= ch_open,
> +	.release		= ch_release,
> +	.unlocked_ioctl	= ch_ioctl,

Do you have a tab setting that's not 8?  You seem to have used one tab
too many for the first three lines.

Please correct that one, and then add my:

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

Thanks!

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
