From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] scsi_debug: improve driver description in Kconfig
Date: Fri, 28 Nov 2014 13:05:37 -0800
Message-ID: <5478E3A1.5090608@infradead.org>
References: <5476302C.9050509@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46403 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaK1VFn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Nov 2014 16:05:43 -0500
In-Reply-To: <5476302C.9050509@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, SCSI development list <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

On 11/26/14 11:55, Douglas Gilbert wrote:
> From: Douglas Gilbert <dgilbert@interlog.com>
> Date: Wed, 26 Nov 2014 14:41:55 -0500
> Subject: [PATCH] scsi_debug improve driver description in Kconfig
> 
> Try to give a more accurate driver description and some extra
> useful information in less lines.
> ---
>  drivers/scsi/Kconfig | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> 

creating a small ram disk device.

I would say:     RAM

Otherwise looks good to me.

-- 
~Randy
