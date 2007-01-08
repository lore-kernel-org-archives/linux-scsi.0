From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: linux-scsi-owner@vger.kernel.org is a pain
Date: Mon, 08 Jan 2007 10:16:15 -0600
Message-ID: <1168272975.2824.11.camel@mulgrave.il.steeleye.com>
References: <45A16FED.7000005@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34822 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161334AbXAHQQX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2007 11:16:23 -0500
In-Reply-To: <45A16FED.7000005@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

On Sun, 2007-01-07 at 17:10 -0500, Douglas Gilbert wrote:
> Seems I'm not the only one sending posts to the
> linux-scsi-owner@vger.kernel.org bit bucket.
> 
> Could the maintainer of lsml either:
>   - get rid of linux-scsi-owner@vger.kernel.org
>   - or forward posts in there to lsml
> 
> That bright idea might save the maintainer time but
> it wastes ours.

I think it's a majordomo feature ... you need misdelivered or
undelivered emails not to come back to the list, so the return-path: is
set to the owner list (so they can be removed from the email list).

In theory, a mailer should never reply to the return path, so how are
you getting this in your reply path?

James


