From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH v5 0/2] block,scsi: fixup blk_get_request dead queue
 scenarios
Date: Wed, 24 Jul 2013 10:29:02 -0400
Message-ID: <20130724102902.42970d66@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1303171328250.1736@jlaw-desktop.mno.stratus.com>
	<20130524141531.737073a8@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub5.stratus.com ([134.111.1.18]:51918 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab3GXO3H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jul 2013 10:29:07 -0400
In-Reply-To: <20130524141531.737073a8@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>

On Fri, 24 May 2013 14:15:31 -0400
Joe Lawrence <joe.lawrence@stratus.com> wrote:

> [PATCH v5 0/2] block,scsi: fixup blk_get_request dead queue scenarios
> 
> Changes from v4:
> 
>  - As per James' suggestion, split into two patches: the first adds
>    blk_get_request return value checking to avoid potential oops, the
>    second converts callers and friends to handle ERR_PTR differentiation
>    of -ENOMEM and -ENODEV.
> 
> Regards,
> 
> -- Joe

Hello Jens,

I'm clearing out some of my old patches and was wondering about the
status of these two.

They apply cleanly to the tip of Linus's branch and it appears
that no new callers of blk_get_request have been introduced since v5 of
the patches.

link to thread:
http://thread.gmane.org/gmane.linux.scsi/80934/focus=82216

Regards,

-- Joe
