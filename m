From: Christoph Hellwig <hch@lst.de>
Subject: Re: [2.6 patch] feature-removal-schedule.txt: remove the NCR53C9x entry
Date: Wed, 6 Aug 2008 01:37:19 +0200
Message-ID: <20080805233718.GB2514@lst.de>
References: <20080805200330.GJ22895@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:52436 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbYHEXiF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Aug 2008 19:38:05 -0400
Content-Disposition: inline
In-Reply-To: <20080805200330.GJ22895@cs181140183.pp.htv.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

This should really be easy enough for any merge window state, whoe wants
to feed it to Linus?

On Tue, Aug 05, 2008 at 11:03:30PM +0300, Adrian Bunk wrote:
> Now that the driver is removed we should also remove the entry in 
> Documentation/feature-removal-schedule.txt
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> Acked-by: Christoph Hellwig <hch@lst.de>
> 
> ---
> 
> This patch has been sent on:
> - 1 Mar 2008
> 
> 6d7882f6e844eaf6551b3a3708e01d1784916435 foobar
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index c1d1fd0..a4530f0 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -19,15 +19,6 @@ Who:	Pavel Machek <pavel@suse.cz>
>  
>  ---------------------------
>  
> -What:	old NCR53C9x driver
> -When:	October 2007
> -Why:	Replaced by the much better esp_scsi driver.  Actual low-level
> -	driver can be ported over almost trivially.
> -Who:	David Miller <davem@davemloft.net>
> -	Christoph Hellwig <hch@lst.de>
> -
> ----------------------------
> -
>  What:	Video4Linux API 1 ioctls and video_decoder.h from Video devices.
>  When:	December 2008
>  Files:	include/linux/video_decoder.h include/linux/videodev.h
---end quoted text---
