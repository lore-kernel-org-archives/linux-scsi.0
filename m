From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] async scsi scanning, version 13
Date: Sun, 01 Oct 2006 15:00:57 -0500
Message-ID: <1159732857.3542.5.camel@mulgrave.il.steeleye.com>
References: <20060928211920.GI5017@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:10218 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932279AbWJAUCJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Oct 2006 16:02:09 -0400
In-Reply-To: <20060928211920.GI5017@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2006-09-28 at 15:19 -0600, Matthew Wilcox wrote:
> Version 13 ...
>   
> changes vs version 12:
> 
> Address akpm's comments:
>  - use DEFINE_SPINLOCK
>  - document how scsi_complete_async_scans works
>  - document why the memory allocation loop in scsi_complete_async_scans
>    will eventually terminate
>  - document why we don't add ourselves to the list if it's already empty
>     
> shost_for_each_device is safe and shost_for_each_device_safe isn't.
> Delete shost_for_each_device_safe, use shost_for_each_device and update
> the docs for __shost_for_each_device and shost_for_each_device to be
> more accurate.
> 
> changes vs version 11:
> 
> Fix whitespace pointed out by Randy Dunlap.

OK, my plan for this is to place it in SCSI misc as soon as we get
2.6.19-rc1.  That way we'll give it a thorough check out in -mm before
it hits mainline.

By the way, a global change log (rather than changes relative to
previous versions) would be appreciated.

James


