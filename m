From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: scale virtual_gb with sector_size properly
Date: Thu, 17 Dec 2009 14:57:06 -0500
Message-ID: <4B2A8D12.2000304@interlog.com>
References: <4B2830CF.2020203@suse.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:41768 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761531AbZLQT5M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2009 14:57:12 -0500
In-Reply-To: <4B2830CF.2020203@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
>  The scsi_debug virtual_gb feature currently assumes that the sector size
>  is always 512 bytes and scales the capacity of virtual_gb based on that
>  assumption.
> 
>  When passed a different sector size, the capacity of the disk is scaled
>  incorrectly higher than it should be.
> 
>  For example, modprobe scsi_debug virtual_gb=1 sector_size=4096 results
>  in an 8 GB device.
> 
>  This patch scales it appropriately. I chose to scale down the sectors-per-GB
>  value and then multiply so that if virtual_gb is changed to allow devices that
>  can max out sector_t, it will just work.
> 
>  References: https://bugzilla.novell.com/show_bug.cgi?id=535939
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
